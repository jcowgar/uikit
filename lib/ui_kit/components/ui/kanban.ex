defmodule UiKit.Components.Ui.Kanban do
  @moduledoc """
  Kanban board components for task management and workflow visualization.

  A drag-and-drop enabled kanban board built on Sortable.js with full theme support.
  Provides composable components for building flexible kanban layouts with optional swimlanes
  for multi-dimensional organization.

  ## Examples

      # Basic kanban without swimlanes
      <.kanban id="project-board">
        <.kanban_column title="To Do" id="todo" count={5}>
          <.kanban_card id="card-1" title="Write documentation">
            <:content>Need to document the new API</:content>
            <:footer><.badge>High Priority</.badge></:footer>
          </.kanban_card>
        </.kanban_column>

        <.kanban_column title="In Progress" id="in-progress">
          <.kanban_card id="card-2" title="Fix bug" />
        </.kanban_column>
      </.kanban>

      # Kanban with swimlanes for team-based organization
      <.kanban id="team-board">
        <.kanban_swimlane title="Team Alpha" id="team-alpha">
          <.kanban_column title="To Do" id="alpha-todo">
            <.kanban_card id="card-1" title="Task 1" />
          </.kanban_column>
          <.kanban_column title="Done" id="alpha-done">
            <.kanban_card id="card-2" title="Task 2" />
          </.kanban_column>
        </.kanban_swimlane>

        <.kanban_swimlane title="Team Beta" id="team-beta">
          <.kanban_column title="To Do" id="beta-todo">
            <.kanban_card id="card-3" title="Task 3" />
          </.kanban_column>
        </.kanban_swimlane>
      </.kanban>

  ## Drag and Drop

  The kanban uses the Sortable.js hook for drag-and-drop functionality. When cards are
  moved between columns or reordered within a column, a "reorder" event is sent to the
  server with the following params:

      %{
        "order" => ["card-1", "card-2", ...],  # New order of all cards in target column
        "item" => "card-1",                     # ID of the card that was moved
        "from" => "source-column-id",           # ID of source column
        "to" => "target-column-id",             # ID of target column
        "oldIndex" => 0,                        # Old position in source
        "newIndex" => 1                         # New position in target
      }

  Handle this event in your LiveView:

      def handle_event("reorder", params, socket) do
        %{
          "item" => card_id,
          "from" => from_column,
          "to" => to_column,
          "newIndex" => new_index
        } = params

        # Update your data based on the move
        # e.g., update card position/status in database

        {:noreply, socket}
      end

  """
  use Phoenix.Component

  import UiKit.Components.CoreComponents, only: [icon: 1]
  import UiKit.Components.Ui.DisplayMedia, only: [card: 1, card_header: 1, card_content: 1]
  import UiKit.Components.LayoutComponents, only: [flex: 1, stack: 1]

  alias Phoenix.LiveView.Rendered

  @doc """
  Renders a kanban board container.

  Provides a scrolling container for kanban columns or swimlanes.
  When used with kanban_column components directly, displays columns horizontally.
  When used with kanban_swimlane components, displays swimlanes vertically with
  columns arranged horizontally within each swimlane.

  ## Attributes

  - `id` - Unique identifier for the board (required)
  - `class` - Additional CSS classes

  ## Slots

  - `headers` - Optional column headers that appear above all swimlanes
  - `inner_block` - Kanban columns or swimlanes (required)

  """
  attr(:id, :string, required: true)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:headers, doc: "Column headers for swimlane boards")
  slot(:inner_block, required: true)

  @spec kanban(map()) :: Rendered.t()
  def kanban(assigns) do
    ~H"""
    <div
      id={@id}
      class={[
        "kanban-board h-full w-full overflow-auto pb-4",
        @class
      ]}
      {@rest}
    >
      <%= if @headers != [] do %>
        <.flex gap="lg" class="kanban-column-headers px-4 py-4 sticky top-0 bg-background z-20 border-b border-border">
          {render_slot(@headers)}
        </.flex>
      <% end %>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a kanban swimlane.

  A horizontal grouping of kanban columns, allowing for multi-dimensional organization.
  Swimlanes are useful for grouping tasks by team, priority, project, or any other category.
  Each swimlane includes a collapse/expand toggle button for managing visibility.

  ## Attributes

  - `id` - Unique identifier for the swimlane (required)
  - `title` - Swimlane heading text (required)
  - `collapsed` - Whether the swimlane is collapsed (default: false)
  - `class` - Additional CSS classes

  ## Slots

  - `header` - Optional custom header content (replaces default title, but toggle button is still shown)
  - `actions` - Optional action buttons or controls in header
  - `inner_block` - Columns within the swimlane (required)

  ## Collapsing

  By default, swimlanes handle collapse/expand **on the client-side** with localStorage persistence.
  This means no server roundtrip is needed, and the state persists across page reloads.

  ### Client-side collapse (default)

  The collapse state is managed in the browser and persisted to localStorage:

      <.kanban_swimlane title="Team Alpha" id="team-alpha">
        <%!-- Collapse state managed client-side automatically --%>
      </.kanban_swimlane>

  ### Server-side collapse (opt-in)

  If you need server-managed state (e.g., to sync across sessions or devices), set `server_collapse={true}`:

      <.kanban_swimlane title="Team Alpha" id="team-alpha" server_collapse={true} collapsed={@collapsed}>
        <%!-- State managed on server --%>
      </.kanban_swimlane>

  Then handle the "toggle-swimlane" event in your LiveView:

      def handle_event("toggle-swimlane", %{"id" => swimlane_id}, socket) do
        # Toggle the collapsed state for this swimlane
        {:noreply, update_collapsed_state(socket, swimlane_id)}
      end

  ## Examples

      <.kanban id="project-board">
        <.kanban_swimlane title="Team Alpha" id="team-alpha">
          <.kanban_column title="To Do" id="alpha-todo">
            <.kanban_card id="card-1" title="Task 1" />
          </.kanban_column>
          <.kanban_column title="Done" id="alpha-done">
            <.kanban_card id="card-2" title="Task 2" />
          </.kanban_column>
        </.kanban_swimlane>

        <.kanban_swimlane title="Team Beta" id="team-beta">
          <.kanban_column title="To Do" id="beta-todo">
            <.kanban_card id="card-3" title="Task 3" />
          </.kanban_column>
        </.kanban_swimlane>
      </.kanban>

  """
  attr(:id, :string, required: true)
  attr(:title, :string, required: true)
  attr(:collapsed, :boolean, default: false)

  attr(:server_collapse, :boolean,
    default: false,
    doc: "Set to true to handle collapse state on the server instead of client-side"
  )

  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:header, doc: "Optional custom header content")
  slot(:actions, doc: "Optional action buttons or controls")
  slot(:inner_block, required: true)

  @spec kanban_swimlane(map()) :: Rendered.t()
  def kanban_swimlane(assigns) do
    ~H"""
    <div
      id={@id}
      phx-hook="KanbanSwimlane"
      data-server-collapse={to_string(@server_collapse)}
      class={[
        "kanban-swimlane",
        @class
      ]}
      {@rest}
    >
      <div class="inline-flex flex-col min-w-full">
        <div class={[
          "kanban-swimlane-header py-2 px-4 w-full border-t border-border",
          @collapsed && "border-b"
        ]}>
          <.flex gap="md" class="w-full">
            <.flex gap="sm" class="sticky left-4 bg-background z-10">
              <button
              type="button"
              data-swimlane-toggle
              phx-click={@server_collapse && "toggle-swimlane"}
              phx-value-id={@server_collapse && @id}
              class="text-muted-foreground hover:text-foreground transition-colors"
              aria-label={(@collapsed && "Expand swimlane") || "Collapse swimlane"}
              aria-expanded={!@collapsed}
            >
              <span data-swimlane-icon class="transition-transform duration-200 inline-block">
                <.icon
                  name={(@collapsed && "hero-chevron-right") || "hero-chevron-down"}
                  class="h-4 w-4"
                />
              </span>
            </button>

            <%= if @header != [] do %>
              {render_slot(@header)}
            <% else %>
              <span class="text-xs font-medium text-muted-foreground uppercase tracking-wider">
                {@title}
              </span>
            <% end %>
            </.flex>

            <%= if @actions != [] do %>
              <.flex gap="sm" class="sticky right-4 bg-background z-10 ml-auto">
                {render_slot(@actions)}
              </.flex>
            <% end %>
          </.flex>
        </div>

        <.flex
          data-swimlane-content
          gap="lg"
          class={[
            "px-4 pt-4 pb-4 w-full border-b border-border",
            @collapsed && "hidden"
          ]}
        >
          {render_slot(@inner_block)}
        </.flex>
      </div>
    </div>
    """
  end

  @doc """
  Renders a kanban column.

  A vertical container for kanban cards with drag-and-drop support.
  Cards can be dragged within the column or between columns.

  ## Attributes

  - `id` - Unique identifier for the column (required)
  - `title` - Column heading text (required)
  - `count` - Optional count badge to display next to title
  - `width` - Column width, defaults to "w-80" (320px)
  - `min_height` - Minimum height for empty columns, defaults to "200px"
  - `show_header` - Whether to show the column header (default: true)
  - `class` - Additional CSS classes

  ## Slots

  - `header` - Optional custom header content (replaces default title/count)
  - `inner_block` - Card contents (required)

  """
  attr(:id, :string, required: true)
  attr(:title, :string, required: true)
  attr(:count, :integer, default: nil)
  attr(:width, :string, default: "w-80")
  attr(:min_height, :string, default: "200px")
  attr(:show_header, :boolean, default: true)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:header, doc: "Optional custom header content")
  slot(:inner_block, required: true)

  @spec kanban_column(map()) :: Rendered.t()
  def kanban_column(assigns) do
    ~H"""
    <div class={["flex flex-col flex-shrink-0 h-full", @width, @class]} {@rest}>
      <%= if @show_header do %>
        <%= if @header != [] do %>
          <div class="mb-4 flex-shrink-0">
            {render_slot(@header)}
          </div>
        <% else %>
          <div class="mb-4 flex-shrink-0">
            <.flex gap="sm">
              <h3 class="font-semibold text-foreground">{@title}</h3>
              <%= if @count do %>
                <span class="inline-flex items-center justify-center rounded-full bg-muted px-2 py-0.5 text-xs font-medium text-muted-foreground">
                  {@count}
                </span>
              <% end %>
            </.flex>
          </div>
        <% end %>
      <% end %>
      <.stack
        gap="default"
        class="flex-1 overflow-y-auto"
        id={@id}
        phx-hook="Sortable"
        data-group="kanban-cards"
        data-handle=".kanban-drag-handle"
        style={"min-height: #{@min_height}"}
      >
        {render_slot(@inner_block)}
      </.stack>
    </div>
    """
  end

  @doc """
  Renders a kanban card.

  A draggable card component for kanban boards. Can be customized with various slots
  for flexible content structure.

  ## Attributes

  - `id` - Unique identifier for the card (required, used for drag-and-drop)
  - `title` - Card title text
  - `draggable` - Whether the card can be dragged (default: true)
  - `width` - Card width override (inherits from column by default)
  - `class` - Additional CSS classes

  ## Slots

  - `header` - Custom header content (replaces title)
  - `content` - Main card body content
  - `footer` - Footer content (badges, actions, etc.)
  - `inner_block` - Alternative to using named slots (simpler usage)

  ## Examples

      <%!-- Simple card with just title --%>
      <.kanban_card id="card-1" title="Task name" />

      <%!-- Card with all slots --%>
      <.kanban_card id="card-2" title="Complex task">
        <:content>
          <p>Task description here</p>
        </:content>
        <:footer>
          <.badge variant="success">Done</.badge>
        </:footer>
      </.kanban_card>

      <%!-- Custom content using inner_block --%>
      <.kanban_card id="card-3">
        <div class="custom-layout">
          Custom card content
        </div>
      </.kanban_card>

  """
  attr(:id, :string, required: true)
  attr(:title, :string, default: nil)
  attr(:draggable, :boolean, default: true)
  attr(:width, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:header, doc: "Custom header content")
  slot(:content, doc: "Main card content")
  slot(:footer, doc: "Footer content")
  slot(:inner_block, doc: "Alternative to using named slots")

  @spec kanban_card(map()) :: Rendered.t()
  def kanban_card(assigns) do
    assigns =
      assign(
        assigns,
        :card_class,
        build_card_class(assigns.class)
      )

    ~H"""
    <div
      data-id={@id}
      class={[
        "group",
        @width,
        @draggable && "cursor-grab active:cursor-grabbing"
      ]}
    >
      <.card class={@card_class} {@rest}>
        <%= if @draggable do %>
          <div class="kanban-drag-handle absolute left-2 top-2 opacity-0 transition-opacity group-hover:opacity-100">
            <.icon name="hero-bars-3" class="h-4 w-4 text-muted-foreground" />
          </div>
        <% end %>

        <%= if @header != [] or @title do %>
          <.card_header class={@draggable && "pl-10"}>
            <%= if @header != [] do %>
              {render_slot(@header)}
            <% else %>
              <div class="font-semibold text-foreground leading-none">
                {@title}
              </div>
            <% end %>
          </.card_header>
        <% end %>

        <%= if @content != [] do %>
          <.card_content>
            {render_slot(@content)}
          </.card_content>
        <% end %>

        <%= if @footer != [] do %>
          <.flex gap="sm" class="px-6 pb-0">
            {render_slot(@footer)}
          </.flex>
        <% end %>

        <%= if @inner_block != [] do %>
          <div class={["px-6", @draggable && "pl-10"]}>
            {render_slot(@inner_block)}
          </div>
        <% end %>
      </.card>
    </div>
    """
  end

  @doc """
  Renders a column header for swimlane boards.

  Use this within the `headers` slot of a kanban board to define column headers
  that appear above all swimlanes.

  ## Attributes

  - `title` - Column heading text (required)
  - `count` - Optional count badge to display next to title
  - `width` - Column width, should match the column width (defaults to "w-80")
  - `class` - Additional CSS classes

  """
  attr(:title, :string, required: true)
  attr(:count, :integer, default: nil)
  attr(:width, :string, default: "w-80")
  attr(:class, :string, default: nil)

  @spec kanban_column_header(map()) :: Rendered.t()
  def kanban_column_header(assigns) do
    ~H"""
    <div class={["flex-shrink-0", @width, @class]}>
      <.flex gap="sm">
        <h3 class="font-semibold text-foreground">{@title}</h3>
        <%= if @count do %>
          <span class="inline-flex items-center justify-center rounded-full bg-muted px-2 py-0.5 text-xs font-medium text-muted-foreground">
            {@count}
          </span>
        <% end %>
      </.flex>
    </div>
    """
  end

  @spec build_card_class(String.t() | nil) :: String.t()
  defp build_card_class(nil) do
    "relative transition-shadow hover:shadow-md"
  end

  defp build_card_class(custom_class) do
    "relative transition-shadow hover:shadow-md #{custom_class}"
  end
end
