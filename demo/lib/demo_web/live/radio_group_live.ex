defmodule DemoWeb.Ui.RadioGroupLive do
  @moduledoc false
  use DemoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:notification_method, "email")
      |> assign(:theme, "system")
      |> assign(:plan, "free")
      |> assign(:form_message, nil)
      |> assign(:form_data, nil)

    {:ok, socket}
  end

  @impl true
  def handle_event("change_notification", %{"method" => method}, socket) do
    {:noreply, assign(socket, :notification_method, method)}
  end

  @impl true
  def handle_event("change_theme", %{"theme" => theme}, socket) do
    {:noreply, assign(socket, :theme, theme)}
  end

  @impl true
  def handle_event("save_preferences", %{"preferences" => preferences}, socket) do
    # Process the form data
    plan = Map.get(preferences, "plan", "free")
    notifications = Map.get(preferences, "notifications", "email")
    visibility = Map.get(preferences, "visibility", "public")

    # Create a message showing the state of each radio selection
    message = """
    Form submitted successfully! Here's what the server received:

    • Plan: #{plan}
    • Notification method: #{notifications}
    • Profile visibility: #{visibility}
    """

    {:noreply,
     socket
     |> assign(:form_message, message)
     |> assign(:form_data, %{
       plan: plan,
       notifications: notifications,
       visibility: visibility
     })}
  end

  @impl true
  def render(assigns) do
    ~H"""
    
      <.container>
        <.stack size="large">
          <%!-- Header --%>
          <div>
            <h1 class="text-3xl font-bold text-foreground">Radio Group Component</h1>
            <p class="text-muted-foreground mt-2">
              A set of checkable buttons—known as radio buttons—where no more than one button can be checked at a time.
            </p>
          </div>

          <%!-- Basic Radio Group --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Basic Usage</h2>
            <.radio_group name="basic-option" value="option-one">
              <div class="flex items-center gap-3">
                <.radio_group_item
                  value="option-one"
                  id="basic-option-one"
                  name="basic-option"
                  checked
                />
                <.label for="basic-option-one" class="cursor-pointer">Option One</.label>
              </div>
              <div class="flex items-center gap-3">
                <.radio_group_item value="option-two" id="basic-option-two" name="basic-option" />
                <.label for="basic-option-two" class="cursor-pointer">Option Two</.label>
              </div>
              <div class="flex items-center gap-3">
                <.radio_group_item value="option-three" id="basic-option-three" name="basic-option" />
                <.label for="basic-option-three" class="cursor-pointer">Option Three</.label>
              </div>
            </.radio_group>
          </section>

          <%!-- Interactive Radio Groups --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Interactive Radio Groups</h2>
            <.card class="max-w-md">
              <.card_header>
                <.card_title>Notification Preferences</.card_title>
                <.card_description>
                  Choose how you want to receive notifications
                </.card_description>
              </.card_header>
              <.card_content>
                <.radio_group name="notification-method" value={@notification_method}>
                  <div class="flex items-center gap-3">
                    <.radio_group_item
                      value="email"
                      id="notify-email"
                      name="notification-method"
                      checked={@notification_method == "email"}
                      phx-click="change_notification"
                      phx-value-method="email"
                    />
                    <div
                      class="flex-1 cursor-pointer"
                      phx-click="change_notification"
                      phx-value-method="email"
                    >
                      <.label for="notify-email" class="cursor-pointer">Email</.label>
                      <p class="text-sm text-muted-foreground">Get notified via email</p>
                    </div>
                  </div>
                  <div class="flex items-center gap-3">
                    <.radio_group_item
                      value="sms"
                      id="notify-sms"
                      name="notification-method"
                      checked={@notification_method == "sms"}
                      phx-click="change_notification"
                      phx-value-method="sms"
                    />
                    <div
                      class="flex-1 cursor-pointer"
                      phx-click="change_notification"
                      phx-value-method="sms"
                    >
                      <.label for="notify-sms" class="cursor-pointer">SMS</.label>
                      <p class="text-sm text-muted-foreground">Get notified via text message</p>
                    </div>
                  </div>
                  <div class="flex items-center gap-3">
                    <.radio_group_item
                      value="push"
                      id="notify-push"
                      name="notification-method"
                      checked={@notification_method == "push"}
                      phx-click="change_notification"
                      phx-value-method="push"
                    />
                    <div
                      class="flex-1 cursor-pointer"
                      phx-click="change_notification"
                      phx-value-method="push"
                    >
                      <.label for="notify-push" class="cursor-pointer">Push Notification</.label>
                      <p class="text-sm text-muted-foreground">Get notified on your device</p>
                    </div>
                  </div>
                  <div class="flex items-center gap-3">
                    <.radio_group_item
                      value="none"
                      id="notify-none"
                      name="notification-method"
                      checked={@notification_method == "none"}
                      phx-click="change_notification"
                      phx-value-method="none"
                    />
                    <div
                      class="flex-1 cursor-pointer"
                      phx-click="change_notification"
                      phx-value-method="none"
                    >
                      <.label for="notify-none" class="cursor-pointer">No Notifications</.label>
                      <p class="text-sm text-muted-foreground">Disable all notifications</p>
                    </div>
                  </div>
                </.radio_group>

                <.separator class="my-4" />

                <div class="text-sm">
                  <span class="text-muted-foreground">Current selection:</span>
                  <span class="font-medium text-foreground ml-2">
                    {String.capitalize(@notification_method)}
                  </span>
                </div>
              </.card_content>
            </.card>
          </section>

          <%!-- Theme Selection --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Theme Selection</h2>
            <.card class="max-w-md">
              <.card_header>
                <.card_title>Appearance</.card_title>
                <.card_description>
                  Select your preferred theme
                </.card_description>
              </.card_header>
              <.card_content>
                <.radio_group name="theme-choice" value={@theme}>
                  <div class="flex items-center gap-3">
                    <.radio_group_item
                      value="light"
                      id="theme-light"
                      name="theme-choice"
                      checked={@theme == "light"}
                      phx-click="change_theme"
                      phx-value-theme="light"
                    />
                    <.label for="theme-light" class="cursor-pointer flex-1">Light</.label>
                  </div>
                  <div class="flex items-center gap-3">
                    <.radio_group_item
                      value="dark"
                      id="theme-dark"
                      name="theme-choice"
                      checked={@theme == "dark"}
                      phx-click="change_theme"
                      phx-value-theme="dark"
                    />
                    <.label for="theme-dark" class="cursor-pointer flex-1">Dark</.label>
                  </div>
                  <div class="flex items-center gap-3">
                    <.radio_group_item
                      value="system"
                      id="theme-system"
                      name="theme-choice"
                      checked={@theme == "system"}
                      phx-click="change_theme"
                      phx-value-theme="system"
                    />
                    <.label for="theme-system" class="cursor-pointer flex-1">System</.label>
                  </div>
                </.radio_group>

                <.separator class="my-4" />

                <div class="text-sm">
                  <span class="text-muted-foreground">Current theme:</span>
                  <span class="font-medium text-foreground ml-2">{String.capitalize(@theme)}</span>
                </div>
              </.card_content>
            </.card>
          </section>

          <%!-- Disabled State --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Disabled</h2>
            <.radio_group name="disabled-option" value="disabled-one">
              <div class="flex items-center gap-3">
                <.radio_group_item
                  value="disabled-one"
                  id="disabled-one"
                  name="disabled-option"
                  checked
                  disabled
                />
                <.label for="disabled-one">Disabled & checked</.label>
              </div>
              <div class="flex items-center gap-3">
                <.radio_group_item
                  value="disabled-two"
                  id="disabled-two"
                  name="disabled-option"
                  disabled
                />
                <.label for="disabled-two">Disabled & unchecked</.label>
              </div>
            </.radio_group>
          </section>

          <%!-- Form Example --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Form Example</h2>
            <p class="text-sm text-muted-foreground mb-4">
              This is a working form that demonstrates radio group components submitting data.
              Select your preferences and click "Save Preferences" to see the round trip.
            </p>
            <.card class="max-w-md">
              <.card_header>
                <.card_title>Account Preferences</.card_title>
                <.card_description>
                  Manage your account settings
                </.card_description>
              </.card_header>
              <.card_content>
                <form phx-submit="save_preferences">
                  <.stack size="medium">
                    <%!-- Plan Selection --%>
                    <div>
                      <.label class="mb-3 block">Choose your plan</.label>
                      <.radio_group name="preferences[plan]" value="free">
                        <div class="flex items-center gap-3">
                          <.radio_group_item
                            value="free"
                            id="form-plan-free"
                            name="preferences[plan]"
                            checked
                          />
                          <div class="flex-1">
                            <.label for="form-plan-free" class="cursor-pointer">Free</.label>
                            <p class="text-xs text-muted-foreground">Basic features, no cost</p>
                          </div>
                        </div>
                        <div class="flex items-center gap-3">
                          <.radio_group_item value="pro" id="form-plan-pro" name="preferences[plan]" />
                          <div class="flex-1">
                            <.label for="form-plan-pro" class="cursor-pointer">Pro</.label>
                            <p class="text-xs text-muted-foreground">All features, $9.99/month</p>
                          </div>
                        </div>
                        <div class="flex items-center gap-3">
                          <.radio_group_item
                            value="enterprise"
                            id="form-plan-enterprise"
                            name="preferences[plan]"
                          />
                          <div class="flex-1">
                            <.label for="form-plan-enterprise" class="cursor-pointer">
                              Enterprise
                            </.label>
                            <p class="text-xs text-muted-foreground">Custom features and support</p>
                          </div>
                        </div>
                      </.radio_group>
                    </div>

                    <%!-- Notification Method --%>
                    <div>
                      <.label class="mb-3 block">Notification method</.label>
                      <.radio_group name="preferences[notifications]" value="email">
                        <div class="flex items-center gap-3">
                          <.radio_group_item
                            value="email"
                            id="form-notify-email"
                            name="preferences[notifications]"
                            checked
                          />
                          <.label for="form-notify-email" class="cursor-pointer">Email</.label>
                        </div>
                        <div class="flex items-center gap-3">
                          <.radio_group_item
                            value="sms"
                            id="form-notify-sms"
                            name="preferences[notifications]"
                          />
                          <.label for="form-notify-sms" class="cursor-pointer">SMS</.label>
                        </div>
                        <div class="flex items-center gap-3">
                          <.radio_group_item
                            value="push"
                            id="form-notify-push"
                            name="preferences[notifications]"
                          />
                          <.label for="form-notify-push" class="cursor-pointer">Push</.label>
                        </div>
                      </.radio_group>
                    </div>

                    <%!-- Profile Visibility --%>
                    <div>
                      <.label class="mb-3 block">Profile visibility</.label>
                      <.radio_group name="preferences[visibility]" value="public">
                        <div class="flex items-center gap-3">
                          <.radio_group_item
                            value="public"
                            id="form-visibility-public"
                            name="preferences[visibility]"
                            checked
                          />
                          <.label for="form-visibility-public" class="cursor-pointer">Public</.label>
                        </div>
                        <div class="flex items-center gap-3">
                          <.radio_group_item
                            value="private"
                            id="form-visibility-private"
                            name="preferences[visibility]"
                          />
                          <.label for="form-visibility-private" class="cursor-pointer">
                            Private
                          </.label>
                        </div>
                        <div class="flex items-center gap-3">
                          <.radio_group_item
                            value="friends"
                            id="form-visibility-friends"
                            name="preferences[visibility]"
                          />
                          <.label for="form-visibility-friends" class="cursor-pointer">
                            Friends Only
                          </.label>
                        </div>
                      </.radio_group>
                    </div>

                    <.button class="w-full">Save Preferences</.button>
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
                    The radio group component includes several accessibility features:
                  </p>
                  <ul class="text-sm text-muted-foreground space-y-2 list-disc list-inside">
                    <li>
                      Proper ARIA roles (<code class="text-xs">role="radiogroup"</code> and <code class="text-xs">role="radio"</code>) and state (<code class="text-xs">aria-checked</code>)
                    </li>
                    <li>
                      Association with labels via <code class="text-xs">id</code>
                      and <code class="text-xs">for</code>
                      attributes
                    </li>
                    <li>Focus visible ring styles for keyboard navigation</li>
                    <li>Keyboard navigation with arrow keys (native radio behavior)</li>
                    <li>Disabled state prevents interaction and reduces opacity</li>
                    <li>Hidden radio input for proper form submission</li>
                    <li>
                      Data attributes (<code class="text-xs">data-state</code>) for state tracking
                    </li>
                    <li>Smooth visual transitions between states</li>
                    <li>Only one radio can be selected at a time within a group</li>
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
