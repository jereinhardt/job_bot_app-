defmodule JobBot.Accounts do
  import Ecto.Query, warn: false
  alias JobBot.Repo
  alias JobBot.Accounts.User
  alias Comeonin.Bcrypt

  def get_user!(id) do
    User
    |> Repo.get!(id)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def authenticate_user(email, given_password) do
    query = 
      from u in User,
      where: u.email == ^email

    Repo.one(query)
    |> check_password(given_password)
  end

  def login(conn, user) do
    conn
    |> JobBot.Accounts.Guardian.Plug.sign_in(user)
    |> Plug.Conn.assign(:current_user, user)
  end
  
  def logout(conn) do
    conn
    |> JobBot.Accounts.Guardian.Plug.sign_out()
  end

  defp check_password(nil, _), do: {:error, "Incorrect email or password"}
  defp check_password(user, given_password) do
    case Bcrypt.checkpw(given_password, user.password) do
      true -> {:ok, user}
      false -> {:error, "Incorrect email or password"}
    end
  end
end