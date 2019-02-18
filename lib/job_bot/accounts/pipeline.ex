defmodule JobBot.Accounts.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :job_bot,
    module: JobBot.Accounts.Guardian,
    error_handler: JobBot.Accounts.ErrorHandler

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
  plug :assign_current_user

  defp assign_current_user(conn, _) do
    user = JobBot.Accounts.Guardian.Plug.current_resource(conn)

    conn
    |> Plug.Conn.assign(:current_user, user)
  end
end