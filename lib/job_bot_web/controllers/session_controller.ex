defmodule JobBotWeb.SessionController do
  use JobBotWeb, :controller

  alias JobBot.Accounts

  plug Guardian.Plug.EnsureAuthenticated when action in [:delete]

  def new(conn, _params) do
    changeset = Accounts.new_user()

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    case JobBot.Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> JobBot.Accounts.login(user)
        |> redirect(to: page_path(conn, :index))
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: session_path(conn, :new))
    end
  end

  def delete(conn, _) do
    conn
    |> JobBot.Accounts.logout()
    |> redirect(to: page_path(conn, :index))
  end
end