defmodule JobBotWeb.SessionControllerTest do
  use JobBotWeb.AuthCase

  describe "create/2" do
    test "logs the user in with valid credentials", %{conn: conn} do
      user = insert(:user)
      params = %{"user" => %{"email" => user.email, "password" => "password"}}
      path = session_path(conn, :create)

      response =
        conn
        |> post(path, params)

      refute response.assigns.current_user == nil
      assert redirected_to(response) == page_path(conn, :index)
    end

    test "renders errors with invalid credentials", %{conn: conn} do
      params = %{"user" => %{"email" => "", "password" => ""}}
      path = session_path(conn, :create)

      response =
        conn
        |> post(path, params)

      assert get_flash(response, :error) == "Incorrect email or password"
      assert redirected_to(response) == session_path(conn, :new)
    end
  end

  describe "delete/2" do
    setup do
      user = insert(:user)
      log_in_user(user)
    end

    test "redirects to the home page", %{conn: conn} do
      path = session_path(conn, :delete)
      response = 
        conn
        |> delete(path)
        |> redirected_to()

      assert response == page_path(conn, :index)
    end
  end
end