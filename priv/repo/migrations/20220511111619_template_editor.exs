defmodule Dsw.Database.Repo.Migrations.TemplateEditor do
  use Ecto.Migration

  def change do
    create table(:template_editor) do
      add :name, :string
      add :content, :text
      add :url, :text
      add :data_url, :text
      add :created_by, :string
      add :app_uuid, :string

      timestamps()
    end
  end
end
