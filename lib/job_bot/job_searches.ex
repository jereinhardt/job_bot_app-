defmodule JobBot.JobSearches do
  alias JobBot.JobSearches.JobSearch

  import Ecto.Query

  def create(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:job_searches)
    |> JobSearch.changeset(attrs)
    |> Repo.insert()
  end
end