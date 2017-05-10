defmodule Poscaster.User do
  @moduledoc """
  User model module
  """

  use Poscaster.Web, :model
  import Ecto.Query
  alias Comeonin.Bcrypt
  alias Poscaster.Repo

  schema "users" do
    belongs_to :invitation, Poscaster.Invitation, foreign_key: :invitation_code,
                                                  type: :binary_id

    field :email, :string
    field :login, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  @spec changeset(%Poscaster.User{}, %{optional(atom) => any}) :: %Ecto.Changeset{}
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w(login email))
    |> validate_required(~w(login email)a)
    |> validate_format(:login, ~r/\A\w{4,}\z/)
    |> validate_format(:email, ~r/\A[^\s]+@[^\s]{3,}\z/)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
    |> unique_constraint(:login)
  end

  @spec registration_changeset(%Poscaster.User{}, %{optional(atom) => any}) :: %Ecto.Changeset{}
  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, ~w(password password_confirmation invitation_code))
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password)

    |> validate_required(:invitation_code)
    |> validate_format(:invitation_code, # UUID
                       ~r/[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}/)
    |> foreign_key_constraint(:invitation_code)
    |> unique_constraint(:invitation_code)

    |> put_password_hash()
  end

  @spec find_and_confirm_password(%{"user": %{"login": String.t, "password": String.t}}) :: {:error} | {:ok, %Poscaster.User{}}
  def find_and_confirm_password(%{"user" => %{"login" => login, "password" => password}}) do
    user = if login, do: find_by_email_or_login(login)
    if user && password do
      if Bcrypt.checkpw(password, user.password_hash) do
        {:ok, user}
      else
        {:error}
      end
    else
      # No timing attack shall pass
      Bcrypt.dummy_checkpw()
      {:error}
    end
  end

  @spec find_by_email_or_login(String.t) :: %Poscaster.User{}
  defp find_by_email_or_login(str) do
    Poscaster.User
    |> where([u], u.login == ^str or u.email == ^str)
    |> first
    |> Repo.one
  end

  @spec put_password_hash(%Ecto.Changeset{}) :: %Ecto.Changeset{}
  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash,
          Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
