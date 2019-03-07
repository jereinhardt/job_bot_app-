defmodule JobBotWeb.UserChannel do
  use Phoenix.Channel
  alias JobBot.Accounts

  def join("users:" <> user_id, _params, socket) do
    if authorized?(socket, user_id) do
      listings = Accounts.listings_from_latest_search(user_id)
      {:ok, %{listings: listings}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("new_listing", %{"listing" => user_listing}, socket) do
    broadcast! socket, "new_listing", %{"listing" => user_listing}
    {:noreply, socket}
  end

  defp authorized?(socket, user_id) do
    socket_user_id = if is_integer(socket.assigns[:user_id]) do
        Integer.to_string(socket.assigns[:user_id])
      else
        socket.assigns[:user_id]
      end

    socket_user_id == user_id
  end  
end