defmodule LiveViewStudio.HouseholdsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveViewStudio.Households` context.
  """

  @doc """
  Generate a house.
  """
  def house_fixture(attrs \\ %{}) do
    {:ok, house} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> LiveViewStudio.Households.create_house()

    house
  end
end
