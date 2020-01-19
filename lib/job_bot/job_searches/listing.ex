defmodule JobBot.JobSearches.Listing do
  use Ecto.Schema

  import Ecto.Query, warn: false
  import Ecto.Changeset

  alias JobBot.Repo
  alias JobBot.Source
  alias JobBot.JobSearches.JobSearch

  @type t :: %__MODULE__{
    title: String.t,
    company_name: String.t,
    listing_url: String.t,
    source: String.t,
    applied_to_at: NaiveDateTime.t | nil,
    description: String.t | nil,
    city: String.t | nil,
    remote: boolean | nil,
    salary: String.t | nil,
    email: String.t | nil,
    application_url: String.t | nil,
    skills: list(String.t) | nil
  }

  @casted_attrs [
    :applied_to_at,
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
    field :applied_to_at, :naive_datetime
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
