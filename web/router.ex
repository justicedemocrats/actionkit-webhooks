defmodule ActionkitWebhooks.Router do
  use ActionkitWebhooks.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ActionkitWebhooks do
    get "/health", IndexController, :health
    get "/force-update", IndexController, :force_update
    get "/list-hooks", IndexController, :list_hooks
  end
end
