defmodule DemoWeb.Ui.SelectLive do
  @moduledoc false
  use DemoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:selected_country, "us")
      |> assign(:selected_framework, nil)
      |> assign(:selected_timezone, "pst")
      |> assign(:selected_status, "pending")

    {:ok, socket}
  end

  @impl true
  def handle_event("country_changed", %{"country" => country}, socket) do
    {:noreply, assign(socket, :selected_country, country)}
  end

  @impl true
  def handle_event("framework_changed", %{"framework" => framework}, socket) do
    {:noreply, assign(socket, :selected_framework, framework)}
  end

  @impl true
  def handle_event("timezone_changed", %{"timezone" => timezone}, socket) do
    {:noreply, assign(socket, :selected_timezone, timezone)}
  end

  @impl true
  def handle_event("status_changed", %{"status" => status}, socket) do
    {:noreply, assign(socket, :selected_status, status)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.container>
      <.stack size="large">
        <%!-- Header --%>
        <div>
          <h1 class="text-3xl font-bold text-foreground">Select Component</h1>
          <p class="text-muted-foreground mt-2">
            Styled dropdown for selecting from a list of options.
          </p>
        </div>

        <%!-- Basic Select --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Basic Select</h2>
          <.stack size="medium">
            <div>
              <.label for="country-select" class="mb-1.5">Country</.label>
              <.select
                id="country-select"
                name="country"
                value={@selected_country}
                options={[
                  {"United States", "us"},
                  {"Canada", "ca"},
                  {"Mexico", "mx"},
                  {"United Kingdom", "uk"},
                  {"Germany", "de"},
                  {"France", "fr"}
                ]}
                phx-change="country_changed"
              />
              <p class="text-sm text-muted-foreground mt-1.5">
                Selected: {@selected_country}
              </p>
            </div>

            <div>
              <.label for="framework-select" class="mb-1.5">Framework</.label>
              <.select
                id="framework-select"
                name="framework"
                value={@selected_framework}
                placeholder="Select a framework..."
                options={[
                  {"Next.js", "nextjs"},
                  {"SvelteKit", "sveltekit"},
                  {"Nuxt.js", "nuxtjs"},
                  {"Remix", "remix"},
                  {"Astro", "astro"},
                  {"Phoenix LiveView", "phoenix"}
                ]}
              />
              <p class="text-sm text-muted-foreground mt-1.5">
                Selected: {if @selected_framework, do: @selected_framework, else: "(none)"}
              </p>
            </div>
          </.stack>
        </section>

        <%!-- With Many Options --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Long List with Scroll</h2>
          <div>
            <.label for="timezone-select" class="mb-1.5">Timezone</.label>
            <.select
              id="timezone-select"
              name="timezone"
              value={@selected_timezone}
              placeholder="Select a timezone..."
              options={[
                {"Pacific Time (PST)", "pst"},
                {"Mountain Time (MST)", "mst"},
                {"Central Time (CST)", "cst"},
                {"Eastern Time (EST)", "est"},
                {"Greenwich Mean Time (GMT)", "gmt"},
                {"Central European Time (CET)", "cet"},
                {"Eastern European Time (EET)", "eet"},
                {"India Standard Time (IST)", "ist"},
                {"Japan Standard Time (JST)", "jst"},
                {"China Standard Time (CST)", "cst-china"},
                {"Australian Eastern Time (AEST)", "aest"},
                {"New Zealand Time (NZST)", "nzst"}
              ]}
            />
            <p class="text-sm text-muted-foreground mt-1.5">
              Selected: {@selected_timezone}
            </p>
          </div>
        </section>

        <%!-- Disabled State --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Disabled</h2>
          <.stack size="medium">
            <div>
              <.label for="disabled-select" class="mb-1.5">Disabled Select</.label>
              <.select
                id="disabled-select"
                name="disabled"
                value="default"
                disabled
                options={[
                  {"Default Option", "default"},
                  {"Option 2", "option2"}
                ]}
              />
            </div>
          </.stack>
        </section>

        <%!-- Error/Invalid State --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Error State</h2>
          <.stack size="medium">
            <div>
              <.label for="error-select" class="mb-1.5">Invalid Selection</.label>
              <.select
                id="error-select"
                name="category"
                aria-invalid="true"
                aria-describedby="category-error"
                placeholder="Select a category..."
                options={[
                  {"Technology", "tech"},
                  {"Design", "design"},
                  {"Business", "business"}
                ]}
              />
              <p id="category-error" class="text-sm text-destructive mt-1.5">
                Please select a category
              </p>
            </div>
          </.stack>
        </section>

        <%!-- Form Example --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Form Example</h2>
          <.card class="max-w-md">
            <.card_header>
              <.card_title>User Preferences</.card_title>
              <.card_description>Configure your account settings</.card_description>
            </.card_header>
            <.card_content>
              <form phx-submit="save_preferences">
                <.stack size="medium">
                  <div>
                    <.label for="language" class="mb-1.5">Language</.label>
                    <.select
                      id="language"
                      name="language"
                      value="en"
                      options={[
                        {"English", "en"},
                        {"Español", "es"},
                        {"Français", "fr"},
                        {"Deutsch", "de"},
                        {"日本語", "ja"}
                      ]}
                    />
                  </div>

                  <div>
                    <.label for="theme" class="mb-1.5">Theme</.label>
                    <.select
                      id="theme"
                      name="theme"
                      value="system"
                      options={[
                        {"Light", "light"},
                        {"Dark", "dark"},
                        {"System", "system"}
                      ]}
                    />
                  </div>

                  <div>
                    <.label for="notifications" class="mb-1.5">Notifications</.label>
                    <.select
                      id="notifications"
                      name="notifications"
                      value="all"
                      options={[
                        {"All Notifications", "all"},
                        {"Important Only", "important"},
                        {"None", "none"}
                      ]}
                    />
                  </div>

                  <.button class="w-full">Save Preferences</.button>
                </.stack>
              </form>
            </.card_content>
          </.card>
        </section>

        <%!-- Integration with Form Fields --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Status Selector</h2>
          <.card class="max-w-md">
            <.card_content>
              <div class="flex items-center gap-4">
                <.label for="status-select">Status:</.label>
                <.select
                  id="status-select"
                  name="status"
                  value={@selected_status}
                  phx-change="status_changed"
                  options={[
                    {"Pending", "pending"},
                    {"In Progress", "in_progress"},
                    {"Completed", "completed"},
                    {"Cancelled", "cancelled"}
                  ]}
                />
              </div>
              <p class="text-sm text-muted-foreground mt-3">
                Current status: <span class="font-medium text-foreground">{@selected_status}</span>
              </p>
            </.card_content>
          </.card>
        </section>

        <%!-- Accessibility & Features --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Features & Accessibility</h2>
          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>Component Features</.card_title>
            </.card_header>
            <.card_content>
              <.stack size="medium">
                <div>
                  <h3 class="text-sm font-semibold text-foreground mb-2">Theming</h3>
                  <p class="text-sm text-muted-foreground mb-2">
                    The select component uses semantic color tokens for proper theme support:
                  </p>
                  <ul class="text-sm text-muted-foreground space-y-1 list-disc list-inside ml-2">
                    <li>
                      Trigger: <code class="text-xs">bg-transparent</code>, <code class="text-xs">dark:bg-input/30</code>,
                      <code class="text-xs">border-input</code>
                    </li>
                    <li>
                      Dropdown: <code class="text-xs">bg-popover</code>, <code class="text-xs">text-popover-foreground</code>,
                      <code class="text-xs">border-border</code>
                    </li>
                    <li>
                      Options: <code class="text-xs">hover:bg-accent</code>,
                      <code class="text-xs">hover:text-accent-foreground</code>
                    </li>
                    <li>Full dark mode support with semantic tokens</li>
                  </ul>
                </div>

                <div>
                  <h3 class="text-sm font-semibold text-foreground mb-2">Keyboard Navigation</h3>
                  <ul class="text-sm text-muted-foreground space-y-1 list-disc list-inside">
                    <li>
                      <code class="text-xs">Space</code>
                      or <code class="text-xs">Arrow Down/Up</code>
                      - Open dropdown
                    </li>
                    <li>
                      <code class="text-xs">Arrow Down/Up</code> - Navigate options
                    </li>
                    <li>
                      <code class="text-xs">Enter</code>
                      or <code class="text-xs">Space</code>
                      - Select focused option
                    </li>
                    <li>
                      <code class="text-xs">Escape</code> - Close dropdown
                    </li>
                    <li>Type to search - Start typing to jump to matching options</li>
                  </ul>
                </div>

                <div>
                  <h3 class="text-sm font-semibold text-foreground mb-2">Accessibility</h3>
                  <ul class="text-sm text-muted-foreground space-y-1 list-disc list-inside">
                    <li>Custom dropdown with full ARIA support</li>
                    <li>Focus visible ring styles for keyboard navigation</li>
                    <li>
                      Error state styling via <code class="text-xs">aria-invalid</code> attribute
                    </li>
                    <li>
                      Support for <code class="text-xs">aria-describedby</code> for error messages
                    </li>
                    <li>Proper disabled state that prevents interaction</li>
                    <li>Check icon indicates selected option</li>
                    <li>Smooth animations matching shadcn/ui design</li>
                  </ul>
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
