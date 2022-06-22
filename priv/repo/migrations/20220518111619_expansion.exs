defmodule Dsw.Database.Repo.Migrations.Expansion do
  use Ecto.Migration

  def change do
    create table(:expansion) do
      add :content, :text
      add :state, :string
      add :path, :string
      add :created_by, :string
      add :app_uuid, :string

      timestamps()
    end
  end
end
