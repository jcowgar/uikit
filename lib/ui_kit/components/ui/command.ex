defmodule UiKit.Components.Ui.Command do
  @moduledoc """
  Command menu components for building search interfaces and command palettes.

  Provides both low-level components for full control and high-level wrappers
  for common use cases.

  ## Simple Usage (Recommended)

      # In your LiveView
      commands = [
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
            %CommandItem{label: "Billing", icon: "hero-credit-card", shortcut: "⌘B"}
          ]
        }
      ]

      # In your template
      <.command_menu
        id="main-command"
        commands={@commands}
        placeholder="Type a command..."
        on_select={JS.push("select_command")}
      />

  ## Advanced Usage

  For complete control, use the low-level components directly:

      <.command id="custom-command">
        <.command_input placeholder="Search..." />
        <.command_list>
          <.command_group heading="Actions">
            <.command_item>New File</.command_item>
          </.command_group>
        </.command_list>
      </.command>

  Components ported from shadcn/ui.
  """
  use Phoenix.Component

  import UiKit.Components.CoreComponents, only: [icon: 1]

  alias Phoenix.LiveView.Rendered

  # ==========================================
  # Data Structures
  # ==========================================

  defmodule CommandItem do
    @moduledoc """
    Represents a single command item.
    """
    @type t :: %__MODULE__{
            label: String.t(),
            value: String.t() | nil,
            icon: String.t() | nil,
            shortcut: String.t() | nil,
            disabled: boolean(),
            metadata: map()
          }

    @enforce_keys [:label]
    defstruct label: nil,
              value: nil,
              icon: nil,
              shortcut: nil,
              disabled: false,
              metadata: %{}
  end

  defmodule CommandGroup do
    @moduledoc """
    Represents a group of command items.
    """
    @type t :: %__MODULE__{
            heading: String.t() | nil,
            items: [CommandItem.t()]
          }

    @enforce_keys [:items]
    defstruct heading: nil, items: []
  end

  # ==========================================
  # High-Level Components
  # ==========================================

  @doc """
  Renders a command menu with data-driven commands.

  A simplified wrapper that renders commands from struct data.
  Supports both client-side (instant JS) and server-side (LiveView) filtering.

  ## Client-Side Filtering (Default)

      # In your LiveView
      alias UiKit.Components.Ui.Command.{CommandGroup, CommandItem}

      def mount(_params, _session, socket) do
        {:ok, assign(socket, :commands, all_commands())}
      end

      # In your template - filtering happens in JS, no server events needed
      <.command_menu
        id="my-command"
        commands={@commands}
        placeholder="Search commands..."
        filter_mode={:client}
        on_select="select_command"
      />

  ## Server-Side Filtering

      # In your LiveView
      def mount(_params, _session, socket) do
        {:ok,
         socket
         |> assign(:all_commands, all_commands())
         |> assign(:filtered_commands, all_commands())
         |> assign(:search_query, "")}
      end

      def handle_event("filter", %{"search" => query}, socket) do
        filtered = filter_commands(socket.assigns.all_commands, query)
        {:noreply, assign(socket, filtered_commands: filtered, search_query: query)}
      end

      # In your template
      <.command_menu
        id="my-command"
        commands={@filtered_commands}
        placeholder="Search commands..."
        search_value={@search_query}
        filter_mode={:server}
        on_change="filter"
        on_select="select_command"
      />

  ## Attributes

  - `id` - Required unique identifier
  - `commands` - List of CommandGroup structs
  - `placeholder` - Input placeholder text
  - `search_value` - Current search input value
  - `filter_mode` - `:client` (default) for instant JS filtering, `:server` for LiveView events
  - `on_change` - Event name for search input changes (only used with filter_mode: :server)
  - `on_select` - Event name for item selection
  - `class` - Additional CSS classes
  - `empty_message` - Message to show when no results (default: "No results found.")
  """
  attr :id, :string, required: true
  attr :commands, :list, required: true
  attr :placeholder, :string, default: "Type a command or search..."
  attr :search_value, :string, default: ""
  attr :filter_mode, :atom, default: :client, values: [:client, :server]
  attr :on_change, :string, default: nil
  attr :on_select, :string, default: nil
  attr :class, :string, default: nil
  attr :empty_message, :string, default: "No results found."
  attr :rest, :global

  @spec command_menu(map()) :: Rendered.t()
  def command_menu(assigns) do
    assigns =
      assigns
      |> assign_new(:computed_class, fn ->
        ["border border-border rounded-lg shadow-sm", assigns[:class]]
      end)
      |> assign_new(:hook_attrs, fn ->
        # Always add CommandKeyboard for keyboard navigation
        # Add CommandFilter only for client-side filtering
        if assigns[:filter_mode] == :client do
          %{"phx-hook" => "CommandFilter CommandKeyboard"}
        else
          %{"phx-hook" => "CommandKeyboard"}
        end
      end)

    ~H"""
    <.command id={@id} class={@computed_class} {@hook_attrs} {@rest}>
      <%= if @filter_mode == :server do %>
        <form phx-change={@on_change}>
          <.command_input
            id={"#{@id}-input"}
            placeholder={@placeholder}
            value={@search_value}
            name="search"
            data-command-input="true"
          />
        </form>
      <% else %>
        <.command_input
          id={"#{@id}-input"}
          placeholder={@placeholder}
          value={@search_value}
          name="search"
          data-command-input="true"
        />
      <% end %>
      <.command_list data-command-list="true">
        <%= if Enum.empty?(@commands) do %>
          <.command_empty data-command-empty="true">
            {@empty_message}
          </.command_empty>
        <% else %>
          <%= for {group, group_idx} <- Enum.with_index(@commands) do %>
            <.command_group heading={group.heading} data-command-group="true">
              <%= for item <- group.items do %>
                <.command_item
                  disabled={item.disabled}
                  phx-click={@on_select}
                  phx-value-command={item.value || item.label}
                  phx-value-metadata={Jason.encode!(item.metadata)}
                  class="cursor-pointer"
                  data-command-item="true"
                  data-command-label={item.label}
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
            <%= if group_idx < length(@commands) - 1 do %>
              <.command_separator />
            <% end %>
          <% end %>
        <% end %>
      </.command_list>
    </.command>
    """
  end

  # ==========================================
  # Low-Level Components
  # ==========================================

  @doc """
  Renders a command menu component.

  A fast, composable command menu for building search interfaces and command palettes.
  Typically used with keyboard shortcuts (⌘K) for quick navigation and actions.

  ## Features

  - Keyboard-driven interaction
  - Fuzzy search filtering
  - Grouped commands
  - Empty states
  - Command shortcuts display
  - Dialog/modal variant

  ## Examples

      <.command id="main-command">
        <.command_input placeholder="Type a command..." />
        <.command_list>
          <.command_empty>No results found.</.command_empty>
          <.command_group heading="Suggestions">
            <.command_item>Calendar</.command_item>
            <.command_item>Search Emoji</.command_item>
            <.command_item>Calculator</.command_item>
          </.command_group>
        </.command_list>
      </.command>
  """
  attr :id, :string, required: true
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @spec command(map()) :: Rendered.t()
  def command(assigns) do
    ~H"""
    <div
      id={@id}
      role="combobox"
      aria-expanded="true"
      class={[
        "bg-popover text-popover-foreground flex h-full w-full flex-col overflow-hidden rounded-md",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a command dialog (modal command palette).

  A modal variant of the command menu, typically triggered by keyboard shortcuts.
  Uses the standard dialog component internally with command-specific styling.

  ## Examples

      <.command_dialog id="command-palette">
        <:trigger>
          <.button>Open Command Palette</.button>
        </:trigger>
        <:content>
          <.command_input placeholder="Type a command..." />
          <.command_list>
            <.command_group heading="Actions">
              <.command_item>New File</.command_item>
              <.command_item>Save</.command_item>
            </.command_group>
          </.command_list>
        </:content>
      </.command_dialog>
  """
  attr :id, :string, required: true
  attr :title, :string, default: "Command Palette"
  attr :description, :string, default: "Search for a command to run..."
  attr :show_close_button, :boolean, default: true
  attr :class, :string, default: nil
  attr :rest, :global
  slot :trigger, doc: "Optional trigger button/element"

  slot :content, required: true, doc: "Command menu content" do
    attr :show_close_button, :boolean, doc: "Whether to show the X close button (default: true)"
  end

  @spec command_dialog(map()) :: Rendered.t()
  def command_dialog(assigns) do
    # Import dialog component from overlays_dialogs
    alias UiKit.Components.Ui.OverlaysDialogs

    assigns =
      assign_new(assigns, :show_close_button_from_content, fn ->
        case assigns.content do
          [first_content | _rest_content] -> Map.get(first_content, :show_close_button, true)
          _empty_list -> true
        end
      end)

    ~H"""
    <OverlaysDialogs.dialog id={@id} {@rest}>
      <:trigger :if={@trigger != []}>
        {render_slot(@trigger)}
      </:trigger>
      <:content show_close_button={@show_close_button_from_content}>
        <div class="sr-only">
          <OverlaysDialogs.dialog_title>{@title}</OverlaysDialogs.dialog_title>
          <OverlaysDialogs.dialog_description>{@description}</OverlaysDialogs.dialog_description>
        </div>
        <.command
          id={"#{@id}-command"}
          phx-hook="CommandKeyboard"
          class="[&_[data-command-group-heading]]:text-muted-foreground [&_[data-command-group-heading]]:px-2 [&_[data-command-group-heading]]:font-medium [&_[data-command-group]]:px-2 [&_[data-command-group]:not([hidden])_~[data-command-group]]:pt-0 [&_[data-command-input-wrapper]]:h-12 [&_[data-command-input-wrapper]_svg]:h-5 [&_[data-command-input-wrapper]_svg]:w-5 [&_[data-command-input]]:h-12 [&_[data-command-item]]:px-2 [&_[data-command-item]]:py-3 [&_[data-command-item]_svg]:h-5 [&_[data-command-item]_svg]:w-5"
        >
          {render_slot(@content)}
        </.command>
      </:content>
    </OverlaysDialogs.dialog>
    """
  end

  @doc """
  Renders a command input field.

  The search input for filtering command items.

  ## Examples

      <.command_input
        id="cmd-search"
        placeholder="Search commands..."
        phx-change="filter_commands"
      />
  """
  attr :id, :string, default: nil
  attr :name, :string, default: "search", doc: "Input name for form submissions"
  attr :placeholder, :string, default: "Type a command or search..."
  attr :value, :string, default: ""
  attr :class, :string, default: nil
  attr :rest, :global
  slot :icon, doc: "Optional icon to display before the input"

  @spec command_input(map()) :: Rendered.t()
  def command_input(assigns) do
    ~H"""
    <div
      data-command-input-wrapper
      class="flex h-9 items-center gap-2 border-b border-border px-3"
    >
      <%= if @icon != [] do %>
        {render_slot(@icon)}
      <% else %>
        <.icon name="hero-magnifying-glass" class="size-4 shrink-0 opacity-50" />
      <% end %>
      <input
        type="text"
        id={@id}
        name={@name}
        value={@value}
        placeholder={@placeholder}
        data-command-input
        autocomplete="off"
        class={[
          "placeholder:text-muted-foreground flex h-10 w-full rounded-md bg-transparent py-3 text-sm outline-hidden disabled:cursor-not-allowed disabled:opacity-50",
          @class
        ]}
        {@rest}
      />
    </div>
    """
  end

  @doc """
  Renders a command list container.

  Container for command items, groups, and empty states.

  ## Examples

      <.command_list>
        <.command_empty>No results.</.command_empty>
        <.command_group>
          <.command_item>Item 1</.command_item>
        </.command_group>
      </.command_list>
  """
  attr :id, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @spec command_list(map()) :: Rendered.t()
  def command_list(assigns) do
    ~H"""
    <div
      id={@id}
      role="listbox"
      data-command-list
      class={[
        "max-h-[300px] scroll-py-1 overflow-x-hidden overflow-y-auto",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a command empty state.

  Displayed when no command items match the search query.

  ## Examples

      <.command_empty>
        No results found.
      </.command_empty>
  """
  attr :id, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @spec command_empty(map()) :: Rendered.t()
  def command_empty(assigns) do
    ~H"""
    <div
      id={@id}
      data-command-empty
      class={[
        "py-6 text-center text-sm",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a command group container.

  Groups related command items together with an optional heading.

  ## Examples

      <.command_group heading="Suggestions">
        <.command_item>Calendar</.command_item>
        <.command_item>Calculator</.command_item>
      </.command_group>
  """
  attr :heading, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @spec command_group(map()) :: Rendered.t()
  def command_group(assigns) do
    ~H"""
    <div
      role="group"
      data-command-group
      class={[
        "text-foreground overflow-hidden p-1 [&_[data-command-group-heading]]:text-muted-foreground [&_[data-command-group-heading]]:px-2 [&_[data-command-group-heading]]:py-1.5 [&_[data-command-group-heading]]:text-xs [&_[data-command-group-heading]]:font-medium",
        @class
      ]}
      {@rest}
    >
      <%= if @heading do %>
        <div data-command-group-heading aria-hidden="true">
          {@heading}
        </div>
      <% end %>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a command separator.

  Visual divider between command groups or items.

  ## Examples

      <.command_separator />
  """
  attr :class, :string, default: nil
  attr :rest, :global

  @spec command_separator(map()) :: Rendered.t()
  def command_separator(assigns) do
    ~H"""
    <div
      role="separator"
      data-command-separator
      class={[
        "bg-border -mx-1 h-px",
        @class
      ]}
      {@rest}
    />
    """
  end

  @doc """
  Renders a command item.

  An individual selectable command option.

  ## Examples

      <.command_item phx-click="select_command" phx-value-id="new-file">
        <.icon name="hero-document-plus" />
        New File
        <.command_shortcut>⌘N</.command_shortcut>
      </.command_item>

      <.command_item disabled>
        Disabled Command
      </.command_item>
  """
  attr :disabled, :boolean, default: false
  attr :selected, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @spec command_item(map()) :: Rendered.t()
  def command_item(assigns) do
    ~H"""
    <div
      role="option"
      aria-disabled={@disabled}
      aria-selected={@selected}
      data-command-item
      data-disabled={@disabled}
      data-selected={@selected}
      class={[
        "data-[selected=true]:bg-accent data-[selected=true]:text-accent-foreground [&_svg:not([class*='text-'])]:text-muted-foreground relative flex cursor-default items-center gap-2 rounded-sm px-2 py-1.5 text-sm outline-hidden select-none data-[disabled=true]:pointer-events-none data-[disabled=true]:opacity-50 [&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a command shortcut display.

  Shows keyboard shortcut hints for command items.

  ## Examples

      <.command_item>
        Save File
        <.command_shortcut>⌘S</.command_shortcut>
      </.command_item>
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @spec command_shortcut(map()) :: Rendered.t()
  def command_shortcut(assigns) do
    ~H"""
    <span
      data-command-shortcut
      class={[
        "text-muted-foreground ml-auto text-xs tracking-widest",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end
end
