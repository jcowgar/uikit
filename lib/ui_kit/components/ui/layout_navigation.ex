defmodule UiKit.Components.Ui.LayoutNavigation do
  @moduledoc """
  Layout & Navigation components for structuring content and navigation.

  Components ported from shadcn/ui.
  """
  use Phoenix.Component

  import UiKit.Components.CoreComponents, only: [icon: 1]
  import UiKit.Components.Ui.FormInput, only: [button: 1]

  import UiKit.Components.Ui.Miscellaneous,
    only: [collapsible: 1, collapsible_trigger: 1, collapsible_content: 1]

  alias Phoenix.LiveView.Rendered

  @doc """
  Renders a separator for visually or semantically dividing content.

  The separator component provides a simple line divider that can be oriented
  horizontally or vertically. It uses semantic border colors and supports both
  decorative and semantic separation.

  ## Orientations

  - `horizontal` (default) - Horizontal line dividing content vertically
  - `vertical` - Vertical line dividing content horizontally

  ## Accessibility

  - `decorative` attribute (default: true) indicates whether the separator is
    purely decorative or has semantic meaning for screen readers
  - When `decorative` is true, the separator is hidden from assistive technology
  - When `decorative` is false, it creates a semantic break in content flow

  ## Features

  - Semantic border color (`bg-border`)
  - Responsive to theme (light/dark mode)
  - Flexible sizing with orientation-specific defaults
  - Custom class support for spacing and sizing adjustments

  ## Examples

      # Horizontal separator (default)
      <.separator />

      # With custom spacing
      <.separator class="my-4" />

      # Vertical separator for inline content
      <.flex gap="md">
        <span>Item 1</span>
        <.separator orientation="vertical" class="h-4" />
        <span>Item 2</span>
        <.separator orientation="vertical" class="h-4" />
        <span>Item 3</span>
      </.flex>

      # Semantic separator (not decorative)
      <.separator decorative={false} />

      # In a form between sections
      <.form for={@form}>
        <.stack>
          <.form_field field={@form[:name]} type="text" label="Name" />
          <.form_field field={@form[:email]} type="email" label="Email" />

          <.separator class="my-6" />

          <.form_field field={@form[:password]} type="password" label="Password" />
          <.form_field field={@form[:confirm]} type="password" label="Confirm" />
        </.stack>
      </.form>

  """
  attr(:orientation, :string, default: "horizontal", values: ~w(horizontal vertical))

  attr(:decorative, :boolean,
    default: true,
    doc: "Whether the separator is purely decorative (true) or has semantic meaning (false)"
  )

  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id role aria-orientation))

  @spec separator(map()) :: Rendered.t()
  def separator(assigns) do
    ~H"""
    <div
      data-slot="separator"
      role={if @decorative, do: "none", else: "separator"}
      {if not @decorative, do: [aria_orientation: @orientation], else: []}
      data-orientation={@orientation}
      class={
        [
          # Base styles
          "bg-border shrink-0",
          # Horizontal orientation (default): 1px height, full width
          @orientation == "horizontal" && "h-px w-full",
          # Vertical orientation: 1px width (height comes from custom class or parent)
          @orientation == "vertical" && "w-px",
          # Custom classes (for vertical, typically add h-4, h-6, etc.)
          @class
        ]
      }
      {@rest}
    />
    """
  end

  @doc """
  Renders a breadcrumb navigation container.

  The breadcrumb component provides hierarchical navigation, showing users their current
  location within the site structure. It's typically placed near the top of a page.

  ## Features

  - Semantic navigation with proper ARIA labels
  - Theme-aware colors using semantic tokens
  - Composable structure with sub-components
  - Customizable separators
  - Support for ellipsis truncation

  ## Components

  - `<.breadcrumb>` - Root navigation wrapper
  - `<.breadcrumb_list>` - List container
  - `<.breadcrumb_item>` - Individual breadcrumb item
  - `<.breadcrumb_link>` - Clickable link (supports both href and navigate)
  - `<.breadcrumb_page>` - Current page (non-clickable)
  - `<.breadcrumb_separator>` - Divider between items (customizable)
  - `<.breadcrumb_ellipsis>` - Truncation indicator

  ## Examples

      # Basic breadcrumb
      <.breadcrumb>
        <.breadcrumb_list>
          <.breadcrumb_item>
            <.breadcrumb_link href={~p"/"}>Home</.breadcrumb_link>
          </.breadcrumb_item>
          <.breadcrumb_separator />
          <.breadcrumb_item>
            <.breadcrumb_link navigate={~p"/docs"}>Docs</.breadcrumb_link>
          </.breadcrumb_item>
          <.breadcrumb_separator />
          <.breadcrumb_item>
            <.breadcrumb_page>Components</.breadcrumb_page>
          </.breadcrumb_item>
        </.breadcrumb_list>
      </.breadcrumb>

      # With custom separator
      <.breadcrumb>
        <.breadcrumb_list>
          <.breadcrumb_item>
            <.breadcrumb_link href={~p"/"}>Home</.breadcrumb_link>
          </.breadcrumb_item>
          <.breadcrumb_separator>
            <.icon name="hero-slash" class="w-4 h-4" />
          </.breadcrumb_separator>
          <.breadcrumb_item>
            <.breadcrumb_page>Settings</.breadcrumb_page>
          </.breadcrumb_item>
        </.breadcrumb_list>
      </.breadcrumb>

      # With ellipsis for truncation
      <.breadcrumb>
        <.breadcrumb_list>
          <.breadcrumb_item>
            <.breadcrumb_link href={~p"/"}>Home</.breadcrumb_link>
          </.breadcrumb_item>
          <.breadcrumb_separator />
          <.breadcrumb_item>
            <.breadcrumb_ellipsis />
          </.breadcrumb_item>
          <.breadcrumb_separator />
          <.breadcrumb_item>
            <.breadcrumb_link navigate={~p"/docs/components"}>Components</.breadcrumb_link>
          </.breadcrumb_item>
          <.breadcrumb_separator />
          <.breadcrumb_item>
            <.breadcrumb_page>Breadcrumb</.breadcrumb_page>
          </.breadcrumb_item>
        </.breadcrumb_list>
      </.breadcrumb>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id))
  slot(:inner_block, required: true)

  @spec breadcrumb(map()) :: Rendered.t()
  def breadcrumb(assigns) do
    ~H"""
    <nav aria-label="breadcrumb" data-slot="breadcrumb" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </nav>
    """
  end

  @doc """
  Renders the breadcrumb list container.

  Contains the individual breadcrumb items. Automatically handles responsive
  layout and text wrapping.

  ## Examples

      <.breadcrumb_list>
        <.breadcrumb_item>
          <.breadcrumb_link href={~p"/"}>Home</.breadcrumb_link>
        </.breadcrumb_item>
      </.breadcrumb_list>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id))
  slot(:inner_block, required: true)

  @spec breadcrumb_list(map()) :: Rendered.t()
  def breadcrumb_list(assigns) do
    ~H"""
    <ol
      data-slot="breadcrumb-list"
      class={[
        "text-muted-foreground flex flex-wrap items-center text-sm break-words gap-1.5 sm:gap-2.5",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </ol>
    """
  end

  @doc """
  Renders an individual breadcrumb item.

  Wraps a breadcrumb link or page indicator. Should be a child of `<.breadcrumb_list>`.

  ## Examples

      <.breadcrumb_item>
        <.breadcrumb_link href={~p"/docs"}>Documentation</.breadcrumb_link>
      </.breadcrumb_item>

      <.breadcrumb_item>
        <.breadcrumb_page>Current Page</.breadcrumb_page>
      </.breadcrumb_item>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id))
  slot(:inner_block, required: true)

  @spec breadcrumb_item(map()) :: Rendered.t()
  def breadcrumb_item(assigns) do
    ~H"""
    <li
      data-slot="breadcrumb-item"
      class={["inline-flex items-center gap-1.5", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </li>
    """
  end

  @doc """
  Renders a clickable breadcrumb link.

  Supports both standard `href` links and LiveView `navigate` links.
  Automatically applies hover effects with theme-aware colors.

  ## Attributes

  - `href` - Standard link (page reload)
  - `navigate` - LiveView navigation (no page reload)
  - `patch` - LiveView patch (updates URL params without remounting)

  ## Examples

      # Standard link
      <.breadcrumb_link href={~p"/about"}>About</.breadcrumb_link>

      # LiveView navigation
      <.breadcrumb_link navigate={~p"/dashboard"}>Dashboard</.breadcrumb_link>

      # LiveView patch
      <.breadcrumb_link patch={~p"/users?page=2"}>Page 2</.breadcrumb_link>

  """
  attr(:href, :string, default: nil)
  attr(:navigate, :string, default: nil)
  attr(:patch, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id))
  slot(:inner_block, required: true)

  @spec breadcrumb_link(map()) :: Rendered.t()
  def breadcrumb_link(assigns) do
    ~H"""
    <.link
      href={@href}
      navigate={@navigate}
      patch={@patch}
      data-slot="breadcrumb-link"
      class={["hover:text-foreground transition-colors", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  @doc """
  Renders the current page indicator (non-clickable).

  Represents the current page in the breadcrumb trail. Uses semantic
  attributes for accessibility.

  ## Examples

      <.breadcrumb_page>Current Page</.breadcrumb_page>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id))
  slot(:inner_block, required: true)

  @spec breadcrumb_page(map()) :: Rendered.t()
  def breadcrumb_page(assigns) do
    ~H"""
    <span
      data-slot="breadcrumb-page"
      role="link"
      aria-disabled="true"
      aria-current="page"
      class={["text-foreground font-normal", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end

  @doc """
  Renders a separator between breadcrumb items.

  By default displays a chevron-right icon, but can be customized with any content.

  ## Examples

      # Default separator (chevron)
      <.breadcrumb_separator />

      # Custom separator
      <.breadcrumb_separator>
        <.icon name="hero-slash" class="w-4 h-4" />
      </.breadcrumb_separator>

      # Text separator
      <.breadcrumb_separator>/</breadcrumb_separator>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id))
  slot(:inner_block)

  @spec breadcrumb_separator(map()) :: Rendered.t()
  def breadcrumb_separator(assigns) do
    ~H"""
    <li
      data-slot="breadcrumb-separator"
      role="presentation"
      aria-hidden="true"
      class={["[&>svg]:size-3.5", @class]}
      {@rest}
    >
      <%= if @inner_block != [] do %>
        {render_slot(@inner_block)}
      <% else %>
        <.icon name="hero-chevron-right" class="w-3.5 h-3.5" />
      <% end %>
    </li>
    """
  end

  @doc """
  Renders an ellipsis indicator for breadcrumb truncation.

  Used to indicate omitted breadcrumb items in long navigation paths.

  ## Examples

      <.breadcrumb>
        <.breadcrumb_list>
          <.breadcrumb_item>
            <.breadcrumb_link href={~p"/"}>Home</.breadcrumb_link>
          </.breadcrumb_item>
          <.breadcrumb_separator />
          <.breadcrumb_item>
            <.breadcrumb_ellipsis />
          </.breadcrumb_item>
          <.breadcrumb_separator />
          <.breadcrumb_item>
            <.breadcrumb_page>Current</.breadcrumb_page>
          </.breadcrumb_item>
        </.breadcrumb_list>
      </.breadcrumb>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id))

  @spec breadcrumb_ellipsis(map()) :: Rendered.t()
  def breadcrumb_ellipsis(assigns) do
    ~H"""
    <span
      data-slot="breadcrumb-ellipsis"
      role="presentation"
      aria-hidden="true"
      class={["flex items-center justify-center size-9", @class]}
      {@rest}
    >
      <.icon name="hero-ellipsis-horizontal" class="w-4 h-4" />
      <span class="sr-only">More</span>
    </span>
    """
  end

  @doc """
  Provides context and wrapper for the sidebar component suite.

  The sidebar provider wraps your entire layout and manages the sidebar state via a JavaScript
  hook. It sets up CSS variables for sidebar widths and handles the sidebar open/collapsed state
  across desktop and mobile viewports.

  ## Features

  - State management via JS hook (localStorage persistence)
  - Keyboard shortcut support (Cmd/Ctrl+B)
  - Responsive mobile handling
  - CSS custom properties for widths
  - Data attributes for styling based on state

  ## Attributes

  - `default_open` - Initial state (default: true/expanded)
  - `class` - Additional CSS classes
  - `style` - Additional inline styles

  ## Examples

      # Basic sidebar layout
      <.sidebar_provider>
        <.sidebar side="left" variant="sidebar" collapsible="offcanvas">
          <.sidebar_header>
            <h2>My App</h2>
          </.sidebar_header>
          <.sidebar_content>
            <%!-- Navigation menu items --%>
          </.sidebar_content>
          <.sidebar_footer>
            <%!-- Footer content --%>
          </.sidebar_footer>
        </.sidebar>
        <.sidebar_inset>
          <%!-- Main page content --%>
        </.sidebar_inset>
      </.sidebar_provider>

      # With custom width via style
      <.sidebar_provider style="--sidebar-width: 20rem;">
        <%!-- Sidebar content --%>
      </.sidebar_provider>

  """
  attr(:id, :string, default: nil, doc: "Unique identifier for the sidebar provider")
  attr(:default_open, :boolean, default: true)
  attr(:class, :string, default: nil)
  attr(:style, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec sidebar_provider(map()) :: Rendered.t()
  def sidebar_provider(assigns) do
    # Build style list, filtering out nil values
    style_list =
      ["--sidebar-width: 16rem;", "--sidebar-width-icon: 3.5rem;"] ++
        if assigns.style, do: [assigns.style], else: []

    # Only generate a dynamic ID if no explicit ID was provided.
    # Using a stable ID is important for LiveView's morphdom to correctly
    # identify the element across renders and preserve scroll position.
    id = assigns.id || "sidebar-#{System.unique_integer([:positive])}"

    assigns =
      assigns
      |> assign(:style_list, style_list)
      |> assign(:id, id)

    ~H"""
    <div
      id={@id}
      phx-hook="Sidebar"
      data-slot="sidebar-wrapper"
      data-state={if @default_open, do: "expanded", else: "collapsed"}
      style={@style_list}
      class={[
        "group/sidebar-wrapper flex w-full h-svh max-h-svh",
        "has-[[data-variant=inset]]:bg-sidebar",
        @class
      ]}
      data-default-open={@default_open}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders the main sidebar component.

  The sidebar adapts based on viewport size and collapsible mode. On mobile, it uses a sheet/drawer.
  On desktop, it can be offcanvas (hidden when collapsed), icon (minimal width), or non-collapsible.

  ## Attributes

  - `side` - Sidebar position: "left" (default) or "right"
  - `variant` - Visual variant: "sidebar" (default), "floating", or "inset"
  - `collapsible` - Collapse behavior: "offcanvas" (default), "icon", or "none"
  - `class` - Additional CSS classes

  ## Variants

  - `sidebar` - Default, attached to viewport edge
  - `floating` - Rounded with shadow, padding from edge
  - `inset` - Inset with margin and rounded corners

  ## Collapsible Modes

  - `offcanvas` - Slides completely off-screen when collapsed
  - `icon` - Collapses to icon-only width
  - `none` - Cannot be collapsed, always visible

  ## Examples

      # Default sidebar
      <.sidebar>
        <.sidebar_content>
          <%!-- Content --%>
        </.sidebar_content>
      </.sidebar>

      # Right sidebar with icon collapse
      <.sidebar side="right" collapsible="icon">
        <.sidebar_content>
          <%!-- Content --%>
        </.sidebar_content>
      </.sidebar>

      # Floating variant
      <.sidebar variant="floating">
        <.sidebar_content>
          <%!-- Content --%>
        </.sidebar_content>
      </.sidebar>

  """
  attr(:side, :string, default: "left", values: ~w(left right))
  attr(:variant, :string, default: "sidebar", values: ~w(sidebar floating inset))
  attr(:collapsible, :string, default: "offcanvas", values: ~w(offcanvas icon none))
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id))
  slot(:inner_block, required: true)

  @spec sidebar(map()) :: Rendered.t()
  def sidebar(assigns) do
    ~H"""
    <%= if @collapsible == "none" do %>
      <div
        data-slot="sidebar"
        class={[
          "bg-sidebar text-sidebar-foreground flex h-full w-[--sidebar-width] flex-col",
          @class
        ]}
        {@rest}
      >
        {render_slot(@inner_block)}
      </div>
    <% else %>
      <div
        class="group peer text-sidebar-foreground hidden md:block"
        data-state="expanded"
        data-collapsible=""
        data-variant={@variant}
        data-side={@side}
        data-slot="sidebar"
      >
        <%!-- Sidebar gap for layout --%>
        <div
          data-slot="sidebar-gap"
          style="width: var(--sidebar-width);"
          class={[
            "relative bg-transparent transition-[width] duration-200 ease-linear",
            "group-data-[side=right]:rotate-180",
            sidebar_gap_variant(@variant)
          ]}
        />
        <%!-- Sidebar container --%>
        <div
          data-slot="sidebar-container"
          style="width: var(--sidebar-width);"
          class={[
            "fixed inset-y-0 z-10 hidden h-svh transition-[left,right,width] duration-200 ease-linear md:flex",
            sidebar_position(@side),
            sidebar_container_variant(@variant),
            @class
          ]}
          {@rest}
        >
          <div
            data-sidebar="sidebar"
            data-slot="sidebar-inner"
            class={[
              "bg-sidebar flex h-full w-full flex-col",
              sidebar_inner_variant(@variant)
            ]}
          >
            {render_slot(@inner_block)}
          </div>
        </div>
      </div>
    <% end %>
    """
  end

  defp sidebar_gap_variant("floating"), do: ""

  defp sidebar_gap_variant("inset"), do: ""

  defp sidebar_gap_variant(_variant), do: ""

  defp sidebar_position("left"),
    do: "left-0 group-data-[collapsible=offcanvas]:left-[calc(var(--sidebar-width)*-1)]"

  defp sidebar_position("right"),
    do: "right-0 group-data-[collapsible=offcanvas]:right-[calc(var(--sidebar-width)*-1)]"

  defp sidebar_container_variant(variant) when variant in ~w(floating inset), do: "p-2"

  defp sidebar_container_variant(_variant),
    do: "group-data-[side=left]:border-r group-data-[side=right]:border-l border-border"

  defp sidebar_inner_variant(variant) when variant in ~w(floating),
    do: "border-sidebar-border rounded-lg border shadow-sm"

  defp sidebar_inner_variant(_variant), do: ""

  @doc """
  Renders a trigger button to toggle the sidebar.

  This button automatically handles the sidebar toggle event via a JS hook. Typically
  placed in the header or toolbar area of your app.

  ## Examples

      # Basic trigger
      <.sidebar_trigger />

      # Custom size and classes
      <.sidebar_trigger class="size-8" />

      # With custom icon (override inner content)
      <.sidebar_trigger>
        <.icon name="hero-bars-3" class="w-5 h-5" />
      </.sidebar_trigger>

  """
  attr(:id, :string, default: "sidebar-trigger")
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(disabled aria-label))
  slot(:inner_block)

  @spec sidebar_trigger(map()) :: Rendered.t()
  def sidebar_trigger(assigns) do
    ~H"""
    <.button
      id={@id}
      variant="unstyled"
      phx-hook="SidebarTrigger"
      type="button"
      data-sidebar="trigger"
      data-slot="sidebar-trigger"
      class={[
        "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium transition-all gap-2",
        "disabled:pointer-events-none disabled:opacity-50",
        "text-foreground hover:bg-accent hover:text-accent-foreground",
        "size-7",
        @class
      ]}
      {@rest}
    >
      <%= if @inner_block != [] do %>
        {render_slot(@inner_block)}
      <% else %>
        <.icon
          name="hero-arrow-left-end-on-rectangle"
          class="w-4 h-4 [[data-state=collapsed]_&]:hidden"
        />
        <.icon
          name="hero-arrow-right-end-on-rectangle"
          class="w-4 h-4 [[data-state=expanded]_&]:hidden"
        />
        <span class="sr-only">Toggle Sidebar</span>
      <% end %>
    </.button>
    """
  end

  @doc """
  Renders an interactive rail for resizing/toggling the sidebar.

  The rail appears on the edge of the sidebar when hovering and provides a visual
  affordance for toggling. Typically only visible on desktop.

  ## Examples

      <.sidebar>
        <.sidebar_content>
          <%!-- Content --%>
        </.sidebar_content>
        <.sidebar_rail />
      </.sidebar>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id))

  @spec sidebar_rail(map()) :: Rendered.t()
  def sidebar_rail(assigns) do
    ~H"""
    <.button
      variant="unstyled"
      type="button"
      phx-click={toggle_sidebar()}
      data-sidebar="rail"
      data-slot="sidebar-rail"
      aria-label="Toggle Sidebar"
      tabindex="-1"
      title="Toggle Sidebar"
      class={[
        "hover:after:bg-sidebar-border absolute inset-y-0 z-20 hidden w-4 -translate-x-1/2 transition-all ease-linear",
        "group-data-[side=left]:-right-4 group-data-[side=right]:left-0",
        "after:absolute after:inset-y-0 after:left-1/2 after:w-[2px]",
        "sm:flex",
        "group-data-[side=left]:cursor-w-resize group-data-[side=right]:cursor-e-resize",
        "[[data-side=left][data-state=collapsed]_&]:cursor-e-resize [[data-side=right][data-state=collapsed]_&]:cursor-w-resize",
        "hover:group-data-[collapsible=offcanvas]:bg-sidebar",
        "group-data-[collapsible=offcanvas]:translate-x-0 group-data-[collapsible=offcanvas]:after:left-full",
        "[[data-side=left][data-collapsible=offcanvas]_&]:-right-2",
        "[[data-side=right][data-collapsible=offcanvas]_&]:-left-2",
        @class
      ]}
      {@rest}
    ></.button>
    """
  end

  @doc """
  Renders the main content inset area adjacent to the sidebar.

  This wraps the main page content when using a sidebar layout. Automatically
  adjusts margins and styling based on the sidebar variant.

  ## Attributes

  - `full_page` - Whether the inset should take full viewport height (default: true).
    Set to false when using sidebar in a contained area like a card or demo.

  ## Examples

      # Full page layout (default)
      <.sidebar_provider>
        <.sidebar>
          <%!-- Sidebar content --%>
        </.sidebar>
        <.sidebar_inset>
          <main>
            <h1>Page Title</h1>
            <p>Page content here...</p>
          </main>
        </.sidebar_inset>
      </.sidebar_provider>

      # Contained layout (for demos/examples)
      <.sidebar_provider>
        <.sidebar>
          <%!-- Sidebar content --%>
        </.sidebar>
        <.sidebar_inset full_page={false}>
          <div>Demo content</div>
        </.sidebar_inset>
      </.sidebar_provider>

  """
  attr(:full_page, :boolean, default: true)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id))
  slot(:inner_block, required: true)

  @spec sidebar_inset(map()) :: Rendered.t()
  def sidebar_inset(assigns) do
    ~H"""
    <main
      data-slot="sidebar-inset"
      class={[
        "bg-background relative flex w-full min-w-0 flex-col",
        @full_page && "flex-1",
        "md:peer-data-[variant=inset]:m-2 md:peer-data-[variant=inset]:ml-0 md:peer-data-[variant=inset]:rounded-xl md:peer-data-[variant=inset]:shadow-sm",
        "md:peer-data-[variant=inset]:peer-data-[state=collapsed]:ml-2",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </main>
    """
  end

  @doc """
  Renders the sidebar header section.

  Typically contains branding, logo, or top-level navigation controls.

  ## Examples

      <.sidebar_header>
        <h2 class="text-lg font-semibold">My Application</h2>
      </.sidebar_header>

      <.sidebar_header class="border-b border-sidebar-border">
        <.flex gap="sm">
          <img src="/logo.png" class="w-8 h-8" />
          <span class="font-bold">Brand</span>
        </.flex>
      </.sidebar_header>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id))
  slot(:inner_block, required: true)

  @spec sidebar_header(map()) :: Rendered.t()
  def sidebar_header(assigns) do
    ~H"""
    <div
      data-slot="sidebar-header"
      data-sidebar="header"
      class={[
        "flex flex-col justify-center h-16 p-2 gap-2 border-b border-border transition-[height] ease-linear",
        "group-has-data-[collapsible=icon]/sidebar-wrapper:h-12",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders the sidebar footer section.

  Typically contains user profile, settings, or other bottom-aligned content.

  ## Examples

      <.sidebar_footer>
        <.flex gap="sm">
          <img src="/avatar.jpg" class="w-8 h-8 rounded-full" />
          <.flex direction="col" gap="none">
            <span class="text-sm font-medium">John Doe</span>
            <span class="text-xs text-muted-foreground">john@example.com</span>
          </.flex>
        </.flex>
      </.sidebar_footer>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id))
  slot(:inner_block, required: true)

  @spec sidebar_footer(map()) :: Rendered.t()
  def sidebar_footer(assigns) do
    ~H"""
    <div
      data-slot="sidebar-footer"
      data-sidebar="footer"
      class={["flex flex-col p-2 gap-2 border-t border-border", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a separator within the sidebar.

  Uses the same semantic separator component but with sidebar-specific styling.

  ## Examples

      <.sidebar_separator />

      <.sidebar_separator class="my-4" />

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id))

  @spec sidebar_separator(map()) :: Rendered.t()
  def sidebar_separator(assigns) do
    ~H"""
    <div
      data-slot="sidebar-separator"
      data-sidebar="separator"
      class={["bg-sidebar-border mx-2 h-px w-auto", @class]}
      {@rest}
    />
    """
  end

  @doc """
  Renders the main scrollable content area of the sidebar.

  This is where navigation menus and other sidebar content goes. Automatically
  handles scrolling and overflow.

  ## Examples

      <.sidebar_content>
        <.sidebar_group>
          <.sidebar_menu>
            <%!-- Menu items --%>
          </.sidebar_menu>
        </.sidebar_group>
      </.sidebar_content>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id))
  slot(:inner_block, required: true)

  @spec sidebar_content(map()) :: Rendered.t()
  def sidebar_content(assigns) do
    ~H"""
    <div
      data-slot="sidebar-content"
      data-sidebar="content"
      class={[
        "flex flex-col flex-1 min-h-0 gap-2 overflow-auto group-data-[collapsible=icon]:overflow-hidden",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a group container for related sidebar items.

  Groups help organize sidebar content into logical sections. Can include labels
  and actions.

  ## Examples

      <.sidebar_group label="Navigation">
        <.sidebar_menu>
          <%!-- Menu items --%>
        </.sidebar_menu>
      </.sidebar_group>

  """
  attr(:label, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id))
  slot(:inner_block, required: true)

  @spec sidebar_group(map()) :: Rendered.t()
  def sidebar_group(assigns) do
    ~H"""
    <div
      data-slot="sidebar-group"
      data-sidebar="group"
      class={[
        "relative flex flex-col w-full min-w-0 px-2 py-2",
        @class
      ]}
      {@rest}
    >
      <.sidebar_group_label :if={@label && @label != ""}>{@label}</.sidebar_group_label>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a label for a sidebar group.

  Labels are automatically hidden when the sidebar is collapsed to icon mode.

  ## Examples

      <.sidebar_group_label>Main Navigation</.sidebar_group_label>

      <.sidebar_group_label class="text-xs uppercase">
        Settings
      </.sidebar_group_label>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id))
  slot(:inner_block, required: true)

  @spec sidebar_group_label(map()) :: Rendered.t()
  def sidebar_group_label(assigns) do
    ~H"""
    <div
      data-slot="sidebar-group-label"
      data-sidebar="group-label"
      class={[
        "text-sidebar-foreground/70 ring-sidebar-ring flex items-center h-8 shrink-0 rounded-md px-2 text-xs font-medium",
        "outline-none transition-[margin,opacity] duration-200 ease-linear focus-visible:ring-2",
        "[&>svg]:size-4 [&>svg]:shrink-0",
        "group-data-[collapsible=icon]:-mt-8 group-data-[collapsible=icon]:opacity-0",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders an action button for a sidebar group (e.g., add, settings).

  Hidden when sidebar is in icon mode.

  ## Examples

      <.sidebar_group>
        <.sidebar_group_label>Projects</.sidebar_group_label>
        <.sidebar_group_action>
          <.icon name="hero-plus" class="w-4 h-4" />
        </.sidebar_group_action>
      </.sidebar_group>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id phx-click))
  slot(:inner_block, required: true)

  @spec sidebar_group_action(map()) :: Rendered.t()
  def sidebar_group_action(assigns) do
    ~H"""
    <.button
      variant="unstyled"
      type="button"
      data-slot="sidebar-group-action"
      data-sidebar="group-action"
      class={[
        "text-sidebar-foreground ring-sidebar-ring hover:bg-sidebar-accent hover:text-sidebar-accent-foreground",
        "absolute top-3.5 right-3 flex items-center justify-center aspect-square w-5 rounded-md p-0",
        "outline-none transition-transform focus-visible:ring-2",
        "[&>svg]:size-4 [&>svg]:shrink-0",
        "after:absolute after:-inset-2 md:after:hidden",
        "group-data-[collapsible=icon]:hidden",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.button>
    """
  end

  @doc """
  Renders the content area within a sidebar group.

  ## Examples

      <.sidebar_group>
        <.sidebar_group_label>Navigation</.sidebar_group_label>
        <.sidebar_group_content>
          <.sidebar_menu>
            <%!-- Menu items --%>
          </.sidebar_menu>
        </.sidebar_group_content>
      </.sidebar_group>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id))
  slot(:inner_block, required: true)

  @spec sidebar_group_content(map()) :: Rendered.t()
  def sidebar_group_content(assigns) do
    ~H"""
    <div
      data-slot="sidebar-group-content"
      data-sidebar="group-content"
      class={["w-full text-sm", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a menu list container within the sidebar.

  ## Examples

      <.sidebar_menu>
        <.sidebar_menu_item>
          <.sidebar_menu_button href={~p"/"}>
            <.icon name="hero-home" />
            <span>Home</span>
          </.sidebar_menu_button>
        </.sidebar_menu_item>
      </.sidebar_menu>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id))
  slot(:inner_block, required: true)

  @spec sidebar_menu(map()) :: Rendered.t()
  def sidebar_menu(assigns) do
    ~H"""
    <ul
      data-slot="sidebar-menu"
      data-sidebar="menu"
      class={["flex flex-col w-full min-w-0 gap-0", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </ul>
    """
  end

  @doc """
  Renders an individual sidebar menu item.

  Can be used in three ways:
  1. Simple: Pass icon and label attributes for a complete menu item
  2. With submenu: Pass icon, label, and items for menu with collapsible submenu
  3. Advanced: Use inner_block for custom content with badges, actions, or submenus

  ## Examples

      # Simple syntax
      <.sidebar_menu_item icon="hero-home" label="Dashboard" navigate={~p"/dashboard"} />

      # With badge
      <.sidebar_menu_item icon="hero-inbox" label="Inbox" badge="5" navigate={~p"/inbox"} />

      # With submenu (simplified)
      <.sidebar_menu_item
        icon="hero-cog-6-tooth"
        label="Settings"
        items={[
          %{label: "Profile", href: ~p"/settings/profile"},
          %{label: "Account", href: ~p"/settings/account"},
          %{label: "Security", href: ~p"/settings/security"}
        ]}
      />

      # Advanced syntax with custom content
      <.sidebar_menu_item>
        <.sidebar_menu_button navigate={~p"/settings"}>
          <.icon name="hero-cog" />
          <span>Settings</span>
          <.icon name="hero-chevron-right" class="ml-auto" />
        </.sidebar_menu_button>
        <.sidebar_menu_sub>
          <%!-- Submenu items --%>
        </.sidebar_menu_sub>
      </.sidebar_menu_item>

  """
  attr(:icon, :string, default: nil)
  attr(:label, :string, default: nil)
  attr(:badge, :string, default: nil)
  attr(:items, :list, default: nil)
  attr(:is_active, :boolean, default: false)
  attr(:tooltip, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id href navigate patch phx-click disabled))
  slot(:inner_block)

  @spec sidebar_menu_item(map()) :: Rendered.t()
  def sidebar_menu_item(assigns) do
    # Determine the mode: simple, with_submenu, or advanced
    assigns =
      assigns
      |> assign(:simple_mode, assigns.icon != nil && assigns.label != nil && assigns.items == nil)
      |> assign(
        :with_submenu,
        assigns.icon != nil && assigns.label != nil && assigns.items != nil && assigns.items != []
      )
      |> assign(
        :collapsible_id,
        "sidebar-menu-#{assigns[:id] || 8 |> :crypto.strong_rand_bytes() |> Base.encode16()}"
      )

    ~H"""
    <li
      data-slot="sidebar-menu-item"
      data-sidebar="menu-item"
      class={["group/menu-item relative", @class]}
    >
      <%= cond do %>
        <% @simple_mode -> %>
          <.sidebar_menu_button is_active={@is_active} tooltip={@tooltip} {@rest}>
            <.icon name={@icon} class="size-4" />
            <span class="group-data-[collapsible=icon]:hidden">{@label}</span>
            <.sidebar_menu_badge :if={@badge}>{@badge}</.sidebar_menu_badge>
          </.sidebar_menu_button>
        <% @with_submenu -> %>
          <.collapsible id={@collapsible_id} open={true} class="group/collapsible">
            <.collapsible_trigger class="w-full">
              <div
                data-slot="sidebar-menu-button"
                data-sidebar="menu-button"
                title={@tooltip}
                class={[
                  "peer/menu-button flex items-center w-full overflow-hidden rounded-md p-2 text-left text-sm gap-2",
                  "outline-none ring-sidebar-ring transition-[width,height,padding]",
                  "hover:bg-sidebar-accent hover:text-sidebar-accent-foreground",
                  "focus-visible:ring-2",
                  "active:bg-sidebar-accent active:text-sidebar-accent-foreground",
                  "disabled:pointer-events-none disabled:opacity-50",
                  "aria-disabled:pointer-events-none aria-disabled:opacity-50",
                  "data-[active=true]:bg-sidebar-accent data-[active=true]:font-medium data-[active=true]:text-sidebar-accent-foreground",
                  "data-[state=open]:hover:bg-sidebar-accent data-[state=open]:hover:text-sidebar-accent-foreground",
                  "group-has-[[data-sidebar=menu-action]]/menu-item:pr-8",
                  "group-data-[collapsible=icon]:!size-8 group-data-[collapsible=icon]:!p-1.5",
                  "group-data-[collapsible=icon]:justify-center",
                  "[&>span:last-child]:truncate",
                  "[&>svg]:size-4 [&>svg]:shrink-0"
                ]}
              >
                <.icon name={@icon} class="size-4" />
                <span class="group-data-[collapsible=icon]:hidden">{@label}</span>
                <.icon
                  name="hero-chevron-right"
                  class="ml-auto size-4 transition-transform duration-200 group-data-[state=open]/collapsible:rotate-90 group-data-[collapsible=icon]:hidden"
                />
              </div>
            </.collapsible_trigger>
            <.collapsible_content id={@collapsible_id}>
              <.sidebar_menu_sub>
                <.sidebar_menu_sub_item :for={item <- @items}>
                  <.sidebar_menu_sub_button
                    href={item[:href]}
                    navigate={item[:navigate]}
                    patch={item[:patch]}
                    phx-click={item[:"phx-click"]}
                  >
                    <span class="group-data-[collapsible=icon]:hidden">{item.label}</span>
                  </.sidebar_menu_sub_button>
                </.sidebar_menu_sub_item>
              </.sidebar_menu_sub>
            </.collapsible_content>
          </.collapsible>
        <% true -> %>
          {render_slot(@inner_block)}
      <% end %>
    </li>
    """
  end

  @doc """
  Renders a clickable menu button within a sidebar menu item.

  Supports all button/link variants and automatically handles active states.

  **Important**: Text content inside <span> tags should use the class
  `group-data-[collapsible=icon]:hidden` to hide when the sidebar is collapsed.

  ## Attributes

  - `variant` - Style variant: "default" or "outline"
  - `size` - Size variant: "default", "sm", or "lg"
  - `is_active` - Whether this item is currently active
  - `tooltip` - Optional tooltip text (shown when sidebar is collapsed)
  - `href`, `navigate`, `patch` - Link destinations

  ## Examples

      # Link button (remember to add hiding class to text)
      <.sidebar_menu_button navigate={~p"/dashboard"}>
        <.icon name="hero-chart-bar" />
        <span class="group-data-[collapsible=icon]:hidden">Dashboard</span>
      </.sidebar_menu_button>

      # Active state
      <.sidebar_menu_button navigate={~p"/settings"} is_active={@current_page == :settings}>
        <.icon name="hero-cog-6-tooth" />
        <span class="group-data-[collapsible=icon]:hidden">Settings</span>
      </.sidebar_menu_button>

      # With tooltip
      <.sidebar_menu_button navigate={~p"/profile"} tooltip="View Profile">
        <.icon name="hero-user" />
        <span class="group-data-[collapsible=icon]:hidden">Profile</span>
      </.sidebar_menu_button>

      # Click handler
      <.sidebar_menu_button phx-click="do_something">
        <.icon name="hero-arrow-right-on-rectangle" />
        <span class="group-data-[collapsible=icon]:hidden">Logout</span>
      </.sidebar_menu_button>

  """
  attr(:variant, :string, default: "default", values: ~w(default outline))
  attr(:size, :string, default: "default", values: ~w(default sm lg))
  attr(:is_active, :boolean, default: false)
  attr(:tooltip, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id href navigate patch phx-click disabled))
  slot(:inner_block, required: true)

  @spec sidebar_menu_button(map()) :: Rendered.t()
  def sidebar_menu_button(assigns) do
    assigns =
      assign(
        assigns,
        :is_link,
        Map.has_key?(assigns.rest, :navigate) ||
          Map.has_key?(assigns.rest, :patch) ||
          Map.has_key?(assigns.rest, :href)
      )

    ~H"""
    <.link
      :if={@is_link}
      data-slot="sidebar-menu-button"
      data-sidebar="menu-button"
      data-size={@size}
      data-active={@is_active}
      title={@tooltip}
      class={[
        sidebar_menu_button_base(),
        sidebar_menu_button_variant(@variant),
        sidebar_menu_button_size(@size),
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    <.button
      :if={!@is_link}
      variant="unstyled"
      type="button"
      data-slot="sidebar-menu-button"
      data-sidebar="menu-button"
      data-size={@size}
      data-active={@is_active}
      title={@tooltip}
      class={[
        sidebar_menu_button_base(),
        sidebar_menu_button_variant(@variant),
        sidebar_menu_button_size(@size),
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.button>
    """
  end

  defp sidebar_menu_button_base do
    [
      "peer/menu-button flex items-center w-full overflow-hidden rounded-md px-2 py-1.5 text-left text-sm gap-2",
      "outline-none ring-sidebar-ring transition-[width,height,padding]",
      "hover:bg-sidebar-accent hover:text-sidebar-accent-foreground",
      "focus-visible:ring-2",
      "active:bg-sidebar-accent active:text-sidebar-accent-foreground",
      "disabled:pointer-events-none disabled:opacity-50",
      "aria-disabled:pointer-events-none aria-disabled:opacity-50",
      "data-[active=true]:bg-sidebar-accent data-[active=true]:font-medium data-[active=true]:text-sidebar-accent-foreground",
      "data-[state=open]:hover:bg-sidebar-accent data-[state=open]:hover:text-sidebar-accent-foreground",
      "group-has-[[data-sidebar=menu-action]]/menu-item:pr-8",
      "group-data-[collapsible=icon]:!size-8 group-data-[collapsible=icon]:!p-1.5",
      "group-data-[collapsible=icon]:justify-center",
      "[&>span:last-child]:break-words",
      "[&>svg]:size-4 [&>svg]:shrink-0 [&>svg]:self-start [&>svg]:mt-0.5"
    ]
  end

  defp sidebar_menu_button_variant("default"),
    do: "hover:bg-sidebar-accent hover:text-sidebar-accent-foreground"

  defp sidebar_menu_button_variant("outline"),
    do:
      "bg-background shadow-[0_0_0_1px_hsl(var(--sidebar-border))] hover:bg-sidebar-accent hover:text-sidebar-accent-foreground hover:shadow-[0_0_0_1px_hsl(var(--sidebar-accent))]"

  defp sidebar_menu_button_size("default"), do: "min-h-8 text-sm"
  defp sidebar_menu_button_size("sm"), do: "min-h-7 text-xs"
  defp sidebar_menu_button_size("lg"), do: "min-h-12 text-sm group-data-[collapsible=icon]:!p-0"

  @doc """
  Renders an action button for a menu item (e.g., dropdown, more options).

  ## Attributes

  - `show_on_hover` - Whether to hide the action until item is hovered

  ## Examples

      <.sidebar_menu_item>
        <.sidebar_menu_button navigate={~p"/project/1"}>
          <.icon name="hero-folder" />
          <span>Project Name</span>
        </.sidebar_menu_button>
        <.sidebar_menu_action show_on_hover>
          <.icon name="hero-ellipsis-horizontal" />
        </.sidebar_menu_action>
      </.sidebar_menu_item>

  """
  attr(:show_on_hover, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id phx-click))
  slot(:inner_block, required: true)

  @spec sidebar_menu_action(map()) :: Rendered.t()
  def sidebar_menu_action(assigns) do
    ~H"""
    <.button
      variant="unstyled"
      type="button"
      data-slot="sidebar-menu-action"
      data-sidebar="menu-action"
      class={[
        "text-sidebar-foreground ring-sidebar-ring hover:bg-sidebar-accent hover:text-sidebar-accent-foreground",
        "peer-hover/menu-button:text-sidebar-accent-foreground",
        "absolute top-1.5 right-1 flex items-center justify-center aspect-square w-5 rounded-md p-0",
        "outline-none transition-transform focus-visible:ring-2",
        "[&>svg]:size-4 [&>svg]:shrink-0",
        "after:absolute after:-inset-2 md:after:hidden",
        "peer-data-[size=sm]/menu-button:top-1",
        "peer-data-[size=default]/menu-button:top-1.5",
        "peer-data-[size=lg]/menu-button:top-2.5",
        "group-data-[collapsible=icon]:hidden",
        @show_on_hover &&
          "peer-data-[active=true]/menu-button:text-sidebar-accent-foreground group-focus-within/menu-item:opacity-100 group-hover/menu-item:opacity-100 data-[state=open]:opacity-100 md:opacity-0",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.button>
    """
  end

  @doc """
  Renders a badge on a menu item (e.g., notification count).

  ## Examples

      <.sidebar_menu_item>
        <.sidebar_menu_button navigate={~p"/inbox"}>
          <.icon name="hero-inbox" />
          <span>Inbox</span>
        </.sidebar_menu_button>
        <.sidebar_menu_badge>5</.sidebar_menu_badge>
      </.sidebar_menu_item>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id))
  slot(:inner_block, required: true)

  @spec sidebar_menu_badge(map()) :: Rendered.t()
  def sidebar_menu_badge(assigns) do
    ~H"""
    <div
      data-slot="sidebar-menu-badge"
      data-sidebar="menu-badge"
      class={[
        "text-sidebar-foreground pointer-events-none absolute right-1 flex items-center justify-center h-5 min-w-5",
        "rounded-md px-1 text-xs font-medium tabular-nums select-none",
        "peer-hover/menu-button:text-sidebar-accent-foreground",
        "peer-data-[active=true]/menu-button:text-sidebar-accent-foreground",
        "peer-data-[size=sm]/menu-button:top-1",
        "peer-data-[size=default]/menu-button:top-1.5",
        "peer-data-[size=lg]/menu-button:top-2.5",
        "group-data-[collapsible=icon]:hidden",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a skeleton loader for menu items.

  Useful for loading states when menu content is being fetched.

  ## Attributes

  - `show_icon` - Whether to show an icon skeleton (default: false)

  ## Examples

      <.sidebar_menu>
        <.sidebar_menu_skeleton />
        <.sidebar_menu_skeleton show_icon />
        <.sidebar_menu_skeleton show_icon />
      </.sidebar_menu>

  """
  attr(:show_icon, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id))

  @spec sidebar_menu_skeleton(map()) :: Rendered.t()
  def sidebar_menu_skeleton(assigns) do
    # Generate random width between 50-90%
    width = Enum.random(50..90)
    assigns = assign(assigns, :width, "#{width}%")

    ~H"""
    <div
      data-slot="sidebar-menu-skeleton"
      data-sidebar="menu-skeleton"
      class={["flex items-center h-8 rounded-md px-2 gap-2", @class]}
      {@rest}
    >
      <%= if @show_icon do %>
        <div class="bg-muted size-4 rounded-md animate-pulse" data-sidebar="menu-skeleton-icon" />
      <% end %>
      <div
        class="bg-muted h-4 flex-1 rounded-md animate-pulse"
        data-sidebar="menu-skeleton-text"
        style={"max-width: #{@width};"}
      />
    </div>
    """
  end

  @doc """
  Renders a sub-menu list (nested menu).

  ## Examples

      <.sidebar_menu_item>
        <.sidebar_menu_button navigate={~p"/projects"}>
          <.icon name="hero-folder" />
          <span>Projects</span>
        </.sidebar_menu_button>
        <.sidebar_menu_sub>
          <.sidebar_menu_sub_item>
            <.sidebar_menu_sub_button navigate={~p"/projects/1"}>
              Project 1
            </.sidebar_menu_sub_button>
          </.sidebar_menu_sub_item>
        </.sidebar_menu_sub>
      </.sidebar_menu_item>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id))
  slot(:inner_block, required: true)

  @spec sidebar_menu_sub(map()) :: Rendered.t()
  def sidebar_menu_sub(assigns) do
    ~H"""
    <ul
      data-slot="sidebar-menu-sub"
      data-sidebar="menu-sub"
      class={[
        "border-sidebar-border mx-3.5 flex flex-col min-w-0 translate-x-px border-l px-2.5 py-0.5 gap-0.5",
        "group-data-[collapsible=icon]:hidden",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </ul>
    """
  end

  @doc """
  Renders a sub-menu item.

  ## Examples

      <.sidebar_menu_sub_item>
        <.sidebar_menu_sub_button navigate={~p"/settings/profile"}>
          Profile
        </.sidebar_menu_sub_button>
      </.sidebar_menu_sub_item>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id))
  slot(:inner_block, required: true)

  @spec sidebar_menu_sub_item(map()) :: Rendered.t()
  def sidebar_menu_sub_item(assigns) do
    ~H"""
    <li
      data-slot="sidebar-menu-sub-item"
      data-sidebar="menu-sub-item"
      class={["group/menu-sub-item relative", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </li>
    """
  end

  @doc """
  Renders a clickable sub-menu button.

  ## Attributes

  - `size` - Size variant: "sm" or "md" (default)
  - `is_active` - Whether this sub-item is currently active

  ## Examples

      <.sidebar_menu_sub_button navigate={~p"/settings/account"}>
        Account Settings
      </.sidebar_menu_sub_button>

      <.sidebar_menu_sub_button
        navigate={~p"/settings/security"}
        is_active={@current_page == :security}
        size="sm"
      >
        Security
      </.sidebar_menu_sub_button>

  """
  attr(:size, :string, default: "md", values: ~w(sm md))
  attr(:is_active, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id href navigate patch phx-click))
  slot(:inner_block, required: true)

  @spec sidebar_menu_sub_button(map()) :: Rendered.t()
  def sidebar_menu_sub_button(assigns) do
    assigns =
      assign(
        assigns,
        :is_link,
        Map.has_key?(assigns.rest, :navigate) ||
          Map.has_key?(assigns.rest, :patch) ||
          Map.has_key?(assigns.rest, :href)
      )

    ~H"""
    <.link
      :if={@is_link}
      data-slot="sidebar-menu-sub-button"
      data-sidebar="menu-sub-button"
      data-size={@size}
      data-active={@is_active}
      class={[
        sidebar_menu_sub_button_base(),
        sidebar_menu_sub_button_size(@size),
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    <.button
      :if={!@is_link}
      variant="unstyled"
      type="button"
      data-slot="sidebar-menu-sub-button"
      data-sidebar="menu-sub-button"
      data-size={@size}
      data-active={@is_active}
      class={[
        sidebar_menu_sub_button_base(),
        sidebar_menu_sub_button_size(@size),
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.button>
    """
  end

  defp sidebar_menu_sub_button_base do
    [
      "text-sidebar-foreground ring-sidebar-ring hover:bg-sidebar-accent hover:text-sidebar-accent-foreground",
      "active:bg-sidebar-accent active:text-sidebar-accent-foreground",
      "[&>svg]:text-sidebar-accent-foreground",
      "flex items-center h-7 min-w-0 -translate-x-px overflow-hidden rounded-md px-2 gap-2",
      "outline-none focus-visible:ring-2",
      "disabled:pointer-events-none disabled:opacity-50",
      "aria-disabled:pointer-events-none aria-disabled:opacity-50",
      "[&>span:last-child]:truncate",
      "[&>svg]:size-4 [&>svg]:shrink-0",
      "data-[active=true]:bg-sidebar-accent data-[active=true]:text-sidebar-accent-foreground",
      "group-data-[collapsible=icon]:hidden"
    ]
  end

  defp sidebar_menu_sub_button_size("sm"), do: "text-xs"
  defp sidebar_menu_sub_button_size("md"), do: "text-sm"

  # Helper function for JS toggle
  defp toggle_sidebar do
    Phoenix.LiveView.JS.dispatch("sidebar:toggle")
  end

  @doc """
  Renders a tabs container for organizing content into tabbed sections.

  The tabs component provides a tabbed interface that allows users to switch between
  different panels of content. It consists of a trigger list and corresponding content
  panels, with only one panel visible at a time.

  ## Features

  - Theme-aware colors using semantic tokens
  - Composable structure with sub-components
  - Keyboard navigation support
  - Flexible layout with gap spacing
  - Support for controlled tab state via LiveView

  ## Components

  - `<.tabs>` - Root tabs wrapper
  - `<.tabs_list>` - Container for tab triggers
  - `<.tabs_trigger>` - Individual clickable tab button
  - `<.tabs_content>` - Content panel for each tab

  ## Usage Patterns

  ### Client-side only (no LiveView state)

  Use this for simple tabs that don't need server interaction:

      <.tabs default_value="account">
        <.tabs_list>
          <.tabs_trigger value="account">Account</.tabs_trigger>
          <.tabs_trigger value="password">Password</.tabs_trigger>
        </.tabs_list>
        <.tabs_content value="account">
          Account settings content
        </.tabs_content>
        <.tabs_content value="password">
          Password change content
        </.tabs_content>
      </.tabs>

  ### LiveView controlled (recommended for dynamic content)

  Use this when tab changes need server interaction or state management:

      # In your LiveView module:
      def mount(_params, _session, socket) do
        {:ok, assign(socket, active_tab: "account")}
      end

      def handle_event("tab_change", %{"value" => value}, socket) do
        {:noreply, assign(socket, active_tab: value)}
      end

      # In your template:
      <.tabs value={@active_tab} phx-change="tab_change">
        <.tabs_list>
          <.tabs_trigger value="account">Account</.tabs_trigger>
          <.tabs_trigger value="password">Password</.tabs_trigger>
        </.tabs_list>
        <.tabs_content value="account" active={@active_tab == "account"}>
          Account settings content
        </.tabs_content>
        <.tabs_content value="password" active={@active_tab == "password"}>
          Password change content
        </.tabs_content>
      </.tabs>

  ## Examples

      # Basic tabs
      <.tabs default_value="overview">
        <.tabs_list>
          <.tabs_trigger value="overview">Overview</.tabs_trigger>
          <.tabs_trigger value="analytics">Analytics</.tabs_trigger>
          <.tabs_trigger value="reports">Reports</.tabs_trigger>
        </.tabs_list>
        <.tabs_content value="overview">
          <h3>Overview</h3>
          <p>Dashboard overview content...</p>
        </.tabs_content>
        <.tabs_content value="analytics">
          <h3>Analytics</h3>
          <p>Analytics charts and data...</p>
        </.tabs_content>
        <.tabs_content value="reports">
          <h3>Reports</h3>
          <p>Report generation tools...</p>
        </.tabs_content>
      </.tabs>

      # With custom styling
      <.tabs default_value="home" class="w-full max-w-md">
        <.tabs_list class="grid w-full grid-cols-2">
          <.tabs_trigger value="home">Home</.tabs_trigger>
          <.tabs_trigger value="settings">Settings</.tabs_trigger>
        </.tabs_list>
        <.tabs_content value="home">
          Home content
        </.tabs_content>
        <.tabs_content value="settings">
          Settings content
        </.tabs_content>
      </.tabs>

  """
  attr(:default_value, :string,
    default: nil,
    doc: "The value of the tab that should be active by default (client-side only)"
  )

  attr(:value, :string,
    default: nil,
    doc: "The value of the currently active tab (for LiveView controlled tabs)"
  )

  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id phx-change))
  slot(:inner_block, required: true)

  @spec tabs(map()) :: Rendered.t()
  def tabs(assigns) do
    ~H"""
    <div
      data-slot="tabs"
      data-default-value={@default_value}
      data-value={@value}
      phx-hook="Tabs"
      class={["flex flex-col gap-2", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders the tabs list container for tab triggers.

  Contains the clickable tab buttons. Has a muted background with inline flex layout.

  ## Examples

      <.tabs_list>
        <.tabs_trigger value="tab1">Tab 1</.tabs_trigger>
        <.tabs_trigger value="tab2">Tab 2</.tabs_trigger>
      </.tabs_list>

      # Full width grid layout
      <.tabs_list class="grid w-full grid-cols-3">
        <.tabs_trigger value="home">Home</.tabs_trigger>
        <.tabs_trigger value="about">About</.tabs_trigger>
        <.tabs_trigger value="contact">Contact</.tabs_trigger>
      </.tabs_list>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id))
  slot(:inner_block, required: true)

  @spec tabs_list(map()) :: Rendered.t()
  def tabs_list(assigns) do
    ~H"""
    <div
      data-slot="tabs-list"
      class={[
        "bg-muted text-muted-foreground inline-flex items-center justify-center h-9 w-fit rounded-lg p-[3px]",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders an individual tab trigger button.

  Each trigger should have a unique `value` that corresponds to a `<.tabs_content>` panel.

  ## Attributes

  - `value` - Unique identifier for this tab (required)
  - `disabled` - Whether the tab is disabled
  - `active` - Whether this tab is currently active (automatically managed)

  ## Examples

      <.tabs_trigger value="profile">Profile</.tabs_trigger>

      <.tabs_trigger value="settings" disabled>Settings</.tabs_trigger>

      # With icon
      <.tabs_trigger value="notifications">
        <.icon name="hero-bell" class="w-4 h-4 mr-2" />
        Notifications
      </.tabs_trigger>

  """
  attr(:value, :string, required: true)
  attr(:disabled, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id phx-click))
  slot(:inner_block, required: true)

  @spec tabs_trigger(map()) :: Rendered.t()
  def tabs_trigger(assigns) do
    ~H"""
    <.button
      variant="unstyled"
      type="button"
      role="tab"
      data-slot="tabs-trigger"
      data-value={@value}
      disabled={@disabled}
      class={[
        "inline-flex items-center justify-center h-[calc(100%-1px)] flex-1 rounded-md border border-transparent px-2 py-1 gap-1.5",
        "text-sm font-medium whitespace-nowrap transition-[color,box-shadow]",
        "text-foreground dark:text-muted-foreground",
        "focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:outline-ring",
        "focus-visible:ring-[3px] focus-visible:outline-1",
        "disabled:pointer-events-none disabled:opacity-50",
        "data-[state=active]:bg-background data-[state=active]:shadow-sm",
        "dark:data-[state=active]:text-foreground dark:data-[state=active]:border-input dark:data-[state=active]:bg-input/30",
        "[&_svg]:pointer-events-none [&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.button>
    """
  end

  @doc """
  Renders the content panel for a tab.

  Each content panel should have a `value` that matches a corresponding `<.tabs_trigger>`.
  Only the content panel matching the active tab's value will be visible.

  ## Attributes

  - `value` - Unique identifier matching a tab trigger (required)
  - `active` - Whether this content is currently active (automatically managed)

  ## Examples

      <.tabs_content value="profile">
        <h2>Profile Settings</h2>
        <p>Manage your profile information.</p>
      </.tabs_content>

      <.tabs_content value="account" class="space-y-4">
        <.card>
          <.card_header>
            <.card_title>Account Settings</.card_title>
          </.card_header>
          <.card_content>
            Account management content
          </.card_content>
        </.card>
      </.tabs_content>

  """
  attr(:value, :string, required: true)
  attr(:active, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id))
  slot(:inner_block, required: true)

  @spec tabs_content(map()) :: Rendered.t()
  def tabs_content(assigns) do
    ~H"""
    <div
      role="tabpanel"
      data-slot="tabs-content"
      data-value={@value}
      data-state={if @active, do: "active", else: "inactive"}
      class={[
        "flex-1 outline-none",
        !@active && "hidden",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a custom scrollable area with styled scrollbars.

  The scroll area component augments native scroll functionality for custom,
  cross-browser styling. It provides enhanced scroll behavior with consistent
  visual treatment across browsers while hiding default scrollbars.

  ## Features

  - Custom styled scrollbars
  - Cross-browser consistent appearance
  - Vertical and horizontal scrolling support
  - Theme-aware colors using semantic tokens
  - Keyboard and focus ring support
  - Composable with scroll bars

  ## Components

  - `<.scroll_area>` - Main scrollable container
  - `<.scroll_bar>` - Visible scroll indicator (vertical or horizontal)

  ## Examples

      # Basic vertical scrolling (default)
      <.scroll_area class="h-[200px] w-[350px] rounded-md border p-4">
        <.stack gap="md">
          <%= for item <- @items do %>
            <div>{item.name}</div>
          <% end %>
        </.stack>
      </.scroll_area>

      # Horizontal scrolling
      <.scroll_area class="w-96 whitespace-nowrap rounded-md border">
        <.scroll_bar orientation="horizontal" />
        <div class="flex w-max space-x-4 p-4">
          <%= for item <- @items do %>
            <div class="shrink-0">{item.name}</div>
          <% end %>
        </div>
      </.scroll_area>

      # Both vertical and horizontal scrolling
      <.scroll_area class="h-[400px] w-[600px] rounded-md border">
        <.scroll_bar orientation="vertical" />
        <.scroll_bar orientation="horizontal" />
        <div class="w-[800px] p-4">
          Wide and tall content...
        </div>
      </.scroll_area>

      # List with separators
      <.scroll_area class="h-72 w-48 rounded-md border">
        <div class="p-4">
          <%= for {tag, index} <- Enum.with_index(@tags) do %>
            <div>
              <div class="text-sm">{tag}</div>
              <.separator :if={index < length(@tags) - 1} class="my-2" />
            </div>
          <% end %>
        </div>
      </.scroll_area>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id))
  slot(:inner_block, required: true)

  @spec scroll_area(map()) :: Rendered.t()
  def scroll_area(assigns) do
    ~H"""
    <div
      data-slot="scroll-area"
      class={["relative overflow-hidden", @class]}
      {@rest}
    >
      <div
        data-slot="scroll-area-viewport"
        class={[
          "size-full rounded-[inherit] [&>div]:!block",
          "outline-none focus-visible:ring-ring/50 focus-visible:outline-ring",
          "transition-[color,box-shadow] focus-visible:ring-[3px] focus-visible:outline-1"
        ]}
        style="overflow: scroll; scrollbar-width: none; -ms-overflow-style: none;"
        tabindex="0"
      >
        <div style="min-width: 100%; display: table;">
          {render_slot(@inner_block)}
        </div>
      </div>
      <style>
        [data-slot="scroll-area-viewport"]::-webkit-scrollbar {
          display: none;
        }
      </style>
    </div>
    """
  end

  @doc """
  Renders a visible scroll indicator for a scroll area.

  By default, scroll areas hide the native scrollbar. This component provides a
  custom-styled scrollbar that can be shown for vertical or horizontal scrolling.

  ## Attributes

  - `orientation` - Direction of the scrollbar: "vertical" (default) or "horizontal"

  ## Examples

      # Vertical scrollbar (default)
      <.scroll_area class="h-[200px]">
        <.scroll_bar />
        Content...
      </.scroll_area>

      # Horizontal scrollbar
      <.scroll_area class="w-96">
        <.scroll_bar orientation="horizontal" />
        Wide content...
      </.scroll_area>

      # Both scrollbars
      <.scroll_area class="h-[400px] w-[600px]">
        <.scroll_bar orientation="vertical" />
        <.scroll_bar orientation="horizontal" />
        Wide and tall content...
      </.scroll_area>

  """
  attr(:orientation, :string, default: "vertical", values: ~w(vertical horizontal))
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id))

  @spec scroll_bar(map()) :: Rendered.t()
  def scroll_bar(assigns) do
    ~H"""
    <div
      data-slot="scroll-area-scrollbar"
      data-orientation={@orientation}
      class={[
        "flex touch-none select-none p-px transition-colors",
        @orientation == "vertical" && "w-2.5 h-full border-l border-l-transparent",
        @orientation == "horizontal" && "flex-col h-2.5 border-t border-t-transparent",
        @class
      ]}
      {@rest}
    >
      <div
        data-slot="scroll-area-thumb"
        class="bg-border/40 hover:bg-border/60 relative flex-1 rounded-full transition-colors"
      />
    </div>
    """
  end

  @doc """
  Renders a mobile-first bottom tab bar for application navigation.

  This component is designed for mobile devices to provide primary navigation
  at the bottom of the screen. It supports an active state based on the current
  route and displays icons with labels.

  ## Features

  - Fixed bottom positioning, full-width layout.
  - Equal-width items using CSS flexbox.
  - Icon-over-label vertical layout for better mobile UX.
  - Active state management via a JavaScript hook (`TabBarHook`).
  - Supports route-based active state integration with Phoenix LiveView navigation.
  - Ensures 44px minimum touch targets for accessibility.
  - Theme-aware colors.

  ## Components

  - `<.tab_bar>` - Root container for the tab bar.
  - `<.tab_bar_item>` - Individual navigation item with icon + label.

  ## Examples

      # Basic tab bar
      <.tab_bar active_path={@current_path}>
        <.tab_bar_item icon="hero-home" label="Home" path={~p"/"} />
        <.tab_bar_item icon="hero-calendar" label="Schedule" path={~p"/schedule"} />
        <.tab_bar_item icon="hero-trophy" label="Standings" path={~p"/standings"} />
        <.tab_bar_item icon="hero-ellipsis-horizontal" label="More" path={~p"/more"} />
      </.tab_bar>

      # With badge
      <.tab_bar active_path={@current_path}>
        <.tab_bar_item icon="hero-chat-bubble-oval-left" label="Chat" path={~p"/chat"} badge="3" />
        <.tab_bar_item icon="hero-bell" label="Alerts" path={~p"/alerts"} badge="99+" />
      </.tab_bar>

  """
  attr(:active_path, :string,
    required: true,
    doc: "The current LiveView path to determine the active tab."
  )

  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id))
  slot(:inner_block, required: true)

  @spec tab_bar(map()) :: Rendered.t()
  def tab_bar(assigns) do
    ~H"""
    <div
      phx-hook="TabBarHook"
      data-slot="tab-bar"
      data-active-path={@active_path}
      class={[
        "fixed inset-x-0 bottom-0 z-40 block bg-background shadow-md md:hidden h-16",
        "flex items-stretch justify-around border-t border-border",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders an individual item within the tab bar.

  Each item represents a navigation link with an icon and a label. It highlights
  automatically if its path matches the `tab_bar`'s `active_path`.

  ## Attributes

  - `path` - The LiveView path this item navigates to (required).
  - `icon` - The Heroicons name for the icon to display (e.g., "hero-home").
  - `label` - The text label for the tab item.
  - `badge` - Optional string to display as a badge (e.g., notification count).
  - `class` - Additional CSS classes for the item.

  ## Examples

      <.tab_bar_item icon="hero-home" label="Home" path={~p"/"} />
      <.tab_bar_item icon="hero-calendar" label="Schedule" path={~p"/schedule"} badge="New" />

  """
  attr(:navigate, :string, required: true, doc: "The LiveView path this item navigates to.")
  attr(:icon, :string, default: nil, doc: "The Heroicons name for the icon to display.")
  attr(:label, :string, default: nil, doc: "The text label for the tab item.")
  attr(:badge, :string, default: nil, doc: "Optional notification badge content.")
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id phx-click))
  slot(:inner_block)

  @spec tab_bar_item(map()) :: Rendered.t()
  def tab_bar_item(assigns) do
    ~H"""
    <.link
      navigate={@navigate}
      data-slot="tab-bar-item"
      class={[
        "flex flex-col flex-1 items-center justify-center relative py-1 px-2 gap-0.5",
        "text-muted-foreground transition-colors duration-200",
        "active:text-primary active:bg-primary-foreground",
        "data-[active=true]:text-primary data-[active=true]:font-medium",
        "min-h-[44px]", # Ensures minimum touch target
        "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary focus-visible:ring-offset-2",
        @class
      ]}
      {@rest}
    >
      <div class="relative">
        <.icon :if={@icon} name={@icon} class="size-6" />
        <%= if @badge do %>
          <span class="absolute -top-1 -right-2 inline-flex items-center justify-center px-1 py-0.5 text-xs font-bold leading-none text-white bg-red-500 rounded-full">
            <%= @badge %>
          </span>
        <% end %>
      </div>
      <span class="text-xs">
        <%= @label %>
      </span>
      {render_slot(@inner_block)}
    </.link>
    """
  end

  @doc """
  Renders an accordion container for collapsible content sections.

  A vertically stacked set of interactive headings that each reveal a section of content.
  Accordions are useful for organizing and displaying content in a compact, scannable format.

  ## Type Modes

  - `single` - Only one section can be open at a time (default behavior)
  - `multiple` - Multiple sections can be open simultaneously

  ## Features

  - Smooth expand/collapse animations
  - Keyboard navigation support
  - Semantic HTML structure
  - Composable sub-components (accordion_item, accordion_trigger, accordion_content)
  - Customizable with CSS classes

  ## Examples

      # Single mode (only one item open at a time)
      <.accordion id="faq">
        <.accordion_item value="item-1">
          <.accordion_trigger>Is it accessible?</.accordion_trigger>
          <.accordion_content>
            Yes. It adheres to the WAI-ARIA design pattern.
          </.accordion_content>
        </.accordion_item>

        <.accordion_item value="item-2">
          <.accordion_trigger>Is it styled?</.accordion_trigger>
          <.accordion_content>
            Yes. It comes with default styles that you can customize.
          </.accordion_content>
        </.accordion_item>
      </.accordion>

      # Multiple mode (multiple items can be open)
      <.accordion id="settings" type="multiple">
        <.accordion_item value="general">
          <.accordion_trigger>General Settings</.accordion_trigger>
          <.accordion_content>
            General configuration options...
          </.accordion_content>
        </.accordion_item>
      </.accordion>

  ## Accessibility

  - Uses proper ARIA attributes for screen readers
  - Supports keyboard navigation (Tab, Enter, Space, Arrow keys)
  - Follows WAI-ARIA Accordion pattern

  """
  attr(:id, :string, required: true, doc: "Unique identifier for the accordion")
  attr(:type, :string, default: "single", values: ~w(single multiple), doc: "Accordion type")
  attr(:default_value, :any, default: nil, doc: "Value(s) of items to open by default. String for single, list for multiple.")
  attr(:class, :string, default: nil, doc: "Additional CSS classes")
  attr(:rest, :global, doc: "Additional HTML attributes")
  slot(:inner_block, required: true, doc: "Accordion items")

  @spec accordion(map()) :: Rendered.t()
  def accordion(assigns) do
    default_value = case assigns.default_value do
      nil -> nil
      list when is_list(list) -> Enum.join(list, ",")
      value -> value
    end
    assigns = assign(assigns, :default_value_str, default_value)

    ~H"""
    <div
      id={@id}
      phx-hook="Accordion"
      data-slot="accordion"
      data-type={@type}
      data-default-value={@default_value_str}
      class={@class}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders an individual accordion item.

  Represents a single collapsible section within an accordion. Must be used within
  an `accordion` component.

  ## Examples

      <.accordion_item value="item-1">
        <.accordion_trigger>Section Title</.accordion_trigger>
        <.accordion_content>
          Section content goes here...
        </.accordion_content>
      </.accordion_item>

  """
  attr(:value, :string, required: true, doc: "Unique identifier for this accordion item")
  attr(:class, :string, default: nil, doc: "Additional CSS classes")
  attr(:rest, :global, doc: "Additional HTML attributes")
  slot(:inner_block, required: true, doc: "Accordion trigger and content")

  @spec accordion_item(map()) :: Rendered.t()
  def accordion_item(assigns) do
    ~H"""
    <div
      data-slot="accordion-item"
      data-value={@value}
      class={[
        "border-b last:border-b-0",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders an accordion trigger button.

  The clickable heading that toggles the visibility of the accordion content.
  Must be used within an `accordion_item` component.

  ## Features

  - Automatically includes chevron icon that rotates when expanded
  - Keyboard accessible
  - Focus visible states
  - Hover effects

  ## Examples

      <.accordion_trigger>
        Click to expand
      </.accordion_trigger>

      <.accordion_trigger class="text-lg font-bold">
        Custom styled trigger
      </.accordion_trigger>

  """
  attr(:class, :string, default: nil, doc: "Additional CSS classes")
  attr(:rest, :global, include: ~w(phx-click), doc: "Additional HTML attributes")
  slot(:inner_block, required: true, doc: "Trigger content (usually text)")

  @spec accordion_trigger(map()) :: Rendered.t()
  def accordion_trigger(assigns) do
    ~H"""
    <h3 class="flex">
      <.button
        variant="unstyled"
        type="button"
        data-slot="accordion-trigger"
        data-state="closed"
        class={[
          "focus-visible:border-ring focus-visible:ring-ring/50 flex flex-1 items-start justify-between rounded-md py-4 text-left text-sm font-medium transition-all outline-none focus-visible:ring-[3px] disabled:pointer-events-none disabled:opacity-50 gap-4 cursor-pointer",
          "[&[data-state=open]>span.shrink-0]:rotate-180",
          @class
        ]}
        {@rest}
      >
        <span class="flex-1">
          {render_slot(@inner_block)}
        </span>
        <.icon
          name="hero-chevron-down"
          class="text-muted-foreground pointer-events-none size-4 shrink-0 translate-y-0.5 transition-transform duration-200"
        />
      </.button>
    </h3>
    """
  end

  @doc """
  Renders accordion content panel.

  The collapsible content that is shown/hidden when the trigger is clicked.
  Must be used within an `accordion_item` component.

  ## Features

  - Smooth slide animations
  - Hidden by default
  - Supports rich content (text, images, nested components)

  ## Examples

      <.accordion_content>
        <p>This is the content that will be revealed.</p>
      </.accordion_content>

      <.accordion_content class="bg-muted">
        <div>
          <h4>Rich Content</h4>
          <p>You can include any content here.</p>
        </div>
      </.accordion_content>

  """
  attr(:class, :string, default: nil, doc: "Additional CSS classes")
  attr(:rest, :global, doc: "Additional HTML attributes")
  slot(:inner_block, required: true, doc: "Content to display when expanded")

  @spec accordion_content(map()) :: Rendered.t()
  def accordion_content(assigns) do
    ~H"""
    <div
      data-slot="accordion-content"
      data-state="closed"
      class="overflow-hidden text-sm transition-all duration-200 ease-in-out"
      style="max-height: 0; opacity: 0;"
      {@rest}
    >
      <div class={[
        "pt-0 pb-4",
        @class
      ]}>
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end
end
