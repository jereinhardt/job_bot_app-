defmodule JobBotWeb.AuthCase do
  alias JobBot.Accounts.User

  defmacro __using__(_opts) do
    quote do
      import JobBot.Accounts.Guardian
      import JobBot.Factory


      defp log_in_user(%Plug.Conn{} = conn, %User{} = user) do
        {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)

        conn = conn
        |> put_req_header("authorization", "bearer: " <> token)
      end


      defp log_in_user(%User{} = user) do
        {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)

        conn = build_conn()
        |> put_req_header("authorization", "bearer: " <> token) 

        {:ok, conn: conn}      
      end

      defp log_in_user(_) do
        user = insert(:user)
        {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)

        conn = build_conn()
        |> put_req_header("authorization", "bearer: " <> token)

        {:ok, conn: conn}
      end
      
      defp build_conn_with_logged_in_user do
        user = insert(:user)
        {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)

        conn = build_conn()
        |> put_req_header("authorization", "bearer: " <> token)

        conn
      end
    end
  end
end