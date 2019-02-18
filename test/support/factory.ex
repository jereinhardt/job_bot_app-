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
end