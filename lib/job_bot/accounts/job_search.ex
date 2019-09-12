defmodule JobBot.Accounts.JobSearch do
  use Ecto.Schema
  import Ecto.Changeset
  alias JobBot.Accounts.User

  schema "job_searches" do
    field :location, :string
    field :sources, {:array, :string}
    field :terms, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(job_search, attrs) do
    job_search
    |> cast(attrs, [:location, :sources, :terms])
    |> validate_required([:location, :sources, :terms])
  end
end
