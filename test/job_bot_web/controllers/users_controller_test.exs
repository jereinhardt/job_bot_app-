defmodule JobBotWeb.UsersControllerTest do
  use JobBotWeb.ConnCase
  use JobBotWeb.AuthCase

  describe "create" do
    test "logs in the user and returns user data on success", %{conn: conn} do
      {name, email, password} = {"John Doe", "john@doe.com", "password"}
      params = %{
        "user" => %{"name" => name, "email" => email, "password" => password}
      }

      response = 
        conn 
        |> post("/data/users", params)
        |> json_response(200)

      assert response["data"]["user"]["name"] == name
      assert response["data"]["user"]["email"] == email
      assert response["data"]["user"]["id"] != nil
    end

    test "returns errors on failure", %{conn: conn} do
      expected_data = %{
        "data" => %{
          "errors" => %{
            "name" => "can't be blank",
            "email" => "can't be blank",
            "password" => "can't be blank"
          }
        }
      }

      response =
        conn
        |> post("/data/users", %{"user" => %{}})
        |> json_response(422)

      assert response == expected_data
    end
  end

  describe "show when user is logged in" do
    test "returns the current user", %{conn: conn} do
      user = insert(:user)
      data = %{
        "data" => %{
          "user" => %{
            "id" => user.id,
            "name" => user.name,
            "email" => user.email
          }
        }
      }
      response = 
        conn
        |> log_in_user(user)
        |> get("/data/users")
        |> json_response(200)

      assert response == data
    end
  end

  describe "show when the user is logged out" do
    test "returns nil", %{conn: conn} do
      response =
        conn
        |> get("/data/users")
        |> json_response(200)

      assert response == %{"data" => %{"user" => nil}}
    end
  end
end