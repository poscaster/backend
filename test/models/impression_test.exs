defmodule Poscaster.ImpressionTest do
  use Poscaster.ModelCase

  alias Poscaster.Impression

  @valid_attrs %{finished: true, paused_at: 0}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Impression.changeset(%Impression{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Impression.changeset(%Impression{}, @invalid_attrs)
    refute changeset.valid?
  end
end
