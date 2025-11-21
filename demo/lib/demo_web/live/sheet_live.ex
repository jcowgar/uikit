defmodule DemoWeb.Ui.SheetLive do
  @moduledoc false
  use DemoWeb, :live_view

  alias Phoenix.LiveView.Socket

  @impl true
  @spec mount(map(), map(), Socket.t()) ::
          {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:name, "John Doe")
      |> assign(:email, "john@example.com")
      |> assign(:notification_count, 5)

    {:ok, socket}
  end

  @impl true
  @spec handle_event(String.t(), map(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("save-profile", _params, socket) do
    {:noreply, put_flash(socket, :info, "Profile saved successfully!")}
  end

  def handle_event("demo-action", %{"action" => action}, socket) do
    {:noreply, put_flash(socket, :info, "Action triggered: #{action}")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    
      <.container>
        <.stack size="large">
          <%!-- Header --%>
          <div>
            <h1 class="text-3xl font-bold text-foreground">Sheet Component</h1>
            <p class="text-muted-foreground mt-2">
              Extends the Dialog component to display content that complements the main content of the screen.
            </p>
          </div>

          <%!-- Side Variants --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Slide-in Directions</h2>
            <.flex align="start" class="gap-4">
              <%!-- Right (default) --%>
              <.sheet id="sheet-right">
                <:trigger>
                  <.button variant="outline">From Right</.button>
                </:trigger>
                <:content side="right">
                  <.sheet_header>
                    <.sheet_title>Slide from Right</.sheet_title>
                    <.sheet_description>
                      This is the default position. The sheet slides in from the right edge.
                    </.sheet_description>
                  </.sheet_header>

                  <div class="p-4">
                    <p class="text-sm text-muted-foreground">
                      This is the most common position for supplementary content, forms, or detailed information.
                    </p>
                  </div>
                </:content>
              </.sheet>

              <%!-- Left --%>
              <.sheet id="sheet-left">
                <:trigger>
                  <.button variant="outline">From Left</.button>
                </:trigger>
                <:content side="left">
                  <.sheet_header>
                    <.sheet_title>Slide from Left</.sheet_title>
                    <.sheet_description>
                      The sheet slides in from the left edge.
                    </.sheet_description>
                  </.sheet_header>

                  <div class="p-4">
                    <p class="text-sm text-muted-foreground">
                      Often used for navigation menus or sidebar content.
                    </p>
                  </div>
                </:content>
              </.sheet>

              <%!-- Top --%>
              <.sheet id="sheet-top">
                <:trigger>
                  <.button variant="outline">From Top</.button>
                </:trigger>
                <:content side="top">
                  <.sheet_header>
                    <.sheet_title>Slide from Top</.sheet_title>
                    <.sheet_description>
                      The sheet slides down from the top edge.
                    </.sheet_description>
                  </.sheet_header>

                  <div class="p-4">
                    <p class="text-sm text-muted-foreground">
                      Useful for notifications or alerts that need prominent attention.
                    </p>
                  </div>
                </:content>
              </.sheet>

              <%!-- Bottom --%>
              <.sheet id="sheet-bottom">
                <:trigger>
                  <.button variant="outline">From Bottom</.button>
                </:trigger>
                <:content side="bottom">
                  <.sheet_header>
                    <.sheet_title>Slide from Bottom</.sheet_title>
                    <.sheet_description>
                      The sheet slides up from the bottom edge.
                    </.sheet_description>
                  </.sheet_header>

                  <div class="p-4">
                    <p class="text-sm text-muted-foreground">
                      Popular for mobile-style action sheets and quick actions.
                    </p>
                  </div>
                </:content>
              </.sheet>
            </.flex>
          </section>

          <%!-- Form Example --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">With Form</h2>
            <.sheet id="edit-profile">
              <:trigger>
                <.button>
                  <.icon name="hero-user-circle" /> Edit Profile
                </.button>
              </:trigger>
              <:content>
                <.sheet_header>
                  <.sheet_title>Edit Profile</.sheet_title>
                  <.sheet_description>
                    Make changes to your profile here. Click save when you're done.
                  </.sheet_description>
                </.sheet_header>

                <div class="p-4 space-y-4">
                  <div>
                    <label class="text-sm font-medium text-foreground">Name</label>
                    <input
                      type="text"
                      value={@name}
                      class="w-full mt-1 px-3 py-2 bg-background border border-input rounded-md text-foreground"
                    />
                  </div>

                  <div>
                    <label class="text-sm font-medium text-foreground">Email</label>
                    <input
                      type="email"
                      value={@email}
                      class="w-full mt-1 px-3 py-2 bg-background border border-input rounded-md text-foreground"
                    />
                  </div>

                  <div>
                    <label class="text-sm font-medium text-foreground">Bio</label>
                    <textarea
                      class="w-full mt-1 px-3 py-2 bg-background border border-input rounded-md text-foreground"
                      rows="3"
                    >I'm a software developer passionate about Phoenix and LiveView.</textarea>
                  </div>
                </div>

                <.sheet_footer>
                  <.button variant="outline" phx-click={close_sheet("edit-profile")}>
                    Cancel
                  </.button>
                  <.button phx-click="save-profile">Save Changes</.button>
                </.sheet_footer>
              </:content>
            </.sheet>
          </section>

          <%!-- Navigation Menu Example --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Navigation Menu</h2>
            <.sheet id="nav-menu">
              <:trigger>
                <.button variant="outline">
                  <.icon name="hero-bars-3" /> Menu
                </.button>
              </:trigger>
              <:content side="left">
                <.sheet_header>
                  <.sheet_title>Navigation</.sheet_title>
                  <.sheet_description>
                    Browse through the application sections.
                  </.sheet_description>
                </.sheet_header>

                <div class="p-4 space-y-2">
                  <a
                    href="#"
                    class="flex items-center gap-3 px-3 py-2 text-sm text-foreground hover:bg-accent hover:text-accent-foreground rounded-md transition-colors"
                  >
                    <.icon name="hero-home" class="size-5" />
                    <span>Dashboard</span>
                  </a>

                  <a
                    href="#"
                    class="flex items-center gap-3 px-3 py-2 text-sm text-foreground hover:bg-accent hover:text-accent-foreground rounded-md transition-colors"
                  >
                    <.icon name="hero-user-group" class="size-5" />
                    <span>Team</span>
                  </a>

                  <a
                    href="#"
                    class="flex items-center gap-3 px-3 py-2 text-sm text-foreground hover:bg-accent hover:text-accent-foreground rounded-md transition-colors"
                  >
                    <.icon name="hero-document-text" class="size-5" />
                    <span>Projects</span>
                  </a>

                  <a
                    href="#"
                    class="flex items-center gap-3 px-3 py-2 text-sm text-foreground hover:bg-accent hover:text-accent-foreground rounded-md transition-colors"
                  >
                    <.icon name="hero-chart-bar" class="size-5" />
                    <span>Analytics</span>
                  </a>

                  <a
                    href="#"
                    class="flex items-center gap-3 px-3 py-2 text-sm text-foreground hover:bg-accent hover:text-accent-foreground rounded-md transition-colors"
                  >
                    <.icon name="hero-cog-6-tooth" class="size-5" />
                    <span>Settings</span>
                  </a>
                </div>
              </:content>
            </.sheet>
          </section>

          <%!-- Notification Panel --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Notification Panel</h2>
            <.sheet id="notifications">
              <:trigger>
                <.button variant="outline" class="relative">
                  <.icon name="hero-bell" />
                  <span class="absolute -top-1 -right-1 size-5 flex items-center justify-center text-xs font-semibold bg-destructive text-destructive-foreground rounded-full">
                    {@notification_count}
                  </span>
                </.button>
              </:trigger>
              <:content>
                <.sheet_header>
                  <.sheet_title>Notifications</.sheet_title>
                  <.sheet_description>
                    You have {@notification_count} unread messages.
                  </.sheet_description>
                </.sheet_header>

                <div class="p-4 space-y-4">
                  <div class="border-b border-border pb-4">
                    <div class="flex items-start gap-3">
                      <div class="size-10 rounded-full bg-primary/10 flex items-center justify-center">
                        <.icon name="hero-user" class="size-5 text-primary" />
                      </div>
                      <div class="flex-1">
                        <p class="text-sm font-medium text-foreground">New team member</p>
                        <p class="text-sm text-muted-foreground">
                          Alice joined your workspace
                        </p>
                        <p class="text-xs text-muted-foreground mt-1">2 hours ago</p>
                      </div>
                    </div>
                  </div>

                  <div class="border-b border-border pb-4">
                    <div class="flex items-start gap-3">
                      <div class="size-10 rounded-full bg-success/10 flex items-center justify-center">
                        <.icon name="hero-check-circle" class="size-5 text-success" />
                      </div>
                      <div class="flex-1">
                        <p class="text-sm font-medium text-foreground">Task completed</p>
                        <p class="text-sm text-muted-foreground">
                          Project review has been completed
                        </p>
                        <p class="text-xs text-muted-foreground mt-1">5 hours ago</p>
                      </div>
                    </div>
                  </div>

                  <div class="border-b border-border pb-4">
                    <div class="flex items-start gap-3">
                      <div class="size-10 rounded-full bg-warning/10 flex items-center justify-center">
                        <.icon name="hero-exclamation-triangle" class="size-5 text-warning" />
                      </div>
                      <div class="flex-1">
                        <p class="text-sm font-medium text-foreground">Deadline approaching</p>
                        <p class="text-sm text-muted-foreground">
                          Q4 report due in 2 days
                        </p>
                        <p class="text-xs text-muted-foreground mt-1">1 day ago</p>
                      </div>
                    </div>
                  </div>
                </div>

                <.sheet_footer>
                  <.button variant="outline" class="w-full">Mark all as read</.button>
                </.sheet_footer>
              </:content>
            </.sheet>
          </section>

          <%!-- Action Sheet (Bottom) --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Action Sheet (Mobile Style)</h2>
            <.sheet id="actions">
              <:trigger>
                <.button variant="outline">
                  <.icon name="hero-ellipsis-horizontal" /> Actions
                </.button>
              </:trigger>
              <:content side="bottom">
                <.sheet_header>
                  <.sheet_title>Choose an action</.sheet_title>
                  <.sheet_description>
                    Select what you'd like to do with this item.
                  </.sheet_description>
                </.sheet_header>

                <div class="p-4 space-y-2">
                  <button
                    phx-click="demo-action"
                    phx-value-action="share"
                    class="w-full flex items-center gap-3 px-4 py-3 text-foreground hover:bg-accent rounded-md transition-colors"
                  >
                    <.icon name="hero-share" class="size-5" />
                    <span class="font-medium">Share</span>
                  </button>

                  <button
                    phx-click="demo-action"
                    phx-value-action="download"
                    class="w-full flex items-center gap-3 px-4 py-3 text-foreground hover:bg-accent rounded-md transition-colors"
                  >
                    <.icon name="hero-arrow-down-tray" class="size-5" />
                    <span class="font-medium">Download</span>
                  </button>

                  <button
                    phx-click="demo-action"
                    phx-value-action="duplicate"
                    class="w-full flex items-center gap-3 px-4 py-3 text-foreground hover:bg-accent rounded-md transition-colors"
                  >
                    <.icon name="hero-document-duplicate" class="size-5" />
                    <span class="font-medium">Duplicate</span>
                  </button>

                  <div class="border-t border-border pt-2 mt-2">
                    <button
                      phx-click="demo-action"
                      phx-value-action="delete"
                      class="w-full flex items-center gap-3 px-4 py-3 text-destructive hover:bg-destructive/10 rounded-md transition-colors"
                    >
                      <.icon name="hero-trash" class="size-5" />
                      <span class="font-medium">Delete</span>
                    </button>
                  </div>
                </div>
              </:content>
            </.sheet>
          </section>

          <%!-- Complex Example --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Complex Example</h2>
            <.sheet id="filters">
              <:trigger>
                <.button>
                  <.icon name="hero-funnel" /> Filter Options
                </.button>
              </:trigger>
              <:content>
                <.sheet_header>
                  <.sheet_title>Filter & Sort</.sheet_title>
                  <.sheet_description>
                    Customize how you view your data.
                  </.sheet_description>
                </.sheet_header>

                <div class="p-4 space-y-6">
                  <%!-- Status filter --%>
                  <div>
                    <label class="text-sm font-medium text-foreground mb-2 block">Status</label>
                    <div class="space-y-2">
                      <label class="flex items-center gap-2">
                        <input type="checkbox" class="rounded border-input" checked />
                        <span class="text-sm">Active</span>
                      </label>
                      <label class="flex items-center gap-2">
                        <input type="checkbox" class="rounded border-input" checked />
                        <span class="text-sm">Pending</span>
                      </label>
                      <label class="flex items-center gap-2">
                        <input type="checkbox" class="rounded border-input" />
                        <span class="text-sm">Archived</span>
                      </label>
                    </div>
                  </div>

                  <%!-- Priority filter --%>
                  <div>
                    <label class="text-sm font-medium text-foreground mb-2 block">Priority</label>
                    <div class="space-y-2">
                      <label class="flex items-center gap-2">
                        <input type="checkbox" class="rounded border-input" checked />
                        <span class="text-sm">High</span>
                      </label>
                      <label class="flex items-center gap-2">
                        <input type="checkbox" class="rounded border-input" checked />
                        <span class="text-sm">Medium</span>
                      </label>
                      <label class="flex items-center gap-2">
                        <input type="checkbox" class="rounded border-input" checked />
                        <span class="text-sm">Low</span>
                      </label>
                    </div>
                  </div>

                  <%!-- Date range --%>
                  <div>
                    <label class="text-sm font-medium text-foreground mb-2 block">Date Range</label>
                    <div class="space-y-2">
                      <input
                        type="date"
                        class="w-full px-3 py-2 bg-background border border-input rounded-md text-foreground"
                      />
                      <input
                        type="date"
                        class="w-full px-3 py-2 bg-background border border-input rounded-md text-foreground"
                      />
                    </div>
                  </div>
                </div>

                <.sheet_footer>
                  <.button variant="outline" phx-click={close_sheet("filters")}>
                    Reset
                  </.button>
                  <.button phx-click={close_sheet("filters")}>Apply Filters</.button>
                </.sheet_footer>
              </:content>
            </.sheet>
          </section>
        </.stack>
      </.container>
    
    """
  end

  # Helper function to close sheet
  @spec close_sheet(String.t(), String.t()) :: Phoenix.LiveView.JS.t()
  defp close_sheet(id, side \\ "right") do
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
  # Currently only "right" is used; other sides can be added when needed
  @spec sheet_transition(String.t(), :close) :: {String.t(), String.t(), String.t()}
  defp sheet_transition(_side, :close) do
    {"duration-300", "opacity-100 translate-x-0", "opacity-0 translate-x-full"}
  end
end
