defmodule JobBotWeb.UsersControllerTest do
  use JobBotWeb.AuthCase
  
  import JobBot.Factory
  import JobBot.Accounts.Guardian

  describe "create/2" do
    test "logs in the user and redirects them to search", %{conn: conn} do
      {name, email, password} = {"John Doe", "john@doe.com", "password"}
      params = %{
        "user" => %{"name" => name, "email" => email, "password" => password}
      }

      redirect_response = 
        conn 
        |> post("/users", params)
        |> redirected_to()
        
      assert redirect_response == job_searches_path(conn, :new)
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