defmodule Poscaster.SubscriptionView do
  use Poscaster.Web, :view

  def render("subscription.json", %{subscription: %{feed: feed}}) do
    %{subscription: %{url: feed.url, title: feed.title, description: feed.description}}
  end

  def render("error.json", %{error: error}) do
    %{error: error}
  end
end
