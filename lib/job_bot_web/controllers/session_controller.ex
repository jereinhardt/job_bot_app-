defmodule JobBotWeb.SessionController do
  use JobBotWeb, :controller
  plug Guardian.Plug.EnsureAuthenticated when action in [:delete]

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case JobBot.Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> JobBot.Accounts.login(user)
        |> render("create.json", user: user)

      {:error, _reason} ->
        conn
        |> put_status(401)
        |> render(ErrorView, "401.json", message: "We couldn't find that username and password.")
    end
  end

  def delete(conn, _) do
    conn
    |> JobBot.Accounts.logout()
    |> redirect(to: page_path(conn, :index))
  end
end