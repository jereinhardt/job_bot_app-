defmodule JobBotWeb.UserChannelTest do
  use JobBotWeb.ChannelCase

  import JobBot.Factory

  alias JobBotWeb.UserChannel

  setup do
    user = insert(:user)
    {:ok, _, socket} =
      socket(nil, %{user_id: user.id})
      |> subscribe_and_join(UserChannel, "users:#{user.id}")

    {:ok, socket: socket, user: user}
  end

  test(
    "join/3 returns listings from latest search",
    %{socket: socket, user: user}
  ) do
    new_timestamp = NaiveDateTime.utc_now
    old_timestamp = new_timestamp |> NaiveDateTime.add(-604800)

    insert(
      :user_listing,
      %{searched_for_at: old_timestamp, user: user}
    )
    new_user_listing = insert(
      :user_listing,
      %{searched_for_at: new_timestamp, user: user}
    )

    {resp, %{listings: [listing]}, _} = UserChannel.join("users:#{user.id}", %{}, socket)

    assert resp == :ok
    assert JobBot.Repo.preload(listing, :user) == new_user_listing
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