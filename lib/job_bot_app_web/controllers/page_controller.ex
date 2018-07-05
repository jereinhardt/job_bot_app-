defmodule JobBotWeb.PageController do
  use JobBotWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
