defmodule DemoWeb.Ui.MiscellaneousLive do
  @moduledoc false
  use DemoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:text_align, "center")
      |> assign(:formatting, ["bold"])
      |> assign(:view_mode, "grid")

    {:ok, socket}
  end

  @impl true
  def handle_event("align_changed", %{"item" => value}, socket) do
    {:noreply, assign(socket, :text_align, value)}
  end

  def handle_event("formatting_changed", %{"item" => value}, socket) do
    current = socket.assigns.formatting

    updated =
      if value in current do
        List.delete(current, value)
      else
        [value | current]
      end

    {:noreply, assign(socket, :formatting, updated)}
  end

  def handle_event("view_changed", %{"item" => value}, socket) do
    {:noreply, assign(socket, :view_mode, value)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.container>
      <.stack gap="xl">
        <%!-- Header --%>
        <div>
          <h1 class="text-3xl font-bold text-foreground">Miscellaneous Components</h1>
          <p class="text-muted-foreground mt-2">
            Various interactive UI components including toggle groups, hover cards, and collapsible sections.
          </p>
        </div>

        <%!-- Toggle Group Section --%>
        <section>
          <h2 class="text-2xl font-semibold text-foreground mb-2">Toggle Group</h2>
          <p class="text-sm text-muted-foreground mb-4">
            A set of two-state buttons that can be toggled on or off. Supports both single and multiple selection modes.
          </p>

          <%!-- Single Select with Icons --%>
          <div class="mb-8">
            <h3 class="text-lg font-medium text-foreground mb-4">Single Select (Text Align)</h3>
            <div class="space-y-4">
              <.toggle_group
                :let={group}
                id="text-align"
                type="single"
                value={@text_align}
                on_value_change="align_changed"
              >
                <.toggle_group_item
                  value="left"
                  aria_label="Align left"
                  variant={group.variant}
                  size={group.size}
                  spacing={group.spacing}
                  selected_values={group.selected_values}
                  type={group.type}
                  disabled={group.disabled}
                  on_value_change={group.on_value_change}
                >
                  <.icon name="hero-bars-arrow-down" class="rotate-90" />
                </.toggle_group_item>
                <.toggle_group_item
                  value="center"
                  aria_label="Align center"
                  variant={group.variant}
                  size={group.size}
                  spacing={group.spacing}
                  selected_values={group.selected_values}
                  type={group.type}
                  disabled={group.disabled}
                  on_value_change={group.on_value_change}
                >
                  <.icon name="hero-bars-3" />
                </.toggle_group_item>
                <.toggle_group_item
                  value="right"
                  aria_label="Align right"
                  variant={group.variant}
                  size={group.size}
                  spacing={group.spacing}
                  selected_values={group.selected_values}
                  type={group.type}
                  disabled={group.disabled}
                  on_value_change={group.on_value_change}
                >
                  <.icon name="hero-bars-arrow-up" class="rotate-90" />
                </.toggle_group_item>
              </.toggle_group>
              <p class="text-sm text-muted-foreground">
                Selected: <span class="font-mono text-foreground">{@text_align}</span>
              </p>
            </div>
          </div>

          <%!-- Multiple Select --%>
          <div class="mb-8">
            <h3 class="text-lg font-medium text-foreground mb-4">
              Multiple Select (Text Formatting)
            </h3>
            <div class="space-y-4">
              <.toggle_group
                :let={group}
                id="formatting"
                type="multiple"
                value={@formatting}
                on_value_change="formatting_changed"
              >
                <.toggle_group_item
                  value="bold"
                  aria_label="Toggle bold"
                  variant={group.variant}
                  size={group.size}
                  spacing={group.spacing}
                  selected_values={group.selected_values}
                  type={group.type}
                  disabled={group.disabled}
                  on_value_change={group.on_value_change}
                >
                  <span class="font-bold">B</span>
                </.toggle_group_item>
                <.toggle_group_item
                  value="italic"
                  aria_label="Toggle italic"
                  variant={group.variant}
                  size={group.size}
                  spacing={group.spacing}
                  selected_values={group.selected_values}
                  type={group.type}
                  disabled={group.disabled}
                  on_value_change={group.on_value_change}
                >
                  <span class="italic">I</span>
                </.toggle_group_item>
                <.toggle_group_item
                  value="underline"
                  aria_label="Toggle underline"
                  variant={group.variant}
                  size={group.size}
                  spacing={group.spacing}
                  selected_values={group.selected_values}
                  type={group.type}
                  disabled={group.disabled}
                  on_value_change={group.on_value_change}
                >
                  <span class="underline">U</span>
                </.toggle_group_item>
              </.toggle_group>
              <p class="text-sm text-muted-foreground">
                Selected: <span class="font-mono text-foreground">{inspect(@formatting)}</span>
              </p>
            </div>
          </div>

          <%!-- Outline Variant with Spacing --%>
          <div class="mb-8">
            <h3 class="text-lg font-medium text-foreground mb-4">Outline Variant with Spacing</h3>
            <div class="space-y-4">
              <.toggle_group
                id="view-mode"
                type="single"
                variant="outline"
                spacing={2}
                value={@view_mode}
                on_value_change="view_changed"
              >
                <.toggle_group_item value="grid" aria_label="Grid view">
                  <.icon name="hero-squares-2x2" />
                </.toggle_group_item>
                <.toggle_group_item value="list" aria_label="List view">
                  <.icon name="hero-list-bullet" />
                </.toggle_group_item>
                <.toggle_group_item value="kanban" aria_label="Kanban view">
                  <.icon name="hero-view-columns" />
                </.toggle_group_item>
              </.toggle_group>
              <p class="text-sm text-muted-foreground">
                View mode: <span class="font-mono text-foreground">{@view_mode}</span>
              </p>
            </div>
          </div>

          <%!-- Size Variants --%>
          <div class="mb-8">
            <h3 class="text-lg font-medium text-foreground mb-4">Size Variants</h3>
            <div class="space-y-6">
              <div class="space-y-2">
                <p class="text-sm font-medium text-foreground">Small</p>
                <.toggle_group id="size-sm" type="single" size="sm" value="option1">
                  <.toggle_group_item value="option1" aria_label="Option 1">
                    Opt 1
                  </.toggle_group_item>
                  <.toggle_group_item value="option2" aria_label="Option 2">
                    Opt 2
                  </.toggle_group_item>
                  <.toggle_group_item value="option3" aria_label="Option 3">
                    Opt 3
                  </.toggle_group_item>
                </.toggle_group>
              </div>

              <div class="space-y-2">
                <p class="text-sm font-medium text-foreground">Default</p>
                <.toggle_group id="size-default" type="single" size="default" value="option1">
                  <.toggle_group_item value="option1" aria_label="Option 1">
                    Option 1
                  </.toggle_group_item>
                  <.toggle_group_item value="option2" aria_label="Option 2">
                    Option 2
                  </.toggle_group_item>
                  <.toggle_group_item value="option3" aria_label="Option 3">
                    Option 3
                  </.toggle_group_item>
                </.toggle_group>
              </div>

              <div class="space-y-2">
                <p class="text-sm font-medium text-foreground">Large</p>
                <.toggle_group id="size-lg" type="single" size="lg" value="option1">
                  <.toggle_group_item value="option1" aria_label="Option 1">
                    Option 1
                  </.toggle_group_item>
                  <.toggle_group_item value="option2" aria_label="Option 2">
                    Option 2
                  </.toggle_group_item>
                  <.toggle_group_item value="option3" aria_label="Option 3">
                    Option 3
                  </.toggle_group_item>
                </.toggle_group>
              </div>
            </div>
          </div>

          <%!-- Disabled State --%>
          <div class="mb-8">
            <h3 class="text-lg font-medium text-foreground mb-4">Disabled State</h3>
            <div class="space-y-4">
              <.toggle_group id="disabled-group" type="single" disabled={true} value="option1">
                <.toggle_group_item value="option1" aria_label="Option 1">
                  Option 1
                </.toggle_group_item>
                <.toggle_group_item value="option2" aria_label="Option 2">
                  Option 2
                </.toggle_group_item>
                <.toggle_group_item value="option3" aria_label="Option 3">
                  Option 3
                </.toggle_group_item>
              </.toggle_group>
            </div>
          </div>

          <%!-- With Icons and Text --%>
          <div class="mb-8">
            <h3 class="text-lg font-medium text-foreground mb-4">With Icons and Text</h3>
            <div class="space-y-4">
              <.toggle_group id="icon-text" type="single" variant="outline" value="dashboard">
                <.toggle_group_item value="dashboard" aria_label="Dashboard">
                  <.icon name="hero-home" />
                  <span class="ml-2">Dashboard</span>
                </.toggle_group_item>
                <.toggle_group_item value="analytics" aria_label="Analytics">
                  <.icon name="hero-chart-bar" />
                  <span class="ml-2">Analytics</span>
                </.toggle_group_item>
                <.toggle_group_item value="settings" aria_label="Settings">
                  <.icon name="hero-cog-6-tooth" />
                  <span class="ml-2">Settings</span>
                </.toggle_group_item>
              </.toggle_group>
            </div>
          </div>
        </section>

        <%!-- Hover Card Section --%>
        <section>
          <h2 class="text-2xl font-semibold text-foreground mb-2">Hover Card</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Display rich content when hovering over an element. Great for profile previews and contextual information.
          </p>

          <%!-- Basic Hover Card --%>
          <div class="mb-8">
            <h3 class="text-lg font-medium text-foreground mb-4">Basic Hover Card</h3>
            <div class="flex gap-4">
              <.hover_card id="basic-hover">
                <.hover_card_trigger>
                  <a href="#" class="text-primary underline">@shadcn</a>
                </.hover_card_trigger>
                <.hover_card_content>
                  <div class="space-y-2">
                    <h4 class="text-sm font-semibold">@shadcn</h4>
                    <p class="text-sm text-muted-foreground">
                      The React Framework - created and maintained by @vercel.
                    </p>
                  </div>
                </.hover_card_content>
              </.hover_card>
            </div>
          </div>

          <%!-- Profile Hover Card --%>
          <div class="mb-8">
            <h3 class="text-lg font-medium text-foreground mb-4">Profile Hover Card</h3>
            <div class="flex gap-4">
              <.hover_card id="profile-hover">
                <.hover_card_trigger>
                  <a href="#" class="text-primary font-medium underline">@nextjs</a>
                </.hover_card_trigger>
                <.hover_card_content class="w-80">
                  <div class="flex gap-4">
                    <.avatar class="size-12">
                      <.avatar_image src="https://github.com/vercel.png" alt="Vercel" />
                      <.avatar_fallback>VL</.avatar_fallback>
                    </.avatar>
                    <div class="flex-1 space-y-1">
                      <h4 class="text-sm font-semibold">@nextjs</h4>
                      <p class="text-sm text-muted-foreground">
                        The React Framework for the Web. Used by some of the world's largest companies.
                      </p>
                      <div class="flex items-center gap-4 pt-2">
                        <div class="flex items-center gap-1">
                          <.icon name="hero-calendar" class="size-4 text-muted-foreground" />
                          <span class="text-xs text-muted-foreground">Joined December 2021</span>
                        </div>
                      </div>
                    </div>
                  </div>
                </.hover_card_content>
              </.hover_card>
            </div>
          </div>

          <%!-- Multiple Hover Cards with Different Alignments --%>
          <div class="mb-8">
            <h3 class="text-lg font-medium text-foreground mb-4">Alignment Options</h3>
            <div class="flex gap-8 items-center justify-center p-8 bg-surface rounded-lg">
              <.hover_card id="align-start">
                <.hover_card_trigger>
                  <.button variant="outline">Align Start</.button>
                </.hover_card_trigger>
                <.hover_card_content align="start">
                  <p class="text-sm">Content aligned to the start (left edge).</p>
                </.hover_card_content>
              </.hover_card>

              <.hover_card id="align-center">
                <.hover_card_trigger>
                  <.button variant="outline">Align Center</.button>
                </.hover_card_trigger>
                <.hover_card_content align="center">
                  <p class="text-sm">Content aligned to the center.</p>
                </.hover_card_content>
              </.hover_card>

              <.hover_card id="align-end">
                <.hover_card_trigger>
                  <.button variant="outline">Align End</.button>
                </.hover_card_trigger>
                <.hover_card_content align="end">
                  <p class="text-sm">Content aligned to the end (right edge).</p>
                </.hover_card_content>
              </.hover_card>
            </div>
          </div>

          <%!-- Rich Content Hover Card --%>
          <div class="mb-8">
            <h3 class="text-lg font-medium text-foreground mb-4">Rich Content</h3>
            <.hover_card id="rich-content">
              <.hover_card_trigger>
                <.badge variant="outline">Hover for details</.badge>
              </.hover_card_trigger>
              <.hover_card_content class="w-96">
                <.card_header class="p-0 pb-3">
                  <.card_title class="text-base">Feature Details</.card_title>
                  <.card_description>Everything you need to know</.card_description>
                </.card_header>
                <div class="space-y-3">
                  <div class="flex items-start gap-2">
                    <.icon name="hero-check-circle" class="size-5 text-success mt-0.5" />
                    <div>
                      <p class="text-sm font-medium">Fully responsive</p>
                      <p class="text-xs text-muted-foreground">Works on all screen sizes</p>
                    </div>
                  </div>
                  <div class="flex items-start gap-2">
                    <.icon name="hero-check-circle" class="size-5 text-success mt-0.5" />
                    <div>
                      <p class="text-sm font-medium">Customizable</p>
                      <p class="text-xs text-muted-foreground">Easy to style and adapt</p>
                    </div>
                  </div>
                  <div class="flex items-start gap-2">
                    <.icon name="hero-check-circle" class="size-5 text-success mt-0.5" />
                    <div>
                      <p class="text-sm font-medium">Accessible</p>
                      <p class="text-xs text-muted-foreground">Built with a11y in mind</p>
                    </div>
                  </div>
                </div>
              </.hover_card_content>
            </.hover_card>
          </div>

          <%!-- Custom Width Example --%>
          <div class="mb-8">
            <h3 class="text-lg font-medium text-foreground mb-4">Custom Width</h3>
            <div class="flex gap-4">
              <.hover_card id="narrow-hover">
                <.hover_card_trigger>
                  <.button variant="outline" size="sm">Narrow</.button>
                </.hover_card_trigger>
                <.hover_card_content class="w-48">
                  <p class="text-sm">A narrower hover card (w-48).</p>
                </.hover_card_content>
              </.hover_card>

              <.hover_card id="wide-hover">
                <.hover_card_trigger>
                  <.button variant="outline" size="sm">Wide</.button>
                </.hover_card_trigger>
                <.hover_card_content class="w-96">
                  <p class="text-sm">
                    A wider hover card (w-96) that can accommodate more content and longer descriptions.
                  </p>
                </.hover_card_content>
              </.hover_card>
            </div>
          </div>
        </section>

        <%!-- Collapsible Section --%>
        <section>
          <h2 class="text-2xl font-semibold text-foreground mb-2">Collapsible</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Expandable sections for showing and hiding content.
          </p>

          <%!-- Basic Collapsible --%>
          <div class="mb-8">
            <h3 class="text-lg font-medium text-foreground mb-4">Basic Collapsible</h3>
            <.collapsible id="basic-collapsible">
              <.collapsible_trigger target_id="basic-collapsible">
                <div class="flex items-center justify-between rounded-md border border-border bg-surface px-4 py-3 hover:bg-accent">
                  <span class="text-sm font-medium text-foreground">Click to expand</span>
                  <.icon
                    name="hero-chevron-down"
                    class="size-4 transition-transform duration-200 text-foreground"
                  />
                </div>
              </.collapsible_trigger>
              <.collapsible_content>
                <div class="p-4 text-sm text-foreground bg-surface border-x border-b border-border rounded-b-md">
                  This is the collapsible content. Click the trigger above to hide it again.
                </div>
              </.collapsible_content>
            </.collapsible>
          </div>

          <%!-- Open by Default --%>
          <div class="mb-8">
            <h3 class="text-lg font-medium text-foreground mb-4">Open by Default</h3>
            <.collapsible id="open-collapsible" open={true}>
              <.collapsible_trigger target_id="open-collapsible">
                <div class="flex items-center justify-between rounded-md border border-border bg-surface px-4 py-3 hover:bg-accent">
                  <span class="text-sm font-medium text-foreground">
                    This section is open by default
                  </span>
                  <.icon
                    name="hero-chevron-down"
                    class="size-4 transition-transform duration-200 rotate-180 text-foreground"
                  />
                </div>
              </.collapsible_trigger>
              <.collapsible_content open={true}>
                <div class="p-4 text-sm text-foreground bg-surface border-x border-b border-border rounded-b-md">
                  You can set the collapsible to be open initially by passing the `open` attribute.
                </div>
              </.collapsible_content>
            </.collapsible>
          </div>
        </section>
      </.stack>
    </.container>
    """
  end
end
