defmodule JobBotWeb.UserChannelTest do
  use JobBotWeb.ChannelCase

  alias JobBotWeb.UserChannel

  setup do
    user_id = 1
    {:ok, _, socket} =
      socket(nil, %{user_id: user_id})
      |> subscribe_and_join(UserChannel, "users:#{user_id}")

    {:ok, socket: socket, user_id: user_id}
  end

  test(
    "join/3 returns associated listings",
    %{socket: socket, user_id: user_id}
  ) do
    {resp, assigns, _} = UserChannel.join("users:#{user_id}", %{}, socket)

    assert resp == :ok
    assert assigns == %{listings: []}
  end

  test(
    "new_listing returns the new listing",
    %{socket: socket}
  ) do
    listing = %JobBot.Listing{title: "New Listing"}
    push socket, "new_listing", %{"listing" => listing}

    assert_broadcast "new_listing", %{"listing" => listing}
  end
end