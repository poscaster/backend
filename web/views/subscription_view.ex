defmodule Poscaster.SubscriptionView do
  use Poscaster.Web, :view

  @spec render(String.t, %{optional(atom) => any}) :: %{optional(any) => any}
  def render("subscription.json", %{subscription: %{feed: feed}}) do
    %{subscription: %{url: feed.url, title: feed.title, description: feed.description}}
  end

  def render("error.json", %{error: error}) do
    %{error: error}
  end
end
