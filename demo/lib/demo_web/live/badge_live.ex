defmodule DemoWeb.Ui.BadgeLive do
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
          <h1 class="text-3xl font-bold text-foreground">Badge Component</h1>
          <p class="text-muted-foreground mt-2">
            Displays a badge or a component that looks like a badge.
          </p>
        </div>

        <%!-- Variants --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Variants</h2>
          <.flex justify="center" items="center" class="gap-3 flex-wrap">
            <.badge>Default</.badge>
            <.badge variant="secondary">Secondary</.badge>
            <.badge variant="destructive">Destructive</.badge>
            <.badge variant="outline">Outline</.badge>
          </.flex>
        </section>

        <%!-- With Icons --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">With Icons</h2>
          <.flex justify="center" items="center" class="gap-3 flex-wrap">
            <.badge>
              <.icon name="hero-check" /> Success
            </.badge>
            <.badge variant="secondary">
              <.icon name="hero-clock" /> Pending
            </.badge>
            <.badge variant="destructive">
              <.icon name="hero-x-mark" /> Error
            </.badge>
            <.badge variant="outline">
              <.icon name="hero-information-circle" /> Info
            </.badge>
          </.flex>
        </section>

        <%!-- Icon Only --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Icon Only</h2>
          <.flex justify="center" items="center" class="gap-3 flex-wrap">
            <.badge>
              <.icon name="hero-heart" />
            </.badge>
            <.badge variant="secondary">
              <.icon name="hero-star" />
            </.badge>
            <.badge variant="destructive">
              <.icon name="hero-bell" />
            </.badge>
            <.badge variant="outline">
              <.icon name="hero-bookmark" />
            </.badge>
          </.flex>
        </section>

        <%!-- Status Indicators --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Status Indicators</h2>
          <.flex justify="start" items="start" class="gap-6 flex-wrap">
            <div class="space-y-2">
              <h3 class="text-sm font-medium text-foreground">System Status</h3>
              <.flex justify="center" items="center" class="gap-2">
                <.badge>
                  <.icon name="hero-check-circle" /> Online
                </.badge>
                <span class="text-sm text-muted-foreground">All systems operational</span>
              </.flex>
            </div>

            <div class="space-y-2">
              <h3 class="text-sm font-medium text-foreground">Build Status</h3>
              <.flex justify="center" items="center" class="gap-2">
                <.badge variant="secondary">
                  <.icon name="hero-arrow-path" class="animate-spin" /> Building
                </.badge>
                <span class="text-sm text-muted-foreground">Build #1234</span>
              </.flex>
            </div>

            <div class="space-y-2">
              <h3 class="text-sm font-medium text-foreground">Alert Status</h3>
              <.flex justify="center" items="center" class="gap-2">
                <.badge variant="destructive">
                  <.icon name="hero-exclamation-triangle" /> Critical
                </.badge>
                <span class="text-sm text-muted-foreground">Requires attention</span>
              </.flex>
            </div>
          </.flex>
        </section>

        <%!-- In Cards --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">In Cards</h2>
          <.grid cols={3}>
            <.card>
              <.card_header>
                <.flex justify="center" items="center" class="justify-between">
                  <.card_title>Active</.card_title>
                  <.badge>Live</.badge>
                </.flex>
                <.card_description>Currently running</.card_description>
              </.card_header>
              <.card_content>
                <p class="text-sm text-foreground">Service is operational and handling requests.</p>
              </.card_content>
            </.card>

            <.card>
              <.card_header>
                <.flex justify="center" items="center" class="justify-between">
                  <.card_title>Pending</.card_title>
                  <.badge variant="secondary">Waiting</.badge>
                </.flex>
                <.card_description>In queue</.card_description>
              </.card_header>
              <.card_content>
                <p class="text-sm text-foreground">Waiting for resources to become available.</p>
              </.card_content>
            </.card>

            <.card>
              <.card_header>
                <.flex justify="center" items="center" class="justify-between">
                  <.card_title>Failed</.card_title>
                  <.badge variant="destructive">Error</.badge>
                </.flex>
                <.card_description>Needs attention</.card_description>
              </.card_header>
              <.card_content>
                <p class="text-sm text-foreground">Service encountered an error and stopped.</p>
              </.card_content>
            </.card>
          </.grid>
        </section>

        <%!-- Categories / Tags --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Categories / Tags</h2>
          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>Article Title</.card_title>
              <.card_description>Published 2 days ago</.card_description>
            </.card_header>
            <.card_content>
              <p class="text-sm text-foreground mb-4">
                This is a sample article demonstrating how badges can be used for categorization and tagging.
              </p>
              <.flex justify="center" items="center" class="gap-2 flex-wrap">
                <.badge variant="outline">JavaScript</.badge>
                <.badge variant="outline">Phoenix</.badge>
                <.badge variant="outline">LiveView</.badge>
                <.badge variant="outline">Tutorial</.badge>
                <.badge variant="outline">Beginner</.badge>
              </.flex>
            </.card_content>
          </.card>
        </section>

        <%!-- Notification Counts --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Notification Counts</h2>
          <.flex justify="start" items="start" class="gap-6 flex-wrap">
            <.button variant="ghost">
              <.icon name="hero-envelope" /> Messages
              <.badge class="ml-2">12</.badge>
            </.button>

            <.button variant="ghost">
              <.icon name="hero-bell" /> Notifications
              <.badge variant="destructive" class="ml-2">3</.badge>
            </.button>

            <.button variant="ghost">
              <.icon name="hero-shopping-cart" /> Cart
              <.badge variant="secondary" class="ml-2">5</.badge>
            </.button>
          </.flex>
        </section>

        <%!-- All Variants Matrix --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Complete Variant Matrix</h2>
          <.stack gap="md">
            <div>
              <h3 class="text-sm font-medium text-muted-foreground mb-3">Default</h3>
              <.flex justify="center" items="center" class="gap-2 flex-wrap">
                <.badge>Badge</.badge>
                <.badge>
                  <.icon name="hero-star" /> With Icon
                </.badge>
                <.badge>
                  <.icon name="hero-check" />
                </.badge>
                <.badge>123</.badge>
              </.flex>
            </div>

            <div>
              <h3 class="text-sm font-medium text-muted-foreground mb-3">Secondary</h3>
              <.flex justify="center" items="center" class="gap-2 flex-wrap">
                <.badge variant="secondary">Badge</.badge>
                <.badge variant="secondary">
                  <.icon name="hero-star" /> With Icon
                </.badge>
                <.badge variant="secondary">
                  <.icon name="hero-check" />
                </.badge>
                <.badge variant="secondary">123</.badge>
              </.flex>
            </div>

            <div>
              <h3 class="text-sm font-medium text-muted-foreground mb-3">Destructive</h3>
              <.flex justify="center" items="center" class="gap-2 flex-wrap">
                <.badge variant="destructive">Badge</.badge>
                <.badge variant="destructive">
                  <.icon name="hero-star" /> With Icon
                </.badge>
                <.badge variant="destructive">
                  <.icon name="hero-check" />
                </.badge>
                <.badge variant="destructive">123</.badge>
              </.flex>
            </div>

            <div>
              <h3 class="text-sm font-medium text-muted-foreground mb-3">Outline</h3>
              <.flex justify="center" items="center" class="gap-2 flex-wrap">
                <.badge variant="outline">Badge</.badge>
                <.badge variant="outline">
                  <.icon name="hero-star" /> With Icon
                </.badge>
                <.badge variant="outline">
                  <.icon name="hero-check" />
                </.badge>
                <.badge variant="outline">123</.badge>
              </.flex>
            </div>
          </.stack>
        </section>
      </.stack>
    </.container>
    """
  end
end
