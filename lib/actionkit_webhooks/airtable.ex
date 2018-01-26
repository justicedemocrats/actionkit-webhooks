defmodule ActionkitWebhooks.AirtableCache do
  use Agent
  require Logger

  @interval 1_000_000

  def key, do: Application.get_env(:actionkit_webhooks, :airtable_key)
  def base, do: Application.get_env(:actionkit_webhooks, :airtable_base)
  def table, do: Application.get_env(:actionkit_webhooks, :airtable_table_name)

  def start_link do
    Agent.start_link(
      fn ->
        fetch_all()
      end,
      name: __MODULE__
    )
  end

  def update() do
    Agent.update(__MODULE__, fn _current ->
      fetch_all()
    end)

    Logger.info("[term codes]: updated at #{inspect(DateTime.utc_now())}")
  end

  def get_all do
    Agent.get(__MODULE__, & &1)
  end

  defp fetch_all() do
    %{body: body} =
      HTTPotion.get(
        "https://api.airtable.com/v0/#{base}/#{table}",
        headers: [
          Authorization: "Bearer #{key}"
        ]
      )

    decoded = Poison.decode!(body)

    records = process_records(decoded["records"])

    if Map.has_key?(decoded, "offset") do
      fetch_all(records, decoded["offset"])
    else
      records
    end
  end

  defp fetch_all(records, offset) do
    %{body: body} =
      HTTPotion.get(
        "https://api.airtable.com/v0/#{base}/#{table}",
        headers: [
          Authorization: "Bearer #{key}"
        ],
        query: [offset: offset]
      )

    decoded = Poison.decode!(body)

    IO.inspect(decoded)
    new_records = process_records(decoded["records"])
    all_records = Enum.into(records, new_records)

    if Map.has_key?(decoded, "offset") do
      fetch_all(all_records, decoded["offset"])
    else
      all_records
    end
  end

  defp typey_downcase(val) when is_binary(val), do: String.downcase(val)
  defp typey_downcase(val), do: val

  defp process_records(records) do
    records
    |> Enum.filter(fn %{"fields" => fields} -> Map.has_key?(fields, "Page ID") end)
    |> Enum.map(fn %{"fields" => fields} ->
      {fields["Page ID"], fields["Endpoint"], fields["Stagger?"] || false}
    end)
  end
end
