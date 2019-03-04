defmodule JobBotWeb.UserListingsControllerTest do
  use JobBotWeb.ConnCase
  use JobBotWeb.AuthCase

  describe "update/2" do
    test "updates the user listing" do
      applied_to_at = NaiveDateTime.utc_now()
      user = insert(:user)
      user_listing = insert(:user_listing, user: user)
      params = %{
        id: user_listing.id,
        user_listing: %{applied_to_at: applied_to_at}
      }

      response =
        conn
        |> log_in_user(user)
        |> patch("/data/user_listings/#{user_listing.id}", params)
        |> json_response(200)

      response_applied_to_at =
        response
        |> Map.get("data")
        |> Map.get("user_listing")
        |> Map.get("applied_to_at")

      assert response_applied_to_at == NaiveDateTime.to_iso8601(applied_to_at)
    end
  end
end