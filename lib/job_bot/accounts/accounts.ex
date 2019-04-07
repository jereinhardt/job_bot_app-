defmodule JobBot.Accounts do
  import Ecto.Query, warn: false
  alias JobBot.Repo
  alias JobBot.Accounts.{User, UserListing}
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

  def get_user_listing!(%User{id: id}, user_listing_id) do
    get_user_listing!(id, user_listing_id)
  end
  
  def get_user_listing!(user_id, user_listing_id) do
    query =
      from ul in UserListing,
      where: ul.user_id == ^user_id,
      where: ul.id == ^user_listing_id

    Repo.one!(query)
  end

  def create_user_listing(attrs \\ %{}) do
    %UserListing{}
    |> create_user_listing(attrs)
  end

  def create_user_listing(%UserListing{} = user_listing, attrs) do
    user_listing
    |> UserListing.changeset(attrs)
    |> Repo.insert()
  end

  def update_user_listing(%UserListing{} = user_listing, attrs) do
    user_listing
    |> UserListing.changeset(attrs)
    |> Repo.update()
  end

  def listings_from_latest_search(%User{id: id}) do
    listings_from_latest_search(id)
  end

  def listings_from_latest_search(user_id) do
    latest_search_query =
      from ul in UserListing,
      select: max(ul.searched_for_at),
      where: ul.user_id == ^user_id

    latest_search_at = Repo.one(latest_search_query)

    if is_nil(latest_search_at) do
      []
    else
      query =
        from ul in UserListing,
        where: ul.searched_for_at == ^latest_search_at,
        where: ul.user_id == ^user_id,
        preload: [:listing]

      Repo.all(query)
    end
  end

  defp check_password(nil, _), do: {:error, "Incorrect email or password"}
  defp check_password(user, given_password) do
    case Bcrypt.checkpw(given_password, user.password) do
      true -> {:ok, user}
      false -> {:error, "Incorrect email or password"}
    end
  end
end