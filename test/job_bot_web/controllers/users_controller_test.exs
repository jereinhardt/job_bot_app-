defmodule JobBotWeb.UsersControllerTest do
  use JobBotWeb.AuthCase
  
  import JobBot.Factory
  import JobBot.Accounts.Guardian

  alias JobBot.Accounts

  describe "create/2" do
    test "logs in the user and returns user data on success", %{conn: conn} do
      {name, email, password} = {"John Doe", "john@doe.com", "password"}
      params = %{
        "user" => %{"name" => name, "email" => email, "password" => password}
      }

      response_redirect = 
        conn 
        |> post("/users", params)
        |> redirected_to()

      assert response_redirect == "/search"
    end

    test "returns errors on failure", %{conn: conn} do
      params = %{ "user" => %{} }

      response =
        conn
        |> post("/users", params)
        |> html_response(200)

      assert response =~ "Please fill in the required fields"
    end
  end
end