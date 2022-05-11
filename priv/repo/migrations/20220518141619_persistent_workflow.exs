defmodule Dsw.Database.Repo.Migrations.PersistentWorkflow do
  use Ecto.Migration

  def change do
    create table(:persistent_workflow) do
      add :state, :string
      add :name, :string
      add :command_ids, {:array, :int}
      add :created_by, :string
      add :app_uuid, :string

      timestamps()
    end
  end
end
