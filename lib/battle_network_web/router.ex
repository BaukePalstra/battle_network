defmodule BattleNetworkWeb.Router do
  use BattleNetworkWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BattleNetworkWeb do
    pipe_through :api
  end
end
