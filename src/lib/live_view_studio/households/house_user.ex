defmodule LiveViewStudio.Households.HouseUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "house_users" do

    field :user_id, :id
    field :house_id, :id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [])
    |> validate_required([])
  end
end
