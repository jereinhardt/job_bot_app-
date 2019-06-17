defmodule JobBotWeb.PageController do
  use JobBotWeb, :controller

  alias JobBot.{Accounts, Source}

  def index(conn, _params) do
    state = %{
      csrfToken: get_csrf_token(),
      listings: current_user_listings(conn.assigns),
      name: current_user_name(conn.assigns),
      sources: Source.all(),
      user: current_user(conn.assigns),
    }
    render conn, "index.html", state: Poison.encode!(state)
  end

  defp current_user(%{current_user: nil}), do: %{}
  defp current_user(%{current_user: user, user_token: token}) do
    Map.put(user, :token, token)
  end

  defp current_user_name(%{current_user: nil}), do: ""
  defp current_user_name(%{current_user: current_user}), do: current_user.name
  defp current_user_listings(%{current_user: nil}), do: []
  defp current_user_listings(%{current_user: current_user}) do
    current_user
    |> Map.get(:id)
    |> Accounts.listings_from_latest_search()
  end
end
