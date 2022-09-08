defmodule LiveViewStudio.Households.LightsTest do
  use LiveViewStudio.DataCase

  alias LiveViewStudio.Households.Lights

  describe "lights" do
    alias LiveViewStudio.Households.Lights.House.Light

    import LiveViewStudio.Households.LightsFixtures

    @invalid_attrs %{brightness: nil, name: nil}

    test "list_lights/0 returns all lights" do
      light = light_fixture()
      assert Lights.list_lights() == [light]
    end

    test "get_light!/1 returns the light with given id" do
      light = light_fixture()
      assert Lights.get_light!(light.id) == light
    end

    test "create_light/1 with valid data creates a light" do
      valid_attrs = %{brightness: 42, name: "some name"}

      assert {:ok, %Light{} = light} = Lights.create_light(valid_attrs)
      assert light.brightness == 42
      assert light.name == "some name"
    end

    test "create_light/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lights.create_light(@invalid_attrs)
    end

    test "update_light/2 with valid data updates the light" do
      light = light_fixture()
      update_attrs = %{brightness: 43, name: "some updated name"}

      assert {:ok, %Light{} = light} = Lights.update_light(light, update_attrs)
      assert light.brightness == 43
      assert light.name == "some updated name"
    end

    test "update_light/2 with invalid data returns error changeset" do
      light = light_fixture()
      assert {:error, %Ecto.Changeset{}} = Lights.update_light(light, @invalid_attrs)
      assert light == Lights.get_light!(light.id)
    end

    test "delete_light/1 deletes the light" do
      light = light_fixture()
      assert {:ok, %Light{}} = Lights.delete_light(light)
      assert_raise Ecto.NoResultsError, fn -> Lights.get_light!(light.id) end
    end

    test "change_light/1 returns a light changeset" do
      light = light_fixture()
      assert %Ecto.Changeset{} = Lights.change_light(light)
    end
  end
end
