defmodule JobBot.Listing do
  use Ecto.Schema
  import Ecto.Changeset


  schema "listings" do
    field :application_url, :string
    field :applied_at, :naive_datetime
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

    timestamps()
  end

  @doc false
  def changeset(listing, attrs) do
    listing
    |> cast(attrs, [:title, :description, :city, :remote, :salary, :email, :company_name, :listing_url, :application_url, :applied_at, :skills])
    |> validate_required([:title, :description, :company_name, :listing_url, :application_url])
  end
end
