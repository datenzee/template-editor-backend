defmodule Dsw.Model.TemplateEditor do
  use Ecto.Schema
  import Ecto.Changeset
  require Jason.Encoder

  @derive {Jason.Encoder, except: [:__meta__]}

  schema "template_editor" do
    field :name, :string
    field :content, :string
    field :created_by, :string
    field :app_uuid, :string

    timestamps()
  end

  @doc false
  def changeset(entity, attrs) do
    entity
    |> cast(attrs, [:name, :content, :created_by, :app_uuid])
    |> validate_required([:name, :content, :created_by, :app_uuid])
  end
end
