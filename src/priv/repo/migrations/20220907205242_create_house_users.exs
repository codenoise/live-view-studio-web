defmodule LiveViewStudio.Repo.Migrations.CreateHouseUsers do
  use Ecto.Migration

  def change do
    create table(:house_users) do
      add :user_id, references(:users, on_delete: :nothing)
      add :house_id, references(:houses, on_delete: :nothing)

      timestamps()
    end

    create index(:house_users, [:user_id])
    create index(:house_users, [:house_id])
  end
end
