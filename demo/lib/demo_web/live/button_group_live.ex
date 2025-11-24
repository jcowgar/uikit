defmodule DemoWeb.Ui.ButtonGroupLive do
  @moduledoc """
  Demo page for ButtonGroup components
  """
  use DemoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.container>
      <.stack size="xxl">
        <%!-- Page Header --%>
        <div>
          <h1 class="text-3xl font-bold">Button Group</h1>
          <p class="mt-2 text-muted-foreground">
            A container that groups related buttons together with consistent styling.
          </p>
        </div>

        <%!-- Basic Example --%>
        <.card>
          <.card_header>
            <.card_title>Basic Button Group</.card_title>
            <.card_description>
              Horizontal button group with outline buttons
            </.card_description>
          </.card_header>
          <.card_content>
            <.button_group>
              <.button variant="outline">First</.button>
              <.button variant="outline">Second</.button>
              <.button variant="outline">Third</.button>
            </.button_group>
          </.card_content>
        </.card>

        <%!-- Vertical Orientation --%>
        <.card>
          <.card_header>
            <.card_title>Vertical Orientation</.card_title>
            <.card_description>
              Stack buttons vertically with proper border handling
            </.card_description>
          </.card_header>
          <.card_content>
            <.button_group orientation="vertical">
              <.button variant="outline">Top</.button>
              <.button variant="outline">Middle</.button>
              <.button variant="outline">Bottom</.button>
            </.button_group>
          </.card_content>
        </.card>

        <%!-- With Separators --%>
        <.card>
          <.card_header>
            <.card_title>With Separators</.card_title>
            <.card_description>
              Use separators to visually divide groups of related actions
            </.card_description>
          </.card_header>
          <.card_content>
            <.stack size="small">
              <%!-- Horizontal group with vertical separator --%>
              <div>
                <p class="text-sm text-muted-foreground mb-2">Editing Tools</p>
                <.button_group>
                  <.button variant="outline">Undo</.button>
                  <.button variant="outline">Redo</.button>
                  <.button_group_separator />
                  <.button variant="outline">Cut</.button>
                  <.button variant="outline">Copy</.button>
                  <.button variant="outline">Paste</.button>
                </.button_group>
              </div>

              <%!-- Vertical group with horizontal separator --%>
              <div>
                <p class="text-sm text-muted-foreground mb-2">View Options</p>
                <.button_group orientation="vertical">
                  <.button variant="outline">Grid View</.button>
                  <.button variant="outline">List View</.button>
                  <.button_group_separator orientation="horizontal" />
                  <.button variant="outline">Settings</.button>
                </.button_group>
              </div>
            </.stack>
          </.card_content>
        </.card>

        <%!-- With Text Elements --%>
        <.card>
          <.card_header>
            <.card_title>With Text Elements</.card_title>
            <.card_description>
              Include non-interactive text labels or status indicators
            </.card_description>
          </.card_header>
          <.card_content>
            <.stack size="small">
              <.button_group>
                <.button_group_text>Format:</.button_group_text>
                <.button variant="outline">
                  <.icon name="hero-bold" class="size-4" />
                </.button>
                <.button variant="outline">
                  <.icon name="hero-italic" class="size-4" />
                </.button>
                <.button variant="outline">
                  <.icon name="hero-underline" class="size-4" />
                </.button>
              </.button_group>

              <.button_group>
                <.button variant="outline">Start</.button>
                <.button_group_text>Status: Running</.button_group_text>
                <.button variant="outline">Stop</.button>
              </.button_group>
            </.stack>
          </.card_content>
        </.card>

        <%!-- Nested Groups --%>
        <.card>
          <.card_header>
            <.card_title>Nested Groups</.card_title>
            <.card_description>
              Multiple button groups with automatic spacing
            </.card_description>
          </.card_header>
          <.card_content>
            <.button_group>
              <.button_group>
                <.button variant="outline">Bold</.button>
                <.button variant="outline">Italic</.button>
                <.button variant="outline">Underline</.button>
              </.button_group>
              <.button_group>
                <.button variant="outline">
                  <.icon name="hero-link" class="size-4" />
                </.button>
                <.button variant="outline">
                  <.icon name="hero-photo" class="size-4" />
                </.button>
              </.button_group>
              <.button_group>
                <.button variant="outline">
                  <.icon name="hero-list-bullet" class="size-4" />
                </.button>
                <.button variant="outline">
                  <.icon name="hero-numbered-list" class="size-4" />
                </.button>
              </.button_group>
            </.button_group>
          </.card_content>
        </.card>

        <%!-- Mixed Button Variants --%>
        <.card>
          <.card_header>
            <.card_title>Mixed Variants</.card_title>
            <.card_description>
              Combine different button variants in a group
            </.card_description>
          </.card_header>
          <.card_content>
            <.stack size="small">
              <.button_group>
                <.button variant="default">Primary</.button>
                <.button variant="secondary">Secondary</.button>
                <.button variant="outline">Outline</.button>
              </.button_group>

              <.button_group>
                <.button variant="destructive">Delete</.button>
                <.button variant="outline">Cancel</.button>
              </.button_group>
            </.stack>
          </.card_content>
        </.card>

        <%!-- With Input Elements --%>
        <.card>
          <.card_header>
            <.card_title>With Input Elements</.card_title>
            <.card_description>
              Combine buttons with inputs and other form elements
            </.card_description>
          </.card_header>
          <.card_content>
            <.stack size="small">
              <.button_group>
                <.input type="text" placeholder="Search..." class="w-64" />
                <.button variant="outline">
                  <.icon name="hero-magnifying-glass" class="size-4" />
                </.button>
              </.button_group>

              <.button_group>
                <.button variant="outline">
                  <.icon name="hero-minus" class="size-4" />
                </.button>
                <.input type="text" value="1" class="w-20 text-center" />
                <.button variant="outline">
                  <.icon name="hero-plus" class="size-4" />
                </.button>
              </.button_group>
            </.stack>
          </.card_content>
        </.card>

        <%!-- Button Sizes in Groups --%>
        <.card>
          <.card_header>
            <.card_title>Button Sizes</.card_title>
            <.card_description>
              Different button sizes within groups
            </.card_description>
          </.card_header>
          <.card_content>
            <.stack size="small">
              <div>
                <p class="text-sm text-muted-foreground mb-2">Small</p>
                <.button_group>
                  <.button variant="outline" size="sm">Small 1</.button>
                  <.button variant="outline" size="sm">Small 2</.button>
                  <.button variant="outline" size="sm">Small 3</.button>
                </.button_group>
              </div>

              <div>
                <p class="text-sm text-muted-foreground mb-2">Default</p>
                <.button_group>
                  <.button variant="outline">Default 1</.button>
                  <.button variant="outline">Default 2</.button>
                  <.button variant="outline">Default 3</.button>
                </.button_group>
              </div>

              <div>
                <p class="text-sm text-muted-foreground mb-2">Large</p>
                <.button_group>
                  <.button variant="outline" size="lg">Large 1</.button>
                  <.button variant="outline" size="lg">Large 2</.button>
                  <.button variant="outline" size="lg">Large 3</.button>
                </.button_group>
              </div>
            </.stack>
          </.card_content>
        </.card>

        <%!-- Real-world Examples --%>
        <.card>
          <.card_header>
            <.card_title>Real-world Examples</.card_title>
            <.card_description>
              Common button group patterns used in applications
            </.card_description>
          </.card_header>
          <.card_content>
            <.stack size="medium">
              <%!-- Alignment controls --%>
              <div>
                <p class="text-sm text-muted-foreground mb-2">Text Alignment</p>
                <.button_group>
                  <.button variant="outline">
                    <.icon name="hero-bars-3-bottom-left" class="size-4" />
                  </.button>
                  <.button variant="outline">
                    <.icon name="hero-bars-3" class="size-4" />
                  </.button>
                  <.button variant="outline">
                    <.icon name="hero-bars-3-bottom-right" class="size-4" />
                  </.button>
                  <.button variant="outline">
                    <.icon name="hero-bars-4" class="size-4" />
                  </.button>
                </.button_group>
              </div>

              <%!-- Pagination --%>
              <div>
                <p class="text-sm text-muted-foreground mb-2">Pagination</p>
                <.button_group>
                  <.button variant="outline">
                    <.icon name="hero-chevron-double-left" class="size-4" />
                  </.button>
                  <.button variant="outline">
                    <.icon name="hero-chevron-left" class="size-4" />
                  </.button>
                  <.button_group_text>Page 3 of 10</.button_group_text>
                  <.button variant="outline">
                    <.icon name="hero-chevron-right" class="size-4" />
                  </.button>
                  <.button variant="outline">
                    <.icon name="hero-chevron-double-right" class="size-4" />
                  </.button>
                </.button_group>
              </div>

              <%!-- View switcher --%>
              <div>
                <p class="text-sm text-muted-foreground mb-2">View Switcher</p>
                <.button_group>
                  <.button variant="outline">
                    <.icon name="hero-squares-2x2" class="size-4" />
                    <span class="ml-1">Grid</span>
                  </.button>
                  <.button variant="outline">
                    <.icon name="hero-list-bullet" class="size-4" />
                    <span class="ml-1">List</span>
                  </.button>
                  <.button variant="outline">
                    <.icon name="hero-table-cells" class="size-4" />
                    <span class="ml-1">Table</span>
                  </.button>
                </.button_group>
              </div>
            </.stack>
          </.card_content>
        </.card>
      </.stack>
    </.container>
    """
  end
end
