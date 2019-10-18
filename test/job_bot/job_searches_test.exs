defmodule JobBot.JobSearchesTest do
  use ExUnit.Case
  use JobBotWeb.FactoryCase

  alias JobBot.JobSearches
  alias JobBot.Repo

  describe "get/2" do
    test "returns the user's job search" do
      job_search = insert(:job_search)
      user = job_search.user
      id = job_search.id

      assert JobSearches.get(user, id).id == job_search.id
    end
  end

  describe "get_most_recent!/2" do
    test "returns the user's most recent search" do
      user = insert(:user)
      datetime = 
        NaiveDateTime.utc_now()
        |> NaiveDateTime.add(-200000)
      old_job_search = insert(:job_search, user: user, inserted_at: datetime)
      new_job_search = insert(:job_search, user: user)

      assert JobSearches.get_most_recent!(user).id == new_job_search.id
    end
  end
end