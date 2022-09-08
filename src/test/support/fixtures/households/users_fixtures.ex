defmodule LiveViewStudio.Households.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveViewStudio.Households.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{

      })
      |> LiveViewStudio.Households.Users.create_user()

    user
  end
end
