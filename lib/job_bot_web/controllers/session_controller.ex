defmodule JobBotWeb.SessionController do
  use JobBotWeb, :controller
  plug Guardian.Plug.EnsureAuthenticated when action in [:delete]

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case JobBot.Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        token = Phoenix.Token.sign(conn, "user socket", user.id)
        conn
        |> JobBot.Accounts.login(user)
        |> render("create.json", user: user, token: token)

      {:error, _reason} ->
        conn
        |> put_status(401)
        |> render(
            JobBotWeb.ErrorView,
            "401.json",
            message: "We couldn't find that email and password."
          )
    end
  end

  def delete(conn, _) do
    conn
    |> JobBot.Accounts.logout()
    |> redirect(to: page_path(conn, :index))
  end
end