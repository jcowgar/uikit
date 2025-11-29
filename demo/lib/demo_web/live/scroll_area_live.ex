defmodule DemoWeb.Ui.ScrollAreaLive do
  @moduledoc false
  use DemoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    # Sample tags for demonstration
    tags = [
      "React",
      "Vue",
      "Angular",
      "Svelte",
      "Ember",
      "Backbone",
      "Knockout",
      "Phoenix",
      "Laravel",
      "Django",
      "Rails",
      "Express",
      "FastAPI",
      "Flask",
      "Spring",
      "ASP.NET",
      "Meteor",
      "Next.js",
      "Nuxt.js",
      "Gatsby",
      "SvelteKit",
      "Remix",
      "Astro",
      "Solid",
      "Qwik",
      "Alpine.js",
      "Htmx",
      "Stimulus"
    ]

    # Sample works of art for horizontal scroll demo
    artworks = [
      %{title: "Mona Lisa", artist: "Leonardo da Vinci", year: "1503-1519"},
      %{title: "The Starry Night", artist: "Vincent van Gogh", year: "1889"},
      %{title: "The Scream", artist: "Edvard Munch", year: "1893"},
      %{title: "Girl with a Pearl Earring", artist: "Johannes Vermeer", year: "1665"},
      %{title: "The Kiss", artist: "Gustav Klimt", year: "1907-1908"},
      %{title: "The Birth of Venus", artist: "Sandro Botticelli", year: "1485"},
      %{title: "American Gothic", artist: "Grant Wood", year: "1930"},
      %{title: "The Night Watch", artist: "Rembrandt", year: "1642"}
    ]

    {:ok, assign(socket, tags: tags, artworks: artworks)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.container>
      <.stack gap="xl">
        <%!-- Header --%>
        <div>
          <h1 class="text-3xl font-bold text-foreground">Scroll Area Component</h1>
          <p class="text-muted-foreground mt-2">
            Custom scrollable area with styled scrollbars for consistent cross-browser appearance.
          </p>
        </div>

        <%!-- Basic Vertical Scrolling --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">
            Vertical Scrolling (Default)
          </h2>
          <.card class="max-w-md">
            <.card_header>
              <.card_title>Tags</.card_title>
              <.card_description>Browse through popular frameworks and libraries</.card_description>
            </.card_header>
            <.card_content>
              <.scroll_area class="h-72 w-full rounded-md border border-border/50">
                <div class="p-4">
                  <%= for {tag, index} <- Enum.with_index(@tags) do %>
                    <div>
                      <div class="text-sm">{tag}</div>
                      <.separator :if={index < length(@tags) - 1} class="my-2" />
                    </div>
                  <% end %>
                </div>
              </.scroll_area>
            </.card_content>
          </.card>
        </section>

        <%!-- Horizontal Scrolling --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Horizontal Scrolling</h2>
          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>Works of Art</.card_title>
              <.card_description>Scroll horizontally to view the collection</.card_description>
            </.card_header>
            <.card_content>
              <.scroll_area class="w-full whitespace-nowrap rounded-md border border-border/50">
                <div class="flex w-max space-x-4 p-4">
                  <%= for artwork <- @artworks do %>
                    <figure class="shrink-0">
                      <div class="bg-muted rounded-md h-[150px] w-[200px] flex items-center justify-center">
                        <div class="text-center p-4">
                          <div class="font-semibold text-foreground text-sm mb-1">
                            {artwork.title}
                          </div>
                          <div class="text-xs text-muted-foreground">
                            {artwork.artist}
                          </div>
                          <div class="text-xs text-muted-foreground mt-1">
                            {artwork.year}
                          </div>
                        </div>
                      </div>
                    </figure>
                  <% end %>
                </div>
              </.scroll_area>
            </.card_content>
          </.card>
        </section>

        <%!-- Custom Height --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Custom Heights</h2>
          <.grid cols={2} class="max-w-4xl">
            <.card>
              <.card_header>
                <.card_title>Small (h-48)</.card_title>
                <.card_description>Compact scroll area</.card_description>
              </.card_header>
              <.card_content>
                <.scroll_area class="h-48 w-full rounded-md border border-border/50">
                  <div class="p-4 space-y-2">
                    <%= for i <- 1..15 do %>
                      <div class="text-sm text-foreground">Item {i}</div>
                    <% end %>
                  </div>
                </.scroll_area>
              </.card_content>
            </.card>

            <.card>
              <.card_header>
                <.card_title>Large (h-96)</.card_title>
                <.card_description>Spacious scroll area</.card_description>
              </.card_header>
              <.card_content>
                <.scroll_area class="h-96 w-full rounded-md border border-border/50">
                  <div class="p-4 space-y-2">
                    <%= for i <- 1..25 do %>
                      <div class="text-sm text-foreground">Item {i}</div>
                    <% end %>
                  </div>
                </.scroll_area>
              </.card_content>
            </.card>
          </.grid>
        </section>

        <%!-- In a Dialog/Modal Context --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">In Cards and Containers</h2>
          <.grid cols={2} class="max-w-4xl">
            <.card>
              <.card_header>
                <.card_title>Notifications</.card_title>
                <.card_description>Recent activity</.card_description>
              </.card_header>
              <.card_content class="p-0">
                <.scroll_area class="h-64 w-full">
                  <div class="p-6 space-y-4">
                    <%= for i <- 1..10 do %>
                      <div class="flex gap-3">
                        <div class="bg-primary/10 rounded-full size-8 flex items-center justify-center shrink-0">
                          <span class="text-xs font-semibold text-primary">{i}</span>
                        </div>
                        <div class="flex-1 min-w-0">
                          <p class="text-sm font-medium text-foreground">Notification {i}</p>
                          <p class="text-xs text-muted-foreground truncate">
                            Description of notification item number {i}
                          </p>
                        </div>
                      </div>
                    <% end %>
                  </div>
                </.scroll_area>
              </.card_content>
            </.card>

            <.card>
              <.card_header>
                <.card_title>Messages</.card_title>
                <.card_description>Inbox preview</.card_description>
              </.card_header>
              <.card_content class="p-0">
                <.scroll_area class="h-64 w-full">
                  <div class="divide-y divide-border">
                    <%= for i <- 1..12 do %>
                      <div class="p-4 hover:bg-accent/50 cursor-pointer transition-colors">
                        <div class="flex items-start gap-3">
                          <div class="bg-secondary rounded-full size-10 flex items-center justify-center shrink-0">
                            <span class="text-sm font-semibold text-secondary-foreground">
                              U{i}
                            </span>
                          </div>
                          <div class="flex-1 min-w-0">
                            <div class="flex items-center justify-between mb-1">
                              <p class="text-sm font-semibold text-foreground">User {i}</p>
                              <span class="text-xs text-muted-foreground">2h ago</span>
                            </div>
                            <p class="text-sm text-muted-foreground truncate">
                              Message preview text for item {i}...
                            </p>
                          </div>
                        </div>
                      </div>
                    <% end %>
                  </div>
                </.scroll_area>
              </.card_content>
            </.card>
          </.grid>
        </section>

        <%!-- With Content --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Rich Content</h2>
          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>Terms of Service</.card_title>
              <.card_description>Please read carefully</.card_description>
            </.card_header>
            <.card_content>
              <.scroll_area class="h-[400px] w-full rounded-md border border-border/50">
                <div class="p-6 space-y-4">
                  <div>
                    <h3 class="font-semibold text-foreground mb-2">1. Acceptance of Terms</h3>
                    <p class="text-sm text-muted-foreground">
                      By accessing and using this service, you accept and agree to be bound by the terms
                      and provision of this agreement. These terms of service outline the rules and
                      regulations for the use of our services.
                    </p>
                  </div>

                  <.separator />

                  <div>
                    <h3 class="font-semibold text-foreground mb-2">2. Use License</h3>
                    <p class="text-sm text-muted-foreground">
                      Permission is granted to temporarily access the materials on our service for personal,
                      non-commercial transitory viewing only. This is the grant of a license, not a transfer
                      of title, and under this license you may not modify or copy the materials.
                    </p>
                  </div>

                  <.separator />

                  <div>
                    <h3 class="font-semibold text-foreground mb-2">3. Disclaimer</h3>
                    <p class="text-sm text-muted-foreground">
                      The materials on our service are provided on an 'as is' basis. We make no warranties,
                      expressed or implied, and hereby disclaim and negate all other warranties including,
                      without limitation, implied warranties or conditions of merchantability, fitness for
                      a particular purpose, or non-infringement of intellectual property.
                    </p>
                  </div>

                  <.separator />

                  <div>
                    <h3 class="font-semibold text-foreground mb-2">4. Limitations</h3>
                    <p class="text-sm text-muted-foreground">
                      In no event shall we or our suppliers be liable for any damages (including, without
                      limitation, damages for loss of data or profit, or due to business interruption)
                      arising out of the use or inability to use the materials on our service.
                    </p>
                  </div>

                  <.separator />

                  <div>
                    <h3 class="font-semibold text-foreground mb-2">5. Revisions</h3>
                    <p class="text-sm text-muted-foreground">
                      We may revise these terms of service at any time without notice. By using this
                      service you are agreeing to be bound by the then current version of these terms
                      of service. Continued use of the service after changes constitutes acceptance.
                    </p>
                  </div>

                  <.separator />

                  <div>
                    <h3 class="font-semibold text-foreground mb-2">6. Privacy Policy</h3>
                    <p class="text-sm text-muted-foreground">
                      Your use of our service is also governed by our Privacy Policy. Please review our
                      Privacy Policy, which also governs the service and informs users of our data
                      collection practices. We are committed to protecting your privacy and personal
                      information.
                    </p>
                  </div>
                </div>
              </.scroll_area>
            </.card_content>
          </.card>
        </section>

        <%!-- Features --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Features</h2>
          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>Component Features</.card_title>
            </.card_header>
            <.card_content>
              <.stack gap="md">
                <ul class="text-sm text-muted-foreground space-y-2 list-disc list-inside">
                  <li>Cross-browser consistent scrollbar styling</li>
                  <li>Hides native scrollbars while maintaining scroll functionality</li>
                  <li>
                    Supports both vertical (default) and horizontal scrolling
                  </li>
                  <li>
                    Custom styled scrollbar with <code class="text-xs">&lt;.scroll_bar /&gt;</code>
                    component
                  </li>
                  <li>Keyboard navigation and focus ring support</li>
                  <li>Uses semantic border color that adapts to light/dark themes</li>
                  <li>Flexible sizing with custom height/width classes</li>
                  <li>
                    Works seamlessly in cards, dialogs, and other containers
                  </li>
                </ul>
              </.stack>
            </.card_content>
          </.card>
        </section>

        <%!-- Usage Guidelines --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Usage Guidelines</h2>
          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>When to Use</.card_title>
            </.card_header>
            <.card_content>
              <.stack gap="md">
                <div>
                  <h3 class="font-semibold text-foreground mb-2">Vertical Scrolling</h3>
                  <p class="text-sm text-muted-foreground">
                    Use for lists, tags, notifications, or any content that extends vertically beyond
                    the container. Set a fixed height with classes like
                    <code class="text-xs">h-72</code>
                    or <code class="text-xs">h-[400px]</code>.
                  </p>
                </div>

                <div>
                  <h3 class="font-semibold text-foreground mb-2">Horizontal Scrolling</h3>
                  <p class="text-sm text-muted-foreground">
                    Use for galleries, timelines, or wide content. Combine with
                    <code class="text-xs">whitespace-nowrap</code>
                    and flex layouts. Include
                    <code class="text-xs">&lt;.scroll_bar orientation="horizontal" /&gt;</code>
                    for a visible indicator.
                  </p>
                </div>

                <div>
                  <h3 class="font-semibold text-foreground mb-2">Height Sizing</h3>
                  <p class="text-sm text-muted-foreground">
                    Always specify a height on the scroll area using Tailwind height utilities. Common
                    heights include <code class="text-xs">h-48</code>
                    (12rem), <code class="text-xs">h-72</code>
                    (18rem), and <code class="text-xs">h-96</code>
                    (24rem).
                  </p>
                </div>

                <div>
                  <h3 class="font-semibold text-foreground mb-2">Nested in Cards</h3>
                  <p class="text-sm text-muted-foreground">
                    When using scroll areas in cards, you may want to set
                    <code class="text-xs">class="p-0"</code>
                    on <code class="text-xs">&lt;.card_content&gt;</code>
                    and add padding to the inner content for proper edge-to-edge scrolling.
                  </p>
                </div>
              </.stack>
            </.card_content>
          </.card>
        </section>
      </.stack>
    </.container>
    """
  end
end
