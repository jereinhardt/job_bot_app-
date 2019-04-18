defmodule JobBotWeb.UsersView do
  use JobBotWeb, :view

  def render("create.json", %{user: user, token: token}) do
    %{data: %{user: json_user(user, token)}}
  end

  def render("create.json", %{errors: errors}) do
    %{data: %{errors: json_errors(errors)}}
  end

  def render("show.json", %{user: user, token: token}) do
    %{data: %{user: json_user(user, token)}}
  end

  defp json_user(user, token) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      token: token
    }
  end

  defp json_errors(errors) do
    Enum.reduce(errors, %{}, fn ({key, {value, _}}, acc) ->
      Map.put(acc, key, value)
    end)
  end
end