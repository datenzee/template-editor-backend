defmodule Dsw.Model.PersistentCommand do
  use Ecto.Schema
  require Ecto.Enum
  import Ecto.Changeset
  require Jason.Encoder
  alias Dsw.Model.PersistentWorkflow

  @derive {Jason.Encoder, except: [:__meta__]}

  schema "persistent_command" do
    field :state, Ecto.Enum, values: [:Prepared, :New, :Done, :Error, :Ignore], default: :Prepared
    field :component, :string
    field :function, :string
    field :body, :string
    field :last_error_message, :string, default: nil
    field :attempts, :integer, default: 0
    field :max_attempts, :integer, default: 1
    field :internal, :boolean, default: false
    belongs_to :persistent_workflow, PersistentWorkflow
    field :created_by, :string
    field :app_uuid, :string

    timestamps()
  end

  @doc false
  def changeset(entity, attrs) do
    entity
    |> cast(attrs, [
      :state,
      :component,
      :function,
      :body,
      :last_error_message,
      :attempts,
      :max_attempts,
      :internal,
      :created_by,
      :app_uuid
    ])
    |> validate_required([
      :state,
      :component,
      :function,
      :body,
      :attempts,
      :max_attempts,
      :internal,
      :created_by,
      :app_uuid
    ])
  end
end
