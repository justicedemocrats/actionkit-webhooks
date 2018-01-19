defmodule ActionkitWebhooks.IndexController do
  use ActionkitWebhooks.Web, :controller
  alias ActionkitWebhooks.{AirtableCache}

  @secret Application.get_env(:actionkit_webhooks, :secret)

  def health(conn, _) do
    text conn, "i'm healthy! thanks for checking :)"
  end

  def force_update(conn, %{"secret" => @secret}) do
    AirtableCache.update()
    text conn, "updated!"
  end

  def force_update(conn, %{"secret" => _}) do
    text conn, "wrong secret. contact ben"
  end

  def force_update(conn, _) do
    text conn, "missing secret"
  end

  def list_hooks(conn, %{"secret" => @secret}) do
    resp =
      AirtableCache.get_all()
      |> Enum.map(&Tuple.to_list/1)

    json conn, resp
  end

  def list_hooks(conn, %{"secret" => _}) do
    text conn, "wrong secret. contact ben"
  end

  def list_hooks(conn, _) do
    text conn, "missing secret"
  end
end
