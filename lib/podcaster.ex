defmodule Poscaster do
  @moduledoc """
  Poscaster application. Web server providing api for podcast feed listening w/ progress tracking.
  """

  use Application
  alias Poscaster.Endpoint

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @doc false
  @spec start(atom, any) :: :ok | {:error, term}
  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Poscaster.Repo, []),
      supervisor(Poscaster.Endpoint, []),
    ]

    opts = [strategy: :one_for_one, name: Poscaster.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc false
  @spec config_change({atom, term}, {atom, term}, [atom]) :: :ok
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
