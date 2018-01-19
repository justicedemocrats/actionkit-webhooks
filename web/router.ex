defmodule ActionkitWebhooks.Router do
  use ActionkitWebhooks.Web, :router

  scope "/", ActionkitWebhooks do
    get "/", IndexController, :index
    get "/health", IndexController, :health
    get "/force-update", IndexController, :force_update
    get "/list-hooks", IndexController, :list_hooks
  end
end
