defmodule Dsw.Database.Repo.Migrations.PersistentCommand do
  use Ecto.Migration

  def change do
    create table(:persistent_command) do
      add :state, :string
      add :component, :string
      add :function, :string
      add :body, :string
      add :last_error_message, :string
      add :attempts, :integer
      add :max_attempts, :integer
      add :internal, :boolean
      add :persistent_workflow_id, references("persistent_workflow")
      add :created_by, :string
      add :app_uuid, :string

      timestamps()
    end
  end
end
