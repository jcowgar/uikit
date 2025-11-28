defmodule UiKit.Components.Ui.OverlaysDialogs do
  @moduledoc """
  Overlay & Dialog components for modal interfaces and dropdown menus.

  Components ported from shadcn/ui.
  """
  use Phoenix.Component

  import UiKit.Components.CoreComponents, only: [icon: 1]
  import UiKit.Components.Ui.FormInput, only: [button: 1, close_button: 1]

  alias Phoenix.LiveView.JS
  alias Phoenix.LiveView.Rendered

  @doc """
  Renders a dropdown menu wrapper component.

  The dropdown menu is a floating panel of menu items that appears when triggered.
  It supports keyboard navigation, nested menus, checkboxes, radio buttons, and more.

  This is the root wrapper component that should contain a dropdown_menu_trigger
  and dropdown_menu_content.

  ## Features

  - Click-to-open/close behavior
  - Click-outside-to-close
  - Keyboard navigation (Arrow keys, Enter, Escape)
  - Nested submenus
  - Checkable items
  - Radio groups
  - Keyboard shortcuts display
  - Semantic color tokens
  - Smooth animations

  ## Basic Structure

      <.dropdown_menu id="user-menu">
        <:trigger>
          <.button>Open Menu</.button>
        </:trigger>
        <:content>
          <.dropdown_menu_item>Profile</.dropdown_menu_item>
          <.dropdown_menu_item>Settings</.dropdown_menu_item>
          <.dropdown_menu_separator />
          <.dropdown_menu_item variant="destructive">Logout</.dropdown_menu_item>
        </:content>
      </.dropdown_menu>

  ## Examples

      # Basic menu
      <.dropdown_menu id="actions-menu">
        <:trigger>
          <.button variant="outline">
            Actions
            <.icon name="hero-chevron-down" />
          </.button>
        </:trigger>
        <:content>
          <.dropdown_menu_label>Actions</.dropdown_menu_label>
          <.dropdown_menu_item>Edit</.dropdown_menu_item>
          <.dropdown_menu_item>Duplicate</.dropdown_menu_item>
          <.dropdown_menu_separator />
          <.dropdown_menu_item variant="destructive">Delete</.dropdown_menu_item>
        </:content>
      </.dropdown_menu>

      # With icons and shortcuts
      <.dropdown_menu id="file-menu">
        <:trigger><.button>File</.button></:trigger>
        <:content>
          <.dropdown_menu_item>
            <.icon name="hero-document-plus" />
            New File
            <.dropdown_menu_shortcut>⌘N</.dropdown_menu_shortcut>
          </.dropdown_menu_item>
          <.dropdown_menu_item>
            <.icon name="hero-folder-open" />
            Open
            <.dropdown_menu_shortcut>⌘O</.dropdown_menu_shortcut>
          </.dropdown_menu_item>
        </:content>
      </.dropdown_menu>

      # With checkboxes
      <.dropdown_menu id="view-menu">
        <:trigger><.button>View</.button></:trigger>
        <:content>
          <.dropdown_menu_checkbox_item
            checked={@show_sidebar}
            phx-click="toggle-sidebar"
          >
            Show Sidebar
          </.dropdown_menu_checkbox_item>
          <.dropdown_menu_checkbox_item
            checked={@show_toolbar}
            phx-click="toggle-toolbar"
          >
            Show Toolbar
          </.dropdown_menu_checkbox_item>
        </:content>
      </.dropdown_menu>

  """
  attr(:id, :string, required: true)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:trigger, required: true, doc: "Trigger button/element")
  slot(:content, required: true, doc: "Menu content")

  @spec dropdown_menu(map()) :: Rendered.t()
  def dropdown_menu(assigns) do
    # Store the parent ID in the process dictionary so dropdown_menu_content can access it
    Process.put(:dropdown_menu_parent_id, assigns.id)

    ~H"""
    <div
      id={@id}
      data-slot="dropdown-menu"
      class={["relative inline-block", @class]}
      phx-click-away={hide_dropdown(@id)}
      {@rest}
    >
      <div
        id={"#{@id}-trigger"}
        data-slot="dropdown-menu-trigger"
        phx-click={toggle_dropdown(@id)}
        class="cursor-pointer"
      >
        {render_slot(@trigger)}
      </div>

      {render_slot(@content)}
    </div>
    """
  end

  @doc """
  Renders dropdown menu content panel.

  This component wraps the menu items and provides the floating panel styling.
  It should be used within the :content slot of dropdown_menu.

  ## Attributes

  - `align` - Horizontal alignment: "start", "center", "end" (default: "start")
  - `side` - Which side to place menu: "top", "bottom", "left", "right" (default: "bottom")
  - `side_offset` - Distance from trigger in pixels (default: 4)

  ## Examples

      <.dropdown_menu id="menu">
        <:trigger><.button>Menu</.button></:trigger>
        <:content>
          <.dropdown_menu_content>
            <.dropdown_menu_item>Item 1</.dropdown_menu_item>
            <.dropdown_menu_item>Item 2</.dropdown_menu_item>
          </.dropdown_menu_content>
        </:content>
      </.dropdown_menu>

      # Right-aligned menu
      <.dropdown_menu_content align="end">
        ...
      </.dropdown_menu_content>

  """
  attr(:parent_id, :string, default: nil, doc: "Parent dropdown menu ID (passed automatically)")
  attr(:align, :string, default: "start", values: ~w(start center end))
  attr(:side, :string, default: "bottom", values: ~w(top bottom left right))
  attr(:side_offset, :integer, default: 4)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec dropdown_menu_content(map()) :: Rendered.t()
  def dropdown_menu_content(assigns) do
    # Get parent menu ID from the process dictionary or generate a fallback
    parent_id = Process.get(:dropdown_menu_parent_id) || "dropdown-#{:erlang.phash2(make_ref())}"
    assigns = assign(assigns, :content_id, "#{parent_id}-content")

    ~H"""
    <div
      id={@content_id}
      data-slot="dropdown-menu-content"
      data-align={@align}
      data-side={@side}
      class={
        [
          # Base styles (overflow-visible to allow nested submenus to extend beyond)
          # Using fixed positioning to escape overflow containers in tables
          "fixed z-50 min-w-[8rem] overflow-visible rounded-md border border-border",
          "bg-popover text-popover-foreground p-1 shadow-md",
          # Custom classes
          @class
        ]
      }
      style="display: none;"
      phx-hook="PositionDropdown"
      phx-mounted={JS.add_class("dropdown-mounted")}
      data-align={@align}
      data-side={@side}
      data-offset={@side_offset}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a dropdown menu item.

  Individual clickable menu item. Supports icons, keyboard shortcuts, and variants.

  ## Variants

  - `default` - Standard menu item
  - `destructive` - For destructive/dangerous actions (delete, logout, etc.)

  ## Examples

      <.dropdown_menu_item>Edit</.dropdown_menu_item>

      <.dropdown_menu_item variant="destructive">
        Delete
      </.dropdown_menu_item>

      # With icon
      <.dropdown_menu_item>
        <.icon name="hero-pencil" />
        Edit Profile
      </.dropdown_menu_item>

      # With icon and shortcut
      <.dropdown_menu_item>
        <.icon name="hero-document-duplicate" />
        Copy
        <.dropdown_menu_shortcut>⌘C</.dropdown_menu_shortcut>
      </.dropdown_menu_item>

      # With click handler
      <.dropdown_menu_item phx-click="edit-user">
        Edit
      </.dropdown_menu_item>

      # Disabled item
      <.dropdown_menu_item disabled>
        Coming Soon
      </.dropdown_menu_item>

      # With inset (for alignment with checkboxes)
      <.dropdown_menu_item inset>
        Profile
      </.dropdown_menu_item>

  """
  attr(:variant, :string, default: "default", values: ~w(default destructive))
  attr(:inset, :boolean, default: false)
  attr(:disabled, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(phx-click phx-value-id phx-value-role phx-value-member-id))
  slot(:inner_block, required: true)

  @spec dropdown_menu_item(map()) :: Rendered.t()
  def dropdown_menu_item(assigns) do
    ~H"""
    <div
      data-slot="dropdown-menu-item"
      data-variant={@variant}
      data-inset={@inset}
      data-disabled={@disabled}
      data-dropdown-close-on-click
      class={
        [
          # Base styles
          "relative flex cursor-default select-none items-center gap-2 rounded-sm px-2 py-1.5 text-sm outline-hidden",
          # Focus/hover styles
          "focus:bg-accent focus:text-accent-foreground",
          "hover:bg-accent hover:text-accent-foreground",
          # Icon styles
          "[&_svg:not([class*='text-'])]:text-muted-foreground",
          "[&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4",
          # Variant styles
          dropdown_menu_item_variant(@variant),
          # Inset (for alignment with checkbox items)
          @inset && "pl-8",
          # Disabled state
          @disabled && "pointer-events-none opacity-50",
          # Custom classes
          @class
        ]
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  defp dropdown_menu_item_variant("default"), do: ""

  defp dropdown_menu_item_variant("destructive"),
    do:
      "text-destructive focus:bg-destructive/10 focus:text-destructive hover:bg-destructive/10 hover:text-destructive dark:focus:bg-destructive/20 dark:hover:bg-destructive/20 [&_svg]:!text-destructive"

  @doc """
  Renders a dropdown menu checkbox item.

  Menu item with a checkbox indicator that shows checked/unchecked state.

  ## Examples

      # Simple checkbox item
      <.dropdown_menu_checkbox_item checked={@show_sidebar}>
        Show Sidebar
      </.dropdown_menu_checkbox_item>

      # With click handler
      <.dropdown_menu_checkbox_item
        checked={@notifications_enabled}
        phx-click="toggle-notifications"
      >
        Enable Notifications
      </.dropdown_menu_checkbox_item>

      # Disabled checkbox
      <.dropdown_menu_checkbox_item checked={false} disabled>
        Feature Coming Soon
      </.dropdown_menu_checkbox_item>

  """
  attr(:checked, :boolean, default: false)
  attr(:disabled, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(phx-click phx-value-id))
  slot(:inner_block, required: true)

  @spec dropdown_menu_checkbox_item(map()) :: Rendered.t()
  def dropdown_menu_checkbox_item(assigns) do
    ~H"""
    <div
      data-slot="dropdown-menu-checkbox-item"
      data-disabled={@disabled}
      class={
        [
          # Base styles
          "relative flex cursor-default select-none items-center gap-2 rounded-sm py-1.5 pr-2 pl-8 text-sm outline-hidden",
          # Focus/hover styles
          "focus:bg-accent focus:text-accent-foreground",
          "hover:bg-accent hover:text-accent-foreground",
          # Icon styles
          "[&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4",
          # Disabled state
          @disabled && "pointer-events-none opacity-50",
          # Custom classes
          @class
        ]
      }
      {@rest}
    >
      <span class="pointer-events-none absolute left-2 flex size-3.5 items-center justify-center">
        <.icon :if={@checked} name="hero-check" class="size-4" />
      </span>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a dropdown menu radio group container.

  Container for radio items where only one item can be selected at a time.

  ## Examples

      <.dropdown_menu_radio_group>
        <.dropdown_menu_radio_item checked={@view == "grid"} phx-click="set-view" phx-value-view="grid">
          Grid View
        </.dropdown_menu_radio_item>
        <.dropdown_menu_radio_item checked={@view == "list"} phx-click="set-view" phx-value-view="list">
          List View
        </.dropdown_menu_radio_item>
        <.dropdown_menu_radio_item checked={@view == "kanban"} phx-click="set-view" phx-value-view="kanban">
          Kanban View
        </.dropdown_menu_radio_item>
      </.dropdown_menu_radio_group>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec dropdown_menu_radio_group(map()) :: Rendered.t()
  def dropdown_menu_radio_group(assigns) do
    ~H"""
    <div data-slot="dropdown-menu-radio-group" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a dropdown menu radio item.

  Menu item with a radio indicator that shows selected state.

  ## Examples

      # Simple radio item
      <.dropdown_menu_radio_item checked={@theme == "light"}>
        Light
      </.dropdown_menu_radio_item>

      # With click handler
      <.dropdown_menu_radio_item
        checked={@sort_order == "asc"}
        phx-click="set-sort"
        phx-value-order="asc"
      >
        Ascending
      </.dropdown_menu_radio_item>

  """
  attr(:checked, :boolean, default: false)
  attr(:disabled, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(phx-click phx-value-id phx-value-view phx-value-order))
  slot(:inner_block, required: true)

  @spec dropdown_menu_radio_item(map()) :: Rendered.t()
  def dropdown_menu_radio_item(assigns) do
    ~H"""
    <div
      data-slot="dropdown-menu-radio-item"
      data-disabled={@disabled}
      class={
        [
          # Base styles
          "relative flex cursor-default select-none items-center gap-2 rounded-sm py-1.5 pr-2 pl-8 text-sm outline-hidden",
          # Focus/hover styles
          "focus:bg-accent focus:text-accent-foreground",
          "hover:bg-accent hover:text-accent-foreground",
          # Icon styles
          "[&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4",
          # Disabled state
          @disabled && "pointer-events-none opacity-50",
          # Custom classes
          @class
        ]
      }
      {@rest}
    >
      <span class="pointer-events-none absolute left-2 flex size-3.5 items-center justify-center">
        <%= if @checked do %>
          <span class="size-2 rounded-full bg-current"></span>
        <% end %>
      </span>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a dropdown menu label.

  Non-interactive label for grouping menu items.

  ## Examples

      <.dropdown_menu_label>My Account</.dropdown_menu_label>
      <.dropdown_menu_item>Profile</.dropdown_menu_item>
      <.dropdown_menu_item>Settings</.dropdown_menu_item>

      # With inset (for alignment with checkbox items)
      <.dropdown_menu_label inset>Actions</.dropdown_menu_label>

  """
  attr(:inset, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec dropdown_menu_label(map()) :: Rendered.t()
  def dropdown_menu_label(assigns) do
    ~H"""
    <div
      data-slot="dropdown-menu-label"
      data-inset={@inset}
      class={[
        "px-2 py-1.5 text-sm font-medium",
        @inset && "pl-8",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a dropdown menu separator.

  Visual divider between menu sections.

  ## Examples

      <.dropdown_menu_item>Edit</.dropdown_menu_item>
      <.dropdown_menu_item>Duplicate</.dropdown_menu_item>
      <.dropdown_menu_separator />
      <.dropdown_menu_item variant="destructive">Delete</.dropdown_menu_item>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  @spec dropdown_menu_separator(map()) :: Rendered.t()
  def dropdown_menu_separator(assigns) do
    ~H"""
    <div
      data-slot="dropdown-menu-separator"
      class={["-mx-1 my-1 h-px bg-border", @class]}
      {@rest}
    />
    """
  end

  @doc """
  Renders a keyboard shortcut indicator.

  Displays keyboard shortcuts aligned to the right of menu items.

  ## Examples

      <.dropdown_menu_item>
        Save
        <.dropdown_menu_shortcut>⌘S</.dropdown_menu_shortcut>
      </.dropdown_menu_item>

      <.dropdown_menu_item>
        Copy
        <.dropdown_menu_shortcut>⌘C</.dropdown_menu_shortcut>
      </.dropdown_menu_item>

      <.dropdown_menu_item>
        Delete
        <.dropdown_menu_shortcut>⌫</.dropdown_menu_shortcut>
      </.dropdown_menu_item>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec dropdown_menu_shortcut(map()) :: Rendered.t()
  def dropdown_menu_shortcut(assigns) do
    ~H"""
    <span
      data-slot="dropdown-menu-shortcut"
      class={["ml-auto text-xs tracking-widest text-muted-foreground", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end

  @doc """
  Renders a dropdown menu group.

  Logical grouping for menu items (doesn't add visual styling).

  ## Examples

      <.dropdown_menu_group>
        <.dropdown_menu_item>Profile</.dropdown_menu_item>
        <.dropdown_menu_item>Billing</.dropdown_menu_item>
        <.dropdown_menu_item>Settings</.dropdown_menu_item>
      </.dropdown_menu_group>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec dropdown_menu_group(map()) :: Rendered.t()
  def dropdown_menu_group(assigns) do
    ~H"""
    <div data-slot="dropdown-menu-group" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a dropdown submenu container.

  Wrapper for nested submenu with trigger and content.

  ## Examples

      <.dropdown_menu_sub id="share-submenu">
        <:trigger>
          <.dropdown_menu_sub_trigger>
            <.icon name="hero-share" />
            Share
          </.dropdown_menu_sub_trigger>
        </:trigger>
        <:content>
          <.dropdown_menu_sub_content>
            <.dropdown_menu_item>
              <.icon name="hero-envelope" />
              Email
            </.dropdown_menu_item>
            <.dropdown_menu_item>
              <.icon name="hero-link" />
              Copy Link
            </.dropdown_menu_item>
          </.dropdown_menu_sub_content>
        </:content>
      </.dropdown_menu_sub>

  """
  attr(:id, :string, required: true)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:trigger, required: true)
  slot(:content, required: true)

  @spec dropdown_menu_sub(map()) :: Rendered.t()
  def dropdown_menu_sub(assigns) do
    ~H"""
    <div
      id={@id}
      data-slot="dropdown-menu-sub"
      class={["relative", @class]}
      {@rest}
    >
      <div
        id={"#{@id}-trigger"}
        phx-click={toggle_dropdown_sub(@id)}
      >
        {render_slot(@trigger)}
      </div>

      <div id={"#{@id}-content"} class="hidden" data-state="closed">
        {render_slot(@content)}
      </div>
    </div>
    """
  end

  @doc """
  Renders a dropdown submenu trigger.

  Clickable item that opens a nested submenu.

  ## Examples

      <.dropdown_menu_sub_trigger>
        Share
      </.dropdown_menu_sub_trigger>

      # With icon
      <.dropdown_menu_sub_trigger>
        <.icon name="hero-share" />
        Share
      </.dropdown_menu_sub_trigger>

      # With inset
      <.dropdown_menu_sub_trigger inset>
        More Options
      </.dropdown_menu_sub_trigger>

  """
  attr(:inset, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec dropdown_menu_sub_trigger(map()) :: Rendered.t()
  def dropdown_menu_sub_trigger(assigns) do
    ~H"""
    <div
      data-slot="dropdown-menu-sub-trigger"
      data-inset={@inset}
      class={
        [
          # Base styles
          "flex cursor-default select-none items-center gap-2 rounded-sm px-2 py-1.5 text-sm outline-hidden",
          # Focus/hover styles
          "focus:bg-accent focus:text-accent-foreground",
          "hover:bg-accent hover:text-accent-foreground",
          "data-[state=open]:bg-accent data-[state=open]:text-accent-foreground",
          # Icon styles
          "[&_svg:not([class*='text-'])]:text-muted-foreground",
          "[&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4",
          # Inset
          @inset && "pl-8",
          # Custom classes
          @class
        ]
      }
      {@rest}
    >
      {render_slot(@inner_block)}
      <.icon name="hero-chevron-right" class="ml-auto size-4" />
    </div>
    """
  end

  @doc """
  Renders a dropdown submenu content panel.

  Container for submenu items.

  ## Examples

      <.dropdown_menu_sub_content>
        <.dropdown_menu_item>Submenu Item 1</.dropdown_menu_item>
        <.dropdown_menu_item>Submenu Item 2</.dropdown_menu_item>
      </.dropdown_menu_sub_content>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec dropdown_menu_sub_content(map()) :: Rendered.t()
  def dropdown_menu_sub_content(assigns) do
    ~H"""
    <div
      data-slot="dropdown-menu-sub-content"
      class={
        [
          # Base styles (z-[60] to appear above parent menu's z-50)
          "absolute left-full top-0 z-[60] min-w-[8rem] overflow-hidden rounded-md border border-border",
          "bg-popover text-popover-foreground p-1 shadow-lg ml-1",
          # Animation classes
          "data-[state=open]:animate-in data-[state=closed]:animate-out",
          "data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0",
          "data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95",
          "data-[side=bottom]:slide-in-from-top-2",
          "data-[side=left]:slide-in-from-right-2",
          "data-[side=right]:slide-in-from-left-2",
          "data-[side=top]:slide-in-from-bottom-2",
          # Custom classes
          @class
        ]
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  # JS commands for dropdown menu interactions
  defp toggle_dropdown(id) do
    [
      to: "##{id}-content",
      in: {
        "transition ease-out duration-150",
        "opacity-0",
        "opacity-100"
      },
      out: {
        "transition ease-in duration-100",
        "opacity-100",
        "opacity-0"
      }
    ]
    |> JS.toggle()
    |> JS.set_attribute({"data-state", "open"}, to: "##{id}-content")
  end

  defp hide_dropdown(id) do
    [
      to: "##{id}-content",
      transition: {
        "transition ease-in duration-100",
        "opacity-100",
        "opacity-0"
      }
    ]
    |> JS.hide()
    |> JS.set_attribute({"data-state", "closed"}, to: "##{id}-content")
    # Close all submenus when parent menu closes (match the submenu wrapper divs)
    |> JS.hide(to: "##{id}-content [data-slot='dropdown-menu-sub'] > div[id$='-content']")
    |> JS.set_attribute({"data-state", "closed"},
      to: "##{id}-content [data-slot='dropdown-menu-sub'] > div[id$='-content']"
    )
  end

  defp toggle_dropdown_sub(id) do
    # Simple approach: hide ALL submenus, then toggle the clicked one
    # This ensures only one submenu is open at a time
    [to: "[data-slot='dropdown-menu-sub'] > div[id$='-content']"]
    |> JS.hide()
    |> JS.set_attribute({"data-state", "closed"},
      to: "[data-slot='dropdown-menu-sub'] > div[id$='-content']"
    )
    # Then toggle this specific submenu wrapper
    |> JS.toggle(
      to: "##{id}-content",
      in: {
        "transition ease-out duration-150",
        "opacity-0",
        "opacity-100"
      },
      out: {
        "transition ease-in duration-100",
        "opacity-100",
        "opacity-0"
      }
    )
    |> JS.toggle_attribute({"data-state", "open", "closed"}, to: "##{id}-content")
    |> JS.toggle_attribute({"data-state", "open", "closed"}, to: "##{id}-trigger")
  end

  # Context Menu Component
  # ======================

  @doc """
  Renders a context menu wrapper component.

  The context menu displays a menu triggered by right-click (contextmenu event).
  It supports the same features as dropdown menus including checkboxes, radio buttons,
  nested submenus, and keyboard shortcuts.

  ## Features

  - Right-click to open
  - Click-outside-to-close
  - Keyboard navigation (Arrow keys, Enter, Escape)
  - Nested submenus
  - Checkable items
  - Radio groups
  - Keyboard shortcuts display
  - Semantic color tokens
  - Smooth animations

  ## Basic Structure

      <.context_menu id="file-context">
        <:trigger>
          <div class="border rounded-md p-4">
            Right-click me
          </div>
        </:trigger>
        <:content>
          <.context_menu_item>Cut</.context_menu_item>
          <.context_menu_item>Copy</.context_menu_item>
          <.context_menu_item>Paste</.context_menu_item>
          <.context_menu_separator />
          <.context_menu_item variant="destructive">Delete</.context_menu_item>
        </:content>
      </.context_menu>

  ## Examples

      # With icons and shortcuts
      <.context_menu id="edit-context">
        <:trigger>
          <div class="border rounded p-4">
            Right-click to edit
          </div>
        </:trigger>
        <:content>
          <.context_menu_item>
            <.icon name="hero-scissors" />
            Cut
            <.context_menu_shortcut>⌘X</.context_menu_shortcut>
          </.context_menu_item>
          <.context_menu_item>
            <.icon name="hero-document-duplicate" />
            Copy
            <.context_menu_shortcut>⌘C</.context_menu_shortcut>
          </.context_menu_item>
        </:content>
      </.context_menu>

      # With checkboxes
      <.context_menu id="view-context">
        <:trigger>
          <div class="border rounded p-4">
            Right-click for options
          </div>
        </:trigger>
        <:content>
          <.context_menu_label>View Options</.context_menu_label>
          <.context_menu_separator />
          <.context_menu_checkbox_item checked={@show_sidebar} phx-click="toggle-sidebar">
            Show Sidebar
          </.context_menu_checkbox_item>
          <.context_menu_checkbox_item checked={@show_toolbar} phx-click="toggle-toolbar">
            Show Toolbar
          </.context_menu_checkbox_item>
        </:content>
      </.context_menu>

  """
  attr(:id, :string, required: true)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:trigger, required: true, doc: "Trigger area (right-click target)")
  slot(:content, required: true, doc: "Menu content")

  @spec context_menu(map()) :: Rendered.t()
  def context_menu(assigns) do
    ~H"""
    <div
      id={@id}
      data-slot="context-menu"
      class={["relative contents", @class]}
      phx-click-away={hide_context_menu(@id)}
      {@rest}
    >
      <div
        id={"#{@id}-trigger"}
        data-slot="context-menu-trigger"
        phx-hook="ContextMenu"
        data-menu-id={"#{@id}-content"}
        class="contents"
      >
        {render_slot(@trigger)}
      </div>

      <div
        id={"#{@id}-content"}
        data-slot="context-menu-content"
        class={[
          "fixed z-50 min-w-[8rem] overflow-hidden rounded-md border border-border",
          "bg-popover text-popover-foreground p-1 shadow-md",
          "data-[state=open]:animate-in data-[state=closed]:animate-out",
          "data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0",
          "data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95"
        ]}
        style="display: none;"
        data-state="closed"
      >
        {render_slot(@content)}
      </div>
    </div>
    """
  end

  @doc """
  Renders a context menu item.

  Individual clickable menu item. Supports icons, keyboard shortcuts, and variants.

  ## Variants

  - `default` - Standard menu item
  - `destructive` - For destructive/dangerous actions (delete, etc.)

  ## Examples

      <.context_menu_item>Edit</.context_menu_item>

      <.context_menu_item variant="destructive">
        Delete
      </.context_menu_item>

      # With icon
      <.context_menu_item>
        <.icon name="hero-pencil" />
        Edit
      </.context_menu_item>

      # With icon and shortcut
      <.context_menu_item>
        <.icon name="hero-document-duplicate" />
        Copy
        <.context_menu_shortcut>⌘C</.context_menu_shortcut>
      </.context_menu_item>

      # With click handler
      <.context_menu_item phx-click="edit-item">
        Edit
      </.context_menu_item>

      # Disabled item
      <.context_menu_item disabled>
        Coming Soon
      </.context_menu_item>

      # With inset (for alignment with checkboxes)
      <.context_menu_item inset>
        Profile
      </.context_menu_item>

  """
  attr(:variant, :string, default: "default", values: ~w(default destructive))
  attr(:inset, :boolean, default: false)
  attr(:disabled, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(phx-click phx-value-id phx-value-action))
  slot(:inner_block, required: true)

  @spec context_menu_item(map()) :: Rendered.t()
  def context_menu_item(assigns) do
    ~H"""
    <div
      data-slot="context-menu-item"
      data-variant={@variant}
      data-inset={@inset}
      data-disabled={@disabled}
      data-context-close-on-click
      class={[
        # Base styles
        "relative flex cursor-default select-none items-center gap-2 rounded-sm px-2 py-1.5 text-sm outline-hidden",
        # Focus/hover styles
        "focus:bg-accent focus:text-accent-foreground",
        "hover:bg-accent hover:text-accent-foreground",
        # Icon styles
        "[&_svg:not([class*='text-'])]:text-muted-foreground",
        "[&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4",
        # Variant styles
        context_menu_item_variant(@variant),
        # Inset (for alignment with checkbox items)
        @inset && "pl-8",
        # Disabled state
        @disabled && "pointer-events-none opacity-50",
        # Custom classes
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  defp context_menu_item_variant("default"), do: ""

  defp context_menu_item_variant("destructive"),
    do:
      "text-destructive focus:bg-destructive/10 focus:text-destructive hover:bg-destructive/10 hover:text-destructive dark:focus:bg-destructive/20 dark:hover:bg-destructive/20 [&_svg]:!text-destructive"

  @doc """
  Renders a context menu checkbox item.

  Menu item with a checkbox indicator that shows checked/unchecked state.

  ## Examples

      # Simple checkbox item
      <.context_menu_checkbox_item checked={@show_sidebar}>
        Show Sidebar
      </.context_menu_checkbox_item>

      # With click handler
      <.context_menu_checkbox_item
        checked={@notifications_enabled}
        phx-click="toggle-notifications"
      >
        Enable Notifications
      </.context_menu_checkbox_item>

      # Disabled checkbox
      <.context_menu_checkbox_item checked={false} disabled>
        Feature Coming Soon
      </.context_menu_checkbox_item>

  """
  attr(:checked, :boolean, default: false)
  attr(:disabled, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(phx-click phx-value-id))
  slot(:inner_block, required: true)

  @spec context_menu_checkbox_item(map()) :: Rendered.t()
  def context_menu_checkbox_item(assigns) do
    ~H"""
    <div
      data-slot="context-menu-checkbox-item"
      data-disabled={@disabled}
      class={[
        # Base styles
        "relative flex cursor-default select-none items-center gap-2 rounded-sm py-1.5 pr-2 pl-8 text-sm outline-hidden",
        # Focus/hover styles
        "focus:bg-accent focus:text-accent-foreground",
        "hover:bg-accent hover:text-accent-foreground",
        # Icon styles
        "[&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4",
        # Disabled state
        @disabled && "pointer-events-none opacity-50",
        # Custom classes
        @class
      ]}
      {@rest}
    >
      <span class="pointer-events-none absolute left-2 flex size-3.5 items-center justify-center">
        <.icon :if={@checked} name="hero-check" class="size-4" />
      </span>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a context menu radio group container.

  Container for radio items where only one item can be selected at a time.

  ## Examples

      <.context_menu_radio_group>
        <.context_menu_radio_item checked={@person == "pedro"} phx-click="set-person" phx-value-person="pedro">
          Pedro Duarte
        </.context_menu_radio_item>
        <.context_menu_radio_item checked={@person == "colm"} phx-click="set-person" phx-value-person="colm">
          Colm Tuite
        </.context_menu_radio_item>
      </.context_menu_radio_group>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec context_menu_radio_group(map()) :: Rendered.t()
  def context_menu_radio_group(assigns) do
    ~H"""
    <div data-slot="context-menu-radio-group" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a context menu radio item.

  Menu item with a radio indicator that shows selected state.

  ## Examples

      # Simple radio item
      <.context_menu_radio_item checked={@theme == "light"}>
        Light
      </.context_menu_radio_item>

      # With click handler
      <.context_menu_radio_item
        checked={@person == "pedro"}
        phx-click="set-person"
        phx-value-person="pedro"
      >
        Pedro Duarte
      </.context_menu_radio_item>

  """
  attr(:checked, :boolean, default: false)
  attr(:disabled, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(phx-click phx-value-id phx-value-person))
  slot(:inner_block, required: true)

  @spec context_menu_radio_item(map()) :: Rendered.t()
  def context_menu_radio_item(assigns) do
    ~H"""
    <div
      data-slot="context-menu-radio-item"
      data-disabled={@disabled}
      class={[
        # Base styles
        "relative flex cursor-default select-none items-center gap-2 rounded-sm py-1.5 pr-2 pl-8 text-sm outline-hidden",
        # Focus/hover styles
        "focus:bg-accent focus:text-accent-foreground",
        "hover:bg-accent hover:text-accent-foreground",
        # Icon styles
        "[&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4",
        # Disabled state
        @disabled && "pointer-events-none opacity-50",
        # Custom classes
        @class
      ]}
      {@rest}
    >
      <span class="pointer-events-none absolute left-2 flex size-3.5 items-center justify-center">
        <%= if @checked do %>
          <span class="size-2 rounded-full bg-current"></span>
        <% end %>
      </span>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a context menu label.

  Non-interactive label for grouping menu items.

  ## Examples

      <.context_menu_label>People</.context_menu_label>
      <.context_menu_item>Pedro</.context_menu_item>
      <.context_menu_item>Colm</.context_menu_item>

      # With inset (for alignment with checkbox items)
      <.context_menu_label inset>Actions</.context_menu_label>

  """
  attr(:inset, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec context_menu_label(map()) :: Rendered.t()
  def context_menu_label(assigns) do
    ~H"""
    <div
      data-slot="context-menu-label"
      data-inset={@inset}
      class={[
        "px-2 py-1.5 text-sm font-medium text-foreground",
        @inset && "pl-8",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a context menu separator.

  Visual divider between menu sections.

  ## Examples

      <.context_menu_item>Edit</.context_menu_item>
      <.context_menu_item>Duplicate</.context_menu_item>
      <.context_menu_separator />
      <.context_menu_item variant="destructive">Delete</.context_menu_item>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  @spec context_menu_separator(map()) :: Rendered.t()
  def context_menu_separator(assigns) do
    ~H"""
    <div
      data-slot="context-menu-separator"
      class={["-mx-1 my-1 h-px bg-border", @class]}
      {@rest}
    />
    """
  end

  @doc """
  Renders a keyboard shortcut indicator for context menu items.

  Displays keyboard shortcuts aligned to the right of menu items.

  ## Examples

      <.context_menu_item>
        Back
        <.context_menu_shortcut>⌘[</.context_menu_shortcut>
      </.context_menu_item>

      <.context_menu_item>
        Forward
        <.context_menu_shortcut>⌘]</.context_menu_shortcut>
      </.context_menu_item>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec context_menu_shortcut(map()) :: Rendered.t()
  def context_menu_shortcut(assigns) do
    ~H"""
    <span
      data-slot="context-menu-shortcut"
      class={["ml-auto text-xs tracking-widest text-muted-foreground", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end

  @doc """
  Renders a context menu group.

  Logical grouping for menu items (doesn't add visual styling).

  ## Examples

      <.context_menu_group>
        <.context_menu_item>Profile</.context_menu_item>
        <.context_menu_item>Billing</.context_menu_item>
        <.context_menu_item>Settings</.context_menu_item>
      </.context_menu_group>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec context_menu_group(map()) :: Rendered.t()
  def context_menu_group(assigns) do
    ~H"""
    <div data-slot="context-menu-group" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a context menu submenu container.

  Wrapper for nested submenu with trigger and content.

  ## Examples

      <.context_menu_sub id="more-tools">
        <:trigger>
          <.context_menu_sub_trigger>
            More Tools
          </.context_menu_sub_trigger>
        </:trigger>
        <:content>
          <.context_menu_sub_content>
            <.context_menu_item>
              Save Page As...
              <.context_menu_shortcut>⇧⌘S</.context_menu_shortcut>
            </.context_menu_item>
            <.context_menu_item>Developer Tools</.context_menu_item>
          </.context_menu_sub_content>
        </:content>
      </.context_menu_sub>

  """
  attr(:id, :string, required: true)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:trigger, required: true)
  slot(:content, required: true)

  @spec context_menu_sub(map()) :: Rendered.t()
  def context_menu_sub(assigns) do
    ~H"""
    <div
      id={@id}
      data-slot="context-menu-sub"
      class={["relative", @class]}
      {@rest}
    >
      <div
        id={"#{@id}-trigger"}
        phx-click={toggle_context_menu_sub(@id)}
      >
        {render_slot(@trigger)}
      </div>

      <div id={"#{@id}-content"} class="hidden" data-state="closed">
        {render_slot(@content)}
      </div>
    </div>
    """
  end

  @doc """
  Renders a context menu submenu trigger.

  Clickable item that opens a nested submenu.

  ## Examples

      <.context_menu_sub_trigger>
        More Tools
      </.context_menu_sub_trigger>

      # With icon
      <.context_menu_sub_trigger>
        <.icon name="hero-share" />
        Share
      </.context_menu_sub_trigger>

      # With inset
      <.context_menu_sub_trigger inset>
        More Options
      </.context_menu_sub_trigger>

  """
  attr(:inset, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec context_menu_sub_trigger(map()) :: Rendered.t()
  def context_menu_sub_trigger(assigns) do
    ~H"""
    <div
      data-slot="context-menu-sub-trigger"
      data-inset={@inset}
      class={[
        # Base styles
        "flex cursor-default select-none items-center gap-2 rounded-sm px-2 py-1.5 text-sm outline-hidden",
        # Focus/hover styles
        "focus:bg-accent focus:text-accent-foreground",
        "hover:bg-accent hover:text-accent-foreground",
        "data-[state=open]:bg-accent data-[state=open]:text-accent-foreground",
        # Icon styles
        "[&_svg:not([class*='text-'])]:text-muted-foreground",
        "[&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4",
        # Inset
        @inset && "pl-8",
        # Custom classes
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
      <.icon name="hero-chevron-right" class="ml-auto size-4" />
    </div>
    """
  end

  @doc """
  Renders context menu submenu content panel.

  Container for submenu items.

  ## Examples

      <.context_menu_sub_content>
        <.context_menu_item>Submenu Item 1</.context_menu_item>
        <.context_menu_item>Submenu Item 2</.context_menu_item>
      </.context_menu_sub_content>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec context_menu_sub_content(map()) :: Rendered.t()
  def context_menu_sub_content(assigns) do
    ~H"""
    <div
      data-slot="context-menu-sub-content"
      class={[
        # Base styles (z-[60] to appear above parent menu's z-50)
        "absolute left-full top-0 z-[60] min-w-[8rem] overflow-hidden rounded-md border border-border",
        "bg-popover text-popover-foreground p-1 shadow-lg ml-1",
        # Animation classes
        "data-[state=open]:animate-in data-[state=closed]:animate-out",
        "data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0",
        "data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95",
        "data-[side=bottom]:slide-in-from-top-2",
        "data-[side=left]:slide-in-from-right-2",
        "data-[side=right]:slide-in-from-left-2",
        "data-[side=top]:slide-in-from-bottom-2",
        # Custom classes
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  # JS commands for context menu interactions
  defp hide_context_menu(id) do
    [
      to: "##{id}-content",
      transition: {
        "transition ease-in duration-100",
        "opacity-100",
        "opacity-0"
      }
    ]
    |> JS.hide()
    |> JS.set_attribute({"data-state", "closed"}, to: "##{id}-content")
    # Close all submenus when parent menu closes
    |> JS.hide(to: "##{id}-content [data-slot='context-menu-sub'] > div[id$='-content']")
    |> JS.set_attribute({"data-state", "closed"},
      to: "##{id}-content [data-slot='context-menu-sub'] > div[id$='-content']"
    )
  end

  defp toggle_context_menu_sub(id) do
    # Simple approach: hide ALL submenus, then toggle the clicked one
    # This ensures only one submenu is open at a time
    [to: "[data-slot='context-menu-sub'] > div[id$='-content']"]
    |> JS.hide()
    |> JS.set_attribute({"data-state", "closed"},
      to: "[data-slot='context-menu-sub'] > div[id$='-content']"
    )
    # Then toggle this specific submenu wrapper
    |> JS.toggle(
      to: "##{id}-content",
      in: {
        "transition ease-out duration-150",
        "opacity-0",
        "opacity-100"
      },
      out: {
        "transition ease-in duration-100",
        "opacity-100",
        "opacity-0"
      }
    )
    |> JS.toggle_attribute({"data-state", "open", "closed"}, to: "##{id}-content")
    |> JS.toggle_attribute({"data-state", "open", "closed"}, to: "##{id}-trigger")
  end

  # Sheet Component
  # ================

  @doc """
  Renders a sheet (slide-out panel) component.

  The sheet is a modal overlay that slides in from the edge of the screen.
  It's useful for displaying supplementary content, forms, or navigation
  without taking the user away from the current page.

  ## Features

  - Slides in from any edge (top, right, bottom, left)
  - Modal overlay with backdrop
  - Click-outside-to-close
  - Keyboard navigation (Escape to close)
  - Focus trap within sheet
  - Smooth slide animations
  - Semantic color tokens

  ## Basic Structure

      <.sheet id="user-profile">
        <:trigger>
          <.button>Edit Profile</.button>
        </:trigger>
        <:content>
          <.sheet_header>
            <.sheet_title>Edit Profile</.sheet_title>
            <.sheet_description>
              Make changes to your profile here. Click save when you're done.
            </.sheet_description>
          </.sheet_header>

          <%!-- Your content here --%>

          <.sheet_footer>
            <.button variant="outline" phx-click={JS.exec("data-cancel", to: "#user-profile")}>
              Cancel
            </.button>
            <.button phx-click="save-profile">Save Changes</.button>
          </.sheet_footer>
        </:content>
      </.sheet>

  ## Examples

      # Right-side sheet (default)
      <.sheet id="filters">
        <:trigger><.button>Filters</.button></:trigger>
        <:content side="right">
          <.sheet_header>
            <.sheet_title>Filter Options</.sheet_title>
          </.sheet_header>
          <%!-- Filter content --%>
        </:content>
      </.sheet>

      # Bottom sheet (mobile-friendly)
      <.sheet id="actions">
        <:trigger><.button>Actions</.button></:trigger>
        <:content side="bottom">
          <.sheet_header>
            <.sheet_title>Actions</.sheet_title>
          </.sheet_header>
          <%!-- Action buttons --%>
        </:content>
      </.sheet>

      # Left navigation sheet
      <.sheet id="nav">
        <:trigger><.icon name="hero-bars-3" /></:trigger>
        <:content side="left">
          <%!-- Navigation menu --%>
        </:content>
      </.sheet>

      # Full-height form sheet
      <.sheet id="add-task">
        <:trigger><.button>Add Task</.button></:trigger>
        <:content>
          <.sheet_header>
            <.sheet_title>Add New Task</.sheet_title>
            <.sheet_description>
              Fill in the task details below.
            </.sheet_description>
          </.sheet_header>

          <.form for={@form} phx-submit="create-task">
            <.input field={@form[:name]} label="Task Name" />
            <.input field={@form[:description]} type="textarea" label="Description" />
          </.form>

          <.sheet_footer>
            <.button type="submit">Create Task</.button>
          </.sheet_footer>
        </:content>
      </.sheet>

  """
  attr(:id, :string, required: true)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:trigger, required: true, doc: "Trigger button/element")

  slot :content, required: true, doc: "Sheet content" do
    attr(:side, :string,
      values: ~w(top right bottom left),
      doc: "Which edge to slide in from (default: right)"
    )
  end

  @spec sheet(map()) :: Rendered.t()
  def sheet(assigns) do
    ~H"""
    <div
      id={@id}
      data-slot="sheet"
      class={["inline-block", @class]}
      phx-click-away={close_sheet(@id, get_sheet_side(@content))}
      {@rest}
    >
      <div
        id={"#{@id}-trigger"}
        data-slot="sheet-trigger"
        phx-click={open_sheet(@id, get_sheet_side(@content))}
        class="cursor-pointer"
      >
        {render_slot(@trigger)}
      </div>

      <%!-- Overlay --%>
      <div
        id={"#{@id}-overlay"}
        data-slot="sheet-overlay"
        class="hidden fixed inset-0 z-50 bg-black/50 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0"
        data-state="closed"
        phx-click={close_sheet(@id, get_sheet_side(@content))}
      >
      </div>

      <%!-- Content --%>
      <%= for content <- @content do %>
        <.sheet_content id={"#{@id}-content"} side={content[:side] || "right"}>
          {render_slot(content)}
        </.sheet_content>
      <% end %>
    </div>
    """
  end

  @doc """
  Renders the sheet content panel.

  This component is automatically used within the :content slot of the sheet component.
  You typically don't need to use it directly.

  ## Attributes

  - `side` - Which edge to slide from: "top", "right", "bottom", "left" (default: "right")

  """
  attr(:id, :string, required: true)
  attr(:side, :string, default: "right", values: ~w(top right bottom left))
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec sheet_content(map()) :: Rendered.t()
  def sheet_content(assigns) do
    ~H"""
    <div
      id={@id}
      data-slot="sheet-content"
      data-state="closed"
      data-side={@side}
      class={
        [
          # Base styles
          "hidden fixed z-50 flex flex-col gap-4 bg-background shadow-lg transition ease-in-out",
          # Animation states
          "data-[state=open]:animate-in data-[state=closed]:animate-out",
          "data-[state=closed]:duration-300 data-[state=open]:duration-500",
          # Side-specific positioning and animations
          sheet_side_classes(@side),
          # Custom classes
          @class
        ]
      }
      {@rest}
    >
      {render_slot(@inner_block)}

      <%!-- Close button --%>
      <.close_button
        phx-click={close_sheet(String.replace_suffix(@id, "-content", ""), @side)}
        class="absolute top-4 right-4"
      />
    </div>
    """
  end

  # Helper to extract side from content slot
  defp get_sheet_side(content) do
    case content do
      [%{side: side}] -> side
      _other -> "right"
    end
  end

  # Helper to determine side-specific classes
  defp sheet_side_classes("right") do
    [
      "inset-y-0 right-0 h-full w-3/4 border-l",
      "sm:max-w-sm",
      "data-[state=closed]:slide-out-to-right data-[state=open]:slide-in-from-right"
    ]
  end

  defp sheet_side_classes("left") do
    [
      "inset-y-0 left-0 h-full w-3/4 border-r",
      "sm:max-w-sm",
      "data-[state=closed]:slide-out-to-left data-[state=open]:slide-in-from-left"
    ]
  end

  defp sheet_side_classes("top") do
    [
      "inset-x-0 top-0 h-auto border-b",
      "data-[state=closed]:slide-out-to-top data-[state=open]:slide-in-from-top"
    ]
  end

  defp sheet_side_classes("bottom") do
    [
      "inset-x-0 bottom-0 h-auto border-t",
      "data-[state=closed]:slide-out-to-bottom data-[state=open]:slide-in-from-bottom"
    ]
  end

  @doc """
  Renders a sheet header section.

  Contains the title and description at the top of the sheet.

  ## Examples

      <.sheet_header>
        <.sheet_title>Edit Profile</.sheet_title>
        <.sheet_description>
          Make changes to your profile here.
        </.sheet_description>
      </.sheet_header>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec sheet_header(map()) :: Rendered.t()
  def sheet_header(assigns) do
    ~H"""
    <div
      data-slot="sheet-header"
      class={["flex flex-col gap-1.5 p-4", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a sheet footer section.

  Contains action buttons at the bottom of the sheet.

  ## Examples

      <.sheet_footer>
        <.button variant="outline" phx-click={JS.exec("data-cancel", to: "#my-sheet")}>
          Cancel
        </.button>
        <.button phx-click="save">Save</.button>
      </.sheet_footer>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec sheet_footer(map()) :: Rendered.t()
  def sheet_footer(assigns) do
    ~H"""
    <div
      data-slot="sheet-footer"
      class={["mt-auto flex flex-col gap-2 p-4", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a sheet title.

  The main heading for the sheet content.

  ## Examples

      <.sheet_title>Edit Profile</.sheet_title>

      <.sheet_title class="text-destructive">Delete Account</.sheet_title>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec sheet_title(map()) :: Rendered.t()
  def sheet_title(assigns) do
    ~H"""
    <h2
      data-slot="sheet-title"
      class={["text-foreground font-semibold text-lg", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </h2>
    """
  end

  @doc """
  Renders a sheet description.

  Explanatory text below the title.

  ## Examples

      <.sheet_description>
        Make changes to your profile here. Click save when you're done.
      </.sheet_description>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec sheet_description(map()) :: Rendered.t()
  def sheet_description(assigns) do
    ~H"""
    <p
      data-slot="sheet-description"
      class={["text-muted-foreground text-sm", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </p>
    """
  end

  # JS commands for sheet interactions
  defp open_sheet(id, side) do
    {_duration, from_position, to_position} = sheet_transition(side, :open)

    [
      to: "##{id}-overlay",
      transition: {
        "transition ease-out duration-300",
        "opacity-0",
        "opacity-100"
      }
    ]
    |> JS.show()
    |> JS.set_attribute({"data-state", "open"}, to: "##{id}-overlay")
    |> JS.show(
      to: "##{id}-content",
      transition: {
        "transition ease-in-out duration-500",
        from_position,
        to_position
      }
    )
    |> JS.set_attribute({"data-state", "open"}, to: "##{id}-content")
    |> JS.add_class("overflow-hidden", to: "body")
  end

  defp close_sheet(id, side) do
    {_duration, from_position, to_position} = sheet_transition(side, :close)

    [
      to: "##{id}-content",
      transition: {
        "transition ease-in-out duration-300",
        from_position,
        to_position
      }
    ]
    |> JS.hide()
    |> JS.set_attribute({"data-state", "closed"}, to: "##{id}-content")
    |> JS.hide(
      to: "##{id}-overlay",
      transition: {
        "transition ease-in duration-200",
        "opacity-100",
        "opacity-0"
      }
    )
    |> JS.set_attribute({"data-state", "closed"}, to: "##{id}-overlay")
    |> JS.remove_class("overflow-hidden", to: "body")
  end

  # Helper to get the correct transition based on side and action
  defp sheet_transition("right", :open) do
    {"duration-500", "opacity-0 translate-x-full", "opacity-100 translate-x-0"}
  end

  defp sheet_transition("right", :close) do
    {"duration-300", "opacity-100 translate-x-0", "opacity-0 translate-x-full"}
  end

  defp sheet_transition("left", :open) do
    {"duration-500", "opacity-0 -translate-x-full", "opacity-100 translate-x-0"}
  end

  defp sheet_transition("left", :close) do
    {"duration-300", "opacity-100 translate-x-0", "opacity-0 -translate-x-full"}
  end

  defp sheet_transition("top", :open) do
    {"duration-500", "opacity-0 -translate-y-full", "opacity-100 translate-y-0"}
  end

  defp sheet_transition("top", :close) do
    {"duration-300", "opacity-100 translate-y-0", "opacity-0 -translate-y-full"}
  end

  defp sheet_transition("bottom", :open) do
    {"duration-500", "opacity-0 translate-y-full", "opacity-100 translate-y-0"}
  end

  defp sheet_transition("bottom", :close) do
    {"duration-300", "opacity-100 translate-y-0", "opacity-0 translate-y-full"}
  end

  # Fallback to right
  defp sheet_transition(_side, :open) do
    {"duration-500", "opacity-0 translate-x-full", "opacity-100 translate-x-0"}
  end

  defp sheet_transition(_side, :close) do
    {"duration-300", "opacity-100 translate-x-0", "opacity-0 translate-x-full"}
  end

  # Alert Dialog Component
  # ======================

  @doc """
  Renders an alert dialog component.

  The alert dialog is a modal dialog that interrupts the user with important content
  and expects a response. It blocks interaction with the underlying content until
  the user makes a choice.

  ## Features

  - Modal overlay with backdrop
  - Click-outside-to-close
  - Keyboard navigation (Escape to close)
  - Focus trap within dialog
  - Smooth animations
  - Semantic color tokens
  - Clear action hierarchy (Cancel vs Confirm)

  ## Basic Structure

      <.alert_dialog id="delete-account">
        <:trigger>
          <.button variant="destructive">Delete Account</.button>
        </:trigger>
        <:content>
          <.alert_dialog_header>
            <.alert_dialog_title>Are you absolutely sure?</.alert_dialog_title>
            <.alert_dialog_description>
              This action cannot be undone. This will permanently delete your
              account and remove your data from our servers.
            </.alert_dialog_description>
          </.alert_dialog_header>
          <.alert_dialog_footer>
            <.alert_dialog_cancel>Cancel</.alert_dialog_cancel>
            <.alert_dialog_action phx-click="delete-account">
              Continue
            </.alert_dialog_action>
          </.alert_dialog_footer>
        </:content>
      </.alert_dialog>

  ## Examples

      # Destructive action confirmation
      <.alert_dialog id="delete-item">
        <:trigger>
          <.button variant="destructive">Delete Item</.button>
        </:trigger>
        <:content>
          <.alert_dialog_header>
            <.alert_dialog_title>Delete item?</.alert_dialog_title>
            <.alert_dialog_description>
              This will permanently delete the item. This action cannot be undone.
            </.alert_dialog_description>
          </.alert_dialog_header>
          <.alert_dialog_footer>
            <.alert_dialog_cancel>Cancel</.alert_dialog_cancel>
            <.alert_dialog_action phx-click="delete-item" phx-value-id={@item_id}>
              Delete
            </.alert_dialog_action>
          </.alert_dialog_footer>
        </:content>
      </.alert_dialog>

      # Confirmation dialog
      <.alert_dialog id="save-changes">
        <:trigger>
          <.button>Save Changes</.button>
        </:trigger>
        <:content>
          <.alert_dialog_header>
            <.alert_dialog_title>Save changes?</.alert_dialog_title>
            <.alert_dialog_description>
              You have unsaved changes. Would you like to save them before leaving?
            </.alert_dialog_description>
          </.alert_dialog_header>
          <.alert_dialog_footer>
            <.alert_dialog_cancel>Don't Save</.alert_dialog_cancel>
            <.alert_dialog_action phx-click="save-changes">
              Save
            </.alert_dialog_action>
          </.alert_dialog_footer>
        </:content>
      </.alert_dialog>

      # Important notice
      <.alert_dialog id="terms">
        <:trigger>
          <.button variant="outline">View Terms</.button>
        </:trigger>
        <:content>
          <.alert_dialog_header>
            <.alert_dialog_title>Terms of Service</.alert_dialog_title>
            <.alert_dialog_description>
              Please read and accept our terms of service before continuing.
            </.alert_dialog_description>
          </.alert_dialog_header>
          <div class="py-4">
            <%!-- Terms content here --%>
          </div>
          <.alert_dialog_footer>
            <.alert_dialog_cancel>Decline</.alert_dialog_cancel>
            <.alert_dialog_action phx-click="accept-terms">
              Accept
            </.alert_dialog_action>
          </.alert_dialog_footer>
        </:content>
      </.alert_dialog>

  """
  attr(:id, :string, required: true)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:trigger, required: true, doc: "Trigger button/element")
  slot(:content, required: true, doc: "Dialog content")

  @spec alert_dialog(map()) :: Rendered.t()
  def alert_dialog(assigns) do
    ~H"""
    <div
      id={@id}
      data-slot="alert-dialog"
      class={["inline-block", @class]}
      {@rest}
    >
      <div
        id={"#{@id}-trigger"}
        data-slot="alert-dialog-trigger"
        phx-click={open_alert_dialog(@id)}
        class="cursor-pointer"
      >
        {render_slot(@trigger)}
      </div>

      <%!-- Overlay --%>
      <div
        id={"#{@id}-overlay"}
        data-slot="alert-dialog-overlay"
        class="hidden fixed inset-0 z-50 bg-black/50 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0"
        data-state="closed"
        phx-click={close_alert_dialog(@id)}
      >
      </div>

      <%!-- Content --%>
      <div
        id={"#{@id}-content"}
        data-slot="alert-dialog-content"
        role="alertdialog"
        aria-modal="true"
        aria-labelledby={"#{@id}-title"}
        aria-describedby={"#{@id}-description"}
        data-state="closed"
        class="hidden fixed top-[50%] left-[50%] z-50 grid w-full max-w-[calc(100%-2rem)] -translate-x-1/2 -translate-y-1/2 gap-4 rounded-lg border border-border bg-background p-6 shadow-lg duration-200 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 sm:max-w-lg"
      >
        {render_slot(@content)}
      </div>

      <%!-- Hidden button for server-triggered close --%>
      <button
        id={"#{@id}-server-close"}
        type="button"
        phx-click={close_alert_dialog(@id)}
        class="hidden"
        aria-hidden="true"
      >
      </button>
    </div>
    """
  end

  @doc """
  Renders the alert dialog header section.

  Contains the title and description at the top of the dialog.

  ## Examples

      <.alert_dialog_header>
        <.alert_dialog_title>Are you sure?</.alert_dialog_title>
        <.alert_dialog_description>
          This action cannot be undone.
        </.alert_dialog_description>
      </.alert_dialog_header>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec alert_dialog_header(map()) :: Rendered.t()
  def alert_dialog_header(assigns) do
    ~H"""
    <div
      data-slot="alert-dialog-header"
      class={["flex flex-col gap-2 text-center sm:text-left", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders the alert dialog footer section.

  Contains action buttons at the bottom of the dialog.

  ## Examples

      <.alert_dialog_footer>
        <.alert_dialog_cancel>Cancel</.alert_dialog_cancel>
        <.alert_dialog_action phx-click="confirm">Confirm</.alert_dialog_action>
      </.alert_dialog_footer>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec alert_dialog_footer(map()) :: Rendered.t()
  def alert_dialog_footer(assigns) do
    ~H"""
    <div
      data-slot="alert-dialog-footer"
      class={["flex flex-col-reverse gap-2 pt-4 sm:flex-row sm:justify-end", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders the alert dialog title.

  The main heading for the dialog content.

  ## Examples

      <.alert_dialog_title>Are you absolutely sure?</.alert_dialog_title>

      <.alert_dialog_title class="text-destructive">Warning</.alert_dialog_title>

  """
  attr(:id, :string, default: nil, doc: "Optional ID for ARIA labeling")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec alert_dialog_title(map()) :: Rendered.t()
  def alert_dialog_title(assigns) do
    ~H"""
    <h2
      id={@id}
      data-slot="alert-dialog-title"
      class={["text-lg font-semibold text-foreground", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </h2>
    """
  end

  @doc """
  Renders the alert dialog description.

  Explanatory text below the title.

  ## Examples

      <.alert_dialog_description>
        This action cannot be undone. This will permanently delete your
        account and remove your data from our servers.
      </.alert_dialog_description>

  """
  attr(:id, :string, default: nil, doc: "Optional ID for ARIA description")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec alert_dialog_description(map()) :: Rendered.t()
  def alert_dialog_description(assigns) do
    ~H"""
    <p
      id={@id}
      data-slot="alert-dialog-description"
      class={["text-sm text-muted-foreground whitespace-normal break-words", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </p>
    """
  end

  @doc """
  Renders the alert dialog action button (primary/confirm button).

  This is the primary action button, typically used for confirming the action.
  It should be used with phx-click to trigger server-side logic.
  The dialog can be closed from the server using the close_alert_dialog/1 helper.

  ## Examples

      # In template - action button triggers Phoenix event
      <.alert_dialog_action phx-click="delete-item" phx-value-id={@item_id}>
        Delete
      </.alert_dialog_action>

      # In LiveView - close dialog after handling event
      def handle_event("delete-item", %{"id" => id}, socket) do
        # ... delete logic ...
        {:noreply,
         socket
         |> put_flash(:info, "Item deleted")
         |> push_event("close-alert-dialog", %{id: "delete-item-dialog"})}
      end

      # With custom styling
      <.alert_dialog_action class="bg-destructive text-destructive-foreground" phx-click="delete">
        Delete Forever
      </.alert_dialog_action>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(phx-click phx-value-id disabled))
  slot(:inner_block, required: true)

  @spec alert_dialog_action(map()) :: Rendered.t()
  def alert_dialog_action(assigns) do
    ~H"""
    <.button type="button" data-slot="alert-dialog-action" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </.button>
    """
  end

  @doc """
  Renders the alert dialog cancel button (secondary/dismiss button).

  This is the cancel/dismiss button, styled with the outline variant.
  It automatically closes the dialog when clicked.

  Note: This component needs to know the dialog ID to close it properly.
  Use the `dialog_id` attribute to specify which dialog to close.

  ## Examples

      <.alert_dialog_cancel dialog_id="my-dialog">Cancel</.alert_dialog_cancel>

      <.alert_dialog_cancel dialog_id="delete-confirmation">No, keep it</.alert_dialog_cancel>

      # With additional click handler
      <.alert_dialog_cancel dialog_id="my-dialog" phx-click="log-cancel">
        Cancel
      </.alert_dialog_cancel>

  """
  attr(:dialog_id, :string, required: true, doc: "The ID of the alert dialog to close")
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(phx-click disabled))
  slot(:inner_block, required: true)

  @spec alert_dialog_cancel(map()) :: Rendered.t()
  def alert_dialog_cancel(assigns) do
    ~H"""
    <.button
      variant="outline"
      type="button"
      data-slot="alert-dialog-cancel"
      phx-click={close_alert_dialog(@dialog_id)}
      class={@class}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.button>
    """
  end

  # Dialog Component
  # ================

  @doc """
  Renders a dialog (modal) component.

  A modal dialog that overlays the primary window or another dialog window,
  rendering the content underneath inert. Perfect for important messages,
  forms, or confirmations that require user attention.

  ## Features

  - Modal overlay with backdrop
  - Click-outside-to-close (closes immediately client-side)
  - X button to close (closes immediately client-side)
  - Server-controlled closing for action buttons (after server logic completes)
  - Keyboard navigation (Escape to close)
  - Focus trap within dialog
  - Auto-focus first input field (optional)
  - Smooth fade and zoom animations
  - Semantic color tokens
  - Optional close button (can be hidden)

  ## Closing Behavior

  The dialog can be closed in two ways:

  1. **Client-side close** (immediate): Click outside, click X button, or press Escape
  2. **Server-side close** (after action): Use `push_event("close-dialog", %{id: "dialog-id"})`

  ## Basic Structure

      <.dialog id="user-settings">
        <:trigger>
          <.button>Settings</.button>
        </:trigger>
        <:content>
          <.dialog_header>
            <.dialog_title>Account Settings</.dialog_title>
            <.dialog_description>
              Make changes to your account here. Click save when you're done.
            </.dialog_description>
          </.dialog_header>

          <%!-- Your content here --%>

          <.dialog_footer dialog_id="user-settings">
            <.button phx-click="save-settings">Save Changes</.button>
          </.dialog_footer>
        </:content>
      </.dialog>

      # In LiveView - close dialog after handling event
      def handle_event("save-settings", _params, socket) do
        # ... save logic ...
        {:noreply,
         socket
         |> put_flash(:info, "Settings saved")
         |> push_event("close-dialog", %{id: "user-settings"})}
      end

  ## Examples

      # Simple dialog with content
      <.dialog id="about">
        <:trigger><.button variant="outline">About</.button></:trigger>
        <:content>
          <.dialog_header>
            <.dialog_title>About</.dialog_title>
            <.dialog_description>
              Learn more about our application.
            </.dialog_description>
          </.dialog_header>
          <p>Content goes here...</p>
        </:content>
      </.dialog>

      # Form dialog with server-controlled close and auto-focus
      <.dialog id="edit-profile">
        <:trigger><.button>Edit Profile</.button></:trigger>
        <:content>
          <.dialog_header>
            <.dialog_title>Edit Profile</.dialog_title>
            <.dialog_description>
              Update your profile information below.
            </.dialog_description>
          </.dialog_header>

          <.form for={@form} phx-submit="save-profile">
            <.input field={@form[:name]} label="Name" autofocus />
            <.input field={@form[:email]} label="Email" type="email" />

            <.dialog_footer dialog_id="edit-profile">
              <.button type="submit">Save</.button>
            </.dialog_footer>
          </.form>
        </:content>
      </.dialog>

      # In LiveView - close after save
      def handle_event("save-profile", params, socket) do
        # ... save logic ...
        {:noreply,
         socket
         |> put_flash(:info, "Profile updated")
         |> push_event("close-dialog", %{id: "edit-profile"})}
      end

      # Dialog without close button (must close via server action)
      <.dialog id="loading">
        <:trigger><.button>Start Process</.button></:trigger>
        <:content show_close_button={false}>
          <.dialog_header>
            <.dialog_title>Processing...</.dialog_title>
            <.dialog_description>
              Please wait while we process your request.
            </.dialog_description>
          </.dialog_header>
        </:content>
      </.dialog>

  """
  attr(:id, :string, required: true)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:trigger, doc: "Optional trigger button/element")

  slot :content, required: true, doc: "Dialog content" do
    attr(:show_close_button, :boolean, doc: "Whether to show the X close button (default: true)")
  end

  @spec dialog(map()) :: Rendered.t()
  def dialog(assigns) do
    ~H"""
    <div
      id={@id}
      data-slot="dialog"
      class={["inline-block", @class]}
      {@rest}
    >
      <div
        :if={@trigger != []}
        id={"#{@id}-trigger"}
        data-slot="dialog-trigger"
        phx-click={open_dialog(@id)}
        class="cursor-pointer"
      >
        {render_slot(@trigger)}
      </div>

      <%!-- Overlay --%>
      <div
        id={"#{@id}-overlay"}
        data-slot="dialog-overlay"
        class="hidden fixed inset-0 z-50 bg-black/50 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0"
        data-state="closed"
        phx-click={close_dialog(@id)}
      >
      </div>

      <%!-- Content --%>
      <%= for content <- @content do %>
        <.dialog_content
          id={"#{@id}-content"}
          show_close_button={Map.get(content, :show_close_button, true)}
        >
          {render_slot(content)}
        </.dialog_content>
      <% end %>

      <%!-- Hidden button for server-triggered close --%>
      <button
        id={"#{@id}-server-close"}
        type="button"
        phx-click={close_dialog(@id)}
        class="hidden"
        aria-hidden="true"
      >
      </button>
    </div>
    """
  end

  @doc """
  Renders the dialog content panel.

  This component is automatically used within the :content slot of the dialog component.
  You typically don't need to use it directly unless you're building custom dialog layouts.

  ## Attributes

  - `show_close_button` - Whether to show the X close button (default: true)

  ## Auto-focus

  The dialog automatically handles input focus when opened:
  - If any input has the `autofocus` attribute, that input will be focused
  - If no input has `autofocus`, the first focusable input will be focused
  - If there are no inputs, nothing happens
  - Simply add `autofocus` to your input: `<.input field={@form[:name]} autofocus />`

  """
  attr(:id, :string, required: true)
  attr(:show_close_button, :boolean, default: true)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec dialog_content(map()) :: Rendered.t()
  def dialog_content(assigns) do
    ~H"""
    <div
      id={@id}
      data-slot="dialog-content"
      data-state="closed"
      phx-hook="DialogAutoFocus"
      class={
        [
          # Base styles
          "hidden fixed top-[50%] left-[50%] z-50 grid w-full max-w-[calc(100%-2rem)] -translate-x-1/2 -translate-y-1/2",
          "gap-4 rounded-lg border border-border bg-background p-6 shadow-lg duration-200",
          # Animation classes
          "data-[state=open]:animate-in data-[state=closed]:animate-out",
          "data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0",
          "data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95",
          # Max width
          "sm:max-w-lg",
          # Custom classes
          @class
        ]
      }
      {@rest}
    >
      {render_slot(@inner_block)}

      <%!-- Close button --%>
      <.close_button
        :if={@show_close_button}
        phx-click={close_dialog(String.replace_suffix(@id, "-content", ""))}
        class="absolute top-4 right-4"
      />
    </div>
    """
  end

  @doc """
  Renders a dialog header section.

  Contains the title and description at the top of the dialog.

  ## Examples

      <.dialog_header>
        <.dialog_title>Account Settings</.dialog_title>
        <.dialog_description>
          Make changes to your account here.
        </.dialog_description>
      </.dialog_header>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec dialog_header(map()) :: Rendered.t()
  def dialog_header(assigns) do
    ~H"""
    <div
      data-slot="dialog-header"
      class={["flex flex-col gap-2 text-center sm:text-left", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a dialog body section.

  Contains the main content of the dialog between the header and footer.
  Automatically adds py-4 padding for consistent spacing.

  ## Examples

      <.dialog_body>
        <p class="text-sm text-muted-foreground">
          This is the main content of the dialog.
        </p>
      </.dialog_body>

      <.dialog_body class="space-y-4">
        <.input label="Name" />
        <.input label="Email" />
      </.dialog_body>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec dialog_body(map()) :: Rendered.t()
  def dialog_body(assigns) do
    ~H"""
    <div
      data-slot="dialog-body"
      class={["py-4", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a dialog footer section.

  Contains action buttons at the bottom of the dialog.
  By default, automatically includes a "Cancel" button that dismisses the dialog.

  ## Attributes

  - `dialog_id` - Required. The ID of the dialog this footer belongs to (for auto-cancel)
  - `auto_cancel` - Whether to automatically add a Cancel button (default: true)
  - `cancel_label` - Label for the auto-cancel button (default: "Cancel")

  ## Examples

      # With automatic cancel button (default)
      <.dialog_footer dialog_id="my-dialog">
        <.button phx-click="save">Save</.button>
      </.dialog_footer>

      # Custom cancel button label
      <.dialog_footer dialog_id="my-dialog" cancel_label="Close">
        <.button phx-click="save">Save</.button>
      </.dialog_footer>

      # Without automatic cancel button
      <.dialog_footer dialog_id="my-dialog" auto_cancel={false}>
        <.button variant="outline" phx-click="custom-cancel">Custom Cancel</.button>
        <.button phx-click="save">Save</.button>
      </.dialog_footer>

  """
  attr(:dialog_id, :string, required: true, doc: "The ID of the dialog to close")
  attr(:auto_cancel, :boolean, default: true, doc: "Whether to automatically add a Cancel button")
  attr(:cancel_label, :string, default: "Cancel", doc: "Label for the auto-cancel button")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec dialog_footer(map()) :: Rendered.t()
  def dialog_footer(assigns) do
    ~H"""
    <div
      data-slot="dialog-footer"
      class={["pt-4 flex flex-col-reverse gap-2 sm:flex-row sm:justify-end", @class]}
      {@rest}
    >
      <.button
        :if={@auto_cancel}
        variant="outline"
        type="button"
        phx-click={JS.exec("phx-click", to: "##{@dialog_id}-server-close")}
      >
        {@cancel_label}
      </.button>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a dialog title.

  The main heading for the dialog content. This is automatically announced
  by screen readers when the dialog opens.

  ## Examples

      <.dialog_title>Edit Profile</.dialog_title>

      <.dialog_title class="text-destructive">Delete Account</.dialog_title>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec dialog_title(map()) :: Rendered.t()
  def dialog_title(assigns) do
    ~H"""
    <h2
      data-slot="dialog-title"
      class={["text-lg font-semibold leading-none text-foreground", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </h2>
    """
  end

  @doc """
  Renders a dialog description.

  Explanatory text below the title that provides additional context.

  ## Examples

      <.dialog_description>
        Make changes to your profile here. Click save when you're done.
      </.dialog_description>

      <.dialog_description class="text-destructive">
        This action cannot be undone.
      </.dialog_description>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec dialog_description(map()) :: Rendered.t()
  def dialog_description(assigns) do
    ~H"""
    <p
      data-slot="dialog-description"
      class={["text-sm text-muted-foreground", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </p>
    """
  end

  # JS commands for dialog interactions
  defp open_dialog(id) do
    [
      to: "##{id}-overlay",
      transition: {
        "transition ease-out duration-200",
        "opacity-0",
        "opacity-100"
      }
    ]
    |> JS.show()
    |> JS.set_attribute({"data-state", "open"}, to: "##{id}-overlay")
    |> JS.show(
      to: "##{id}-content",
      transition: {
        "transition ease-out duration-200",
        "opacity-0 scale-95",
        "opacity-100 scale-100"
      }
    )
    |> JS.set_attribute({"data-state", "open"}, to: "##{id}-content")
    |> JS.add_class("overflow-hidden", to: "body")
  end

  defp close_dialog(id) do
    [
      to: "##{id}-content",
      transition: {
        "transition ease-in duration-200",
        "opacity-100 scale-100",
        "opacity-0 scale-95"
      }
    ]
    |> JS.hide()
    |> JS.set_attribute({"data-state", "closed"}, to: "##{id}-content")
    |> JS.hide(
      to: "##{id}-overlay",
      transition: {
        "transition ease-in duration-200",
        "opacity-100",
        "opacity-0"
      }
    )
    |> JS.set_attribute({"data-state", "closed"}, to: "##{id}-overlay")
    |> JS.remove_class("overflow-hidden", to: "body")
  end

  # JS commands for alert dialog interactions
  defp open_alert_dialog(id) do
    [
      to: "##{id}-overlay",
      transition: {
        "transition ease-out duration-200",
        "opacity-0",
        "opacity-100"
      }
    ]
    |> JS.show()
    |> JS.set_attribute({"data-state", "open"}, to: "##{id}-overlay")
    |> JS.show(
      to: "##{id}-content",
      transition: {
        "transition ease-out duration-200",
        "opacity-0 scale-95",
        "opacity-100 scale-100"
      }
    )
    |> JS.set_attribute({"data-state", "open"}, to: "##{id}-content")
    |> JS.add_class("overflow-hidden", to: "body")
  end

  defp close_alert_dialog(id) do
    [
      to: "##{id}-content",
      transition: {
        "transition ease-in duration-200",
        "opacity-100 scale-100",
        "opacity-0 scale-95"
      }
    ]
    |> JS.hide()
    |> JS.set_attribute({"data-state", "closed"}, to: "##{id}-content")
    |> JS.hide(
      to: "##{id}-overlay",
      transition: {
        "transition ease-in duration-200",
        "opacity-100",
        "opacity-0"
      }
    )
    |> JS.set_attribute({"data-state", "closed"}, to: "##{id}-overlay")
    |> JS.remove_class("overflow-hidden", to: "body")
  end

  # Drawer Component
  # ================

  @doc """
  Renders a drawer (slide-out panel) component.

  The drawer is a mobile-friendly modal overlay that slides in from the edge of the screen,
  typically from the bottom. It's similar to a sheet but optimized for mobile interactions
  with gesture support and a drag handle. Perfect for mobile menus, filters, and actions.

  ## Features

  - Slides in from any edge (top, right, bottom, left)
  - Modal overlay with backdrop
  - Click-outside-to-close
  - Keyboard navigation (Escape to close)
  - Focus trap within drawer
  - Drag handle for bottom/top drawers
  - Smooth slide animations
  - Semantic color tokens
  - Mobile-optimized

  ## Basic Structure

      <.drawer id="mobile-menu">
        <:trigger>
          <.button>Open Menu</.button>
        </:trigger>
        <:content>
          <.drawer_header>
            <.drawer_title>Menu</.drawer_title>
            <.drawer_description>
              Navigate to your desired section.
            </.drawer_description>
          </.drawer_header>

          <%!-- Your content here --%>

          <.drawer_footer>
            <.button phx-click={JS.exec("phx-click", to: "#mobile-menu-close")}>
              Close
            </.button>
          </.drawer_footer>
        </:content>
      </.drawer>

  ## Examples

      # Bottom drawer (default, mobile-friendly)
      <.drawer id="filters">
        <:trigger><.button>Filters</.button></:trigger>
        <:content>
          <.drawer_header>
            <.drawer_title>Filter Options</.drawer_title>
          </.drawer_header>
          <%!-- Filter content --%>
          <.drawer_footer>
            <.button phx-click="apply-filters">Apply</.button>
          </.drawer_footer>
        </:content>
      </.drawer>

      # Right drawer (similar to sheet)
      <.drawer id="settings">
        <:trigger><.button>Settings</.button></:trigger>
        <:content direction="right">
          <.drawer_header>
            <.drawer_title>Settings</.drawer_title>
          </.drawer_header>
          <%!-- Settings content --%>
        </:content>
      </.drawer>

      # Top drawer
      <.drawer id="notifications">
        <:trigger><.icon name="hero-bell" /></:trigger>
        <:content direction="top">
          <.drawer_header>
            <.drawer_title>Notifications</.drawer_title>
          </.drawer_header>
          <%!-- Notifications content --%>
        </:content>
      </.drawer>

      # Left drawer (navigation)
      <.drawer id="nav">
        <:trigger><.icon name="hero-bars-3" /></:trigger>
        <:content direction="left">
          <%!-- Navigation menu --%>
        </:content>
      </.drawer>

      # With form
      <.drawer id="add-task">
        <:trigger><.button>Add Task</.button></:trigger>
        <:content>
          <.drawer_header>
            <.drawer_title>Add New Task</.drawer_title>
            <.drawer_description>
              Fill in the task details below.
            </.drawer_description>
          </.drawer_header>

          <.form for={@form} phx-submit="create-task" class="p-4">
            <.input field={@form[:name]} label="Task Name" />
            <.input field={@form[:description]} type="textarea" label="Description" />
          </.form>

          <.drawer_footer>
            <.button type="submit" form="task-form">Create Task</.button>
          </.drawer_footer>
        </:content>
      </.drawer>

  """
  attr(:id, :string, required: true)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:trigger, required: true, doc: "Trigger button/element")

  slot :content, required: true, doc: "Drawer content" do
    attr(:direction, :string,
      values: ~w(top right bottom left),
      doc: "Which edge to slide in from (default: bottom)"
    )
  end

  @spec drawer(map()) :: Rendered.t()
  def drawer(assigns) do
    ~H"""
    <div
      id={@id}
      data-slot="drawer"
      class={["inline-block", @class]}
      phx-click-away={close_drawer(@id, get_drawer_direction(@content))}
      {@rest}
    >
      <div
        id={"#{@id}-trigger"}
        data-slot="drawer-trigger"
        phx-click={open_drawer(@id, get_drawer_direction(@content))}
        class="cursor-pointer"
      >
        {render_slot(@trigger)}
      </div>

      <%!-- Overlay --%>
      <div
        id={"#{@id}-overlay"}
        data-slot="drawer-overlay"
        class="hidden fixed inset-0 z-50 bg-black/50 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0"
        data-state="closed"
        phx-click={close_drawer(@id, get_drawer_direction(@content))}
      >
      </div>

      <%!-- Content --%>
      <%= for content <- @content do %>
        <.drawer_content id={"#{@id}-content"} direction={content[:direction] || "bottom"}>
          {render_slot(content)}
        </.drawer_content>
      <% end %>

      <%!-- Hidden button for programmatic close --%>
      <button
        id={"#{@id}-close"}
        type="button"
        phx-click={close_drawer(@id, get_drawer_direction(@content))}
        class="hidden"
        aria-hidden="true"
      >
      </button>
    </div>
    """
  end

  @doc """
  Renders the drawer content panel.

  This component is automatically used within the :content slot of the drawer component.
  You typically don't need to use it directly.

  ## Attributes

  - `direction` - Which edge to slide from: "top", "right", "bottom", "left" (default: "bottom")

  """
  attr(:id, :string, required: true)
  attr(:direction, :string, default: "bottom", values: ~w(top right bottom left))
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec drawer_content(map()) :: Rendered.t()
  def drawer_content(assigns) do
    ~H"""
    <div
      id={@id}
      data-slot="drawer-content"
      data-state="closed"
      data-vaul-drawer-direction={@direction}
      class={
        [
          # Base styles
          "hidden fixed z-50 flex flex-col bg-background transition ease-in-out",
          # Animation states
          "data-[state=open]:animate-in data-[state=closed]:animate-out",
          "data-[state=closed]:duration-300 data-[state=open]:duration-500",
          # Direction-specific positioning and animations
          drawer_direction_classes(@direction),
          # Custom classes
          @class
        ]
      }
      {@rest}
    >
      <%!-- Drag handle (only for bottom/top drawers) --%>
      <div
        :if={@direction in ["bottom", "top"]}
        class={[
          "bg-muted mx-auto h-2 w-[100px] shrink-0 rounded-full",
          @direction == "bottom" && "mt-4",
          @direction == "top" && "mb-4"
        ]}
      >
      </div>

      {render_slot(@inner_block)}
    </div>
    """
  end

  # Helper to extract direction from content slot
  defp get_drawer_direction(content) do
    case content do
      [%{direction: direction}] -> direction
      _other -> "bottom"
    end
  end

  # Helper to determine direction-specific classes
  defp drawer_direction_classes("bottom") do
    [
      "inset-x-0 bottom-0 mt-24 max-h-[80vh] rounded-t-lg border-t",
      "data-[state=closed]:slide-out-to-bottom data-[state=open]:slide-in-from-bottom"
    ]
  end

  defp drawer_direction_classes("top") do
    [
      "inset-x-0 top-0 mb-24 max-h-[80vh] rounded-b-lg border-b",
      "data-[state=closed]:slide-out-to-top data-[state=open]:slide-in-from-top"
    ]
  end

  defp drawer_direction_classes("right") do
    [
      "inset-y-0 right-0 w-3/4 border-l sm:max-w-sm",
      "data-[state=closed]:slide-out-to-right data-[state=open]:slide-in-from-right"
    ]
  end

  defp drawer_direction_classes("left") do
    [
      "inset-y-0 left-0 w-3/4 border-r sm:max-w-sm",
      "data-[state=closed]:slide-out-to-left data-[state=open]:slide-in-from-left"
    ]
  end

  @doc """
  Renders a drawer header section.

  Contains the title and description at the top of the drawer.
  Text is automatically centered for bottom/top drawers and left-aligned for side drawers.

  ## Examples

      <.drawer_header>
        <.drawer_title>Settings</.drawer_title>
        <.drawer_description>
          Configure your preferences.
        </.drawer_description>
      </.drawer_header>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec drawer_header(map()) :: Rendered.t()
  def drawer_header(assigns) do
    ~H"""
    <div
      data-slot="drawer-header"
      class={[
        "flex flex-col gap-0.5 p-4",
        "group-data-[vaul-drawer-direction=bottom]/drawer-content:text-center",
        "group-data-[vaul-drawer-direction=top]/drawer-content:text-center",
        "md:gap-1.5 md:text-left",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a drawer footer section.

  Contains action buttons at the bottom of the drawer.

  ## Examples

      <.drawer_footer>
        <.button variant="outline" phx-click={JS.exec("phx-click", to: "#my-drawer-close")}>
          Cancel
        </.button>
        <.button phx-click="save">Save</.button>
      </.drawer_footer>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec drawer_footer(map()) :: Rendered.t()
  def drawer_footer(assigns) do
    ~H"""
    <div
      data-slot="drawer-footer"
      class={["mt-auto flex flex-col gap-2 p-4", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a drawer title.

  The main heading for the drawer content.

  ## Examples

      <.drawer_title>Navigation</.drawer_title>

      <.drawer_title class="text-primary">Featured</.drawer_title>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec drawer_title(map()) :: Rendered.t()
  def drawer_title(assigns) do
    ~H"""
    <h2
      data-slot="drawer-title"
      class={["text-foreground font-semibold", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </h2>
    """
  end

  @doc """
  Renders a drawer description.

  Explanatory text below the title.

  ## Examples

      <.drawer_description>
        Select your preferred settings below.
      </.drawer_description>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec drawer_description(map()) :: Rendered.t()
  def drawer_description(assigns) do
    ~H"""
    <p
      data-slot="drawer-description"
      class={["text-muted-foreground text-sm", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </p>
    """
  end

  # JS commands for drawer interactions
  defp open_drawer(id, direction) do
    {_duration, from_position, to_position} = drawer_transition(direction, :open)

    [
      to: "##{id}-overlay",
      transition: {
        "transition ease-out duration-300",
        "opacity-0",
        "opacity-100"
      }
    ]
    |> JS.show()
    |> JS.set_attribute({"data-state", "open"}, to: "##{id}-overlay")
    |> JS.show(
      to: "##{id}-content",
      transition: {
        "transition ease-in-out duration-500",
        from_position,
        to_position
      }
    )
    |> JS.set_attribute({"data-state", "open"}, to: "##{id}-content")
    |> JS.add_class("overflow-hidden", to: "body")
  end

  defp close_drawer(id, direction) do
    {_duration, from_position, to_position} = drawer_transition(direction, :close)

    [
      to: "##{id}-content",
      transition: {
        "transition ease-in-out duration-300",
        from_position,
        to_position
      }
    ]
    |> JS.hide()
    |> JS.set_attribute({"data-state", "closed"}, to: "##{id}-content")
    |> JS.hide(
      to: "##{id}-overlay",
      transition: {
        "transition ease-in duration-200",
        "opacity-100",
        "opacity-0"
      }
    )
    |> JS.set_attribute({"data-state", "closed"}, to: "##{id}-overlay")
    |> JS.remove_class("overflow-hidden", to: "body")
  end

  # Helper to get the correct transition based on direction and action
  defp drawer_transition("bottom", :open) do
    {"duration-500", "opacity-0 translate-y-full", "opacity-100 translate-y-0"}
  end

  defp drawer_transition("bottom", :close) do
    {"duration-300", "opacity-100 translate-y-0", "opacity-0 translate-y-full"}
  end

  defp drawer_transition("top", :open) do
    {"duration-500", "opacity-0 -translate-y-full", "opacity-100 translate-y-0"}
  end

  defp drawer_transition("top", :close) do
    {"duration-300", "opacity-100 translate-y-0", "opacity-0 -translate-y-full"}
  end

  defp drawer_transition("right", :open) do
    {"duration-500", "opacity-0 translate-x-full", "opacity-100 translate-x-0"}
  end

  defp drawer_transition("right", :close) do
    {"duration-300", "opacity-100 translate-x-0", "opacity-0 translate-x-full"}
  end

  defp drawer_transition("left", :open) do
    {"duration-500", "opacity-0 -translate-x-full", "opacity-100 translate-x-0"}
  end

  defp drawer_transition("left", :close) do
    {"duration-300", "opacity-100 translate-x-0", "opacity-0 -translate-x-full"}
  end

  # Fallback to bottom
  defp drawer_transition(_direction, :open) do
    {"duration-500", "opacity-0 translate-y-full", "opacity-100 translate-y-0"}
  end

  defp drawer_transition(_direction, :close) do
    {"duration-300", "opacity-100 translate-y-0", "opacity-0 translate-y-full"}
  end

  # Popover Component
  # =================

  @doc """
  Renders a popover component.

  The popover is a floating panel that displays rich content in a non-modal overlay,
  triggered by a button or other interactive element. Unlike a dialog, popovers don't
  block interaction with the rest of the page and are typically used for contextual
  information or supplementary actions.

  ## Features

  - Floating panel with flexible positioning
  - Click-to-toggle behavior
  - Click-outside-to-close
  - Keyboard navigation (Escape to close)
  - Smooth fade and zoom animations
  - Semantic color tokens
  - Customizable alignment and positioning

  ## Basic Structure

      <.popover id="settings-popover">
        <:trigger>
          <.button variant="outline">Settings</.button>
        </:trigger>
        <:content>
          <div class="grid gap-4">
            <div class="space-y-2">
              <h4 class="font-medium leading-none">Dimensions</h4>
              <p class="text-sm text-muted-foreground">
                Set the dimensions for the layer.
              </p>
            </div>
            <div class="grid gap-2">
              <div class="grid grid-cols-3 items-center gap-4">
                <label for="width">Width</label>
                <input id="width" class="col-span-2 h-8" value="100%" />
              </div>
              <div class="grid grid-cols-3 items-center gap-4">
                <label for="height">Height</label>
                <input id="height" class="col-span-2 h-8" value="25px" />
              </div>
            </div>
          </div>
        </:content>
      </.popover>

  ## Examples

      # Basic popover with text content
      <.popover id="info-popover">
        <:trigger>
          <.button variant="ghost" size="sm">
            <.icon name="hero-information-circle" />
          </.button>
        </:trigger>
        <:content>
          <p class="text-sm">Additional information here</p>
        </:content>
      </.popover>

      # Right-aligned popover
      <.popover id="actions-popover">
        <:trigger>
          <.button variant="outline">Actions</.button>
        </:trigger>
        <:content align="end">
          <div class="flex flex-col gap-2">
            <.button variant="ghost" size="sm">Action 1</.button>
            <.button variant="ghost" size="sm">Action 2</.button>
            <.button variant="ghost" size="sm">Action 3</.button>
          </div>
        </:content>
      </.popover>

      # Popover on different side
      <.popover id="top-popover">
        <:trigger>
          <.button>Show Above</.button>
        </:trigger>
        <:content side="top">
          <p class="text-sm">This appears above the trigger</p>
        </:content>
      </.popover>

      # Form in popover
      <.popover id="date-popover">
        <:trigger>
          <.button variant="outline">Pick a date</.button>
        </:trigger>
        <:content>
          <.form for={@form} phx-change="update-date">
            <.input field={@form[:date]} type="date" label="Select date" />
          </.form>
        </:content>
      </.popover>

  """
  attr(:id, :string, required: true)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:trigger, required: true, doc: "Trigger button/element")

  slot :content, required: true, doc: "Popover content" do
    attr(:align, :string,
      values: ~w(start center end),
      doc: "Horizontal alignment (default: center)"
    )

    attr(:side, :string,
      values: ~w(top right bottom left),
      doc: "Which side to place popover (default: bottom)"
    )

    attr(:side_offset, :integer, doc: "Distance from trigger in pixels (default: 4)")
    attr(:class, :string, doc: "Additional CSS classes for the popover content")
  end

  @spec popover(map()) :: Rendered.t()
  def popover(assigns) do
    ~H"""
    <div
      id={@id}
      data-slot="popover"
      class={["relative inline-block", @class]}
      phx-click-away={hide_popover(@id)}
      {@rest}
    >
      <div
        id={"#{@id}-trigger"}
        data-slot="popover-trigger"
        phx-click={toggle_popover(@id)}
        class="cursor-pointer"
      >
        {render_slot(@trigger)}
      </div>

      <%= for content <- @content do %>
        <.popover_content
          id={"#{@id}-content"}
          align={Map.get(content, :align, "center")}
          side={Map.get(content, :side, "bottom")}
          side_offset={Map.get(content, :side_offset, 4)}
          class={Map.get(content, :class)}
        >
          {render_slot(content)}
        </.popover_content>
      <% end %>
    </div>
    """
  end

  @doc """
  Renders popover content panel.

  This component is automatically used within the :content slot of the popover component.
  You typically don't need to use it directly.

  ## Attributes

  - `align` - Horizontal alignment: "start", "center", "end" (default: "center")
  - `side` - Which side to place popover: "top", "bottom", "left", "right" (default: "bottom")
  - `side_offset` - Distance from trigger in pixels (default: 4)

  """
  attr(:id, :string, required: true)
  attr(:align, :string, default: "center", values: ~w(start center end))
  attr(:side, :string, default: "bottom", values: ~w(top bottom left right))
  attr(:side_offset, :integer, default: 4)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec popover_content(map()) :: Rendered.t()
  def popover_content(assigns) do
    ~H"""
    <div
      id={@id}
      data-slot="popover-content"
      data-state="closed"
      data-align={@align}
      data-side={@side}
      class={
        [
          # Base styles
          "hidden absolute z-50 w-72 rounded-md border border-border bg-popover text-popover-foreground p-4 shadow-md outline-hidden",
          # Animation classes
          "data-[state=open]:animate-in data-[state=closed]:animate-out",
          "data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0",
          "data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95",
          "data-[side=bottom]:slide-in-from-top-2",
          "data-[side=left]:slide-in-from-right-2",
          "data-[side=right]:slide-in-from-left-2",
          "data-[side=top]:slide-in-from-bottom-2",
          # Positioning based on side
          popover_position_classes(@side, @align),
          # Custom classes
          @class
        ]
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  # Helper to determine positioning classes for popover
  defp popover_position_classes("bottom", "start"), do: "left-0 top-full mt-1"
  defp popover_position_classes("bottom", "center"), do: "left-1/2 -translate-x-1/2 top-full mt-1"
  defp popover_position_classes("bottom", "end"), do: "right-0 top-full mt-1"
  defp popover_position_classes("top", "start"), do: "left-0 bottom-full mb-1"
  defp popover_position_classes("top", "center"), do: "left-1/2 -translate-x-1/2 bottom-full mb-1"
  defp popover_position_classes("top", "end"), do: "right-0 bottom-full mb-1"
  defp popover_position_classes("left", "start"), do: "right-full top-0 mr-1"
  defp popover_position_classes("left", "center"), do: "right-full top-1/2 -translate-y-1/2 mr-1"
  defp popover_position_classes("left", "end"), do: "right-full bottom-0 mr-1"
  defp popover_position_classes("right", "start"), do: "left-full top-0 ml-1"
  defp popover_position_classes("right", "center"), do: "left-full top-1/2 -translate-y-1/2 ml-1"
  defp popover_position_classes("right", "end"), do: "left-full bottom-0 ml-1"
  defp popover_position_classes(_side, _align), do: "left-1/2 -translate-x-1/2 top-full mt-1"

  # JS commands for popover interactions
  defp toggle_popover(id) do
    [
      to: "##{id}-content",
      in: {
        "transition ease-out duration-100",
        "opacity-0 scale-95",
        "opacity-100 scale-100"
      },
      out: {
        "transition ease-in duration-75",
        "opacity-100 scale-100",
        "opacity-0 scale-95"
      }
    ]
    |> JS.toggle()
    |> JS.toggle_attribute({"data-state", "open", "closed"}, to: "##{id}-content")
  end

  defp hide_popover(id) do
    [
      to: "##{id}-content",
      transition: {
        "transition ease-in duration-75",
        "opacity-100 scale-100",
        "opacity-0 scale-95"
      }
    ]
    |> JS.hide()
    |> JS.set_attribute({"data-state", "closed"}, to: "##{id}-content")
  end

  # Destructive Confirmation Dialog Component
  # ==========================================

  @doc """
  Renders a destructive confirmation dialog for dangerous actions.

  This is a specialized dialog component for destructive operations that require
  explicit user confirmation by typing a confirmation text (like organization slug).
  The confirm button is disabled until the user types the exact confirmation text.

  This component is designed to be controlled from the server side - use assigns
  to control when it opens and LiveView events to handle confirmation and cancellation.

  ## Features

  - Modal overlay with backdrop (click-outside disabled for safety)
  - Destructive styling (red/warning colors)
  - Text input requiring exact match before confirmation
  - Confirm button disabled until text matches
  - Clear warning messaging
  - Keyboard-accessible

  ## Attributes

  - `open` - Boolean, controls dialog visibility (required)
  - `title` - Dialog title (e.g., "Delete 'Acme Corp'?") (required)
  - `message` - Warning message about consequences (required)
  - `confirmation_text` - The exact text user must type (e.g., organization slug) (required)
  - `confirmation_label` - Label/instruction for input (e.g., "Type 'acme-corp' to confirm") (required)
  - `on_confirm` - Phoenix event name to send when confirmed (required)
  - `on_cancel` - Phoenix event name to send when cancelled (required)

  ## Examples

      # In LiveView assigns
      socket
      |> assign(:show_delete_dialog, false)
      |> assign(:organization, organization)

      # In template
      <.destructive_confirmation_dialog
        open={@show_delete_dialog}
        title={"Delete '\#{@organization.name}'?"}
        message="This will permanently delete the organization, all its documents, document types, and team memberships. This action cannot be undone."
        confirmation_text={@organization.slug}
        confirmation_label={"Type '\#{@organization.slug}' to confirm deletion"}
        on_confirm="confirm_delete"
        on_cancel="cancel_delete"
      />

      # In LiveView event handlers
      def handle_event("start_delete", _params, socket) do
        {:noreply, assign(socket, :show_delete_dialog, true)}
      end

      def handle_event("cancel_delete", _params, socket) do
        {:noreply, assign(socket, :show_delete_dialog, false)}
      end

      def handle_event("confirm_delete", _params, socket) do
        case Organizations.delete_organization(socket.assigns.organization) do
          {:ok, org} ->
            socket
            |> put_flash(:info, "Organization '\#{org.name}' has been deleted")
            |> push_navigate(to: "/select-organization")
            |> then(&{:noreply, &1})
          {:error, _changeset} ->
            socket
            |> put_flash(:error, "Could not delete organization")
            |> assign(:show_delete_dialog, false)
            |> then(&{:noreply, &1})
        end
      end

  """
  attr(:open, :boolean, required: true, doc: "Controls dialog visibility")
  attr(:title, :string, required: true, doc: "Dialog title")
  attr(:message, :string, required: true, doc: "Warning message about consequences")
  attr(:confirmation_text, :string, required: true, doc: "Exact text user must type to confirm")

  attr(:confirmation_label, :string,
    required: true,
    doc: "Label/instruction for confirmation input"
  )

  attr(:on_confirm, :string, required: true, doc: "Phoenix event name for confirmation")
  attr(:on_cancel, :string, required: true, doc: "Phoenix event name for cancellation")
  attr(:id, :string, default: "destructive-confirmation-dialog", doc: "DOM ID for the dialog")
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  @spec destructive_confirmation_dialog(map()) :: Rendered.t()
  def destructive_confirmation_dialog(assigns) do
    ~H"""
    <div :if={@open} id={@id} data-slot="destructive-confirmation-dialog" {@rest}>
      <%!-- Overlay (no click-to-close for safety) --%>
      <div
        id={"#{@id}-overlay"}
        data-slot="dialog-overlay"
        class="fixed inset-0 z-50 bg-black/50 animate-in fade-in-0"
        data-state="open"
        aria-hidden="true"
      >
      </div>

      <%!-- Content --%>
      <div
        id={"#{@id}-content"}
        role="alertdialog"
        aria-labelledby={"#{@id}-title"}
        aria-describedby={"#{@id}-description"}
        data-slot="dialog-content"
        data-state="open"
        class="fixed top-[50%] left-[50%] z-50 grid w-full max-w-[calc(100%-2rem)] -translate-x-1/2 -translate-y-1/2 gap-4 rounded-lg border-2 border-destructive bg-background p-6 shadow-lg animate-in fade-in-0 zoom-in-95 sm:max-w-lg"
      >
        <%!-- Header --%>
        <div class="flex flex-col gap-2">
          <div class="flex items-start gap-3">
            <.icon
              name="hero-exclamation-triangle"
              class="h-6 w-6 text-destructive flex-shrink-0 mt-0.5"
            />
            <h2
              id={"#{@id}-title"}
              class="text-lg font-semibold text-destructive"
            >
              {@title}
            </h2>
          </div>
          <p
            id={"#{@id}-description"}
            class="text-sm text-muted-foreground"
          >
            {@message}
          </p>
        </div>

        <%!-- Confirmation Input --%>
        <div class="flex flex-col gap-2">
          <label
            for={"#{@id}-confirmation-input"}
            class="text-sm font-medium text-foreground"
          >
            {@confirmation_label}
          </label>
          <input
            id={"#{@id}-confirmation-input"}
            type="text"
            class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-hidden focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
            placeholder={@confirmation_text}
            phx-hook="DestructiveConfirmationInput"
            data-confirmation-text={@confirmation_text}
            data-button-id={"#{@id}-confirm-button"}
            autocomplete="off"
            spellcheck="false"
          />
        </div>

        <%!-- Actions --%>
        <div class="flex flex-col-reverse gap-2 pt-2 sm:flex-row sm:justify-end">
          <.button variant="outline" type="button" phx-click={@on_cancel}>
            Cancel
          </.button>
          <.button
            id={"#{@id}-confirm-button"}
            variant="destructive"
            type="button"
            phx-click={@on_confirm}
            disabled
          >
            Delete
          </.button>
        </div>
      </div>
    </div>
    """
  end
end
