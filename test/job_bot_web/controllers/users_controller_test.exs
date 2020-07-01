defmodule JobBotWeb.UsersControllerTest do
  use JobBotWeb.AuthCase
  
  import JobBot.Factory

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

  describe "update/2" do
    setup :log_in_user

    test "renders a success response when submitted attributes are valid", %{conn: conn, user: _user} do
      params = %{"user" => %{"name" => "John Doe"}}

      redirect_response =
        conn
        |> put("/account", params)
        |> redirected_to()

      assert redirect_response == users_path(conn, :edit)
    end

    test "renders error message when invalid attributes are submitted", %{conn: conn, user: _user} do
      params = %{"user" => %{"name" => ""}}
      
      response =
        conn
        |> put("/account", params)
        |> html_response(200)

      assert response =~ "Please make sure your information is valid"
    end
  end
end