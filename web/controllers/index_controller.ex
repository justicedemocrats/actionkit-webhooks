defmodule ActionkitWebhooks.IndexController do
  use ActionkitWebhooks.Web, :controller
  alias ActionkitWebhooks.{AirtableCache}

  def secret, do: Application.get_env(:actionkit_webhooks, :secret)

  def index(conn, _) do
    text conn, ~s(
      hey friends! what's up?

      try visiting this same website, but /health or /list-hooks with a secret.

      there's also /force-update.

      actually, just check out the docs: https://github.com/justicedemocrats/actionkit-webhooks

      isn't it funny that i put the time into typing out this whole message and
      going way overboard with the documentation, but i didn't put the time
      into making this an html page so the links would be clickable?

      have a good day! take it easy! bye bye!
    )
  end

  def health(conn, _) do
    text conn, "i'm healthy! thanks for checking :)"
  end

  def force_update(conn, %{"secret" => input_secret}) do
    if input_secret == secret() do
      AirtableCache.update()
      text conn, "updated!"
    else
      text conn, "wrong secret. contact ben"
    end
  end

  def force_update(conn, _) do
    text conn, "missing secret"
  end

  def list_hooks(conn, %{"secret" => input_secret}) do
    if input_secret == secret() do
      resp =
        AirtableCache.get_all()
        |> Enum.map(&Tuple.to_list/1)

      json conn, resp
    else
      text conn, "wrong secret. contact ben"
    end
  end

  def list_hooks(conn, _) do
    text conn, "missing secret"
  end
end
