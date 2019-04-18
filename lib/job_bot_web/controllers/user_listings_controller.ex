defmodule JobBotWeb.UserListingsController do
  use JobBotWeb, :controller

  alias JobBot.{Accounts, Repo}
  alias JobBot.Accounts.UserListing

  def index(conn, _params) do
    listings =
      conn.assigns
      |> Map.get(:current_user)
      |> Map.get(:id)
      |> Accounts.listings_from_latest_search()

    render(conn, "index.json", listings: listings)
  end

  def update(conn, %{"id" => id, "user_listing" => %{"toggle_applied_to_at" => "true"}}) do
    id = String.to_integer(id)
    user_listing =
      conn.assigns[:current_user]
      |> Accounts.get_user_listing!(id)
      |> Repo.preload(:listing)
    update = toggle_applied_to_at(user_listing)
    send_update_response(conn, update)
  end

  def update(conn, %{"id" => id, "user_listing" => user_listing_params}) do
    id = String.to_integer(id)
    user_listing =
      conn.assigns[:current_user]
      |> Accounts.get_user_listing!(id)
      |> Repo.preload(:listing)
    
    update = Accounts.update_user_listing(user_listing, user_listing_params)
    send_update_response(conn, update)
  end

  defp toggle_applied_to_at(%UserListing{applied_to_at: nil} = user_listing) do
    Accounts.update_user_listing(
      user_listing,
      %{applied_to_at: NaiveDateTime.utc_now()}
    )
  end

  defp toggle_applied_to_at(user_listing) do
    Accounts.update_user_listing(user_listing, %{applied_to_at: nil})
  end

  defp send_update_response(conn, {:ok, user_listing}) do
    render(conn, "update.json", user_listing: user_listing)
  end

  defp send_update_response(conn, {:error, _}) do
    conn
    |> put_status(401)
    |> render(
         JobBotWeb.ErrorView,
         "401.json",
         message: "We couldn't process that request"
       )    
  end
end