defmodule DemoWeb.Ui.TooltipLive do
  @moduledoc false
  use DemoWeb, :live_view

  alias Phoenix.LiveView.Socket

  @impl true
  @spec mount(map(), map(), Socket.t()) ::
          {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.container>
      <.stack gap="xl">
        <%!-- Header --%>
        <div>
          <h1 class="text-3xl font-bold text-foreground">Tooltip Component</h1>
          <p class="text-muted-foreground mt-2">
            A popup that displays information related to an element when hovering or focusing.
          </p>
        </div>

        <%!-- Basic Example --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Basic Tooltip</h2>
          <.tooltip>
            <:trigger>
              <.button variant="outline">Hover me</.button>
            </:trigger>
            <:content>
              <p>Add to library</p>
            </:content>
          </.tooltip>
        </section>

        <%!-- Position Options --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Position Options</h2>
          <.flex justify="center" items="center" class="gap-4 flex-wrap">
            <.tooltip side="top">
              <:trigger>
                <.button variant="outline">Top</.button>
              </:trigger>
              <:content>Appears above</:content>
            </.tooltip>

            <.tooltip side="bottom">
              <:trigger>
                <.button variant="outline">Bottom</.button>
              </:trigger>
              <:content>Appears below</:content>
            </.tooltip>

            <.tooltip side="left">
              <:trigger>
                <.button variant="outline">Left</.button>
              </:trigger>
              <:content>Appears to the left</:content>
            </.tooltip>

            <.tooltip side="right">
              <:trigger>
                <.button variant="outline">Right</.button>
              </:trigger>
              <:content>Appears to the right</:content>
            </.tooltip>
          </.flex>
        </section>

        <%!-- Alignment Options --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Alignment Options</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Control how the tooltip aligns relative to the trigger element.
          </p>
          <.flex justify="center" items="center" class="gap-4 flex-wrap">
            <.tooltip side="bottom" align="start">
              <:trigger>
                <.button variant="outline">Align Start</.button>
              </:trigger>
              <:content>Aligned to start (left)</:content>
            </.tooltip>

            <.tooltip side="bottom" align="center">
              <:trigger>
                <.button variant="outline">Align Center</.button>
              </:trigger>
              <:content>Aligned to center</:content>
            </.tooltip>

            <.tooltip side="bottom" align="end">
              <:trigger>
                <.button variant="outline">Align End</.button>
              </:trigger>
              <:content>Aligned to end (right)</:content>
            </.tooltip>
          </.flex>
        </section>

        <%!-- With Icons --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Icon Tooltips</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Tooltips work great with icon buttons to provide accessible labels.
          </p>
          <.flex justify="center" items="center" class="gap-2">
            <.tooltip>
              <:trigger>
                <.button variant="ghost" size="icon">
                  <.icon name="hero-pencil" class="size-4" />
                </.button>
              </:trigger>
              <:content>Edit</:content>
            </.tooltip>

            <.tooltip>
              <:trigger>
                <.button variant="ghost" size="icon">
                  <.icon name="hero-document-duplicate" class="size-4" />
                </.button>
              </:trigger>
              <:content>Duplicate</:content>
            </.tooltip>

            <.tooltip>
              <:trigger>
                <.button variant="ghost" size="icon">
                  <.icon name="hero-trash" class="size-4" />
                </.button>
              </:trigger>
              <:content>Delete</:content>
            </.tooltip>

            <.tooltip>
              <:trigger>
                <.button variant="ghost" size="icon">
                  <.icon name="hero-information-circle" class="size-4" />
                </.button>
              </:trigger>
              <:content>More information</:content>
            </.tooltip>
          </.flex>
        </section>

        <%!-- With Delay --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">With Delay</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Add a delay before the tooltip appears using the <code class="text-xs bg-muted px-1 py-0.5 rounded">delay</code> attribute.
          </p>
          <.flex justify="center" items="center" class="gap-4">
            <.tooltip delay={0}>
              <:trigger>
                <.button variant="outline">No delay</.button>
              </:trigger>
              <:content>Appears immediately</:content>
            </.tooltip>

            <.tooltip delay={300}>
              <:trigger>
                <.button variant="outline">300ms delay</.button>
              </:trigger>
              <:content>Appears after 300ms</:content>
            </.tooltip>

            <.tooltip delay={500}>
              <:trigger>
                <.button variant="outline">500ms delay</.button>
              </:trigger>
              <:content>Appears after 500ms</:content>
            </.tooltip>
          </.flex>
        </section>

        <%!-- Rich Content --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Rich Content</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Tooltips can contain rich content including multiple lines of text.
          </p>
          <.flex justify="center" items="center" class="gap-4">
            <.tooltip>
              <:trigger>
                <.button variant="outline">
                  <.icon name="hero-calendar" class="size-4 mr-2" />
                  Schedule
                </.button>
              </:trigger>
              <:content>
                <p class="font-medium">Schedule Meeting</p>
                <p class="text-background/70">Set up a new calendar event</p>
              </:content>
            </.tooltip>

            <.tooltip>
              <:trigger>
                <span class="underline decoration-dotted cursor-help text-sm">
                  Keyboard shortcut
                </span>
              </:trigger>
              <:content>
                <span class="font-mono">Cmd + K</span>
              </:content>
            </.tooltip>
          </.flex>
        </section>

        <%!-- Accessibility --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Keyboard Accessible</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Tooltips appear when elements receive keyboard focus. Try tabbing to the buttons below.
          </p>
          <.flex justify="center" items="center" class="gap-4">
            <.tooltip>
              <:trigger>
                <.button variant="outline">Tab to me</.button>
              </:trigger>
              <:content>This tooltip is keyboard accessible!</:content>
            </.tooltip>

            <.tooltip>
              <:trigger>
                <.button variant="outline">Then tab here</.button>
              </:trigger>
              <:content>Focus moves through elements in order</:content>
            </.tooltip>
          </.flex>
        </section>

        <%!-- Inline Text --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Inline Text Tooltips</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Tooltips can be used inline with text to provide additional context.
          </p>
          <p class="text-foreground">
            The file was last modified on
            <.tooltip>
              <:trigger>
                <span class="underline decoration-dotted cursor-help">January 15, 2025</span>
              </:trigger>
              <:content>
                <p>Last modified: 3:42 PM</p>
                <p>By: john@example.com</p>
              </:content>
            </.tooltip>
            by the marketing team.
          </p>
        </section>

        <%!-- Usage Notes --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Usage Notes</h2>
          <.card>
            <.card_content class="pt-6">
              <.stack gap="md">
                <p class="text-sm text-muted-foreground">
                  <strong class="text-foreground">Pure CSS Implementation:</strong>
                  This tooltip uses CSS hover/focus states and requires no JavaScript hooks.
                </p>
                <p class="text-sm text-muted-foreground">
                  <strong class="text-foreground">Accessibility:</strong>
                  Tooltips are keyboard accessible and use proper ARIA attributes (role="tooltip", aria-describedby).
                </p>
                <p class="text-sm text-muted-foreground">
                  <strong class="text-foreground">Animation:</strong>
                  Tooltips fade in smoothly with a configurable delay.
                </p>
                <p class="text-sm text-muted-foreground">
                  <strong class="text-foreground">Best Practices:</strong>
                  Keep tooltip content brief. For longer content, consider using a Popover instead.
                </p>
              </.stack>
            </.card_content>
          </.card>
        </section>
      </.stack>
    </.container>
    """
  end
end
