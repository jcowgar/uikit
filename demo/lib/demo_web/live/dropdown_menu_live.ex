defmodule DemoWeb.Ui.DropdownMenuLive do
  @moduledoc false
  use DemoWeb, :live_view

  alias Phoenix.LiveView.Socket

  @impl true
  @spec mount(map(), map(), Socket.t()) ::
          {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:show_sidebar, true)
      |> assign(:show_toolbar, false)
      |> assign(:show_status_bar, true)
      |> assign(:view_mode, "grid")
      |> assign(:sort_order, "asc")

    {:ok, socket}
  end

  @impl true
  @spec handle_event(String.t(), map(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("toggle-sidebar", _params, socket) do
    {:noreply, assign(socket, :show_sidebar, !socket.assigns.show_sidebar)}
  end

  def handle_event("toggle-toolbar", _params, socket) do
    {:noreply, assign(socket, :show_toolbar, !socket.assigns.show_toolbar)}
  end

  def handle_event("toggle-status-bar", _params, socket) do
    {:noreply, assign(socket, :show_status_bar, !socket.assigns.show_status_bar)}
  end

  def handle_event("set-view", %{"view" => view}, socket) do
    {:noreply, assign(socket, :view_mode, view)}
  end

  def handle_event("set-sort", %{"order" => order}, socket) do
    {:noreply, assign(socket, :sort_order, order)}
  end

  def handle_event("demo-action", %{"action" => action}, socket) do
    {:noreply, put_flash(socket, :info, "Action triggered: #{action}")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    
      <.container>
        <.stack size="large">
          <%!-- Header --%>
          <div>
            <h1 class="text-3xl font-bold text-foreground">Dropdown Menu Component</h1>
            <p class="text-muted-foreground mt-2">
              Displays a menu to the user — such as a set of actions or functions — triggered by a button.
            </p>
          </div>

          <%!-- Basic Example --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Basic Menu</h2>
            <.dropdown_menu id="basic-menu">
              <:trigger>
                <.button variant="outline">
                  Open Menu <.icon name="hero-chevron-down" />
                </.button>
              </:trigger>
              <:content>
                <.dropdown_menu_content>
                  <.dropdown_menu_label>My Account</.dropdown_menu_label>
                  <.dropdown_menu_separator />
                  <.dropdown_menu_item phx-click="demo-action" phx-value-action="profile">
                    Profile
                  </.dropdown_menu_item>
                  <.dropdown_menu_item phx-click="demo-action" phx-value-action="billing">
                    Billing
                  </.dropdown_menu_item>
                  <.dropdown_menu_item phx-click="demo-action" phx-value-action="settings">
                    Settings
                  </.dropdown_menu_item>
                  <.dropdown_menu_separator />
                  <.dropdown_menu_item
                    variant="destructive"
                    phx-click="demo-action"
                    phx-value-action="logout"
                  >
                    Logout
                  </.dropdown_menu_item>
                </.dropdown_menu_content>
              </:content>
            </.dropdown_menu>
          </section>

          <%!-- With Icons and Shortcuts --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">With Icons & Shortcuts</h2>
            <.dropdown_menu id="icons-menu">
              <:trigger>
                <.button variant="outline">
                  File Menu <.icon name="hero-chevron-down" />
                </.button>
              </:trigger>
              <:content>
                <.dropdown_menu_content>
                  <.dropdown_menu_label>File</.dropdown_menu_label>
                  <.dropdown_menu_separator />
                  <.dropdown_menu_item phx-click="demo-action" phx-value-action="new">
                    <.icon name="hero-document-plus" /> New File
                    <.dropdown_menu_shortcut>⌘N</.dropdown_menu_shortcut>
                  </.dropdown_menu_item>
                  <.dropdown_menu_item phx-click="demo-action" phx-value-action="open">
                    <.icon name="hero-folder-open" /> Open
                    <.dropdown_menu_shortcut>⌘O</.dropdown_menu_shortcut>
                  </.dropdown_menu_item>
                  <.dropdown_menu_item phx-click="demo-action" phx-value-action="save">
                    <.icon name="hero-arrow-down-tray" /> Save
                    <.dropdown_menu_shortcut>⌘S</.dropdown_menu_shortcut>
                  </.dropdown_menu_item>
                  <.dropdown_menu_separator />
                  <.dropdown_menu_item phx-click="demo-action" phx-value-action="print">
                    <.icon name="hero-printer" /> Print
                    <.dropdown_menu_shortcut>⌘P</.dropdown_menu_shortcut>
                  </.dropdown_menu_item>
                </.dropdown_menu_content>
              </:content>
            </.dropdown_menu>
          </section>

          <%!-- Checkbox Items --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">With Checkboxes</h2>
            <.flex align="start" class="gap-4">
              <.dropdown_menu id="checkboxes-menu">
                <:trigger>
                  <.button variant="outline">
                    View Options <.icon name="hero-chevron-down" />
                  </.button>
                </:trigger>
                <:content>
                  <.dropdown_menu_content>
                    <.dropdown_menu_label>Toggle View</.dropdown_menu_label>
                    <.dropdown_menu_separator />
                    <.dropdown_menu_checkbox_item
                      checked={@show_sidebar}
                      phx-click="toggle-sidebar"
                    >
                      <.icon name="hero-sidebar" /> Show Sidebar
                    </.dropdown_menu_checkbox_item>
                    <.dropdown_menu_checkbox_item
                      checked={@show_toolbar}
                      phx-click="toggle-toolbar"
                    >
                      <.icon name="hero-squares-2x2" /> Show Toolbar
                    </.dropdown_menu_checkbox_item>
                    <.dropdown_menu_checkbox_item
                      checked={@show_status_bar}
                      phx-click="toggle-status-bar"
                    >
                      <.icon name="hero-information-circle" /> Show Status Bar
                    </.dropdown_menu_checkbox_item>
                  </.dropdown_menu_content>
                </:content>
              </.dropdown_menu>

              <div class="text-sm text-muted-foreground">
                <p>Current state:</p>
                <ul class="list-disc list-inside">
                  <li>Sidebar: {if @show_sidebar, do: "visible", else: "hidden"}</li>
                  <li>Toolbar: {if @show_toolbar, do: "visible", else: "hidden"}</li>
                  <li>Status Bar: {if @show_status_bar, do: "visible", else: "hidden"}</li>
                </ul>
              </div>
            </.flex>
          </section>

          <%!-- Radio Groups --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Radio Groups</h2>
            <.flex align="start" class="gap-4">
              <.dropdown_menu id="radio-menu">
                <:trigger>
                  <.button variant="outline">
                    View: {String.capitalize(@view_mode)}
                    <.icon name="hero-chevron-down" />
                  </.button>
                </:trigger>
                <:content>
                  <.dropdown_menu_content>
                    <.dropdown_menu_label>View Mode</.dropdown_menu_label>
                    <.dropdown_menu_separator />
                    <.dropdown_menu_radio_group>
                      <.dropdown_menu_radio_item
                        checked={@view_mode == "grid"}
                        phx-click="set-view"
                        phx-value-view="grid"
                      >
                        <.icon name="hero-squares-2x2" /> Grid View
                      </.dropdown_menu_radio_item>
                      <.dropdown_menu_radio_item
                        checked={@view_mode == "list"}
                        phx-click="set-view"
                        phx-value-view="list"
                      >
                        <.icon name="hero-list-bullet" /> List View
                      </.dropdown_menu_radio_item>
                      <.dropdown_menu_radio_item
                        checked={@view_mode == "kanban"}
                        phx-click="set-view"
                        phx-value-view="kanban"
                      >
                        <.icon name="hero-view-columns" /> Kanban View
                      </.dropdown_menu_radio_item>
                    </.dropdown_menu_radio_group>
                  </.dropdown_menu_content>
                </:content>
              </.dropdown_menu>

              <.dropdown_menu id="sort-menu">
                <:trigger>
                  <.button variant="outline">
                    Sort: {String.upcase(@sort_order)}
                    <.icon name="hero-chevron-down" />
                  </.button>
                </:trigger>
                <:content>
                  <.dropdown_menu_content>
                    <.dropdown_menu_label>Sort Order</.dropdown_menu_label>
                    <.dropdown_menu_separator />
                    <.dropdown_menu_radio_group>
                      <.dropdown_menu_radio_item
                        checked={@sort_order == "asc"}
                        phx-click="set-sort"
                        phx-value-order="asc"
                      >
                        <.icon name="hero-arrow-up" /> Ascending
                      </.dropdown_menu_radio_item>
                      <.dropdown_menu_radio_item
                        checked={@sort_order == "desc"}
                        phx-click="set-sort"
                        phx-value-order="desc"
                      >
                        <.icon name="hero-arrow-down" /> Descending
                      </.dropdown_menu_radio_item>
                    </.dropdown_menu_radio_group>
                  </.dropdown_menu_content>
                </:content>
              </.dropdown_menu>
            </.flex>
          </section>

          <%!-- Nested Submenus --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Nested Submenus</h2>
            <.dropdown_menu id="nested-menu">
              <:trigger>
                <.button variant="outline">
                  Edit Menu <.icon name="hero-chevron-down" />
                </.button>
              </:trigger>
              <:content>
                <.dropdown_menu_content>
                  <.dropdown_menu_item phx-click="demo-action" phx-value-action="cut">
                    <.icon name="hero-scissors" /> Cut
                    <.dropdown_menu_shortcut>⌘X</.dropdown_menu_shortcut>
                  </.dropdown_menu_item>
                  <.dropdown_menu_item phx-click="demo-action" phx-value-action="copy">
                    <.icon name="hero-document-duplicate" /> Copy
                    <.dropdown_menu_shortcut>⌘C</.dropdown_menu_shortcut>
                  </.dropdown_menu_item>
                  <.dropdown_menu_item phx-click="demo-action" phx-value-action="paste">
                    <.icon name="hero-clipboard" /> Paste
                    <.dropdown_menu_shortcut>⌘V</.dropdown_menu_shortcut>
                  </.dropdown_menu_item>
                  <.dropdown_menu_separator />

                  <.dropdown_menu_sub id="share-submenu">
                    <:trigger>
                      <.dropdown_menu_sub_trigger>
                        <.icon name="hero-share" /> Share
                      </.dropdown_menu_sub_trigger>
                    </:trigger>
                    <:content>
                      <.dropdown_menu_sub_content>
                        <.dropdown_menu_item phx-click="demo-action" phx-value-action="email">
                          <.icon name="hero-envelope" /> Email
                        </.dropdown_menu_item>
                        <.dropdown_menu_item phx-click="demo-action" phx-value-action="link">
                          <.icon name="hero-link" /> Copy Link
                        </.dropdown_menu_item>
                        <.dropdown_menu_item phx-click="demo-action" phx-value-action="social">
                          <.icon name="hero-globe-alt" /> Social Media
                        </.dropdown_menu_item>
                        <.dropdown_menu_item phx-click="demo-action" phx-value-action="slack">
                          <.icon name="hero-chat-bubble-left-right" /> Slack
                        </.dropdown_menu_item>
                        <.dropdown_menu_item phx-click="demo-action" phx-value-action="teams">
                          <.icon name="hero-user-group" /> Microsoft Teams
                        </.dropdown_menu_item>
                        <.dropdown_menu_item phx-click="demo-action" phx-value-action="discord">
                          <.icon name="hero-chat-bubble-bottom-center" /> Discord
                        </.dropdown_menu_item>
                        <.dropdown_menu_item phx-click="demo-action" phx-value-action="twitter">
                          <.icon name="hero-megaphone" /> Twitter
                        </.dropdown_menu_item>
                        <.dropdown_menu_item phx-click="demo-action" phx-value-action="linkedin">
                          <.icon name="hero-briefcase" /> LinkedIn
                        </.dropdown_menu_item>
                        <.dropdown_menu_item phx-click="demo-action" phx-value-action="whatsapp">
                          <.icon name="hero-device-phone-mobile" /> WhatsApp
                        </.dropdown_menu_item>
                        <.dropdown_menu_item phx-click="demo-action" phx-value-action="telegram">
                          <.icon name="hero-paper-airplane" /> Telegram
                        </.dropdown_menu_item>
                      </.dropdown_menu_sub_content>
                    </:content>
                  </.dropdown_menu_sub>

                  <.dropdown_menu_sub id="export-submenu">
                    <:trigger>
                      <.dropdown_menu_sub_trigger>
                        <.icon name="hero-arrow-down-tray" /> Export
                      </.dropdown_menu_sub_trigger>
                    </:trigger>
                    <:content>
                      <.dropdown_menu_sub_content>
                        <.dropdown_menu_item phx-click="demo-action" phx-value-action="pdf">
                          <.icon name="hero-document" /> Export as PDF
                        </.dropdown_menu_item>
                        <.dropdown_menu_item phx-click="demo-action" phx-value-action="csv">
                          <.icon name="hero-document-text" /> Export as CSV
                        </.dropdown_menu_item>
                        <.dropdown_menu_item phx-click="demo-action" phx-value-action="json">
                          <.icon name="hero-code-bracket" /> Export as JSON
                        </.dropdown_menu_item>
                      </.dropdown_menu_sub_content>
                    </:content>
                  </.dropdown_menu_sub>
                </.dropdown_menu_content>
              </:content>
            </.dropdown_menu>
          </section>

          <%!-- Alignment Options --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Menu Alignment</h2>
            <.flex align="start" class="gap-4">
              <.dropdown_menu id="align-start-menu">
                <:trigger>
                  <.button variant="outline">Align Start</.button>
                </:trigger>
                <:content>
                  <.dropdown_menu_content align="start">
                    <.dropdown_menu_item>Item 1</.dropdown_menu_item>
                    <.dropdown_menu_item>Item 2</.dropdown_menu_item>
                    <.dropdown_menu_item>Item 3</.dropdown_menu_item>
                  </.dropdown_menu_content>
                </:content>
              </.dropdown_menu>

              <.dropdown_menu id="align-center-menu">
                <:trigger>
                  <.button variant="outline">Align Center</.button>
                </:trigger>
                <:content>
                  <.dropdown_menu_content align="center">
                    <.dropdown_menu_item>Item 1</.dropdown_menu_item>
                    <.dropdown_menu_item>Item 2</.dropdown_menu_item>
                    <.dropdown_menu_item>Item 3</.dropdown_menu_item>
                  </.dropdown_menu_content>
                </:content>
              </.dropdown_menu>

              <.dropdown_menu id="align-end-menu">
                <:trigger>
                  <.button variant="outline">Align End</.button>
                </:trigger>
                <:content>
                  <.dropdown_menu_content align="end">
                    <.dropdown_menu_item>Item 1</.dropdown_menu_item>
                    <.dropdown_menu_item>Item 2</.dropdown_menu_item>
                    <.dropdown_menu_item>Item 3</.dropdown_menu_item>
                  </.dropdown_menu_content>
                </:content>
              </.dropdown_menu>
            </.flex>
          </section>

          <%!-- Disabled Items --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Disabled Items</h2>
            <.dropdown_menu id="disabled-menu">
              <:trigger>
                <.button variant="outline">
                  Actions <.icon name="hero-chevron-down" />
                </.button>
              </:trigger>
              <:content>
                <.dropdown_menu_content>
                  <.dropdown_menu_item phx-click="demo-action" phx-value-action="edit">
                    Edit
                  </.dropdown_menu_item>
                  <.dropdown_menu_item phx-click="demo-action" phx-value-action="duplicate">
                    Duplicate
                  </.dropdown_menu_item>
                  <.dropdown_menu_item disabled>
                    Archive (Coming Soon)
                  </.dropdown_menu_item>
                  <.dropdown_menu_separator />
                  <.dropdown_menu_item disabled variant="destructive">
                    Delete (Disabled)
                  </.dropdown_menu_item>
                </.dropdown_menu_content>
              </:content>
            </.dropdown_menu>
          </section>

          <%!-- Complex Example --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Complex Example</h2>
            <.dropdown_menu id="complex-menu">
              <:trigger>
                <.button variant="outline">
                  <.icon name="hero-cog-6-tooth" /> Settings <.icon name="hero-chevron-down" />
                </.button>
              </:trigger>
              <:content>
                <.dropdown_menu_content>
                  <.dropdown_menu_label>Preferences</.dropdown_menu_label>
                  <.dropdown_menu_separator />

                  <.dropdown_menu_group>
                    <.dropdown_menu_item phx-click="demo-action" phx-value-action="profile">
                      <.icon name="hero-user" /> Profile
                      <.dropdown_menu_shortcut>⌘P</.dropdown_menu_shortcut>
                    </.dropdown_menu_item>
                    <.dropdown_menu_item phx-click="demo-action" phx-value-action="billing">
                      <.icon name="hero-credit-card" /> Billing
                      <.dropdown_menu_shortcut>⌘B</.dropdown_menu_shortcut>
                    </.dropdown_menu_item>
                    <.dropdown_menu_item phx-click="demo-action" phx-value-action="settings">
                      <.icon name="hero-cog-6-tooth" /> Settings
                      <.dropdown_menu_shortcut>⌘S</.dropdown_menu_shortcut>
                    </.dropdown_menu_item>
                  </.dropdown_menu_group>

                  <.dropdown_menu_separator />

                  <.dropdown_menu_label inset>Display Options</.dropdown_menu_label>
                  <.dropdown_menu_checkbox_item checked={@show_sidebar} phx-click="toggle-sidebar">
                    Sidebar
                  </.dropdown_menu_checkbox_item>
                  <.dropdown_menu_checkbox_item checked={@show_toolbar} phx-click="toggle-toolbar">
                    Toolbar
                  </.dropdown_menu_checkbox_item>

                  <.dropdown_menu_separator />

                  <.dropdown_menu_item
                    variant="destructive"
                    phx-click="demo-action"
                    phx-value-action="logout"
                  >
                    <.icon name="hero-arrow-right-on-rectangle" /> Log out
                    <.dropdown_menu_shortcut>⇧⌘Q</.dropdown_menu_shortcut>
                  </.dropdown_menu_item>
                </.dropdown_menu_content>
              </:content>
            </.dropdown_menu>
          </section>
        </.stack>
      </.container>
    
    """
  end
end
