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
  attr :max_width, :string,
    default: "7xl",
    values: ~w(sm md lg xl 2xl 3xl 4xl 5xl 6xl 7xl full),
    doc: "Maximum width: sm, md, lg, xl, 2xl, 3xl, 4xl, 5xl, 6xl, 7xl (default), full"

  attr :padding, :string,
    default: "default",
    values: ~w(none small default),
    doc: "Horizontal padding: none (no padding), small (px-4), default (px-4 sm:px-6 lg:px-8)"

  attr :class, :string, default: nil, doc: "Additional CSS classes"
  slot :inner_block, required: true

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
      "none" -> ""
      "small" -> "px-4"
      "default" -> "px-4 sm:px-6 lg:px-8"
      invalid -> raise ArgumentError, "invalid padding value: #{inspect(invalid)}. Expected none, small, or default"
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
      <.grid cols={2} gap="large">
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
  attr :cols, :integer, default: 3, doc: "Number of columns (1-6)"

  attr :gap, :string,
    default: "medium",
    values: ~w(xs small medium large xl),
    doc: "Gap size: xs, small, medium (default), large, xl"

  attr :class, :string, default: nil, doc: "Additional CSS classes"
  slot :inner_block, required: true

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

    gap_class =
      case assigns.gap do
        "xs" -> "gap-2"
        "small" -> "gap-4"
        "medium" -> "gap-6"
        "large" -> "gap-8"
        "xl" -> "gap-12"
        invalid -> raise ArgumentError, "invalid gap value: #{inspect(invalid)}. Expected xs, small, medium, large, or xl"
      end

    assigns =
      assigns
      |> assign(:col_classes, col_classes)
      |> assign(:gap_class, gap_class)

    ~H"""
    <div class={["grid", @col_classes, @gap_class, @class]}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Flex container for common alignment patterns.

  Provides simple props for the most common flex layouts without
  needing to remember Tailwind flex classes.

  ## Examples

      # Horizontal row, items centered
      <.flex align="center">
        <.icon name="hero-check" />
        <span>Success!</span>
      </.flex>

      # Horizontal row, space between (common for headers)
      <.flex align="between">
        <h1>Title</h1>
        <.button>Action</.button>
      </.flex>

      # Vertical column, centered
      <.flex direction="col" align="center">
        <.icon name="hero-inbox" class="size-12" />
        <p>No items yet</p>
      </.flex>

      # Horizontal with tight spacing
      <.flex gap="small">
        <.badge>New</.badge>
        <.badge>Featured</.badge>
      </.flex>
  """
  attr :direction, :string,
    default: "row",
    values: ~w(row col),
    doc: "Flex direction: row (horizontal) or col (vertical)"

  attr :align, :string,
    default: "start",
    values: ~w(start center end between),
    doc: "Alignment: start, center, end, or between (space-between)"

  attr :gap, :string,
    default: "medium",
    values: ~w(xs small medium large),
    doc: "Gap size: xs, small, medium (default), large"

  attr :class, :string, default: nil, doc: "Additional CSS classes"
  slot :inner_block, required: true

  @spec flex(map()) :: Rendered.t()
  def flex(assigns) do
    direction_class =
      case assigns.direction do
        "row" -> "flex-row"
        "col" -> "flex-col"
        invalid -> raise ArgumentError, "invalid direction value: #{inspect(invalid)}. Expected row or col"
      end

    align_class =
      case assigns.align do
        "start" ->
          "justify-start items-start"

        "center" ->
          "justify-center items-center"

        "end" ->
          "justify-end items-end"

        "between" ->
          "justify-between items-center"

        invalid ->
          raise ArgumentError, "invalid align value: #{inspect(invalid)}. Expected start, center, end, or between"
      end

    gap_class =
      case assigns.gap do
        "xs" -> "gap-1"
        "small" -> "gap-2"
        "medium" -> "gap-4"
        "large" -> "gap-6"
        invalid -> raise ArgumentError, "invalid gap value: #{inspect(invalid)}. Expected xs, small, medium, or large"
      end

    assigns =
      assigns
      |> assign(:direction_class, direction_class)
      |> assign(:align_class, align_class)
      |> assign(:gap_class, gap_class)

    ~H"""
    <div class={["flex", @direction_class, @align_class, @gap_class, @class]}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Vertical stack with consistent spacing between children.

  Use this instead of manually adding margins between elements.
  Creates consistent vertical rhythm.

  ## Examples

      <.stack>
        <.header>Title</.header>
        <.card>Content</.card>
        <.card>More content</.card>
      </.stack>

      # Larger spacing for major sections
      <.stack size="xl">
        <section>Section 1</section>
        <section>Section 2</section>
      </.stack>

      # Tighter spacing for related items
      <.stack size="small">
        <p>Line 1</p>
        <p>Line 2</p>
        <p>Line 3</p>
      </.stack>
  """
  attr :size, :string,
    default: "medium",
    values: ~w(xs small medium large xl xxl),
    doc: "Vertical spacing size: xs, small, medium (default), large, xl, xxl"

  attr :class, :string, default: nil, doc: "Additional CSS classes"
  slot :inner_block, required: true

  @spec stack(map()) :: Rendered.t()
  def stack(assigns) do
    size_class =
      case assigns.size do
        "xs" ->
          "space-y-2"

        "small" ->
          "space-y-4"

        "medium" ->
          "space-y-6"

        "large" ->
          "space-y-8"

        "xl" ->
          "space-y-12"

        "xxl" ->
          "space-y-16"

        invalid ->
          raise ArgumentError, "invalid size value: #{inspect(invalid)}. Expected xs, small, medium, large, xl, or xxl"
      end

    assigns = assign(assigns, :size_class, size_class)

    ~H"""
    <div class={[@size_class, @class]}>
      {render_slot(@inner_block)}
    </div>
    """
  end

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
  attr :sidebar_width, :string,
    default: "medium",
    values: ~w(narrow medium wide),
    doc: "Sidebar width: narrow (12rem), medium (16rem), wide (20rem)"

  attr :gap, :string,
    default: "medium",
    values: ~w(small medium large),
    doc: "Gap between sidebar and main: small, medium (default), large"

  attr :class, :string, default: nil, doc: "Additional CSS classes"
  slot :sidebar, required: true
  slot :main, required: true

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
          raise ArgumentError, "invalid sidebar_width value: #{inspect(invalid)}. Expected narrow, medium, or wide"
      end

    gap_class =
      case assigns.gap do
        "small" -> "gap-4"
        "medium" -> "gap-6"
        "large" -> "gap-8"
        invalid -> raise ArgumentError, "invalid gap value: #{inspect(invalid)}. Expected small, medium, or large"
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
  attr :class, :string, default: nil, doc: "Additional CSS classes"
  slot :inner_block, required: true

  @spec section(map()) :: Rendered.t()
  def section(assigns) do
    ~H"""
    <section class={["w-full", @class]}>
      {render_slot(@inner_block)}
    </section>
    """
  end
end
