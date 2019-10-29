defmodule JobBotWeb.UsersController do
  use JobBotWeb, :controller

  alias JobBot.Accounts

  def new(conn, _params) do
    changeset = Accounts.new_user()

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.create_user(user_params) do
      conn
      |> Accounts.login(user)
      |> put_flash(:success, "Welcome to JobBot!")
      |> redirect(to: job_searches_path(conn, :new))
    else
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Please fill in the required fields")
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, _params) do
    changeset = Accounts.edit_user(conn.assigns.current_user)

    conn
    |> render("edit.html", changeset: changeset)
  end

  def update(conn, %{"user" => user_params}) do
    user = conn.assigns.current_user

    with {:ok, user} <- Accounts.update_user(user, user_params) do
      conn
      |> put_flash(:success, "Your profile has been updated")
      |> redirect(to: users_path(conn, :edit))
    else
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Please make sure your information is valid")
        |> render("edit.html", changeset: changeset)
    end
  end
end