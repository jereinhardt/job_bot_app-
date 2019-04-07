defmodule JobBotWeb.UserListingsView do
  use JobBotWeb, :view

  def render("update.json", %{user_listing: user_listing}) do
    %{data: %{user_listing: user_listing}}
  end
end