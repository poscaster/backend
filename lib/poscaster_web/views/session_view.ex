defmodule PoscasterWeb.SessionView do
  use Poscaster.Web, :view

  @spec render(String.t, %{optional(atom) => any}) :: %{optional(any) => any}
  def render("session.json", %{user: user, jwt: jwt, exp: exp}) do
    juser =
      if user do
        %{login: user.login, email: user.email}
      end
    %{user: juser, jwt: jwt, exp: exp}
  end

  def render("error.json", %{message: error}) do
    %{error: error}
  end
end
