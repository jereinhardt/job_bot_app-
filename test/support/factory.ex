defmodule JobBot.Factory do
  use ExMachina.Ecto, repo: JobBot.Repo

  def user_factory do
    name = sequence(:name, &"User Guy/Gal#{&1}")
    email = sequence(:email, &"email#{&1}@gmail.com")
    %JobBot.Accounts.User{
      name: name,
      email: email,
      password: Bcrypt.hash_pwd_salt("password")
    }
  end

  def listing_factory do
    %JobBot.Listing{
      company_name: sequence(:company_name, &"comapny-#{&1}"),
      description: "We are in need of a worker",
      listing_url: sequence(:listing_url, &"www.app#{&1}.com"),
      source: "We Work Remotely",
      title: sequence(:title, &"Job Title #{&1}"),
    }
  end

  def user_listing_factory do
    %JobBot.Accounts.UserListing{
      user: insert(:user),
      listing: insert(:listing),
      searched_for_at: DateTime.utc_now()
    }
  end
end