defmodule DemoWeb.Ui.DrawerLive do
  @moduledoc """
  Showcase for the Drawer component - a mobile-friendly slide-out panel.
  """
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
      |> assign(:goal, 350)

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

  def handle_event("update-goal", %{"change" => change}, socket) do
    new_goal = socket.assigns.goal + String.to_integer(change)
    {:noreply, assign(socket, :goal, max(0, new_goal))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    
      <.container>
        <.stack size="large">
          <%!-- Header --%>
          <div>
            <h1 class="text-3xl font-bold text-foreground">Drawer Component</h1>
            <p class="text-muted-foreground mt-2">
              A mobile-friendly slide-out panel with gesture support and drag handle.
              Perfect for mobile menus, filters, and actions.
            </p>
          </div>

          <%!-- Direction Variants --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Slide-in Directions</h2>
            <.flex align="start" class="gap-4 flex-wrap">
              <%!-- Bottom (default, mobile-friendly) --%>
              <.drawer id="drawer-bottom">
                <:trigger>
                  <.button variant="outline">From Bottom</.button>
                </:trigger>
                <:content>
                  <.drawer_header>
                    <.drawer_title>Slide from Bottom</.drawer_title>
                    <.drawer_description>
                      This is the default position, optimized for mobile interactions.
                    </.drawer_description>
                  </.drawer_header>

                  <div class="p-4">
                    <p class="text-sm text-muted-foreground">
                      The bottom drawer is perfect for mobile-style action sheets and quick actions.
                      Notice the drag handle at the top that indicates it can be swiped.
                    </p>
                  </div>
                </:content>
              </.drawer>

              <%!-- Top --%>
              <.drawer id="drawer-top">
                <:trigger>
                  <.button variant="outline">From Top</.button>
                </:trigger>
                <:content direction="top">
                  <.drawer_header>
                    <.drawer_title>Slide from Top</.drawer_title>
                    <.drawer_description>
                      The drawer slides down from the top edge.
                    </.drawer_description>
                  </.drawer_header>

                  <div class="p-4">
                    <p class="text-sm text-muted-foreground">
                      Top drawers are useful for notifications or alerts that need prominent attention.
                    </p>
                  </div>
                </:content>
              </.drawer>

              <%!-- Right --%>
              <.drawer id="drawer-right">
                <:trigger>
                  <.button variant="outline">From Right</.button>
                </:trigger>
                <:content direction="right">
                  <.drawer_header>
                    <.drawer_title>Slide from Right</.drawer_title>
                    <.drawer_description>
                      Similar to sheet, slides in from the right edge.
                    </.drawer_description>
                  </.drawer_header>

                  <div class="p-4">
                    <p class="text-sm text-muted-foreground">
                      Right-side drawers work well for supplementary content and settings.
                    </p>
                  </div>
                </:content>
              </.drawer>

              <%!-- Left --%>
              <.drawer id="drawer-left">
                <:trigger>
                  <.button variant="outline">From Left</.button>
                </:trigger>
                <:content direction="left">
                  <.drawer_header>
                    <.drawer_title>Slide from Left</.drawer_title>
                    <.drawer_description>
                      The drawer slides in from the left edge.
                    </.drawer_description>
                  </.drawer_header>

                  <div class="p-4">
                    <p class="text-sm text-muted-foreground">
                      Often used for navigation menus or sidebar content.
                    </p>
                  </div>
                </:content>
              </.drawer>
            </.flex>
          </section>

          <%!-- Mobile Goal Example (inspired by shadcn docs) --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Interactive Goal Tracker</h2>
            <.drawer id="goal-tracker">
              <:trigger>
                <.button>
                  <.icon name="hero-chart-bar" /> Set Goal
                </.button>
              </:trigger>
              <:content>
                <.drawer_header>
                  <.drawer_title>Move Goal</.drawer_title>
                  <.drawer_description>
                    Set your daily activity goal.
                  </.drawer_description>
                </.drawer_header>

                <div class="p-4 space-y-6">
                  <%!-- Goal visualization --%>
                  <div class="flex flex-col items-center justify-center py-8">
                    <div class="text-7xl font-bold text-foreground">{@goal}</div>
                    <div class="text-sm text-muted-foreground mt-2">Calories/day</div>
                  </div>

                  <%!-- Goal controls --%>
                  <div class="flex items-center justify-center gap-4">
                    <.button
                      variant="outline"
                      size="icon"
                      class="size-12 rounded-full"
                      phx-click="update-goal"
                      phx-value-change="-10"
                    >
                      <.icon name="hero-minus" class="size-5" />
                    </.button>

                    <div class="flex flex-col items-center gap-2 min-w-[120px]">
                      <div class="w-full bg-secondary rounded-full h-2">
                        <div
                          class="bg-primary h-2 rounded-full transition-all"
                          style={"width: #{min(100, (@goal / 500) * 100)}%"}
                        >
                        </div>
                      </div>
                      <span class="text-xs text-muted-foreground">
                        Goal: {@goal} / 500
                      </span>
                    </div>

                    <.button
                      variant="outline"
                      size="icon"
                      class="size-12 rounded-full"
                      phx-click="update-goal"
                      phx-value-change="10"
                    >
                      <.icon name="hero-plus" class="size-5" />
                    </.button>
                  </div>

                  <%!-- Info cards --%>
                  <div class="grid grid-cols-3 gap-3">
                    <div class="border border-border rounded-lg p-3 text-center">
                      <div class="text-2xl font-bold text-foreground">12,453</div>
                      <div class="text-xs text-muted-foreground mt-1">Steps</div>
                    </div>
                    <div class="border border-border rounded-lg p-3 text-center">
                      <div class="text-2xl font-bold text-foreground">5.2</div>
                      <div class="text-xs text-muted-foreground mt-1">Miles</div>
                    </div>
                    <div class="border border-border rounded-lg p-3 text-center">
                      <div class="text-2xl font-bold text-foreground">45</div>
                      <div class="text-xs text-muted-foreground mt-1">Minutes</div>
                    </div>
                  </div>
                </div>

                <.drawer_footer>
                  <.button
                    variant="outline"
                    class="w-full"
                    phx-click={JS.exec("phx-click", to: "#goal-tracker-close")}
                  >
                    Cancel
                  </.button>
                  <.button class="w-full" phx-click="save-profile">
                    Submit Goal
                  </.button>
                </.drawer_footer>
              </:content>
            </.drawer>
          </section>

          <%!-- Filter Panel --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Filter Panel</h2>
            <.drawer id="filters">
              <:trigger>
                <.button variant="outline">
                  <.icon name="hero-funnel" /> Filters
                </.button>
              </:trigger>
              <:content>
                <.drawer_header>
                  <.drawer_title>Filter Options</.drawer_title>
                  <.drawer_description>
                    Customize your search results.
                  </.drawer_description>
                </.drawer_header>

                <div class="p-4 space-y-6">
                  <%!-- Category filter --%>
                  <div>
                    <label class="text-sm font-medium text-foreground mb-3 block">Category</label>
                    <div class="grid grid-cols-2 gap-2">
                      <button class="px-4 py-2 text-sm border border-input rounded-md hover:bg-accent transition-colors">
                        All
                      </button>
                      <button class="px-4 py-2 text-sm bg-primary text-primary-foreground rounded-md">
                        Electronics
                      </button>
                      <button class="px-4 py-2 text-sm border border-input rounded-md hover:bg-accent transition-colors">
                        Clothing
                      </button>
                      <button class="px-4 py-2 text-sm border border-input rounded-md hover:bg-accent transition-colors">
                        Books
                      </button>
                    </div>
                  </div>

                  <%!-- Price range --%>
                  <div>
                    <label class="text-sm font-medium text-foreground mb-3 block">Price Range</label>
                    <div class="space-y-2">
                      <input
                        type="range"
                        min="0"
                        max="1000"
                        value="500"
                        class="w-full"
                      />
                      <div class="flex justify-between text-sm text-muted-foreground">
                        <span>$0</span>
                        <span>$500</span>
                        <span>$1000</span>
                      </div>
                    </div>
                  </div>

                  <%!-- Rating filter --%>
                  <div>
                    <label class="text-sm font-medium text-foreground mb-3 block">
                      Minimum Rating
                    </label>
                    <div class="flex gap-2">
                      <%= for rating <- [1, 2, 3, 4, 5] do %>
                        <button class="px-3 py-2 text-sm border border-input rounded-md hover:bg-accent transition-colors">
                          {rating}⭐
                        </button>
                      <% end %>
                    </div>
                  </div>
                </div>

                <.drawer_footer>
                  <.button
                    variant="outline"
                    class="w-full"
                    phx-click={JS.exec("phx-click", to: "#filters-close")}
                  >
                    Reset
                  </.button>
                  <.button class="w-full" phx-click="demo-action" phx-value-action="apply-filters">
                    Apply Filters
                  </.button>
                </.drawer_footer>
              </:content>
            </.drawer>
          </section>

          <%!-- Mobile Action Sheet --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Action Sheet</h2>
            <.drawer id="actions">
              <:trigger>
                <.button variant="outline">
                  <.icon name="hero-ellipsis-horizontal" /> Actions
                </.button>
              </:trigger>
              <:content>
                <.drawer_header>
                  <.drawer_title>Choose an action</.drawer_title>
                  <.drawer_description>
                    What would you like to do?
                  </.drawer_description>
                </.drawer_header>

                <div class="p-4 space-y-2">
                  <button
                    phx-click="demo-action"
                    phx-value-action="share"
                    class="w-full flex items-center gap-3 px-4 py-3 text-foreground hover:bg-accent rounded-lg transition-colors"
                  >
                    <.icon name="hero-share" class="size-5" />
                    <div class="flex-1 text-left">
                      <div class="font-medium">Share</div>
                      <div class="text-xs text-muted-foreground">Send to your friends</div>
                    </div>
                  </button>

                  <button
                    phx-click="demo-action"
                    phx-value-action="download"
                    class="w-full flex items-center gap-3 px-4 py-3 text-foreground hover:bg-accent rounded-lg transition-colors"
                  >
                    <.icon name="hero-arrow-down-tray" class="size-5" />
                    <div class="flex-1 text-left">
                      <div class="font-medium">Download</div>
                      <div class="text-xs text-muted-foreground">Save to your device</div>
                    </div>
                  </button>

                  <button
                    phx-click="demo-action"
                    phx-value-action="favorite"
                    class="w-full flex items-center gap-3 px-4 py-3 text-foreground hover:bg-accent rounded-lg transition-colors"
                  >
                    <.icon name="hero-heart" class="size-5" />
                    <div class="flex-1 text-left">
                      <div class="font-medium">Add to Favorites</div>
                      <div class="text-xs text-muted-foreground">Save for later</div>
                    </div>
                  </button>

                  <div class="border-t border-border pt-2 mt-2">
                    <button
                      phx-click="demo-action"
                      phx-value-action="delete"
                      class="w-full flex items-center gap-3 px-4 py-3 text-destructive hover:bg-destructive/10 rounded-lg transition-colors"
                    >
                      <.icon name="hero-trash" class="size-5" />
                      <div class="flex-1 text-left">
                        <div class="font-medium">Delete</div>
                        <div class="text-xs opacity-75">Permanently remove</div>
                      </div>
                    </button>
                  </div>
                </div>
              </:content>
            </.drawer>
          </section>

          <%!-- Navigation Drawer --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Navigation Drawer</h2>
            <.drawer id="nav-menu">
              <:trigger>
                <.button variant="outline">
                  <.icon name="hero-bars-3" /> Menu
                </.button>
              </:trigger>
              <:content direction="left">
                <.drawer_header>
                  <.drawer_title>Navigation</.drawer_title>
                  <.drawer_description>
                    Browse through the app sections.
                  </.drawer_description>
                </.drawer_header>

                <div class="p-4 space-y-1">
                  <a
                    href="#"
                    class="flex items-center gap-3 px-3 py-3 text-sm bg-accent text-accent-foreground rounded-md"
                  >
                    <.icon name="hero-home" class="size-5" />
                    <span class="font-medium">Dashboard</span>
                  </a>

                  <a
                    href="#"
                    class="flex items-center gap-3 px-3 py-3 text-sm text-foreground hover:bg-accent hover:text-accent-foreground rounded-md transition-colors"
                  >
                    <.icon name="hero-user-group" class="size-5" />
                    <span>Team</span>
                  </a>

                  <a
                    href="#"
                    class="flex items-center gap-3 px-3 py-3 text-sm text-foreground hover:bg-accent hover:text-accent-foreground rounded-md transition-colors"
                  >
                    <.icon name="hero-folder" class="size-5" />
                    <span>Projects</span>
                  </a>

                  <a
                    href="#"
                    class="flex items-center gap-3 px-3 py-3 text-sm text-foreground hover:bg-accent hover:text-accent-foreground rounded-md transition-colors"
                  >
                    <.icon name="hero-chart-bar" class="size-5" />
                    <span>Analytics</span>
                  </a>

                  <div class="border-t border-border my-2"></div>

                  <a
                    href="#"
                    class="flex items-center gap-3 px-3 py-3 text-sm text-foreground hover:bg-accent hover:text-accent-foreground rounded-md transition-colors"
                  >
                    <.icon name="hero-cog-6-tooth" class="size-5" />
                    <span>Settings</span>
                  </a>

                  <a
                    href="#"
                    class="flex items-center gap-3 px-3 py-3 text-sm text-foreground hover:bg-accent hover:text-accent-foreground rounded-md transition-colors"
                  >
                    <.icon name="hero-question-mark-circle" class="size-5" />
                    <span>Help</span>
                  </a>
                </div>
              </:content>
            </.drawer>
          </section>
        </.stack>
      </.container>
    
    """
  end
end
