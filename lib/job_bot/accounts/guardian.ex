defmodule JobBot.Accounts.Guardian do
  use Guardian, otp_app: :job_bot

  alias JobBot.Accounts
  alias JobBot.Accounts.User

  def subject_for_token(%User{} = user, _claims) do
    {:ok, to_string(user.id)}
  end

  def subject_for_token(_, _), do: {:error, :reason_for_error}

  def resource_from_claims(claims) do
    user =
      claims["sub"]
      |> Accounts.get_user!()
    {:ok, user}
  end

  def resource_from_claims(_claims), do: {:error, :reason_for_error}
end