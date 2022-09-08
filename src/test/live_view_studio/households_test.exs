defmodule LiveViewStudio.HouseholdsTest do
  use LiveViewStudio.DataCase

  alias LiveViewStudio.Households

  describe "houses" do
    alias LiveViewStudio.Households.House

    import LiveViewStudio.HouseholdsFixtures

    @invalid_attrs %{name: nil}

    test "list_houses/0 returns all houses" do
      house = house_fixture()
      assert Households.list_houses() == [house]
    end

    test "get_house!/1 returns the house with given id" do
      house = house_fixture()
      assert Households.get_house!(house.id) == house
    end

    test "create_house/1 with valid data creates a house" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %House{} = house} = Households.create_house(valid_attrs)
      assert house.name == "some name"
    end

    test "create_house/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Households.create_house(@invalid_attrs)
    end

    test "update_house/2 with valid data updates the house" do
      house = house_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %House{} = house} = Households.update_house(house, update_attrs)
      assert house.name == "some updated name"
    end

    test "update_house/2 with invalid data returns error changeset" do
      house = house_fixture()
      assert {:error, %Ecto.Changeset{}} = Households.update_house(house, @invalid_attrs)
      assert house == Households.get_house!(house.id)
    end

    test "delete_house/1 deletes the house" do
      house = house_fixture()
      assert {:ok, %House{}} = Households.delete_house(house)
      assert_raise Ecto.NoResultsError, fn -> Households.get_house!(house.id) end
    end

    test "change_house/1 returns a house changeset" do
      house = house_fixture()
      assert %Ecto.Changeset{} = Households.change_house(house)
    end
  end
end
