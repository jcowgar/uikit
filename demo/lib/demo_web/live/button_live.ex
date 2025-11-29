defmodule DemoWeb.Ui.ButtonLive do
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
          <h1 class="text-3xl font-bold text-foreground">Button Component</h1>
          <p class="text-muted-foreground mt-2">
            Displays a button or a component that looks like a button.
          </p>
        </div>

        <%!-- Variants --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Variants</h2>
          <.flex justify="start" items="start" class="gap-4 flex-wrap">
            <.button>Default</.button>
            <.button variant="secondary">Secondary</.button>
            <.button variant="destructive">Destructive</.button>
            <.button variant="outline">Outline</.button>
            <.button variant="ghost">Ghost</.button>
            <.button variant="link">Link</.button>
          </.flex>
        </section>

        <%!-- Sizes --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Sizes</h2>
          <.flex justify="center" items="center" class="gap-4 flex-wrap">
            <.button size="sm">Small</.button>
            <.button>Default</.button>
            <.button size="lg">Large</.button>
          </.flex>
        </section>

        <%!-- Icon Buttons --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Icon Buttons</h2>
          <.flex justify="center" items="center" class="gap-4 flex-wrap">
            <.button size="icon-sm" aria-label="Small icon">
              <.icon name="hero-heart" />
            </.button>
            <.button size="icon" aria-label="Default icon">
              <.icon name="hero-heart" />
            </.button>
            <.button size="icon-lg" aria-label="Large icon">
              <.icon name="hero-heart" />
            </.button>
          </.flex>
        </section>

        <%!-- With Icons --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">With Icons</h2>
          <.flex justify="start" items="start" class="gap-4 flex-wrap">
            <.button>
              <.icon name="hero-envelope" /> Login with Email
            </.button>
            <.button variant="outline">
              <.icon name="hero-arrow-left" /> Back
            </.button>
            <.button variant="secondary">
              Continue <.icon name="hero-arrow-right" />
            </.button>
          </.flex>
        </section>

        <%!-- Disabled State --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Disabled</h2>
          <.flex justify="start" items="start" class="gap-4 flex-wrap">
            <.button disabled>Disabled Default</.button>
            <.button variant="outline" disabled>Disabled Outline</.button>
            <.button variant="secondary" disabled>Disabled Secondary</.button>
          </.flex>
        </section>

        <%!-- Loading State (custom example) --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Loading</h2>
          <.flex justify="start" items="start" class="gap-4 flex-wrap">
            <.button disabled>
              <.icon name="hero-arrow-path" class="animate-spin" /> Loading...
            </.button>
            <.button variant="outline" disabled>
              <.icon name="hero-arrow-path" class="animate-spin" /> Please wait
            </.button>
          </.flex>
        </section>

        <%!-- All Variants x All Sizes Matrix --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-6">
            Complete Variant × Size Matrix
          </h2>
          <.stack gap="lg">
            <div>
              <h3 class="text-sm font-medium text-muted-foreground mb-3">Default</h3>
              <.flex justify="center" items="center" class="gap-3">
                <.button size="sm">Small</.button>
                <.button>Default</.button>
                <.button size="lg">Large</.button>
              </.flex>
            </div>

            <div>
              <h3 class="text-sm font-medium text-muted-foreground mb-3">Secondary</h3>
              <.flex justify="center" items="center" class="gap-3">
                <.button variant="secondary" size="sm">Small</.button>
                <.button variant="secondary">Default</.button>
                <.button variant="secondary" size="lg">Large</.button>
              </.flex>
            </div>

            <div>
              <h3 class="text-sm font-medium text-muted-foreground mb-3">Destructive</h3>
              <.flex justify="center" items="center" class="gap-3">
                <.button variant="destructive" size="sm">Small</.button>
                <.button variant="destructive">Default</.button>
                <.button variant="destructive" size="lg">Large</.button>
              </.flex>
            </div>

            <div>
              <h3 class="text-sm font-medium text-muted-foreground mb-3">Outline</h3>
              <.flex justify="center" items="center" class="gap-3">
                <.button variant="outline" size="sm">Small</.button>
                <.button variant="outline">Default</.button>
                <.button variant="outline" size="lg">Large</.button>
              </.flex>
            </div>

            <div>
              <h3 class="text-sm font-medium text-muted-foreground mb-3">Ghost</h3>
              <.flex justify="center" items="center" class="gap-3">
                <.button variant="ghost" size="sm">Small</.button>
                <.button variant="ghost">Default</.button>
                <.button variant="ghost" size="lg">Large</.button>
              </.flex>
            </div>

            <div>
              <h3 class="text-sm font-medium text-muted-foreground mb-3">Link</h3>
              <.flex justify="center" items="center" class="gap-3">
                <.button variant="link" size="sm">Small</.button>
                <.button variant="link">Default</.button>
                <.button variant="link" size="lg">Large</.button>
              </.flex>
            </div>
          </.stack>
        </section>
      </.stack>
    </.container>
    """
  end
end
