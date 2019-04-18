defmodule JobBotWeb.UserListingsView do
  use JobBotWeb, :view

  def render("index.json", %{listings: listings}) do
    %{data: %{listings: listings}}
  end

  def render("update.json", %{user_listing: user_listing}) do
    %{data: %{user_listing: user_listing}}
  end
end