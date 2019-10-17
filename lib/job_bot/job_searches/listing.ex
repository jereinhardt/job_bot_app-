defmodule JobBot.JobSearches.Listing do
  use Ecto.Schema

  import Ecto.Query, warn: false
  import Ecto.Changeset

  alias JobBot.Repo
  alias JobBot.Source
  alias JobBot.JobSearches.JobSearch

  @derive {Poison.Encoder, except: [:__meta__]}
  schema "listings" do
    field :application_url, :string
    field :city, :string
    field :company_name, :string
    field :description, :string
    field :email, :string
    field :listing_url, :string
    field :remote, :boolean, default: false
    field :salary, :string
    field :skills, {:array, :string}
    field :title, :string
    field :source, :string
    belongs_to :job_search, JobSearch

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{source: %Source{name: source_name}} = listing, attrs) do
    listing
    |> Map.put(:source, source_name)
    |> changeset(attrs)
  end

  @doc false
  def changeset(listing, attrs) do
    listing
    |> cast(attrs, casted_attrs())
    |> validate_required(required_attrs())
  end

  def get!(id) do
    __MODULE__
    |> Repo.get!(id)
  end

  def create(listing, attrs \\ %{}) do
    listing
    |> changeset(attrs)
    |> Repo.insert()
  end

  def find_or_create(listing) do
    case find_existing_listing(listing) do
      %__MODULE__{} = existing_listing -> {:ok, existing_listing}
      nil -> create(listing)
    end
  end

  def find_existing_listing(%__MODULE__{listing_url: listing_url}) do
    find_existing_listing(listing_url)
  end

  def find_existing_listing(listing_url) do
    query =
      from l in __MODULE__,
      where: l.listing_url == ^listing_url

    Repo.one(query)
  end

  defp casted_attrs do
    [
      :title,
      :description,
      :city,
      :remote,
      :salary,
      :email,
      :company_name,
      :listing_url,
      :application_url,
      :skills,
      :source
    ]
  end

  defp required_attrs do
    [
      :title,
      :description,
      :company_name,
      :listing_url
    ]
  end
end
