defmodule JobBotWeb.UsersController do
  use JobBotWeb, :controller

  def create(conn, %{"user" => user_params}) do
    case JobBot.Accounts.create_user(user_params) do
      {:ok, user} -> 
        token = Phoenix.Token.sign(conn, "user socket", user.id)
        conn
        |> JobBot.Accounts.login(user)
        |> render("create.json", user: user, token: token)
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render("create.json", errors: changeset.errors)
    end
  end

  def show(conn, _params) do
    render(
      conn,
      "show.json",
      user: conn.assigns[:current_user],
      token: conn.assigns[:user_token]
    )
  end
end