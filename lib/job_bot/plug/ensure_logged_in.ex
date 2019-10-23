defmodule JobBot.Plug.EnsureLoggedIn do
  import Plug.Conn
  import import Phoenix.Controller, only: [redirect: 2]

  alias JobBotWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:info, "Please log in to view this page")
      |> redirect(to: Routes.session_path(conn, :new))
    end
  end
end