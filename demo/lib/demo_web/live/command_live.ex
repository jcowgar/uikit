defmodule DemoWeb.Ui.CommandLive do
  @moduledoc false
  use DemoWeb, :live_view

  alias UiKit.Components.Ui.Command.CommandGroup
  alias UiKit.Components.Ui.Command.CommandItem
  alias Phoenix.LiveView.Socket

  @impl true
  @spec mount(map(), map(), Socket.t()) ::
          {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:search_query, "")
      |> assign(:all_commands, all_commands())
      |> assign(:filtered_commands, all_commands())
      |> assign(:dialog_search_query, "")
      |> assign(:dialog_filtered_commands, all_commands())

    {:ok, socket}
  end

  @impl true
  @spec handle_event(String.t(), map(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("filter_commands", %{"search" => query}, socket) do
    filtered =
      if query == "" do
        socket.assigns.all_commands
      else
        filter_commands(socket.assigns.all_commands, query)
      end

    {:noreply,
     socket
     |> assign(:search_query, query)
     |> assign(:filtered_commands, filtered)}
  end

  def handle_event("filter_dialog_commands", %{"search" => query}, socket) do
    filtered =
      if query == "" do
        socket.assigns.all_commands
      else
        filter_commands(socket.assigns.all_commands, query)
      end

    {:noreply,
     socket
     |> assign(:dialog_search_query, query)
     |> assign(:dialog_filtered_commands, filtered)}
  end

  def handle_event("select_command", %{"command" => command}, socket) do
    {:noreply,
     socket
     |> put_flash(:info, "Selected command: #{command}")
     |> push_event("close-dialog", %{id: "command-palette"})}
  end

  @impl true
  def render(assigns) do
    ~H"""
    
      <.container>
        <.stack size="large">
          <%!-- Header --%>
          <div>
            <h1 class="text-3xl font-bold text-foreground">Command Component</h1>
            <p class="text-muted-foreground mt-2">
              A fast, composable command menu for building search interfaces and command palettes.
            </p>
          </div>

          <%!-- Client-Side Filtering --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">
              Client-Side Filtering
            </h2>
            <p class="text-sm text-muted-foreground mb-4">
              Instant filtering via JavaScript with no server round trips.
              Best for static command lists.
            </p>
            <.command_menu
              id="client-command"
              commands={@all_commands}
              placeholder="Type a command or search..."
              filter_mode={:client}
              on_select="select_command"
              class="max-w-md"
            />
          </section>

          <%!-- Server-Side Filtering --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">
              Server-Side Filtering
            </h2>
            <p class="text-sm text-muted-foreground mb-4">
              LiveView handles filtering on each keystroke.
              Best for dynamic data, database queries, or very large command lists.
            </p>
            <.command_menu
              id="server-command"
              commands={@filtered_commands}
              placeholder="Type a command or search..."
              search_value={@search_query}
              filter_mode={:server}
              on_change="filter_commands"
              on_select="select_command"
              class="max-w-md"
            />
          </section>

          <%!-- Command Dialog (Modal) --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Command Dialog (⌘K)</h2>
            <p class="text-sm text-muted-foreground mb-4">
              A modal command palette, typically triggered by keyboard shortcuts.
            </p>
            <.command_dialog
              id="command-palette"
              title="Command Palette"
              description="Search for commands"
            >
              <:trigger>
                <.button>
                  <.icon name="hero-magnifying-glass" /> Open Command Palette
                </.button>
              </:trigger>
              <:content>
                <form phx-change="filter_dialog_commands">
                  <.command_input
                    id="palette-search"
                    placeholder="Type a command or search..."
                    value={@dialog_search_query}
                    name="search"
                    phx-hook="CommandInputFocus"
                  />
                </form>
                <.command_list>
                  <%= if Enum.empty?(@dialog_filtered_commands) do %>
                    <.command_empty>
                      No results found.
                    </.command_empty>
                  <% else %>
                    <%= for group <- @dialog_filtered_commands do %>
                      <.command_group heading={group.heading}>
                        <%= for item <- group.items do %>
                          <.command_item
                            phx-click="select_command"
                            phx-value-command={item.label}
                            disabled={item.disabled}
                          >
                            <%= if item.icon do %>
                              <.icon name={item.icon} />
                            <% end %>
                            {item.label}
                            <%= if item.shortcut do %>
                              <.command_shortcut>{item.shortcut}</.command_shortcut>
                            <% end %>
                          </.command_item>
                        <% end %>
                      </.command_group>
                      <%= if group != List.last(@dialog_filtered_commands) do %>
                        <.command_separator />
                      <% end %>
                    <% end %>
                  <% end %>
                </.command_list>
              </:content>
            </.command_dialog>
          </section>

          <%!-- With Custom Icons --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">With Custom Icons</h2>
            <p class="text-sm text-muted-foreground mb-4">
              Command items can include icons and keyboard shortcuts for better UX.
            </p>
            <.command
              id="icons-command"
              class="border border-border rounded-lg shadow-sm max-w-md"
              phx-hook="CommandFilter CommandKeyboard"
            >
              <.command_input placeholder="Search actions..." data-command-input="true" />
              <.command_list data-command-list="true">
                <.command_group heading="File" data-command-group="true">
                  <.command_item data-command-item="true" data-command-label="New File">
                    <.icon name="hero-document-plus" /> New File
                    <.command_shortcut>⌘N</.command_shortcut>
                  </.command_item>
                  <.command_item data-command-item="true" data-command-label="New Folder">
                    <.icon name="hero-folder-plus" /> New Folder
                    <.command_shortcut>⇧⌘N</.command_shortcut>
                  </.command_item>
                  <.command_item data-command-item="true" data-command-label="Save">
                    <.icon name="hero-arrow-down-tray" /> Save
                    <.command_shortcut>⌘S</.command_shortcut>
                  </.command_item>
                </.command_group>
                <.command_separator />
                <.command_group heading="Edit" data-command-group="true">
                  <.command_item data-command-item="true" data-command-label="Undo">
                    <.icon name="hero-arrow-uturn-left" /> Undo
                    <.command_shortcut>⌘Z</.command_shortcut>
                  </.command_item>
                  <.command_item data-command-item="true" data-command-label="Redo">
                    <.icon name="hero-arrow-uturn-right" /> Redo
                    <.command_shortcut>⇧⌘Z</.command_shortcut>
                  </.command_item>
                  <.command_item data-command-item="true" data-command-label="Cut">
                    <.icon name="hero-scissors" /> Cut
                    <.command_shortcut>⌘X</.command_shortcut>
                  </.command_item>
                  <.command_item data-command-item="true" data-command-label="Copy">
                    <.icon name="hero-clipboard-document" /> Copy
                    <.command_shortcut>⌘C</.command_shortcut>
                  </.command_item>
                  <.command_item data-command-item="true" data-command-label="Paste">
                    <.icon name="hero-clipboard-document-list" /> Paste
                    <.command_shortcut>⌘V</.command_shortcut>
                  </.command_item>
                </.command_group>
              </.command_list>
            </.command>
          </section>

          <%!-- Disabled Items --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">With Disabled Items</h2>
            <p class="text-sm text-muted-foreground mb-4">
              Command items can be disabled to indicate unavailable actions.
            </p>
            <.command
              id="disabled-command"
              class="border border-border rounded-lg shadow-sm max-w-md"
              phx-hook="CommandFilter CommandKeyboard"
            >
              <.command_input placeholder="Search settings..." data-command-input="true" />
              <.command_list data-command-list="true">
                <.command_group heading="Account" data-command-group="true">
                  <.command_item data-command-item="true" data-command-label="Profile Settings">
                    <.icon name="hero-user" /> Profile Settings
                  </.command_item>
                  <.command_item data-command-item="true" data-command-label="Notifications">
                    <.icon name="hero-bell" /> Notifications
                  </.command_item>
                  <.command_item
                    disabled
                    data-command-item="true"
                    data-command-label="Two-Factor Auth"
                  >
                    <.icon name="hero-shield-check" /> Two-Factor Auth (Coming Soon)
                  </.command_item>
                </.command_group>
                <.command_separator />
                <.command_group heading="Preferences" data-command-group="true">
                  <.command_item data-command-item="true" data-command-label="Theme">
                    <.icon name="hero-paint-brush" /> Theme
                  </.command_item>
                  <.command_item data-command-item="true" data-command-label="Language">
                    <.icon name="hero-language" /> Language
                  </.command_item>
                  <.command_item
                    disabled
                    data-command-item="true"
                    data-command-label="Advanced Settings"
                  >
                    <.icon name="hero-cog-6-tooth" /> Advanced Settings (Pro Only)
                  </.command_item>
                </.command_group>
              </.command_list>
            </.command>
          </section>

          <%!-- Usage Guidelines --%>
          <section class="border-t border-border pt-8">
            <h2 class="text-xl font-semibold text-foreground mb-4">Usage Guidelines</h2>
            <div class="space-y-4 text-sm">
              <div>
                <h3 class="font-medium text-foreground mb-2">When to Use</h3>
                <ul class="list-disc list-inside space-y-1 text-muted-foreground">
                  <li>For quick navigation and action discovery in your application</li>
                  <li>As a command palette triggered by keyboard shortcuts (⌘K, ⌘J)</li>
                  <li>For autocomplete/combobox implementations with search functionality</li>
                  <li>When you want to provide a keyboard-driven interface</li>
                </ul>
              </div>
              <div>
                <h3 class="font-medium text-foreground mb-2">Command vs Dropdown Menu</h3>
                <ul class="list-disc list-inside space-y-1 text-muted-foreground">
                  <li>
                    Use <strong class="text-foreground">Command</strong>
                    for searchable, filterable lists of actions or items
                  </li>
                  <li>
                    Use <strong class="text-foreground">Dropdown Menu</strong>
                    for contextual actions on a specific element
                  </li>
                  <li>Commands are better for large sets of options with search/filter</li>
                  <li>Dropdown menus are better for small, context-specific action lists</li>
                </ul>
              </div>
              <div>
                <h3 class="font-medium text-foreground mb-2">Best Practices</h3>
                <ul class="list-disc list-inside space-y-1 text-muted-foreground">
                  <li>Group related commands together with clear headings</li>
                  <li>Show keyboard shortcuts for common actions</li>
                  <li>Provide immediate visual feedback when filtering/searching</li>
                  <li>Use icons to help users quickly identify commands</li>
                  <li>Keep command labels short and action-oriented</li>
                  <li>For command dialogs, typically bind to ⌘K or Ctrl+K</li>
                </ul>
              </div>
              <div>
                <h3 class="font-medium text-foreground mb-2">Filtering Implementation</h3>
                <ul class="list-disc list-inside space-y-1 text-muted-foreground">
                  <li>
                    The command input should filter results as the user types
                  </li>
                  <li>
                    Use <code class="text-xs bg-muted px-1 py-0.5 rounded">phx-change</code>
                    event on the input to handle filtering
                  </li>
                  <li>
                    Implement fuzzy search or simple string matching in your LiveView
                  </li>
                  <li>
                    Show "No results found" when the filter returns empty
                  </li>
                </ul>
              </div>
              <div>
                <h3 class="font-medium text-foreground mb-2">Accessibility</h3>
                <ul class="list-disc list-inside space-y-1 text-muted-foreground">
                  <li>Command menu uses proper ARIA roles (combobox, listbox, option)</li>
                  <li>Keyboard navigation with arrow keys (implementation needed)</li>
                  <li>Enter key selects the focused command</li>
                  <li>Escape key closes the command dialog</li>
                </ul>
              </div>
            </div>
          </section>
        </.stack>
      </.container>
    
    """
  end

  # Private helper functions

  @spec all_commands() :: [CommandGroup.t()]
  defp all_commands do
    [
      %CommandGroup{
        heading: "Suggestions",
        items: [
          %CommandItem{label: "Calendar", icon: "hero-calendar"},
          %CommandItem{label: "Search Emoji", icon: "hero-face-smile"},
          %CommandItem{label: "Calculator", icon: "hero-calculator"}
        ]
      },
      %CommandGroup{
        heading: "Settings",
        items: [
          %CommandItem{label: "Profile", icon: "hero-user", shortcut: "⌘P"},
          %CommandItem{label: "Billing", icon: "hero-credit-card", shortcut: "⌘B"},
          %CommandItem{label: "Settings", icon: "hero-cog-6-tooth", shortcut: "⌘S"}
        ]
      },
      %CommandGroup{
        heading: "Actions",
        items: [
          %CommandItem{label: "New Document", icon: "hero-document-plus", shortcut: "⌘N"},
          %CommandItem{label: "Upload File", icon: "hero-arrow-up-tray", shortcut: "⌘U"},
          %CommandItem{label: "Share", icon: "hero-share"}
        ]
      }
    ]
  end

  @spec filter_commands([CommandGroup.t()], String.t()) :: [CommandGroup.t()]
  defp filter_commands(groups, query) do
    query_lower = String.downcase(query)

    groups
    |> Enum.map(fn group ->
      filtered_items =
        Enum.filter(group.items, fn item ->
          String.contains?(String.downcase(item.label), query_lower)
        end)

      %{group | items: filtered_items}
    end)
    |> Enum.reject(fn group -> Enum.empty?(group.items) end)
  end
end
