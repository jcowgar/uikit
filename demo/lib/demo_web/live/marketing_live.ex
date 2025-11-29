defmodule DemoWeb.Ui.MarketingLive do
  @moduledoc """
  Demonstrates the Hero and CTA marketing components.
  """
  use DemoWeb, :live_view

  import UiKit.Components.LayoutComponents
  import UiKit.Components.Ui.Marketing
  import UiKit.Components.Ui.Typography

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.container class="!py-12">
      <.stack gap="xl">
        <h1 class="text-4xl font-bold tracking-tight text-foreground">Marketing Components</h1>
        <p class="mt-4 text-lg text-muted-foreground">
          Showcase of Hero and Call-to-Action components for landing pages.
        </p>

        <.typography variant={:h2}>Hero Component</.typography>

        <.hero>
          <:headline>Welcome to the Open Pool League</:headline>
          <:subheadline>Play, Learn, Grow</:subheadline>
          <:description>
            Join thousands of players worldwide in the premier digital pool league.
            Improve your skills, compete with friends, and become a champion!
          </:description>
          <:actions>
            <.button>Get Started</.button>
            <.button variant="secondary">Learn More</.button>
          </:actions>
        </.hero>

        <.hero variant={:primary} align={:left} size={:large}>
          <:headline>Become a Member Today</:headline>
          <:description>
            Unlock exclusive features, track your progress, and get matched with players
            who challenge your skill level.
          </:description>
          <:actions>
            <.button>Sign Up Now</.button>
          </:actions>
        </.hero>

        <.hero variant={:muted}>
          <:headline>New Season Starts Soon!</:headline>
          <:subheadline>Don't Miss Out</:subheadline>
          <:description>
            Register your team before the deadline to secure your spot in the next exciting season.
          </:description>
          <:actions>
            <.button variant="ghost">View Schedule</.button>
          </:actions>
        </.hero>

        <.typography variant={:h2}>Call-to-Action (CTA) Component</.typography>

        <.cta>
          <:headline>Ready to Elevate Your Game?</:headline>
          <:description>
            Join OPL today and start your journey to becoming a pool master.
          </:description>
          <:actions>
            <.button>Find a Team</.button>
            <.button variant="outline">Contact Us</.button>
          </:actions>
        </.cta>

        <.cta variant={:primary} align={:left}>
          <:headline>Download the OPLHub App</:headline>
          <:description>
            Get real-time scores, schedules, and player stats right on your mobile device.
          </:description>
          <:actions>
            <.button>App Store</.button>
            <.button variant="secondary">Google Play</.button>
          </:actions>
        </.cta>

        <.cta variant={:muted}>
          <:headline>Have Questions?</:headline>
          <:description>
            Our support team is here to help you get started.
          </:description>
          <:actions>
            <.button variant="ghost">Visit FAQ</.button>
          </:actions>
        </.cta>
      </.stack>
    </.container>
    """
  end
end
