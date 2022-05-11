defmodule Dsw.Database.Repo.Migrations.TemplateEditor do
  use Ecto.Migration

  def change do
    create table(:template_editor) do
      add :name, :string
      add :content, :string
      add :created_by, :string
      add :app_uuid, :string

      timestamps()
    end
  end
end
