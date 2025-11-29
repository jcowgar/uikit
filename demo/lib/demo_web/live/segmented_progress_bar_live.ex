defmodule DemoWeb.Ui.SegmentedProgressBarLive do
  @moduledoc false
  use DemoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:race_to_5, 2)
      |> assign(:race_to_7, 4)
      |> assign(:skill_level, 3)

    {:ok, socket}
  end

  @impl true
  def handle_event("increment", %{"bar" => bar}, socket) do
    case bar do
      "race5" ->
        current = socket.assigns.race_to_5
        {:noreply, assign(socket, :race_to_5, min(current + 1, 5))}

      "race7" ->
        current = socket.assigns.race_to_7
        {:noreply, assign(socket, :race_to_7, min(current + 1, 7))}

      "skill" ->
        current = socket.assigns.skill_level
        {:noreply, assign(socket, :skill_level, min(current + 1, 5))}

      _ ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("decrement", %{"bar" => bar}, socket) do
    case bar do
      "race5" ->
        current = socket.assigns.race_to_5
        {:noreply, assign(socket, :race_to_5, max(current - 1, 0))}

      "race7" ->
        current = socket.assigns.race_to_7
        {:noreply, assign(socket, :race_to_7, max(current - 1, 0))}

      "skill" ->
        current = socket.assigns.skill_level
        {:noreply, assign(socket, :skill_level, max(current - 1, 0))}

      _ ->
        {:noreply, socket}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.container>
      <.stack gap="xl">
        <%!-- Header --%>
        <div>
          <h1 class="text-3xl font-bold text-foreground">Segmented Progress Bar</h1>
          <p class="text-muted-foreground mt-2">
            Display progress through distinct segments, ideal for race-to-target scenarios like game scoring.
          </p>
        </div>

        <%!-- Basic Examples --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Basic Examples</h2>
          <.stack gap="lg">
            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">2 of 5 segments filled</p>
              <.segmented_progress_bar total={5} filled={2} />
            </div>

            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">4 of 7 segments filled</p>
              <.segmented_progress_bar total={7} filled={4} />
            </div>

            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">1 of 3 segments filled</p>
              <.segmented_progress_bar total={3} filled={1} />
            </div>
          </.stack>
        </section>

        <%!-- Size Variants --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Size Variants</h2>
          <.stack gap="lg">
            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">Small (h-1)</p>
              <.segmented_progress_bar total={5} filled={2} class="h-1" />
            </div>

            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">Default (h-2)</p>
              <.segmented_progress_bar total={5} filled={2} class="h-2" />
            </div>

            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">Medium (h-3)</p>
              <.segmented_progress_bar total={5} filled={2} class="h-3" />
            </div>

            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">Large (h-4)</p>
              <.segmented_progress_bar total={5} filled={2} class="h-4" />
            </div>
          </.stack>
        </section>

        <%!-- Gap Variants --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Gap Variants</h2>
          <.stack gap="lg">
            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">No gap (gap-0)</p>
              <.segmented_progress_bar total={5} filled={2} gap={0} />
            </div>

            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">Small gap (gap-1)</p>
              <.segmented_progress_bar total={5} filled={2} gap={1} />
            </div>

            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">Default gap (gap-2)</p>
              <.segmented_progress_bar total={5} filled={2} gap={2} />
            </div>

            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">Large gap (gap-4)</p>
              <.segmented_progress_bar total={5} filled={2} gap={4} />
            </div>
          </.stack>
        </section>

        <%!-- Color Variants --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Color Variants</h2>
          <.stack gap="lg">
            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">Primary (default)</p>
              <.segmented_progress_bar total={5} filled={3} />
            </div>

            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">Success</p>
              <.segmented_progress_bar
                total={5}
                filled={3}
                filled_class="bg-success"
                empty_class="bg-success/20"
              />
            </div>

            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">Warning</p>
              <.segmented_progress_bar
                total={5}
                filled={3}
                filled_class="bg-warning"
                empty_class="bg-warning/20"
              />
            </div>

            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">Destructive</p>
              <.segmented_progress_bar
                total={5}
                filled={3}
                filled_class="bg-destructive"
                empty_class="bg-destructive/20"
              />
            </div>

            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">Info</p>
              <.segmented_progress_bar
                total={5}
                filled={3}
                filled_class="bg-info"
                empty_class="bg-info/20"
              />
            </div>
          </.stack>
        </section>

        <%!-- Interactive Examples --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Interactive Examples</h2>
          <.stack gap="lg">
            <.card>
              <.card_header>
                <.card_title>Pool Game - Race to 5</.card_title>
                <.card_description>Track wins in a race-to-5 format</.card_description>
              </.card_header>
              <.card_content>
                <.stack gap="md">
                  <div class="space-y-2">
                    <.flex justify="center" items="center" class="justify-between">
                      <span class="text-sm font-medium text-foreground">
                        Games Won: {@race_to_5} / 5
                      </span>
                      <.flex justify="center" items="center" class="gap-2">
                        <.button
                          size="sm"
                          variant="outline"
                          phx-click="decrement"
                          phx-value-bar="race5"
                        >
                          <.icon name="hero-minus" />
                        </.button>
                        <.button
                          size="sm"
                          variant="outline"
                          phx-click="increment"
                          phx-value-bar="race5"
                        >
                          <.icon name="hero-plus" />
                        </.button>
                      </.flex>
                    </.flex>
                    <.segmented_progress_bar
                      total={5}
                      filled={@race_to_5}
                      class="h-3"
                      filled_class="bg-success"
                      empty_class="bg-accent"
                    />
                  </div>
                </.stack>
              </.card_content>
            </.card>

            <.card>
              <.card_header>
                <.card_title>Tournament - Race to 7</.card_title>
                <.card_description>Track wins in a race-to-7 format</.card_description>
              </.card_header>
              <.card_content>
                <.stack gap="md">
                  <div class="space-y-2">
                    <.flex justify="center" items="center" class="justify-between">
                      <span class="text-sm font-medium text-foreground">
                        Games Won: {@race_to_7} / 7
                      </span>
                      <.flex justify="center" items="center" class="gap-2">
                        <.button
                          size="sm"
                          variant="outline"
                          phx-click="decrement"
                          phx-value-bar="race7"
                        >
                          <.icon name="hero-minus" />
                        </.button>
                        <.button
                          size="sm"
                          variant="outline"
                          phx-click="increment"
                          phx-value-bar="race7"
                        >
                          <.icon name="hero-plus" />
                        </.button>
                      </.flex>
                    </.flex>
                    <.segmented_progress_bar
                      total={7}
                      filled={@race_to_7}
                      class="h-3"
                      filled_class="bg-info"
                      empty_class="bg-accent"
                    />
                  </div>
                </.stack>
              </.card_content>
            </.card>

            <.card>
              <.card_header>
                <.card_title>Skill Level</.card_title>
                <.card_description>Visual skill progression indicator</.card_description>
              </.card_header>
              <.card_content>
                <.stack gap="md">
                  <div class="space-y-2">
                    <.flex justify="center" items="center" class="justify-between">
                      <span class="text-sm font-medium text-foreground">
                        Level {@skill_level} / 5
                      </span>
                      <.flex justify="center" items="center" class="gap-2">
                        <.button
                          size="sm"
                          variant="outline"
                          phx-click="decrement"
                          phx-value-bar="skill"
                        >
                          <.icon name="hero-minus" />
                        </.button>
                        <.button
                          size="sm"
                          variant="outline"
                          phx-click="increment"
                          phx-value-bar="skill"
                        >
                          <.icon name="hero-plus" />
                        </.button>
                      </.flex>
                    </.flex>
                    <.segmented_progress_bar
                      total={5}
                      filled={@skill_level}
                      class="h-3"
                      filled_class="bg-warning"
                      empty_class="bg-accent"
                    />
                  </div>
                </.stack>
              </.card_content>
            </.card>
          </.stack>
        </section>

        <%!-- In Cards - Scoreboard Example --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Scoreboard Example</h2>
          <.grid cols={2}>
            <.card>
              <.card_header>
                <.card_title>Player 1</.card_title>
                <.card_description>Current leader</.card_description>
              </.card_header>
              <.card_content>
                <.stack gap="md">
                  <div class="space-y-1">
                    <span class="text-2xl font-bold text-foreground">3</span>
                    <p class="text-xs text-muted-foreground">Games won</p>
                  </div>
                  <.segmented_progress_bar
                    total={5}
                    filled={3}
                    class="h-2"
                    filled_class="bg-success"
                    empty_class="bg-success/20"
                  />
                </.stack>
              </.card_content>
            </.card>

            <.card>
              <.card_header>
                <.card_title>Player 2</.card_title>
                <.card_description>Trailing</.card_description>
              </.card_header>
              <.card_content>
                <.stack gap="md">
                  <div class="space-y-1">
                    <span class="text-2xl font-bold text-foreground">1</span>
                    <p class="text-xs text-muted-foreground">Games won</p>
                  </div>
                  <.segmented_progress_bar
                    total={5}
                    filled={1}
                    class="h-2"
                    filled_class="bg-primary"
                    empty_class="bg-accent"
                  />
                </.stack>
              </.card_content>
            </.card>
          </.grid>
        </section>

        <%!-- Edge Cases --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Edge Cases</h2>
          <.stack gap="lg">
            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">Empty (0 of 5)</p>
              <.segmented_progress_bar total={5} filled={0} />
            </div>

            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">Complete (5 of 5)</p>
              <.segmented_progress_bar total={5} filled={5} />
            </div>

            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">Single segment</p>
              <.segmented_progress_bar total={1} filled={1} />
            </div>

            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">Many segments (20 total)</p>
              <.segmented_progress_bar total={20} filled={12} class="h-1" gap={1} />
            </div>
          </.stack>
        </section>
      </.stack>
    </.container>
    """
  end
end
