defmodule Dsw.Model.Expansion do
  use Ecto.Schema
  require Ecto.Enum
  import Ecto.Changeset
  require Jason.Encoder

  @derive {Jason.Encoder, except: [:__meta__]}

  schema "expansion" do
    field :content, :string
    field :state, Ecto.Enum, values: [:New, :Done, :Error], default: :New
    field :path, :string
    field :created_by, :string
    field :app_uuid, :string

    timestamps()
  end

  @doc false
  def changeset(entity, attrs) do
    entity
    |> cast(attrs, [:content, :state, :path, :created_by, :app_uuid])
    |> validate_required([:content, :state, :created_by, :app_uuid])
  end
end
