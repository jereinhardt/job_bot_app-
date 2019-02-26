defmodule JobBotWeb.FactoryCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import JobBot.Factory
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(JobBot.Repo)
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(JobBot.Repo, {:shared, self()})
    end
    :ok
  end
end