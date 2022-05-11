defmodule Dsw.Model.User do
  use Ecto.Schema
  import Ecto.Changeset
  require Jason.Encoder

  @derive {Jason.Encoder, except: [:__meta__]}

  schema "user_entity" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password_hash, :string
    field :affiliation, :string
    field :sources, {:array, :string}
    field :role, :string
    field :permissions, {:array, :string}
    field :active, :boolean
    field :submission_props, :map
    field :image_url, :string
    field :groups, {:array, :string}
    field :last_visited_at, :utc_datetime
    field :app_uuid, :string
    field :machine, :boolean

    timestamps()
  end

  @doc false
  def changeset(entity, attrs) do
    entity
    |> cast(attrs, [
      :first_name,
      :last_name,
      :email,
      :password_hash,
      :affiliation,
      :sources,
      :role,
      :permissions,
      :active,
      :submission_props,
      :image_url,
      :groups,
      :last_visited_at,
      :app_uuid,
      :machine
    ])
    |> validate_required([
      :first_name,
      :last_name,
      :email,
      :password_hash,
      :affiliation,
      :role,
      :active,
      :image_url,
      :last_visited_at,
      :app_uuid,
      :machine
    ])

    # |> validate_required([:first_name, :last_name, :email, :password_hash, :affiliation, :sources, :role, :permissions, :active, :submission_props, :image_url, :groups, :last_visited_at, :app_uuid, :machine])
  end
end
