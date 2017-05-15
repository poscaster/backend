defmodule Poscaster.SubscriptionView do
  use Poscaster.Web, :view

  @spec render(String.t, %{optional(atom) => any}) :: %{optional(any) => any}
  def render("subscription.json", subscription) do
    %{subscription: render("subscription_int.json", subscription)}
  end

  @spec render(String.t, %{subscriptions: [%{optional(atom) => any}]}) :: [%{optional(any) => any}]
  def render("subscriptions.json", %{subscriptions: subscriptions}) do
    %{subscriptions: Enum.map(subscriptions, &render("subscription_int.json", %{subscription: &1}))}
  end

  @spec render(String.t, %{subscription: %{feed: %{optional(atom) => any}}}) :: %{optional(any) => any}
  def render("subscription_int.json", %{subscription: %{feed: feed}}) do
    %{feed_id: feed.id, url: feed.url, title: feed.title, description: feed.description}
  end

  @spec render(String.t, %{optional(atom) => any}) :: %{optional(any) => any}
  def render("error.json", %{error: error}) do
    %{error: error}
  end
end
