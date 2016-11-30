defmodule Poscaster.SubscriptionController do
  use Poscaster.Web, :controller
  alias Poscaster.Subscription


  def create(conn, %{"subscription" => subscription_params}) do
    # conn
    # |> render("subscription.json", subscription: subscription)
  end
end
