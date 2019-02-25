defmodule JobBotWeb.SessionView do
  use JobBotWeb, :view

  def render("create.json", %{user: user, token: token}) do
    %{data: %{user: user_json(user, token)}}
  end

  defp user_json(user, token) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      token: token
    }
  end
end