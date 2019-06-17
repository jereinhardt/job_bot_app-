defmodule JobBotWeb.SessionControllerTest do
  use JobBotWeb.ConnCase
  use JobBotWeb.AuthCase

  import Mock

  describe "create session" do
    test "successful json requests return the user", %{conn: conn} do
      with_mock( Phoenix.Token, [sign: fn(_, _, _) -> "token" end]) do
        user = insert(:user)
        json_user = %{
          "id" => user.id,
          "name" => user.name,
          "email" => user.email,
          "token" => "token",
          "userListings" => []
        }
        data = %{"data" => %{"user" => json_user}}

        params = 
          %{"session" => %{"email" => user.email, "password" => "password"}}
        response = 
          conn
          |> post("/session", params)
          |> json_response(200)

        assert response == data
      end
    end
  end

  describe "delete session" do
    setup do
      user = insert(:user)
      log_in_user(user)
    end

    test "redirects to the home page", %{conn: conn} do
      response = delete(conn, "/session")

      assert redirected_to(response) == page_path(response, :index)
    end
  end
end