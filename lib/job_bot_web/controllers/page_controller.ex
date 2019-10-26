defmodule JobBotWeb.PageController do
  use JobBotWeb, :controller

  alias JobBot.{Accounts, Source}

  def index(conn, _params) do
    %{current_user: user} = conn.assigns

    if user do
      conn
      |> redirect(to: most_recent_search_results_path(conn, :show))
    else
      render(conn, "index.html")
    end
  end
end
