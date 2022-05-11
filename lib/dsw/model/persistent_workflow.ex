defmodule Dsw.Model.PersistentWorkflow do
  use Ecto.Schema
  require Ecto.Enum
  import Ecto.Changeset
  require Jason.Encoder
  alias Dsw.Model.PersistentCommand

  @derive {Jason.Encoder, except: [:__meta__]}

  schema "persistent_workflow" do
    field :state, Ecto.Enum, values: [:New, :InProgress, :Done, :Error, :Ignore], default: :New
    field :name, :string
    field :command_ids, {:array, :integer}
    has_many :commands, PersistentCommand
    field :created_by, :string
    field :app_uuid, :string

    timestamps()
  end

  @doc false
  def changeset(entity, attrs) do
    entity
    |> cast(attrs, [
      :state,
      :name,
      :command_ids,
      :created_by,
      :app_uuid
    ])
    |> cast_assoc(:commands, with: &PersistentCommand.changeset/2)
    |> validate_required([
      :state,
      :name,
      :command_ids,
      :commands,
      :created_by,
      :app_uuid
    ])
  end
end
