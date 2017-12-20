defmodule PoscasterWeb.Guardian do
  @moduledoc """
  User serializer for guardan sessions
  """

  use Guardian, otp_app: :poscaster
  alias Poscaster.Repo
  alias Poscaster.User

  @spec subject_for_token(%{optional(any) => any}, %{optional(any) => any}) :: {:ok|:error, String.t}
  def subject_for_token(user = %User{}, _claims), do: {:ok, "User:#{user.id}"}
  def subject_for_token(_, _), do: {:error, "Unknown resource type"}

  @spec resource_from_claims(%{optional(any) => any}) :: {:ok|:error, any}
  def resource_from_claims(%{"sub" => "User:" <> id}), do: {:ok, Repo.get(User, id)}
  def resource_from_claims(_), do: {:error, "Unknown resource type"}
end
