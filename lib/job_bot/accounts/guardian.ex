defmodule JobBot.Accounts.Guardian do
  use Guardian, otp_app: :job_bot

  alias JobBot.Accounts
  alias JobBot.Accounts.User

  @dialyzer {:nowarn_function, resource_from_claims: 1}

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

  def resource_from_claims(_), do: {:error, :reason_for_error}

  def signed_token(user) do
    Phoenix.Token.sign(JobBotWeb.Endpoint, token_salt(), user.id)
  end

  def verify_signed_token(token) do
    Phoenix.Token.verify(JobBotWeb.Endpoint, token_salt(), token, max_age: 3600)
  end

  defp token_salt do
    :job_bot
    |> Application.get_env(JobBotWeb.Endpoint)
    |> Keyword.get(:secret_key_base)    
  end
end