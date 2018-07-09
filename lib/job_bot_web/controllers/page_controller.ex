defmodule JobBotWeb.PageController do
  use JobBotWeb, :controller

  def index(conn, _params) do
    render conn, "index.html", token: get_csrf_token()
  end
end
