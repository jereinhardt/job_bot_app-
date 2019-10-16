defmodule JobBot.Accounts do
  import Ecto.Query, warn: false
  alias JobBot.Repo
  alias JobBot.Accounts.{User, JobSearch}
  alias Comeonin.Bcrypt

  def new_user(params \\ %{}) do
    User.changeset(%User{}, params)
  end

  def get_user!(id) do
    Repo.get!(User, id)
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

  def get_job_search!(id) do
    Repo.get!(JobSearch, id)
  end

  def most_recent_job_search(%User{id: id}) do
    most_recent_job_search(id)
  end

  def most_recent_job_search(user_id) do
    latest_search_query =
      from s in JobSearch,
      select: max(s.created_at),
      where: s.user_id == ^user_id,
      preload: [:listings]

    Repo.one(latest_search_query)
  end

  defp check_password(nil, _), do: {:error, "Incorrect email or password"}
  defp check_password(user, given_password) do
    case Bcrypt.checkpw(given_password, user.password) do
      true -> {:ok, user}
      false -> {:error, "Incorrect email or password"}
    end
  end
end