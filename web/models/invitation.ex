defmodule Poscaster.Invitation do
  @moduledoc """
  Invitation model module
  """

  use Poscaster.Web, :model

  @primary_key {:code, :binary_id, read_after_writes: true}

  schema "invitations" do
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  @spec changeset(%Poscaster.Invitation{}, %{optional(any) => any}) :: %Ecto.Changeset{}
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:code])
    |> validate_required([:code])
  end
end
