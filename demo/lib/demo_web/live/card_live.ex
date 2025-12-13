defmodule DemoWeb.Ui.CardLive do
  @moduledoc false
  use DemoWeb, :live_view

  @impl true
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
          <h1 class="text-3xl font-bold text-foreground">Card Component</h1>
          <p class="text-muted-foreground mt-2">
            A flexible container for grouping related content.
          </p>
        </div>

        <%!-- Basic Card --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Basic Card</h2>
          <.card class="max-w-md">
            <.card_header>
              <.card_title>Card Title</.card_title>
              <.card_description>Card description goes here</.card_description>
            </.card_header>
            <.card_content>
              <p class="text-foreground">
                This is the main content area of the card. You can put any content here.
              </p>
            </.card_content>
            <.card_footer>
              <.button>Action</.button>
              <.button variant="outline" class="ml-2">Cancel</.button>
            </.card_footer>
          </.card>
        </section>

        <%!-- Card with Action --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Card with Header Action</h2>
          <.card class="max-w-md">
            <.card_header>
              <.card_title>Notifications</.card_title>
              <.card_description>You have 3 unread messages</.card_description>
              <.card_action>
                <.button size="icon" variant="ghost" aria-label="Close">
                  <.icon name="hero-x-mark" />
                </.button>
              </.card_action>
            </.card_header>
            <.card_content>
              <div class="space-y-3">
                <div class="flex items-start gap-3">
                  <.icon name="hero-envelope" class="mt-0.5 text-primary" />
                  <div>
                    <p class="text-sm font-medium text-foreground">New message from Alice</p>
                    <p class="text-sm text-muted-foreground">5 minutes ago</p>
                  </div>
                </div>
                <div class="flex items-start gap-3">
                  <.icon name="hero-envelope" class="mt-0.5 text-primary" />
                  <div>
                    <p class="text-sm font-medium text-foreground">New message from Bob</p>
                    <p class="text-sm text-muted-foreground">1 hour ago</p>
                  </div>
                </div>
              </div>
            </.card_content>
            <.card_footer>
              <.button variant="link" size="sm">View all</.button>
            </.card_footer>
          </.card>
        </section>

        <%!-- Simple Cards Grid --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Card Grid</h2>
          <.grid cols={3}>
            <.card>
              <.card_header>
                <.card_title>Total Revenue</.card_title>
                <.card_description>Last 30 days</.card_description>
              </.card_header>
              <.card_content>
                <div class="text-2xl font-bold text-foreground">$45,231.89</div>
                <p class="text-xs text-muted-foreground mt-1">+20.1% from last month</p>
              </.card_content>
            </.card>

            <.card>
              <.card_header>
                <.card_title>Active Users</.card_title>
                <.card_description>Current month</.card_description>
              </.card_header>
              <.card_content>
                <div class="text-2xl font-bold text-foreground">+2,350</div>
                <p class="text-xs text-muted-foreground mt-1">+15.4% from last month</p>
              </.card_content>
            </.card>

            <.card>
              <.card_header>
                <.card_title>Conversion Rate</.card_title>
                <.card_description>This quarter</.card_description>
              </.card_header>
              <.card_content>
                <div class="text-2xl font-bold text-foreground">3.2%</div>
                <p class="text-xs text-muted-foreground mt-1">+0.5% from last quarter</p>
              </.card_content>
            </.card>
          </.grid>
        </section>

        <%!-- Form Card Example --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Form Card</h2>
          <.card class="max-w-md">
            <.card_header>
              <.card_title>Create Account</.card_title>
              <.card_description>Enter your details to get started</.card_description>
            </.card_header>
            <.card_content>
              <.stack gap="md">
                <div>
                  <label class="text-sm font-medium text-foreground">Email</label>
                  <input
                    type="email"
                    placeholder="you@example.com"
                    class="mt-1.5 w-full rounded-md border border-input bg-background px-3 py-2 text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring"
                  />
                </div>
                <div>
                  <label class="text-sm font-medium text-foreground">Password</label>
                  <input
                    type="password"
                    placeholder="••••••••"
                    class="mt-1.5 w-full rounded-md border border-input bg-background px-3 py-2 text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring"
                  />
                </div>
              </.stack>
            </.card_content>
            <.card_footer>
              <.button class="w-full">Create Account</.button>
            </.card_footer>
          </.card>
        </section>

        <%!-- Card Without Footer --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Minimal Card (No Footer)</h2>
          <.card class="max-w-md">
            <.card_header>
              <.card_title>Quick Note</.card_title>
              <.card_description>Just title, description, and content</.card_description>
            </.card_header>
            <.card_content>
              <p class="text-sm text-foreground">
                This card demonstrates that the footer is optional. You can use any combination of card sub-components based on your needs.
              </p>
            </.card_content>
          </.card>
        </section>

        <%!-- Content-Only Card --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Content-Only Card</h2>
          <.card class="max-w-md">
            <.card_content>
              <p class="text-foreground">
                You can also skip the header entirely and just use the card with content. This is useful for simple containers or list items.
              </p>
            </.card_content>
          </.card>
        </section>

        <%!-- Card Badge Section --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Card Badge</h2>
          <p class="text-muted-foreground mb-6">
            Corner badges for status indicators, labels, and metadata.
          </p>

          <.grid cols={2} class="max-w-4xl">
            <%!-- Single badge --%>
            <.card auto_badge_padding={false}>
              <.card_badge>
                <:top_right variant="success">NEW</:top_right>
              </.card_badge>
              <.card_header>
                <.card_title>Single Badge</.card_title>
                <.card_description>Top-right with success variant</.card_description>
              </.card_header>
              <.card_content>
                <p class="text-sm text-muted-foreground">
                  A single badge in the top-right corner.
                </p>
              </.card_content>
            </.card>

            <%!-- Multiple badges horizontal --%>
            <.card auto_badge_padding={false}>
              <.card_badge>
                <:top_right variant="muted">
                  <.icon name="hero-star-solid" class="size-3.5" />
                </:top_right>
                <:top_right variant="success">SL 5</:top_right>
              </.card_badge>
              <.card_header>
                <.card_title>Multiple Badges (Horizontal)</.card_title>
                <.card_description>Like the player card pattern</.card_description>
              </.card_header>
              <.card_content>
                <p class="text-sm text-muted-foreground">
                  Multiple badges stack horizontally by default.
                </p>
              </.card_content>
            </.card>

            <%!-- Multiple badges vertical --%>
            <.card auto_badge_padding={false}>
              <.card_badge>
                <:top_right variant="muted" direction="vertical">
                  <.icon name="hero-star-solid" class="size-3.5" />
                </:top_right>
                <:top_right variant="success" direction="vertical">SL 5</:top_right>
              </.card_badge>
              <.card_header>
                <.card_title>Vertical Stacking</.card_title>
                <.card_description>Badges stack downward</.card_description>
              </.card_header>
              <.card_content>
                <p class="text-sm text-muted-foreground">
                  Use direction="vertical" for column layout.
                </p>
              </.card_content>
            </.card>

            <%!-- All corners --%>
            <.card>
              <.card_badge>
                <:top_left variant="warning">DRAFT</:top_left>
                <:top_right variant="success">$99</:top_right>
                <:bottom_left variant="primary">Featured</:bottom_left>
                <:bottom_right variant="muted">v2.1</:bottom_right>
              </.card_badge>
              <.card_header>
                <.card_title>All Four Corners</.card_title>
                <.card_description>Badges in every position</.card_description>
              </.card_header>
              <.card_content>
                <p class="text-sm text-muted-foreground">
                  Each corner can have its own badge(s).
                </p>
              </.card_content>
            </.card>

            <%!-- Variant showcase --%>
            <.card class="col-span-2">
              <.card_badge>
                <:top_left variant="default">Default</:top_left>
                <:top_left variant="primary">Primary</:top_left>
                <:top_right variant="success">Success</:top_right>
                <:top_right variant="warning">Warning</:top_right>
                <:top_right variant="destructive">Destructive</:top_right>
              </.card_badge>
              <.card_header>
                <.card_title>Badge Variants</.card_title>
                <.card_description>All available color variants</.card_description>
              </.card_header>
              <.card_content>
                <p class="text-sm text-muted-foreground">
                  Variants: default, primary, success, warning, destructive
                </p>
              </.card_content>
            </.card>
          </.grid>
        </section>

        <%!-- Card Status Section --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Card Status</h2>
          <p class="text-muted-foreground mb-6">
            A status bar at the bottom of a card with left/center/right layout.
          </p>

          <.grid cols={2} class="max-w-4xl">
            <%!-- Simple left/right --%>
            <.card gap="none">
              <.card_header>
                <.card_title>Simple Status</.card_title>
                <.card_description>Left and right content</.card_description>
              </.card_header>
              <.card_content class="pb-4">
                <p class="text-sm text-muted-foreground">
                  Basic status bar with left/right layout.
                </p>
              </.card_content>
              <.card_status>
                <:left>
                  <.icon name="hero-map-pin" class="size-3.5" />
                  <span>Corner Pocket</span>
                </:left>
                <:right>12 hours ago</:right>
              </.card_status>
            </.card>

            <%!-- With actions --%>
            <.card gap="none">
              <.card_header>
                <.card_title>With Actions</.card_title>
                <.card_description>Action buttons on the left</.card_description>
              </.card_header>
              <.card_content class="pb-4">
                <p class="text-sm text-muted-foreground">
                  Actions are separated with a border.
                </p>
              </.card_content>
              <.card_status>
                <:actions>
                  <.button variant="ghost" size="icon-xs" aria-label="Send invite">
                    <.icon name="hero-paper-airplane" class="size-4" />
                  </.button>
                  <.button variant="ghost" size="icon-xs" aria-label="More options">
                    <.icon name="hero-ellipsis-horizontal" class="size-4" />
                  </.button>
                </:actions>
                <:left>
                  <.icon name="hero-map-pin" class="size-3.5" />
                  <span>Billiards Club</span>
                </:left>
                <:right>Just now</:right>
              </.card_status>
            </.card>

            <%!-- With center content --%>
            <.card gap="none">
              <.card_header>
                <.card_title>With Center</.card_title>
                <.card_description>Three-column layout</.card_description>
              </.card_header>
              <.card_content class="pb-4">
                <p class="text-sm text-muted-foreground">
                  Left, center, and right sections.
                </p>
              </.card_content>
              <.card_status>
                <:left>
                  <.icon name="hero-user" class="size-3.5" />
                  <span>4 players</span>
                </:left>
                <:center>
                  <.icon name="hero-clock" class="size-3.5" />
                  <span>In Progress</span>
                </:center>
                <:right>Round 2/5</:right>
              </.card_status>
            </.card>

            <%!-- Combined with badge --%>
            <.card gap="none">
              <.card_badge>
                <:top_right variant="muted">
                  <.icon name="hero-star-solid" class="size-3.5" />
                </:top_right>
                <:top_right variant="success">SL 5</:top_right>
              </.card_badge>
              <.card_header>
                <.card_title>Badge + Status</.card_title>
                <.card_description>Both components together</.card_description>
              </.card_header>
              <.card_content class="pb-4">
                <p class="text-sm text-muted-foreground">
                  Combining badge and status bar.
                </p>
              </.card_content>
              <.card_status>
                <:actions>
                  <.button variant="ghost" size="icon-xs" aria-label="Edit">
                    <.icon name="hero-pencil" class="size-4" />
                  </.button>
                </:actions>
                <:left>
                  <.icon name="hero-trophy" class="size-3.5" />
                  <span>8-Ball</span>
                </:left>
                <:right>Active</:right>
              </.card_status>
            </.card>
          </.grid>
        </section>
      </.stack>
    </.container>
    """
  end
end
