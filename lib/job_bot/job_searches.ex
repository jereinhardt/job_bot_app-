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
    Repo.get!(JobSearch, id)
  end

  def get(id) do
    Repo.get(JobSearch, id)
  end

  def get_most_recent!(user) do
    user_id = user.id
    query =
      from s in JobSearch,
      where: s.user_id == ^user_id,
      order_by: [desc: s.inserted_at],
      limit: 1,
      preload: [:listings, :user]

    Repo.one(query)    
  end

  def create_listing(job_search, attrs) do
    job_search
    |> Ecto.build_assoc(:listings)
    |> Listing.changeset(attrs)
    |> Repo.insert()
  end
end