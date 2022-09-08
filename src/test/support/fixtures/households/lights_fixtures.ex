defmodule LiveViewStudio.Households.LightsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveViewStudio.Households.Lights` context.
  """

  @doc """
  Generate a light.
  """
  def light_fixture(attrs \\ %{}) do
    {:ok, light} =
      attrs
      |> Enum.into(%{
        brightness: 42,
        name: "some name"
      })
      |> LiveViewStudio.Households.Lights.create_light()

    light
  end
end
