defmodule JobBot.JobSearches.Listing do
  use Ecto.Schema

  import Ecto.Query, warn: false
  import Ecto.Changeset

  alias JobBot.Repo
  alias JobBot.Source
  alias JobBot.JobSearches.JobSearch

  @casted_attrs [
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

  @required_attrs [
    :title,
    :description,
    :company_name,
    :listing_url
  ]

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
  def changeset(listing, attrs) do
    listing
    |> cast(attrs, @casted_attrs)
    |> validate_required(@required_attrs)
  end
end
