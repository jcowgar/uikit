defmodule DemoWeb.Ui.TabsLive do
  @moduledoc false
  use DemoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, active_tab: "account")}
  end

  @impl true
  def handle_event("tab_change", %{"value" => value}, socket) do
    {:noreply, assign(socket, active_tab: value)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    
      <.container>
        <.stack size="large">
          <%!-- Header --%>
          <div>
            <h1 class="text-3xl font-bold text-foreground">Tabs Component</h1>
            <p class="text-muted-foreground mt-2">
              A tabbed interface for organizing content into separate, switchable panels.
            </p>
          </div>

          <%!-- Basic Tabs (Client-side only) --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Basic Tabs</h2>
            <.card class="max-w-2xl">
              <.card_content class="pt-6">
                <.tabs id="basic-tabs" default_value="overview">
                  <.tabs_list>
                    <.tabs_trigger value="overview">Overview</.tabs_trigger>
                    <.tabs_trigger value="analytics">Analytics</.tabs_trigger>
                    <.tabs_trigger value="reports">Reports</.tabs_trigger>
                  </.tabs_list>
                  <.tabs_content value="overview" active={true}>
                    <.card>
                      <.card_header>
                        <.card_title>Overview</.card_title>
                        <.card_description>
                          View a summary of your dashboard.
                        </.card_description>
                      </.card_header>
                      <.card_content>
                        <p class="text-sm text-muted-foreground">
                          This is the overview tab content. You can display charts, metrics, and key information here.
                        </p>
                      </.card_content>
                    </.card>
                  </.tabs_content>
                  <.tabs_content value="analytics">
                    <.card>
                      <.card_header>
                        <.card_title>Analytics</.card_title>
                        <.card_description>
                          Detailed analytics and insights.
                        </.card_description>
                      </.card_header>
                      <.card_content>
                        <p class="text-sm text-muted-foreground">
                          Analytics data and charts would go here. Track user behavior and system metrics.
                        </p>
                      </.card_content>
                    </.card>
                  </.tabs_content>
                  <.tabs_content value="reports">
                    <.card>
                      <.card_header>
                        <.card_title>Reports</.card_title>
                        <.card_description>
                          Generate and view reports.
                        </.card_description>
                      </.card_header>
                      <.card_content>
                        <p class="text-sm text-muted-foreground">
                          Create custom reports and export data for analysis.
                        </p>
                      </.card_content>
                    </.card>
                  </.tabs_content>
                </.tabs>
              </.card_content>
            </.card>
          </section>

          <%!-- LiveView Controlled Tabs --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">
              LiveView Controlled Tabs
            </h2>
            <.card class="max-w-2xl">
              <.card_content class="pt-6">
                <.tabs id="liveview-tabs" value={@active_tab} phx-change="tab_change">
                  <.tabs_list>
                    <.tabs_trigger value="account">Account</.tabs_trigger>
                    <.tabs_trigger value="password">Password</.tabs_trigger>
                    <.tabs_trigger value="notifications">Notifications</.tabs_trigger>
                  </.tabs_list>
                  <.tabs_content value="account" active={@active_tab == "account"}>
                    <.card>
                      <.card_header>
                        <.card_title>Account Settings</.card_title>
                        <.card_description>
                          Manage your account settings and preferences.
                        </.card_description>
                      </.card_header>
                      <.card_content>
                        <.stack size="medium">
                          <div>
                            <label class="text-sm font-medium text-foreground">Username</label>
                            <p class="text-sm text-muted-foreground mt-1">john_doe</p>
                          </div>
                          <div>
                            <label class="text-sm font-medium text-foreground">Email</label>
                            <p class="text-sm text-muted-foreground mt-1">john@example.com</p>
                          </div>
                          <.button>Save Changes</.button>
                        </.stack>
                      </.card_content>
                    </.card>
                  </.tabs_content>
                  <.tabs_content value="password" active={@active_tab == "password"}>
                    <.card>
                      <.card_header>
                        <.card_title>Change Password</.card_title>
                        <.card_description>
                          Update your password to keep your account secure.
                        </.card_description>
                      </.card_header>
                      <.card_content>
                        <.stack size="medium">
                          <div>
                            <label class="text-sm font-medium text-foreground">
                              Current Password
                            </label>
                            <input
                              type="password"
                              class="mt-1 w-full rounded-md border border-input bg-background px-3 py-2 text-sm"
                            />
                          </div>
                          <div>
                            <label class="text-sm font-medium text-foreground">New Password</label>
                            <input
                              type="password"
                              class="mt-1 w-full rounded-md border border-input bg-background px-3 py-2 text-sm"
                            />
                          </div>
                          <.button>Update Password</.button>
                        </.stack>
                      </.card_content>
                    </.card>
                  </.tabs_content>
                  <.tabs_content value="notifications" active={@active_tab == "notifications"}>
                    <.card>
                      <.card_header>
                        <.card_title>Notification Preferences</.card_title>
                        <.card_description>
                          Configure how you receive notifications.
                        </.card_description>
                      </.card_header>
                      <.card_content>
                        <.stack size="medium">
                          <div class="flex items-center justify-between">
                            <div>
                              <p class="text-sm font-medium text-foreground">Email Notifications</p>
                              <p class="text-sm text-muted-foreground">
                                Receive notifications via email
                              </p>
                            </div>
                            <.switch id="email-notifications" name="email_notifications" checked />
                          </div>
                          <div class="flex items-center justify-between">
                            <div>
                              <p class="text-sm font-medium text-foreground">Push Notifications</p>
                              <p class="text-sm text-muted-foreground">
                                Receive push notifications
                              </p>
                            </div>
                            <.switch id="push-notifications" name="push_notifications" />
                          </div>
                          <.button>Save Preferences</.button>
                        </.stack>
                      </.card_content>
                    </.card>
                  </.tabs_content>
                </.tabs>
                <div class="mt-4 text-sm text-muted-foreground">
                  Current active tab: <span class="font-mono text-foreground">{@active_tab}</span>
                </div>
              </.card_content>
            </.card>
          </section>

          <%!-- Full Width Grid Layout --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Full Width Grid Layout</h2>
            <.card class="max-w-2xl">
              <.card_content class="pt-6">
                <.tabs id="grid-tabs" default_value="home">
                  <.tabs_list class="grid w-full grid-cols-2">
                    <.tabs_trigger value="home">Home</.tabs_trigger>
                    <.tabs_trigger value="settings">Settings</.tabs_trigger>
                  </.tabs_list>
                  <.tabs_content value="home" active={true}>
                    <.card>
                      <.card_header>
                        <.card_title>Home</.card_title>
                        <.card_description>Welcome to your dashboard</.card_description>
                      </.card_header>
                      <.card_content>
                        <p class="text-sm text-muted-foreground">
                          This tab list uses a grid layout to make tabs fill the full width equally.
                        </p>
                      </.card_content>
                    </.card>
                  </.tabs_content>
                  <.tabs_content value="settings">
                    <.card>
                      <.card_header>
                        <.card_title>Settings</.card_title>
                        <.card_description>Manage your preferences</.card_description>
                      </.card_header>
                      <.card_content>
                        <p class="text-sm text-muted-foreground">
                          Configure your application settings here.
                        </p>
                      </.card_content>
                    </.card>
                  </.tabs_content>
                </.tabs>
              </.card_content>
            </.card>
          </section>

          <%!-- Tabs with Icons --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Tabs with Icons</h2>
            <.card class="max-w-2xl">
              <.card_content class="pt-6">
                <.tabs id="icon-tabs" default_value="profile">
                  <.tabs_list>
                    <.tabs_trigger value="profile">
                      <.icon name="hero-user" class="w-4 h-4" /> Profile
                    </.tabs_trigger>
                    <.tabs_trigger value="security">
                      <.icon name="hero-lock-closed" class="w-4 h-4" /> Security
                    </.tabs_trigger>
                    <.tabs_trigger value="billing">
                      <.icon name="hero-credit-card" class="w-4 h-4" /> Billing
                    </.tabs_trigger>
                  </.tabs_list>
                  <.tabs_content value="profile" active={true}>
                    <p class="text-sm text-muted-foreground">
                      Profile settings and information.
                    </p>
                  </.tabs_content>
                  <.tabs_content value="security">
                    <p class="text-sm text-muted-foreground">
                      Security and privacy settings.
                    </p>
                  </.tabs_content>
                  <.tabs_content value="billing">
                    <p class="text-sm text-muted-foreground">
                      Billing and payment information.
                    </p>
                  </.tabs_content>
                </.tabs>
              </.card_content>
            </.card>
          </section>

          <%!-- Component Features --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Features</h2>
            <.card class="max-w-2xl">
              <.card_content class="pt-6">
                <.stack size="medium">
                  <div class="flex items-start gap-3">
                    <.icon name="hero-check-circle" class="w-5 h-5 text-success mt-0.5" />
                    <div>
                      <p class="font-medium text-foreground">Keyboard Navigation</p>
                      <p class="text-sm text-muted-foreground">
                        Navigate tabs using Arrow keys, Home, and End for accessibility
                      </p>
                    </div>
                  </div>

                  <div class="flex items-start gap-3">
                    <.icon name="hero-check-circle" class="w-5 h-5 text-success mt-0.5" />
                    <div>
                      <p class="font-medium text-foreground">Client or Server Side</p>
                      <p class="text-sm text-muted-foreground">
                        Use pure client-side tabs or integrate with LiveView for server-side state management
                      </p>
                    </div>
                  </div>

                  <div class="flex items-start gap-3">
                    <.icon name="hero-check-circle" class="w-5 h-5 text-success mt-0.5" />
                    <div>
                      <p class="font-medium text-foreground">Theme-Aware</p>
                      <p class="text-sm text-muted-foreground">
                        Automatically adapts to light and dark themes using semantic color tokens
                      </p>
                    </div>
                  </div>

                  <div class="flex items-start gap-3">
                    <.icon name="hero-check-circle" class="w-5 h-5 text-success mt-0.5" />
                    <div>
                      <p class="font-medium text-foreground">Flexible Layout</p>
                      <p class="text-sm text-muted-foreground">
                        Supports custom layouts including grid for equal-width tabs
                      </p>
                    </div>
                  </div>

                  <div class="flex items-start gap-3">
                    <.icon name="hero-check-circle" class="w-5 h-5 text-success mt-0.5" />
                    <div>
                      <p class="font-medium text-foreground">Icon Support</p>
                      <p class="text-sm text-muted-foreground">
                        Add icons to tab triggers for better visual communication
                      </p>
                    </div>
                  </div>

                  <div class="flex items-start gap-3">
                    <.icon name="hero-check-circle" class="w-5 h-5 text-success mt-0.5" />
                    <div>
                      <p class="font-medium text-foreground">Disabled State</p>
                      <p class="text-sm text-muted-foreground">
                        Supports disabled tabs with appropriate styling and accessibility attributes
                      </p>
                    </div>
                  </div>
                </.stack>
              </.card_content>
            </.card>
          </section>
        </.stack>
      </.container>
    
    """
  end
end
