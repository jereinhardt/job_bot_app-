defmodule JobBot.Factory do
  use ExMachina.Ecto, repo: JobBot.Repo

  alias JobBot.Accounts.User
  alias JobBot.JobSearches.JobSearch
  alias JobBot.JobSearches.Listing

  def user_factory do
    name = sequence(:name, &"User Guy/Gal#{&1}")
    email = sequence(:email, &"email#{&1}@gmail.com")
    %User{
      name: name,
      email: email,
      password: Bcrypt.hash_pwd_salt("password")
    }
  end

  def listing_factory do
    %Listing{
      company_name: sequence(:company_name, &"comapny-#{&1}"),
      description: "We are in need of a worker",
      listing_url: sequence(:listing_url, &"www.app#{&1}.com"),
      source: "Monster",
      title: sequence(:title, &"Job Title #{&1}"),
      job_search: build(:job_search)
    }
  end

  def job_search_factory do
    %JobSearch{
      location: nil,
      sources: ["Monster"],
      terms: "Elixir Developer",
      user: build(:user),
    }
  end
end