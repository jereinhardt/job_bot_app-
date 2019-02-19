defmodule JobBotWeb.SessionControllerTest do
  use JobBotWeb.ConnCase
  use JobBotWeb.AuthCase

  describe "create session" do
    test "successful json requests return the user" do
      user = insert(:user)
      json_user = %{
        "id" => user.id,
        "name" => user.name,
        "email" => user.email
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