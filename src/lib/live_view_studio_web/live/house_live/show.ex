defmodule LiveViewStudioWeb.HouseLive.Show do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Households

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:house, Households.get_house!(id))}
  end

  defp page_title(:show), do: "Show House"
  defp page_title(:edit), do: "Edit House"
end
