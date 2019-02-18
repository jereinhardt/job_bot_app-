defmodule JobBotWeb.SessionView do
  use JobBotWeb, :view

  def render("create.json", %{user: user}) do
    %{data: %{user: user_json(user)}}
  end

  defp user_json(user) do
    %{
      id: user.id,
      name: user.name,
      email: user.email
    }
  end
end