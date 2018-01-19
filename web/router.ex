defmodule ActionkitWebhooks.Router do
  use ActionkitWebhooks.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ActionkitWebhooks do
    pipe_through :api
  end
end
