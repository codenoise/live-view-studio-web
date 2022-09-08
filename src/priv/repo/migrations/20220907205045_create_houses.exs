defmodule LiveViewStudio.Repo.Migrations.CreateHouses do
  use Ecto.Migration

  def change do
    create table(:houses) do
      add :name, :string

      timestamps()
    end
  end
end
