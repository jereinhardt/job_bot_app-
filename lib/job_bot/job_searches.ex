defmodule JobBot.JobSearches do
  alias JobBot.Accounts.User
  alias JobBot.JobSearches.JobSearch
  alias JobBot.JobSearches.Listing
  alias JobBot.Repo

  import Ecto.Query

  def create(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:job_searches)
    |> JobSearch.changeset(attrs)
    |> Repo.insert()
  end

  def get!(id) do
    JobSearch
    |> Repo.get!(id)
    |> Repo.preload([:listings, :user])
  end

  def get(user, id) do
    user
    |> Ecto.assoc(:job_searches)
    |> where([j], j.id == ^id)
    |> preload([:listings])
    |> Repo.one()
  end

  def get_most_recent!(user) do
    user_id = user.id
    query =
      from s in JobSearch,
      where: s.user_id == ^user_id,
      order_by: [desc: s.inserted_at],
      limit: 1,
      preload: [:listings]

    Repo.one(query)    
  end

  def get_listings(job_search, opts \\ []) do
    opts = Enum.into(opts, %{})
    
    job_search
    |> Ecto.assoc(:listings)
    |> order_by(asc: :inserted_at)
    |> JobBot.Repo.paginate(opts)
  end

  def get_listing(id) do
    Repo.get(Listing, id)
  end

  def create_listing(job_search, attrs) do
    job_search
    |> Ecto.build_assoc(:listings)
    |> Listing.changeset(attrs)
    |> Repo.insert()
  end

  def update_listing(listing, attrs) do
    listing
    |> Listing.changeset(attrs)
    |> Repo.update()
  end
end