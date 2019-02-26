defmodule JobBot.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias JobBot.Accounts.UserListing

  @derive {Poison.Encoder, only: [:name, :email]}
  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :binary
    has_many :user_listings, UserListing
    has_many :listings, through: [:user_listings, :listing]

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  def put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        change(changeset, password: Bcrypt.hash_pwd_salt(password))
      _ -> changeset
    end
  end
end
