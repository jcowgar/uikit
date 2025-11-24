defmodule DemoWeb.Ui.SwitchLive do
  @moduledoc false
  use DemoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:airplane_mode, false)
      |> assign(:notifications, true)
      |> assign(:dark_mode, false)
      |> assign(:wifi, true)
      |> assign(:bluetooth, false)
      |> assign(:form_message, nil)
      |> assign(:form_data, nil)

    {:ok, socket}
  end

  @impl true
  def handle_event("toggle_" <> setting, _params, socket) do
    setting_atom = String.to_existing_atom(setting)
    {:noreply, assign(socket, setting_atom, !Map.get(socket.assigns, setting_atom))}
  end

  @impl true
  def handle_event("save_settings", %{"settings" => settings}, socket) do
    # Process the form data
    analytics = Map.get(settings, "analytics") == "true"
    marketing = Map.get(settings, "marketing") == "true"
    social = Map.get(settings, "social") == "true"
    personalization = Map.get(settings, "personalization") == "true"

    # Create a message showing the state of each switch
    message = """
    Form submitted successfully! Here's what the server received:

    • Analytics: #{if analytics, do: "ON ✓", else: "OFF ✗"}
    • Marketing emails: #{if marketing, do: "ON ✓", else: "OFF ✗"}
    • Social features: #{if social, do: "ON ✓", else: "OFF ✗"}
    • Personalization: #{if personalization, do: "ON ✓", else: "OFF ✗"}
    """

    {:noreply,
     socket
     |> assign(:form_message, message)
     |> assign(:form_data, %{
       analytics: analytics,
       marketing: marketing,
       social: social,
       personalization: personalization
     })}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.container>
      <.stack size="large">
        <%!-- Header --%>
        <div>
          <h1 class="text-3xl font-bold text-foreground">Switch Component</h1>
          <p class="text-muted-foreground mt-2">
            A control that allows the user to toggle between checked and not checked.
          </p>
        </div>

        <%!-- Basic Switch --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Basic Usage</h2>
          <.stack size="medium">
            <div class="flex items-center gap-3">
              <.switch id="basic-off" name="basic_off" />
              <.label for="basic-off" class="cursor-pointer">Unchecked</.label>
            </div>

            <div class="flex items-center gap-3">
              <.switch id="basic-on" name="basic_on" checked />
              <.label for="basic-on" class="cursor-pointer">Checked by default</.label>
            </div>
          </.stack>
        </section>

        <%!-- Interactive Switches --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Interactive Switches</h2>
          <.card class="max-w-md">
            <.card_header>
              <.card_title>Quick Settings</.card_title>
              <.card_description>
                Toggle settings on and off
              </.card_description>
            </.card_header>
            <.card_content>
              <.stack size="medium">
                <div class="flex items-center justify-between">
                  <div class="flex-1">
                    <.label for="airplane-toggle" class="cursor-pointer">
                      Airplane Mode
                    </.label>
                    <p class="text-sm text-muted-foreground">
                      Turn off all wireless connections
                    </p>
                  </div>
                  <.switch
                    id="airplane-toggle"
                    name="airplane_mode"
                    checked={@airplane_mode}
                    phx-click="toggle_airplane_mode"
                  />
                </div>

                <div class="flex items-center justify-between">
                  <div class="flex-1">
                    <.label for="notifications-toggle" class="cursor-pointer">
                      Notifications
                    </.label>
                    <p class="text-sm text-muted-foreground">
                      Receive push notifications
                    </p>
                  </div>
                  <.switch
                    id="notifications-toggle"
                    name="notifications"
                    checked={@notifications}
                    phx-click="toggle_notifications"
                  />
                </div>

                <div class="flex items-center justify-between">
                  <div class="flex-1">
                    <.label for="dark-toggle" class="cursor-pointer">
                      Dark Mode
                    </.label>
                    <p class="text-sm text-muted-foreground">
                      Use dark theme
                    </p>
                  </div>
                  <.switch
                    id="dark-toggle"
                    name="dark_mode"
                    checked={@dark_mode}
                    phx-click="toggle_dark_mode"
                  />
                </div>

                <div class="flex items-center justify-between">
                  <div class="flex-1">
                    <.label for="wifi-toggle" class="cursor-pointer">
                      Wi-Fi
                    </.label>
                    <p class="text-sm text-muted-foreground">
                      Connect to wireless networks
                    </p>
                  </div>
                  <.switch
                    id="wifi-toggle"
                    name="wifi"
                    checked={@wifi}
                    phx-click="toggle_wifi"
                  />
                </div>

                <div class="flex items-center justify-between">
                  <div class="flex-1">
                    <.label for="bluetooth-toggle" class="cursor-pointer">
                      Bluetooth
                    </.label>
                    <p class="text-sm text-muted-foreground">
                      Connect to bluetooth devices
                    </p>
                  </div>
                  <.switch
                    id="bluetooth-toggle"
                    name="bluetooth"
                    checked={@bluetooth}
                    phx-click="toggle_bluetooth"
                  />
                </div>
              </.stack>
            </.card_content>
          </.card>
        </section>

        <%!-- With Labels --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">With Labels</h2>
          <.stack size="medium">
            <div class="flex items-center gap-3">
              <.switch id="marketing-emails" name="marketing_emails" />
              <.label for="marketing-emails" class="cursor-pointer">
                Marketing emails
              </.label>
            </div>

            <div class="flex items-center gap-3">
              <.switch id="security-emails" name="security_emails" checked />
              <.label for="security-emails" class="cursor-pointer">
                Security emails
              </.label>
            </div>

            <div class="flex items-center gap-3">
              <.switch id="newsletter" name="newsletter" />
              <.label for="newsletter" class="cursor-pointer">
                Newsletter
              </.label>
            </div>
          </.stack>
        </section>

        <%!-- Disabled State --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Disabled</h2>
          <.stack size="medium">
            <div class="flex items-center gap-3">
              <.switch id="disabled-off" name="disabled_off" disabled />
              <.label for="disabled-off">Disabled unchecked</.label>
            </div>

            <div class="flex items-center gap-3">
              <.switch id="disabled-on" name="disabled_on" checked disabled />
              <.label for="disabled-on">Disabled checked</.label>
            </div>
          </.stack>
        </section>

        <%!-- With Description --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">With Description</h2>
          <.stack size="medium">
            <div class="flex items-center justify-between max-w-md">
              <div class="flex-1">
                <.label for="analytics" class="cursor-pointer">
                  Share analytics data
                </.label>
                <p class="text-sm text-muted-foreground mt-1">
                  Help us improve by sharing anonymous usage data.
                </p>
              </div>
              <.switch id="analytics" name="analytics" class="ml-4" />
            </div>

            <div class="flex items-center justify-between max-w-md">
              <div class="flex-1">
                <.label for="location" class="cursor-pointer">
                  Location services
                </.label>
                <p class="text-sm text-muted-foreground mt-1">
                  Allow the app to use your location for better recommendations.
                </p>
              </div>
              <.switch id="location" name="location" checked class="ml-4" />
            </div>
          </.stack>
        </section>

        <%!-- Form Example --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Form Example</h2>
          <p class="text-sm text-muted-foreground mb-4">
            This is a working form that demonstrates switch components submitting data.
            Toggle the switches and click "Save Settings" to see the round trip.
          </p>
          <.card class="max-w-md">
            <.card_header>
              <.card_title>Privacy Settings</.card_title>
              <.card_description>
                Manage your privacy and data preferences
              </.card_description>
            </.card_header>
            <.card_content>
              <form phx-submit="save_settings">
                <.stack size="medium">
                  <div class="flex items-center justify-between">
                    <.label for="form-analytics" class="cursor-pointer flex-1">
                      Analytics
                    </.label>
                    <.switch id="form-analytics" name="settings[analytics]" checked />
                  </div>

                  <div class="flex items-center justify-between">
                    <.label for="form-marketing" class="cursor-pointer flex-1">
                      Marketing emails
                    </.label>
                    <.switch id="form-marketing" name="settings[marketing]" />
                  </div>

                  <div class="flex items-center justify-between">
                    <.label for="form-social" class="cursor-pointer flex-1">
                      Social features
                    </.label>
                    <.switch id="form-social" name="settings[social]" checked />
                  </div>

                  <div class="flex items-center justify-between">
                    <.label for="form-personalization" class="cursor-pointer flex-1">
                      Personalization
                    </.label>
                    <.switch id="form-personalization" name="settings[personalization]" checked />
                  </div>

                  <.button class="w-full">Save Settings</.button>
                </.stack>
              </form>
            </.card_content>
          </.card>

          <%!-- Display form submission result --%>
          <.card :if={@form_message} class="max-w-md mt-4">
            <.card_header>
              <.card_title>Server Response</.card_title>
              <.card_description>
                This shows what the server received from the form
              </.card_description>
            </.card_header>
            <.card_content>
              <pre class="text-sm text-foreground whitespace-pre-wrap bg-muted p-4 rounded-md"><%= @form_message %></pre>
            </.card_content>
          </.card>
        </section>

        <%!-- Accessibility Features --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Accessibility</h2>
          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>Accessibility Features</.card_title>
            </.card_header>
            <.card_content>
              <.stack size="small">
                <p class="text-sm text-muted-foreground">
                  The switch component includes several accessibility features:
                </p>
                <ul class="text-sm text-muted-foreground space-y-2 list-disc list-inside">
                  <li>
                    Proper ARIA role (<code class="text-xs">role="switch"</code>) and state (<code class="text-xs">aria-checked</code>)
                  </li>
                  <li>
                    Association with labels via <code class="text-xs">id</code>
                    and <code class="text-xs">for</code>
                    attributes
                  </li>
                  <li>Focus visible ring styles for keyboard navigation</li>
                  <li>Keyboard activation via Space and Enter keys</li>
                  <li>Disabled state prevents interaction and reduces opacity</li>
                  <li>Hidden checkbox input for proper form submission</li>
                  <li>
                    Data attributes (<code class="text-xs">data-state</code>) for state tracking
                  </li>
                  <li>Smooth visual transition between states</li>
                </ul>
              </.stack>
            </.card_content>
          </.card>
        </section>
      </.stack>
    </.container>
    """
  end
end
