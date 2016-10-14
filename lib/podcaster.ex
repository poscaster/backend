defmodule Poscaster do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Poscaster.Repo, []),
      supervisor(Poscaster.Endpoint, []),
    ]

    opts = [strategy: :one_for_one, name: Poscaster.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    Poscaster.Endpoint.config_change(changed, removed)
    :ok
  end
end
