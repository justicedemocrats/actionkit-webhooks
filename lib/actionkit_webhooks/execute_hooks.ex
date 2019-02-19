defmodule ActionkitWebhooks.ExecuteHooks do
  import ShortMaps
  require Logger

  @stagger_offset 250
  # Spawn everything to start it off at the same time
  def execute_all() do
    scenarios = ActionkitWebhooks.AirtableCache.get_all()

    Enum.map(scenarios, fn scenario ->
      spawn(fn ->
        execute(scenario)
      end)
    end)
  end

  def execute({page, endpoint, should_stagger}) do
    five_minutes_ago = Timex.shift(Timex.now(), minutes: -1)
    order_by = "-created_at"

    Ak.Api.stream("action", query: ~m(page order_by))
    |> Enum.take_while(fn ~m(created_at) ->
      {:ok, in_utc, _} = Ak.Helpers.isoify(created_at) |> DateTime.from_iso8601()
      Timex.after?(in_utc, five_minutes_ago)
    end)
    |> Enum.with_index()
    |> Enum.map(fn {action, idx} ->
      # Spawn everything to start it off at the same time
      spawn(fn ->
        if should_stagger do
          :timer.sleep(@stagger_offset * idx)
        end

        %{"user" => "/rest/v1/user/" <> user_id, "fields" => fields, "created_at" => created_at} =
          action

        %{body: ~m(email first_name last_name phones)} = Ak.Api.get("user/#{user_id}")

        phone =
          case List.first(phones) do
            "/rest/v1/phone/" <> phone_id ->
              %{body: ~m(phone)} = Ak.Api.get("phone/#{phone_id}")
              phone

            _ ->
              nil
          end

        map_body = Map.merge(~m(email first_name last_name phone created_at), fields)
        to_post = Poison.encode!(map_body)
        Logger.info("#{page} -> #{endpoint}: #{inspect(map_body)}")
        HTTPotion.post(endpoint, body: to_post)
      end)
    end)

    Logger.info("Spawned scenario to handle #{page}")
  end
end
