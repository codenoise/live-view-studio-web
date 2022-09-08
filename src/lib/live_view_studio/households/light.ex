defmodule LiveViewStudio.Households.Light do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lights" do
    field :brightness, :integer
    field :name, :string
    field :house_id, :id

    timestamps()
  end

  @doc false
  def changeset(light, attrs) do
    light
    |> cast(attrs, [:name, :brightness])
    |> validate_required([:name, :brightness])
  end
end
