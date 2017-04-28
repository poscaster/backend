defmodule Poscaster.UserView do
  use Poscaster.Web, :view
  alias Ecto.Changeset

  @spec render(String.t, %{optional(atom) => any}) :: %{optional(any) => any}
  def render("user.json", %{user: user}) do
    %{user: %{login: user.login, email: user.email}}
  end

  def render("error.json", %{changeset: changeset}) do
    errors = Changeset.traverse_errors(changeset, fn
      {msg, opts} ->
        Enum.reduce(opts, msg, fn {k, v}, acc ->
          String.replace(acc, "%{#{k}}", to_string(v))
        end)
      msg -> msg
    end)

    %{errors: %{user: errors}}
  end
end
