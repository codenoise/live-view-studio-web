defmodule LiveViewStudioWeb.HouseLive.FormComponent do
  use LiveViewStudioWeb, :live_component

  alias LiveViewStudio.Households

  @impl true
  def update(%{house: house} = assigns, socket) do
    changeset = Households.change_house(house)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"house" => house_params}, socket) do
    changeset =
      socket.assigns.house
      |> Households.change_house(house_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"house" => house_params}, socket) do
    save_house(socket, socket.assigns.action, house_params)
  end

  defp save_house(socket, :edit, house_params) do
    case Households.update_house(socket.assigns.house, house_params) do
      {:ok, _house} ->
        {:noreply,
         socket
         |> put_flash(:info, "House updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_house(socket, :new, house_params) do
    case Households.create_house(house_params) do
      {:ok, _house} ->
        {:noreply,
         socket
         |> put_flash(:info, "House created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
