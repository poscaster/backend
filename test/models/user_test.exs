defmodule Poscaster.UserTest do
  use ExUnit.Case, async: true

  alias Poscaster.User

  @valid_attrs %{email: "some@content", login: "login111"}
  @invalid_attrs %{login: "test login"}

  @valid_reg_attrs Map.merge(@valid_attrs, %{password: "password", password_confirmation: "password", invitation_code: Ecto.UUID.generate})
  @invalid_reg_attrs Map.merge(@valid_attrs, %{password: "123"})

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "registration_changeset with valid attributes" do
    changeset = User.registration_changeset(%User{}, @valid_reg_attrs)
    assert changeset.valid?
  end

  test "registration_changeset with invalid attributes" do
    changeset = User.registration_changeset(%User{}, @invalid_reg_attrs)
    refute changeset.valid?
  end
end
