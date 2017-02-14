defmodule Poscaster.GuardianSerializer do
  @moduledoc """
  User serializer for guardan sessions
  """

  @behaviour Guardian.Serializer

  alias Poscaster.Repo
  alias Poscaster.User

  @spec for_token(%{optional(any) => any}) :: {:ok|:error, String.t}
  def for_token(user = %User{}), do: {:ok, "User:#{user.id}"}
  def for_token(_), do: {:error, "Unknown resource type"}

  @spec from_token(String.t) :: {:ok|:error, any}
  def from_token("User:" <> id), do: {:ok, Repo.get(User, id)}
  def from_token(_), do: {:error, "Unknown resource type"}
end
