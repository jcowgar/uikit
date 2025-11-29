defmodule DemoWeb.Ui.RadioCardLive do
  @moduledoc false
  use DemoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:theme, "system")
      |> assign(:plan, "free")
      |> assign(:game_type, "8ball")
      |> assign(:break_type, "winner")

    {:ok, socket}
  end

  @impl true
  def handle_event("change_theme", %{"theme" => theme}, socket) do
    {:noreply, assign(socket, :theme, theme)}
  end

  @impl true
  def handle_event("change_plan", %{"plan" => plan}, socket) do
    {:noreply, assign(socket, :plan, plan)}
  end

  @impl true
  def handle_event("change_game_type", %{"game_type" => game_type}, socket) do
    {:noreply, assign(socket, :game_type, game_type)}
  end

  @impl true
  def handle_event("change_break_type", %{"break_type" => break_type}, socket) do
    {:noreply, assign(socket, :break_type, break_type)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.container>
      <.stack gap="xl">
        <%!-- Header --%>
        <div>
          <h1 class="text-3xl font-bold text-foreground">Radio Card Component</h1>
          <p class="text-muted-foreground mt-2">
            A selectable card with radio button - perfect for selection interfaces that need more context than a simple radio button.
          </p>
        </div>

        <%!-- Basic Example: Theme Selection --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Basic Usage - Theme Selection</h2>
          <p class="text-muted-foreground mb-4">
            Simple cards with title and description. Perfect for settings or preferences.
          </p>

          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>Choose Your Theme</.card_title>
              <.card_description>
                Select how you want the application to appear
              </.card_description>
            </.card_header>
            <.card_content>
              <form phx-change="change_theme">
                <.radio_group name="theme" value={@theme}>
                  <.radio_card
                    value="system"
                    id="theme-system"
                    name="theme"
                    checked={@theme == "system"}
                  >
                    <:title>System</:title>
                    <:description>
                      Automatically match your device's system theme
                    </:description>
                  </.radio_card>

                  <.radio_card value="light" id="theme-light" name="theme" checked={@theme == "light"}>
                    <:title>Light Mode</:title>
                    <:description>
                      Always use light theme regardless of system settings
                    </:description>
                  </.radio_card>

                  <.radio_card value="dark" id="theme-dark" name="theme" checked={@theme == "dark"}>
                    <:title>Dark Mode</:title>
                    <:description>
                      Always use dark theme regardless of system settings
                    </:description>
                  </.radio_card>
                </.radio_group>
              </form>

              <div class="mt-4 p-3 bg-muted rounded-md">
                <p class="text-sm font-medium">Selected: {@theme}</p>
              </div>
            </.card_content>
          </.card>
        </section>

        <%!-- Example with Visual Elements --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">With Visual Elements</h2>
          <p class="text-muted-foreground mb-4">
            Add icons or images to make options more visually distinct.
          </p>

          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>Select Game Type</.card_title>
              <.card_description>
                Choose which pool game you want to play
              </.card_description>
            </.card_header>
            <.card_content>
              <form phx-change="change_game_type">
                <.radio_group name="game_type" value={@game_type}>
                  <.radio_card
                    value="8ball"
                    id="game-8ball"
                    name="game_type"
                    checked={@game_type == "8ball"}
                  >
                    <:visual>
                      <div class="flex size-12 items-center justify-center rounded-full bg-primary/10">
                        <span class="text-2xl">🎱</span>
                      </div>
                    </:visual>
                    <:title>8-Ball</:title>
                    <:description>
                      Classic 8-ball pool game with solids and stripes
                    </:description>
                  </.radio_card>

                  <.radio_card
                    value="9ball"
                    id="game-9ball"
                    name="game_type"
                    checked={@game_type == "9ball"}
                  >
                    <:visual>
                      <div class="flex size-12 items-center justify-center rounded-full bg-primary/10">
                        <span class="text-2xl">9️⃣</span>
                      </div>
                    </:visual>
                    <:title>9-Ball</:title>
                    <:description>
                      Rotation game where balls must be hit in sequence
                    </:description>
                  </.radio_card>

                  <.radio_card
                    value="10ball"
                    id="game-10ball"
                    name="game_type"
                    checked={@game_type == "10ball"}
                  >
                    <:visual>
                      <div class="flex size-12 items-center justify-center rounded-full bg-primary/10">
                        <span class="text-2xl">🔟</span>
                      </div>
                    </:visual>
                    <:title>10-Ball</:title>
                    <:description>
                      Similar to 9-ball but with ten balls and call shot rules
                    </:description>
                  </.radio_card>
                </.radio_group>
              </form>

              <div class="mt-4 p-3 bg-muted rounded-md">
                <p class="text-sm font-medium">Selected: {@game_type}</p>
              </div>
            </.card_content>
          </.card>
        </section>

        <%!-- Example with Custom Content --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">With Custom Content</h2>
          <p class="text-muted-foreground mb-4">
            Use the content slot for pricing, feature lists, or any custom layout.
          </p>

          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>Choose Your Plan</.card_title>
              <.card_description>
                Select the plan that best fits your needs
              </.card_description>
            </.card_header>
            <.card_content>
              <form phx-change="change_plan">
                <.radio_group name="plan" value={@plan}>
                  <.radio_card value="free" id="plan-free" name="plan" checked={@plan == "free"}>
                    <:title>Free</:title>
                    <:description>Perfect for getting started</:description>
                    <:content>
                      <div class="mt-2">
                        <div class="text-2xl font-bold">$0<span class="text-sm font-normal text-muted-foreground">/month</span></div>
                        <ul class="mt-2 space-y-1 text-sm text-muted-foreground">
                          <li>✓ Up to 3 projects</li>
                          <li>✓ Basic support</li>
                          <li>✓ 1GB storage</li>
                        </ul>
                      </div>
                    </:content>
                  </.radio_card>

                  <.radio_card value="pro" id="plan-pro" name="plan" checked={@plan == "pro"}>
                    <:title>
                      <span>Pro</span>
                      <.badge variant="default" class="ml-2">Popular</.badge>
                    </:title>
                    <:description>For professionals and teams</:description>
                    <:content>
                      <div class="mt-2">
                        <div class="text-2xl font-bold">$29<span class="text-sm font-normal text-muted-foreground">/month</span></div>
                        <ul class="mt-2 space-y-1 text-sm text-muted-foreground">
                          <li>✓ Unlimited projects</li>
                          <li>✓ Priority support</li>
                          <li>✓ 100GB storage</li>
                          <li>✓ Advanced analytics</li>
                        </ul>
                      </div>
                    </:content>
                  </.radio_card>

                  <.radio_card
                    value="enterprise"
                    id="plan-enterprise"
                    name="plan"
                    checked={@plan == "enterprise"}
                  >
                    <:title>Enterprise</:title>
                    <:description>For large organizations</:description>
                    <:content>
                      <div class="mt-2">
                        <div class="text-2xl font-bold">Custom</div>
                        <ul class="mt-2 space-y-1 text-sm text-muted-foreground">
                          <li>✓ Unlimited everything</li>
                          <li>✓ 24/7 dedicated support</li>
                          <li>✓ Custom integrations</li>
                          <li>✓ SLA guarantees</li>
                        </ul>
                      </div>
                    </:content>
                  </.radio_card>
                </.radio_group>
              </form>

              <div class="mt-4 p-3 bg-muted rounded-md">
                <p class="text-sm font-medium">Selected: {@plan}</p>
              </div>
            </.card_content>
          </.card>
        </section>

        <%!-- Example: Break Type --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Pool League Settings</h2>
          <p class="text-muted-foreground mb-4">
            Example of using radio cards for game configuration.
          </p>

          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>Break Type</.card_title>
              <.card_description>
                Choose who breaks after the opening rack
              </.card_description>
            </.card_header>
            <.card_content>
              <form phx-change="change_break_type">
                <.radio_group name="break_type" value={@break_type}>
                  <.radio_card
                    value="winner"
                    id="break-winner"
                    name="break_type"
                    checked={@break_type == "winner"}
                  >
                    <:title>Winner Breaks</:title>
                    <:description>
                      The winner of each rack breaks the next rack
                    </:description>
                  </.radio_card>

                  <.radio_card
                    value="loser"
                    id="break-loser"
                    name="break_type"
                    checked={@break_type == "loser"}
                  >
                    <:title>Loser Breaks</:title>
                    <:description>
                      The loser of each rack breaks the next rack
                    </:description>
                  </.radio_card>

                  <.radio_card
                    value="alternating"
                    id="break-alternating"
                    name="break_type"
                    checked={@break_type == "alternating"}
                  >
                    <:title>Alternating Breaks</:title>
                    <:description>
                      Players alternate breaking regardless of who won the previous rack
                    </:description>
                  </.radio_card>
                </.radio_group>
              </form>

              <div class="mt-4 p-3 bg-muted rounded-md">
                <p class="text-sm font-medium">Selected: {@break_type}</p>
              </div>
            </.card_content>
          </.card>
        </section>

        <%!-- Example: Fully Custom Content --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Fully Custom Content</h2>
          <p class="text-muted-foreground mb-4">
            Don't use the predefined slots - provide completely custom HTML layout for maximum flexibility.
          </p>

          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>Custom Layout Example</.card_title>
              <.card_description>
                These cards use the inner_block slot with custom HTML instead of title/description slots
              </.card_description>
            </.card_header>
            <.card_content>
              <.radio_group name="custom_demo" value="custom1">
                <.radio_card
                  value="custom1"
                  id="custom-1"
                  name="custom_demo"
                  checked
                >
                  <div class="flex items-center gap-4">
                    <div class="flex size-16 items-center justify-center rounded-full bg-blue-500/10">
                      <span class="text-3xl">🎨</span>
                    </div>
                    <div class="flex-1">
                      <h3 class="text-lg font-bold">Creative Layout</h3>
                      <p class="text-sm text-muted-foreground mt-1">
                        Build your own custom card structure with complete control over markup and styling
                      </p>
                      <div class="mt-2 flex gap-2">
                        <.badge variant="default">Custom</.badge>
                        <.badge variant="outline">Flexible</.badge>
                      </div>
                    </div>
                  </div>
                </.radio_card>

                <.radio_card
                  value="custom2"
                  id="custom-2"
                  name="custom_demo"
                >
                  <div class="space-y-3">
                    <div class="flex items-start justify-between">
                      <h3 class="font-semibold text-base">Any Structure You Want</h3>
                      <.badge variant="success">Recommended</.badge>
                    </div>
                    <p class="text-sm text-muted-foreground">
                      Create grid layouts, complex hierarchies, custom spacing - anything you need.
                    </p>
                    <div class="grid grid-cols-2 gap-2 text-xs">
                      <div class="rounded bg-muted p-2">Feature A</div>
                      <div class="rounded bg-muted p-2">Feature B</div>
                      <div class="rounded bg-muted p-2">Feature C</div>
                      <div class="rounded bg-muted p-2">Feature D</div>
                    </div>
                  </div>
                </.radio_card>
              </.radio_group>
            </.card_content>
          </.card>
        </section>

        <%!-- Code Example --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Code Example</h2>

          <.code_block language="elixir">
            <pre><code>&lt;.radio_group name="theme" value={@theme}&gt;
              &lt;.radio_card
                value="system"
                id="theme-system"
                name="theme"
                checked={@theme == "system"}&gt;
                &lt;:title&gt;System&lt;/:title&gt;
                &lt;:description&gt;
                  Automatically match your device's system theme
                &lt;/:description&gt;
              &lt;/.radio_card&gt;

              &lt;.radio_card value="light" id="theme-light" name="theme"&gt;
                &lt;:title&gt;Light Mode&lt;/:title&gt;
                &lt;:description&gt;Always use light theme&lt;/:description&gt;
              &lt;/.radio_card&gt;
            &lt;/.radio_group&gt;</code></pre>
          </.code_block>
        </section>
      </.stack>
    </.container>
    """
  end
end
