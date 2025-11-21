defmodule UiKit.Components.Ui.DisplayMedia do
  @moduledoc """
  Display & Media components for content presentation.

  Components ported from shadcn/ui.
  """
  use Phoenix.Component

  alias Phoenix.LiveView.Rendered

  @doc """
  Renders a card container.

  The card component provides a flexible container for grouping related content.
  Use with the card_* sub-components for consistent structure.

  ## Examples

      <.card>
        <.card_header>
          <.card_title>Card Title</.card_title>
          <.card_description>Card description text</.card_description>
        </.card_header>
        <.card_content>
          Main content goes here
        </.card_content>
        <.card_footer>
          <.button>Action</.button>
        </.card_footer>
      </.card>

  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @spec card(map()) :: Rendered.t()
  def card(assigns) do
    ~H"""
    <div
      class={[
        "bg-card text-card-foreground flex flex-col gap-6 rounded-xl border border-border py-6 shadow-sm",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a card header section.

  Contains the card title, description, and optional action element.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @spec card_header(map()) :: Rendered.t()
  def card_header(assigns) do
    ~H"""
    <div
      class={[
        "grid auto-rows-min grid-rows-[auto_auto] items-start gap-2 px-6",
        "has-[[data-card-action]]:grid-cols-[1fr_auto]",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a card title.

  Typically used within card_header.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @spec card_title(map()) :: Rendered.t()
  def card_title(assigns) do
    ~H"""
    <div class={["leading-none font-semibold text-foreground", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a card description.

  Typically used within card_header, below the card_title.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @spec card_description(map()) :: Rendered.t()
  def card_description(assigns) do
    ~H"""
    <div class={["text-muted-foreground text-sm", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a card action element.

  Positioned in the top-right corner of the card header.
  Use for actions like a close button or menu.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @spec card_action(map()) :: Rendered.t()
  def card_action(assigns) do
    ~H"""
    <div
      data-card-action
      class={[
        "col-start-2 row-span-2 row-start-1 self-start justify-self-end",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders the main card content area.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @spec card_content(map()) :: Rendered.t()
  def card_content(assigns) do
    ~H"""
    <div class={["px-6", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a card footer section.

  Typically used for action buttons or secondary information.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @spec card_footer(map()) :: Rendered.t()
  def card_footer(assigns) do
    ~H"""
    <div class={["flex items-center px-6", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders an avatar container.

  An image element with a fallback for representing the user.
  Use with avatar_image and avatar_fallback sub-components.

  ## Examples

      <.avatar aria_label="John Doe">
        <.avatar_image src="https://github.com/shadcn.png" alt="@shadcn" />
        <.avatar_fallback>CN</.avatar_fallback>
      </.avatar>

      <%!-- Square avatar with rounded corners --%>
      <.avatar class="rounded-lg" aria_label="Emily Roberts">
        <.avatar_image src="..." alt="..." />
        <.avatar_fallback>ER</.avatar_fallback>
      </.avatar>

  """
  attr :aria_label, :string, default: nil, doc: "Accessible label for screen readers"
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @spec avatar(map()) :: Rendered.t()
  def avatar(assigns) do
    ~H"""
    <div
      data-slot="avatar"
      aria-label={@aria_label}
      class={[
        "relative flex size-8 shrink-0 overflow-hidden rounded-full",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders an avatar image.

  Displays the user's profile image. If the image fails to load,
  the avatar_fallback will be shown instead.

  ## Attributes

  - `src` - Image URL (required)
  - `alt` - Alternative text for accessibility (required)
  """
  attr :src, :string, required: true
  attr :alt, :string, required: true
  attr :class, :string, default: nil
  attr :rest, :global

  @spec avatar_image(map()) :: Rendered.t()
  def avatar_image(assigns) do
    ~H"""
    <img
      data-slot="avatar-image"
      src={@src}
      alt={@alt}
      class={["aspect-square size-full", @class]}
      {@rest}
    />
    """
  end

  @doc """
  Renders an avatar fallback.

  Displays fallback content (typically initials) when the avatar image
  fails to load or is not available.

  ## Examples

      <.avatar_fallback>JD</.avatar_fallback>
      <.avatar_fallback class="bg-primary text-primary-foreground">AB</.avatar_fallback>

  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @spec avatar_fallback(map()) :: Rendered.t()
  def avatar_fallback(assigns) do
    ~H"""
    <div
      data-slot="avatar-fallback"
      class={[
        "bg-muted flex size-full items-center justify-center rounded-full",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a responsive table container.

  A flexible table component for displaying tabular data with semantic HTML structure.
  Use with table_* sub-components for consistent styling and accessibility.

  By default, tables are horizontally scrollable when content overflows.

  ## Examples

      <.table>
        <.table_caption>A list of your recent invoices.</.table_caption>
        <.table_header>
          <.table_row>
            <.table_head>Invoice</.table_head>
            <.table_head>Status</.table_head>
            <.table_head>Amount</.table_head>
          </.table_row>
        </.table_header>
        <.table_body>
          <.table_row>
            <.table_cell>INV001</.table_cell>
            <.table_cell>Paid</.table_cell>
            <.table_cell>$250.00</.table_cell>
          </.table_row>
        </.table_body>
      </.table>

      <%!-- Striped table for better readability --%>
      <.table striped>
        ...
      </.table>

      <%!-- Disable horizontal scrolling if needed --%>
      <.table x_overflow={false}>
        ...
      </.table>

  """
  attr :class, :string, default: nil
  attr :container_class, :string, default: nil, doc: "Additional classes for the table container wrapper"
  attr :striped, :boolean, default: false
  attr :x_overflow, :boolean, default: true, doc: "Enable horizontal scrolling when table overflows (default: true)"
  attr :rest, :global
  slot :inner_block, required: true

  @spec table(map()) :: Rendered.t()
  def table(assigns) do
    ~H"""
    <div
      data-slot="table-container"
      class={[
        "relative w-full",
        if(@x_overflow, do: "overflow-x-auto", else: nil),
        @container_class
      ]}
    >
      <table
        data-slot="table"
        data-striped={if @striped, do: "true", else: "false"}
        class={["w-full caption-bottom text-sm text-foreground", @class]}
        {@rest}
      >
        {render_slot(@inner_block)}
      </table>
    </div>
    """
  end

  @doc """
  Renders a table header section.

  Contains the header rows with column titles.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @spec table_header(map()) :: Rendered.t()
  def table_header(assigns) do
    ~H"""
    <thead data-slot="table-header" class={["[&_tr]:border-b", @class]} {@rest}>
      {render_slot(@inner_block)}
    </thead>
    """
  end

  @doc """
  Renders a table body section.

  Contains the main data rows of the table.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @spec table_body(map()) :: Rendered.t()
  def table_body(assigns) do
    ~H"""
    <tbody data-slot="table-body" class={["[&_tr:last-child]:border-0", @class]} {@rest}>
      {render_slot(@inner_block)}
    </tbody>
    """
  end

  @doc """
  Renders a table footer section.

  Typically used for summary rows or totals.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @spec table_footer(map()) :: Rendered.t()
  def table_footer(assigns) do
    ~H"""
    <tfoot
      data-slot="table-footer"
      class={["bg-muted/50 border-t font-bold [&>tr]:last:border-b-0", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </tfoot>
    """
  end

  @doc """
  Renders a table row.

  Contains table cells (table_head or table_cell).
  Supports hover effects and selected state.
  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @spec table_row(map()) :: Rendered.t()
  def table_row(assigns) do
    ~H"""
    <tr
      data-slot="table-row"
      class={[
        "hover:bg-muted/50 data-[state=selected]:bg-muted border-b transition-colors",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </tr>
    """
  end

  @doc """
  Renders a table header cell.

  Used within table_header rows to define column titles.

  ## Examples

      <.table_head>Name</.table_head>
      <.table_head class="text-right">Amount</.table_head>

  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @spec table_head(map()) :: Rendered.t()
  def table_head(assigns) do
    ~H"""
    <th
      data-slot="table-head"
      class={[
        "h-10 px-2 text-left align-middle font-bold whitespace-nowrap [&:has([role=checkbox])]:pr-0 [&>[role=checkbox]]:translate-y-[2px]",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </th>
    """
  end

  @doc """
  Renders a table data cell.

  Used within table_body rows to display data.

  ## Examples

      <.table_cell>John Doe</.table_cell>
      <.table_cell class="text-right">$100.00</.table_cell>

  """
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(colspan rowspan)
  slot :inner_block, required: true

  @spec table_cell(map()) :: Rendered.t()
  def table_cell(assigns) do
    ~H"""
    <td
      data-slot="table-cell"
      class={[
        "p-2 align-middle whitespace-nowrap [&:has([role=checkbox])]:pr-0 [&>[role=checkbox]]:translate-y-[2px]",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </td>
    """
  end

  @doc """
  Renders a table caption.

  Provides a descriptive caption for the table, typically displayed below the table.

  ## Examples

      <.table_caption>A list of your recent invoices.</.table_caption>

  """
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  @spec table_caption(map()) :: Rendered.t()
  def table_caption(assigns) do
    ~H"""
    <caption data-slot="table-caption" class={["text-muted-foreground mt-4 text-sm", @class]} {@rest}>
      {render_slot(@inner_block)}
    </caption>
    """
  end

  @doc """
  Renders a Chart.js chart.

  A responsive chart component powered by Chart.js. Supports all Chart.js chart types
  including bar, line, pie, doughnut, radar, and polar area charts.

  The component automatically applies theme colors for a consistent look with your design system.

  ## Configuration

  The `config` attribute should be a map that follows the Chart.js configuration structure:

  - `type` - The chart type (e.g., "bar", "line", "pie", "doughnut", "radar", "polarArea")
  - `data` - Chart data including labels and datasets
  - `options` - Chart.js options for customization (optional)

  ## Examples

      <%!-- Simple bar chart --%>
      <.chart
        id="sales-chart"
        config={%{
          type: "bar",
          data: %{
            labels: ["Jan", "Feb", "Mar", "Apr", "May"],
            datasets: [%{
              label: "Sales",
              data: [12, 19, 3, 5, 2],
              backgroundColor: "rgb(59, 130, 246)"
            }]
          },
          options: %{
            responsive: true,
            maintainAspectRatio: false
          }
        }}
      />

      <%!-- Line chart with multiple datasets --%>
      <.chart
        id="revenue-chart"
        config={%{
          type: "line",
          data: %{
            labels: ["Jan", "Feb", "Mar"],
            datasets: [
              %{
                label: "Revenue",
                data: [30, 45, 38],
                borderColor: "rgb(59, 130, 246)",
                tension: 0.1
              },
              %{
                label: "Expenses",
                data: [20, 25, 22],
                borderColor: "rgb(239, 68, 68)",
                tension: 0.1
              }
            ]
          }
        }}
      />

      <%!-- Pie chart --%>
      <.chart
        id="distribution-chart"
        config={%{
          type: "pie",
          data: %{
            labels: ["Red", "Blue", "Yellow"],
            datasets: [%{
              data: [300, 50, 100],
              backgroundColor: [
                "rgb(239, 68, 68)",
                "rgb(59, 130, 246)",
                "rgb(234, 179, 8)"
              ]
            }]
          }
        }}
      />

      <%!-- Chart in a card with custom height --%>
      <.card>
        <.card_header>
          <.card_title>Sales Overview</.card_title>
          <.card_description>Monthly sales data</.card_description>
        </.card_header>
        <.card_content>
          <.chart id="card-chart" class="h-[300px]" config={@chart_config} />
        </.card_content>
      </.card>

  ## Dynamic Updates

  You can update the chart data from your LiveView by:

  1. Reassigning the config and letting LiveView handle the update automatically
  2. Using the `chart-update` push event for more control

  ### Method 1: Automatic update via assign

      # In your LiveView
      def handle_event("refresh", _params, socket) do
        new_config = %{
          type: "bar",
          data: %{
            labels: ["Jan", "Feb", "Mar"],
            datasets: [%{
              label: "Updated",
              data: [10, 20, 30]
            }]
          }
        }

        {:noreply, assign(socket, chart_config: new_config)}
      end

  ### Method 2: Push event (advanced)

      # In your LiveView
      def handle_event("refresh", _params, socket) do
        new_config = %{...}

        {:noreply, push_event(socket, "chart-update", new_config)}
      end

  ## Styling

  The chart automatically inherits theme colors for text, borders, and tooltips.
  You can customize the appearance by:

  - Setting the `class` attribute (e.g., `class="h-[400px]"` for height)
  - Providing custom colors in the dataset configuration
  - Using Chart.js options for advanced customization

  ## Notes

  - Always provide a unique `id` for each chart
  - Set `maintainAspectRatio: false` in options and use a height class for better control
  - The canvas uses `phx-update="ignore"` to prevent LiveView from re-rendering the chart
  - Charts automatically respond to theme changes (light/dark mode)

  """
  attr :id, :string, required: true, doc: "Unique identifier for the chart"
  attr :config, :map, required: true, doc: "Chart.js configuration map"
  attr :class, :string, default: nil, doc: "Additional CSS classes for the canvas container"
  attr :rest, :global

  @spec chart(map()) :: Rendered.t()
  def chart(assigns) do
    # Encode the config as JSON for the JavaScript hook
    assigns = assign(assigns, :config_json, Jason.encode!(assigns.config))

    ~H"""
    <div class={["relative w-full h-full", @class]} {@rest}>
      <canvas
        id={@id}
        phx-hook="Chart"
        phx-update="ignore"
        data-chart-config={@config_json}
      >
      </canvas>
    </div>
    """
  end
end
