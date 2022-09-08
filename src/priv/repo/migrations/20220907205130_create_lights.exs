defmodule LiveViewStudio.Repo.Migrations.CreateLights do
  use Ecto.Migration

  def change do
    create table(:lights) do
      add :name, :string
      add :brightness, :integer
      add :house_id, references(:houses, on_delete: :nothing)

      timestamps()
    end

    create index(:lights, [:house_id])
  end
end
