defmodule LiveViewStudio.Households.House do
  use Ecto.Schema
  import Ecto.Changeset

  schema "houses" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(house, attrs) do
    house
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
