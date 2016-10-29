defmodule Poscaster.InvitationTest do
  use ExUnit.Case, async: true

  alias Poscaster.Invitation

  @valid_attrs %{code: Ecto.UUID.generate}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Invitation.changeset(%Invitation{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Invitation.changeset(%Invitation{}, @invalid_attrs)
    refute changeset.valid?
  end
end
