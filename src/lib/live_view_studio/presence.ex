defmodule LiveViewStudio.Presence do
  use Phoenix.Presence, otp_app: :live_view_studio, pubsub_server: LiveViewStudio.PubSub
end
