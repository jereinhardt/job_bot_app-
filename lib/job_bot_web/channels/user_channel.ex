defmodule JobBotWeb.UserChannel do
  use Phoenix.Channel

  def join("users:" <> user_id, _params, socket) do
    if socket.assigns[:user_id] == String.to_integer(user_id) do
      # TODO: get all the listings associated with the user id and return them
      # with the socket
      {:ok, %{listings: []}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("new_listing", %{"listing" => listing}, socket) do
    broadcast! socket, "new_listing", %{"listing" => listing}
    {:noreply, socket}
  end
end