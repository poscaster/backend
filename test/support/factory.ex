defmodule Poscaster.Factory do
  use ExMachina.Ecto, repo: Poscaster.Repo
  alias Poscaster.Feed
  alias Poscaster.Invitation
  alias Poscaster.User
  alias Poscaster.Subscription

  def user_factory do
    pass = sequence(:password, &"password-#{&1}")
    %User{
      login: sequence(:login, &"user-#{&1}"),
      email: sequence(:email, &"email-#{&1}@example.com"),
      invitation: build(:invitation),
      password: pass,
      password_hash: Comeonin.Bcrypt.hashpwsalt(pass)
    }
  end

  def invitation_factory do
    %Invitation{}
  end

  def feed_factory do
    %Feed{
      description: sequence(:description, &"description-#{&1}"),
      last_fetched_at: "2010-01-01 01:02:03",
      title: sequence(:title, &"title-#{&1}"),
      url: sequence(:url, &"http://example.com/feed#{&1}"),
      creator: build(:user)
    }
  end

  def subscription_factory do
    %Subscription{
      feed: build(:feed),
      user: build(:user)
    }
  end
end
