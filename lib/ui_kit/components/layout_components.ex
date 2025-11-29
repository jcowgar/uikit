defmodule UiKit.Components.LayoutComponents do
  @moduledoc """
  Provides layout components for consistent page structure.

  These components abstract common layout patterns to ensure consistency
  across the application while remaining simple and intuitive.

  ## Philosophy

  - Use these components for 99% of layout needs
  - They enforce smart, responsive defaults
  - Simpler API than raw Tailwind utilities
  - Ensures visual consistency across pages

  ## Examples

      <.container>
        <.stack>
          <.header>Dashboard</.header>
          <.grid cols={3}>
            <.card>Card 1</.card>
            <.card>Card 2</.card>
            <.card>Card 3</.card>
          </.grid>
        </.stack>
      </.container>
  """
  use Phoenix.Component

  alias Phoenix.LiveView.Rendered

  @doc """
  Standard page container with consistent max-width and padding.

  Provides horizontal padding and centers content with a max width.
  This should wrap most page content.

  ## Examples

      <.container>
        Page content here
      </.container>

      <.container class="py-12">
        Custom vertical padding
      </.container>

      <.container max_width="full">
        Full-width content (for dashboards, kanbans, etc.)
      </.container>
  """
  attr(:max_width, :string,
    default: "7xl",
    values: ~w(sm md lg xl 2xl 3xl 4xl 5xl 6xl 7xl full),
    doc: "Maximum width: sm, md, lg, xl, 2xl, 3xl, 4xl, 5xl, 6xl, 7xl (default), full"
  )

  attr(:padding, :string,
    default: "default",
    values: ~w(none small default),
    doc: "Horizontal padding: none (no padding), small (px-4), default (px-4 sm:px-6 lg:px-8)"
  )

  attr(:class, :string, default: nil, doc: "Additional CSS classes")
  slot(:inner_block, required: true)

  @spec container(map()) :: Rendered.t()
  def container(assigns) do
    assigns =
      assigns
      |> assign(:max_width_class, build_max_width_class(assigns.max_width))
      |> assign(:base_class, build_base_class(assigns.max_width))
      |> assign(:padding_class, build_padding_class(assigns.padding))

    ~H"""
    <div class={[@base_class, "mx-auto py-8", @padding_class, @max_width_class, @class]}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @spec build_max_width_class(String.t()) :: String.t()
  defp build_max_width_class(max_width) do
    case max_width do
      "sm" ->
        "max-w-sm"

      "md" ->
        "max-w-md"

      "lg" ->
        "max-w-lg"

      "xl" ->
        "max-w-xl"

      "2xl" ->
        "max-w-2xl"

      "3xl" ->
        "max-w-3xl"

      "4xl" ->
        "max-w-4xl"

      "5xl" ->
        "max-w-5xl"

      "6xl" ->
        "max-w-6xl"

      "7xl" ->
        "max-w-7xl"

      "full" ->
        "max-w-full"

      invalid ->
        raise ArgumentError,
              "invalid max_width value: #{inspect(invalid)}. Expected sm, md, lg, xl, 2xl, 3xl, 4xl, 5xl, 6xl, 7xl, or full"
    end
  end

  @spec build_padding_class(String.t()) :: String.t()
  defp build_padding_class(padding) do
    case padding do
      "none" ->
        ""

      "small" ->
        "px-4"

      "default" ->
        "px-4 sm:px-6 lg:px-8"

      invalid ->
        raise ArgumentError,
              "invalid padding value: #{inspect(invalid)}. Expected none, small, or default"
    end
  end

  @spec build_base_class(String.t()) :: String.t()
  defp build_base_class(max_width) do
    # When max_width is "full", don't use the "container" class which has responsive max-widths
    if max_width == "full", do: "w-full", else: "container"
  end

  @doc """
  Responsive grid layout with smart column defaults.

  Automatically applies responsive breakpoints based on column count:
  - 1 col: Always 1 column
  - 2 cols: 1 → 2 columns (mobile → desktop)
  - 3 cols: 1 → 2 → 3 columns (mobile → tablet → desktop)
  - 4 cols: 1 → 2 → 4 columns (mobile → tablet → desktop)
  - 5 cols: 1 → 2 → 3 → 5 columns (mobile → tablet → desktop → wide)
  - 6 cols: 1 → 2 → 3 → 6 columns (mobile → tablet → desktop → wide)

  ## Examples

      # Three column grid (most common)
      <.grid cols={3}>
        <.card>Item 1</.card>
        <.card>Item 2</.card>
        <.card>Item 3</.card>
      </.grid>

      # Two column grid with larger gap
      <.grid cols={2} gap="xl">
        <.card>Left</.card>
        <.card>Right</.card>
      </.grid>

      # Custom classes for special cases
      <.grid cols={4} class="mb-8">
        <.stat_card title="Stat 1" />
        <.stat_card title="Stat 2" />
        <.stat_card title="Stat 3" />
        <.stat_card title="Stat 4" />
      </.grid>
  """
  attr(:cols, :integer, default: 3, doc: "Number of columns (1-6)")

  attr(:gap, :string,
    default: "lg",
    values: ~w(none xs sm default md lg xl),
    doc: "Gap size: none (0), xs (1), sm (2), default (3), md (4), lg (6, default), xl (8)"
  )

  attr(:class, :string, default: nil, doc: "Additional CSS classes")
  slot(:inner_block, required: true)

  @spec grid(map()) :: Rendered.t()
  def grid(assigns) do
    col_classes =
      case assigns.cols do
        1 -> "grid-cols-1"
        2 -> "grid-cols-1 md:grid-cols-2"
        3 -> "grid-cols-1 md:grid-cols-2 lg:grid-cols-3"
        4 -> "grid-cols-1 md:grid-cols-2 lg:grid-cols-4"
        5 -> "grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5"
        6 -> "grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6"
        invalid -> raise ArgumentError, "invalid cols value: #{inspect(invalid)}. Expected 1-6"
      end

    assigns =
      assigns
      |> assign(:col_classes, col_classes)
      |> assign(:gap_class, grid_gap(assigns.gap))

    ~H"""
    <div class={["grid", @col_classes, @gap_class, @class]}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  defp grid_gap("none"), do: nil
  defp grid_gap("xs"), do: "gap-1"
  defp grid_gap("sm"), do: "gap-2"
  defp grid_gap("default"), do: "gap-3"
  defp grid_gap("md"), do: "gap-4"
  defp grid_gap("lg"), do: "gap-6"
  defp grid_gap("xl"), do: "gap-8"

  @doc """
  Flex container for common alignment patterns.

  Provides simple props for the most common flex layouts without
  needing to remember Tailwind flex classes.

  ## Attributes

  - `direction` - Flex direction: `"row"` (default) or `"col"`
  - `justify` - Main axis alignment: `"start"` (default), `"center"`, `"end"`, `"between"`
  - `items` - Cross axis alignment: `"start"`, `"center"` (default), `"end"`, `"stretch"`, `"baseline"`
  - `gap` - Gap between items: `"none"`, `"xs"`, `"sm"`, `"md"` (default), `"lg"`, `"xl"`
  - `wrap` - Whether items wrap: `true` or `false` (default)

  ## Examples

      # Horizontal row with centered items (most common pattern)
      <.flex items="center" gap="sm">
        <.icon name="hero-check" />
        <span>Success!</span>
      </.flex>

      # Space between with centered items (common for headers)
      <.flex justify="between" items="center">
        <h1>Title</h1>
        <.button>Action</.button>
      </.flex>

      # Vertical column, all centered
      <.flex direction="col" justify="center" items="center">
        <.icon name="hero-inbox" class="size-12" />
        <p>No items yet</p>
      </.flex>

      # Wrapping flex container
      <.flex wrap={true} gap="sm">
        <.badge>Tag 1</.badge>
        <.badge>Tag 2</.badge>
        <.badge>Tag 3</.badge>
      </.flex>
  """
  attr(:direction, :string,
    default: "row",
    values: ~w(row col row-reverse col-reverse),
    doc: "Flex direction"
  )

  attr(:justify, :string,
    default: "start",
    values: ~w(start center end between around evenly),
    doc: "Main axis alignment (justify-content)"
  )

  attr(:items, :string,
    default: "center",
    values: ~w(start center end stretch baseline),
    doc: "Cross axis alignment (align-items)"
  )

  attr(:gap, :string,
    default: "md",
    values: ~w(none xs sm default md lg xl),
    doc: "Gap between items: none (0), xs (1), sm (2), default (3), md (4), lg (6), xl (8)"
  )

  attr(:wrap, :boolean,
    default: false,
    doc: "Whether flex items should wrap"
  )

  attr(:class, :any, default: nil, doc: "Additional CSS classes")
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec flex(map()) :: Rendered.t()
  def flex(assigns) do
    ~H"""
    <div
      class={[
        "flex",
        flex_direction(@direction),
        flex_justify(@justify),
        flex_items(@items),
        flex_gap(@gap),
        @wrap && "flex-wrap",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  defp flex_direction("row"), do: nil
  defp flex_direction("col"), do: "flex-col"
  defp flex_direction("row-reverse"), do: "flex-row-reverse"
  defp flex_direction("col-reverse"), do: "flex-col-reverse"

  defp flex_justify("start"), do: nil
  defp flex_justify("center"), do: "justify-center"
  defp flex_justify("end"), do: "justify-end"
  defp flex_justify("between"), do: "justify-between"
  defp flex_justify("around"), do: "justify-around"
  defp flex_justify("evenly"), do: "justify-evenly"

  defp flex_items("start"), do: "items-start"
  defp flex_items("center"), do: "items-center"
  defp flex_items("end"), do: "items-end"
  defp flex_items("stretch"), do: "items-stretch"
  defp flex_items("baseline"), do: "items-baseline"

  defp flex_gap("none"), do: nil
  defp flex_gap("xs"), do: "gap-1"
  defp flex_gap("sm"), do: "gap-2"
  defp flex_gap("default"), do: "gap-3"
  defp flex_gap("md"), do: "gap-4"
  defp flex_gap("lg"), do: "gap-6"
  defp flex_gap("xl"), do: "gap-8"

  @doc """
  Vertical stack with consistent spacing between children.

  Use this instead of manually adding margins between elements.
  Creates consistent vertical rhythm using `space-y-*` classes.

  ## Examples

      <.stack>
        <.header>Title</.header>
        <.card>Content</.card>
        <.card>More content</.card>
      </.stack>

      # Larger spacing for major sections
      <.stack gap="lg">
        <section>Section 1</section>
        <section>Section 2</section>
      </.stack>

      # Tighter spacing for related items
      <.stack gap="xs">
        <p>Line 1</p>
        <p>Line 2</p>
        <p>Line 3</p>
      </.stack>
  """
  attr(:gap, :string,
    default: "sm",
    values: ~w(none xs sm default md lg xl),
    doc: "Vertical spacing: none (0), xs (1), sm (2), default (3), md (4), lg (6), xl (8)"
  )

  attr(:class, :any, default: nil, doc: "Additional CSS classes")
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec stack(map()) :: Rendered.t()
  def stack(assigns) do
    ~H"""
    <div class={[stack_gap(@gap), @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  defp stack_gap("none"), do: nil
  defp stack_gap("xs"), do: "space-y-1"
  defp stack_gap("sm"), do: "space-y-2"
  defp stack_gap("default"), do: "space-y-3"
  defp stack_gap("md"), do: "space-y-4"
  defp stack_gap("lg"), do: "space-y-6"
  defp stack_gap("xl"), do: "space-y-8"

  @doc """
  Two-column layout with sidebar and main content.

  Common pattern for admin/dashboard layouts with a sidebar.
  Automatically collapses to single column on mobile.

  ## Examples

      <.sidebar_layout>
        <:sidebar>
          <.nav_menu />
        </:sidebar>
        <:main>
          <.page_content />
        </:main>
      </.sidebar_layout>

      # Custom sidebar width and spacing
      <.sidebar_layout sidebar_width="wide" gap="large">
        <:sidebar>Wider sidebar</:sidebar>
        <:main>Content</:main>
      </.sidebar_layout>
  """
  attr(:sidebar_width, :string,
    default: "medium",
    values: ~w(narrow medium wide),
    doc: "Sidebar width: narrow (12rem), medium (16rem), wide (20rem)"
  )

  attr(:gap, :string,
    default: "medium",
    values: ~w(small medium large),
    doc: "Gap between sidebar and main: small, medium (default), large"
  )

  attr(:class, :string, default: nil, doc: "Additional CSS classes")
  slot(:sidebar, required: true)
  slot(:main, required: true)

  @spec sidebar_layout(map()) :: Rendered.t()
  def sidebar_layout(assigns) do
    width_class =
      case assigns.sidebar_width do
        "narrow" ->
          "lg:w-48"

        "medium" ->
          "lg:w-64"

        "wide" ->
          "lg:w-80"

        invalid ->
          raise ArgumentError,
                "invalid sidebar_width value: #{inspect(invalid)}. Expected narrow, medium, or wide"
      end

    gap_class =
      case assigns.gap do
        "small" ->
          "gap-4"

        "medium" ->
          "gap-6"

        "large" ->
          "gap-8"

        invalid ->
          raise ArgumentError,
                "invalid gap value: #{inspect(invalid)}. Expected small, medium, or large"
      end

    assigns =
      assigns
      |> assign(:width_class, width_class)
      |> assign(:gap_class, gap_class)

    ~H"""
    <div class={["flex flex-col lg:flex-row", @gap_class, @class]}>
      <aside class={["w-full flex-shrink-0", @width_class]}>
        {render_slot(@sidebar)}
      </aside>
      <main class="flex-1 min-w-0">
        {render_slot(@main)}
      </main>
    </div>
    """
  end

  @doc """
  Full-width section with background.

  Use for distinct sections that span the full viewport width
  but contain centered content.

  ## Examples

      <.section>
        <.container>
          Content centered with max-width
        </.container>
      </.section>

      # Colored section
      <.section class="bg-muted">
        <.container>
          Highlighted section
        </.container>
      </.section>
  """
  attr(:class, :string, default: nil, doc: "Additional CSS classes")
  slot(:inner_block, required: true)

  @spec section(map()) :: Rendered.t()
  def section(assigns) do
    ~H"""
    <section class={["w-full", @class]}>
      {render_slot(@inner_block)}
    </section>
    """
  end
end
