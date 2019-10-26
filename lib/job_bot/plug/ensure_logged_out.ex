defmodule JobBot.Plug.EnsureLoggedOut do
  import Plug.Conn
  import import Phoenix.Controller, only: [redirect: 2]

  alias JobBotWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _) do
    case conn.assigns.current_user do
      nil   -> conn
      _user -> redirect(conn, to: Routes.page_path(conn, :index))
    end
  end
end