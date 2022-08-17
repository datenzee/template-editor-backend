defmodule Dsw.Model.TemplateEditor do
  use Ecto.Schema
  import Ecto.Changeset
  require Logger
  require Jason.Encoder
  alias Dsw.Model.Expansion

  @derive {Jason.Encoder, except: [:__meta__, :expansions]}

  schema "template_editor" do
    field :name, :string
    field :content, :string
    field :url, :string
    field :data_url, :string
    field :created_by, :string
    field :app_uuid, :string

    has_many :expansions, Expansion

    timestamps()
  end

  @doc false
  def changeset(entity, attrs) do
    entity
    |> cast(attrs, [:name, :content, :url, :data_url, :created_by, :app_uuid])
    |> validate_required([:name, :content, :created_by, :app_uuid])
  end
end
