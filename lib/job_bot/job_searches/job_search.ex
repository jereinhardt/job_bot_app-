defmodule JobBot.JobSearches.JobSearch do
  use Ecto.Schema

  import Ecto.Changeset

  alias JobBot.Accounts.User
  alias JobBot.JobSearches.Listing

  schema "job_searches" do
    field :location, :string
    field :sources, {:array, :string}
    field :terms, :string

    belongs_to :user, User

    has_many :listings, Listing

    timestamps()
  end

  @doc false
  def changeset(job_search, attrs \\ %{}) do
    job_search
    |> cast(attrs, [:location, :terms])
    |> cast_sources(attrs)
    |> validate_required([:terms])
    |> validate_at_least_one_source_selected()
  end

  defp cast_sources(changeset, %{"sources" => sources}) do
    cast_sources(changeset, %{sources: sources})
  end

  defp cast_sources(changeset, %{sources: sources}) when is_list(sources) do
    normalized_sources = 
      sources
      |> Enum.reject(&is_nil/1)
      |> Enum.reject(&(&1 == ""))
    cast(changeset, %{sources: normalized_sources}, [:sources])
  end

  defp cast_sources(changeset, _), do: changeset

  defp validate_at_least_one_source_selected(changeset) do
    sources = get_field(changeset, :sources)
    if is_nil(sources) || Enum.count(sources) < 1 do
      add_error(changeset, :sources, "at least one must be selected")
    else
      changeset
    end
  end
end
