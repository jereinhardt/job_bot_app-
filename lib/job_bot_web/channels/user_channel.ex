defmodule JobBotWeb.UserChannel do
  use Phoenix.Channel

  def join("users:" <> user_id, _params, socket) do
    if authorized?(socket, user_id) do
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

  defp authorized?(socket, user_id) do
    socket_user_id = if is_integer(socket.assigns[:user_id]) do
        Integer.to_string(socket.assigns[:user_id])
      else
        socket.assigns[:user_id]
      end

    socket_user_id == user_id
  end  
end