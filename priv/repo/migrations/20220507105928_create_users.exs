defmodule Dsw.Database.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:user_entity) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :password_hash, :string
      add :affiliation, :string
      add :sources, {:array, :string}
      add :role, :string
      add :permissions, {:array, :string}
      add :active, :boolean
      add :submission_props, :map
      add :image_url, :string
      add :groups, {:array, :string}
      add :last_visited_at, :utc_datetime
      add :app_uuid, :string
      add :machine, :boolean

      timestamps()
    end
  end
end
