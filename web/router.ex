defmodule Poscaster.Router do
  use Poscaster.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Poscaster do
    pipe_through :api
  end
end
