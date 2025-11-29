defmodule DemoWeb.Ui.ProgressLive do
  @moduledoc false
  use DemoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:progress_value, 33)
      |> assign(:loading_value, 0)

    # Start a timer for the animated example
    if connected?(socket) do
      Process.send_after(self(), :increment_loading, 100)
    end

    {:ok, socket}
  end

  @impl true
  def handle_event("increment", _params, socket) do
    current = socket.assigns.progress_value
    {:noreply, assign(socket, :progress_value, min(current + 10, 100))}
  end

  @impl true
  def handle_event("decrement", _params, socket) do
    current = socket.assigns.progress_value
    {:noreply, assign(socket, :progress_value, max(current - 10, 0))}
  end

  @impl true
  def handle_event("set_to", %{"val" => val}, socket) when is_binary(val) do
    case Integer.parse(val) do
      {int_value, _} -> {:noreply, assign(socket, :progress_value, int_value)}
      :error -> {:noreply, socket}
    end
  end

  @impl true
  def handle_info(:increment_loading, socket) do
    new_value = rem(socket.assigns.loading_value + 1, 101)

    if new_value < 100 do
      Process.send_after(self(), :increment_loading, 50)
    else
      Process.send_after(self(), :increment_loading, 1000)
    end

    {:noreply, assign(socket, :loading_value, new_value)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.container>
      <.stack gap="xl">
        <%!-- Header --%>
        <div>
          <h1 class="text-3xl font-bold text-foreground">Progress</h1>
          <p class="text-muted-foreground mt-2">
            Displays an indicator showing the completion progress of a task, typically displayed as a progress bar.
          </p>
        </div>

        <%!-- Basic Examples --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Basic Examples</h2>
          <.stack gap="lg">
            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">33% complete</p>
              <.progress value={33} />
            </div>

            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">66% complete</p>
              <.progress value={66} />
            </div>

            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">100% complete</p>
              <.progress value={100} />
            </div>
          </.stack>
        </section>

        <%!-- Size Variants --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Size Variants</h2>
          <.stack gap="lg">
            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">Small (h-1)</p>
              <.progress value={60} class="h-1" />
            </div>

            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">Default (h-2)</p>
              <.progress value={60} class="h-2" />
            </div>

            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">Medium (h-3)</p>
              <.progress value={60} class="h-3" />
            </div>

            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">Large (h-4)</p>
              <.progress value={60} class="h-4" />
            </div>
          </.stack>
        </section>

        <%!-- Width Variants --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Width Variants</h2>
          <.stack gap="lg">
            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">Full width (default)</p>
              <.progress value={60} />
            </div>

            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">60% width</p>
              <.progress value={60} class="w-[60%]" />
            </div>

            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">40% width</p>
              <.progress value={60} class="w-[40%]" />
            </div>
          </.stack>
        </section>

        <%!-- Animated Example --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Animated Example</h2>
          <.card>
            <.card_header>
              <.card_title>Loading Content</.card_title>
              <.card_description>Watch the progress bar animate automatically</.card_description>
            </.card_header>
            <.card_content>
              <div class="space-y-2">
                <.flex justify="center" items="center" class="justify-between">
                  <span class="text-sm font-medium text-foreground">Loading...</span>
                  <span class="text-sm text-muted-foreground">{@loading_value}%</span>
                </.flex>
                <.progress value={@loading_value} />
              </div>
            </.card_content>
          </.card>
        </section>

        <%!-- Interactive Example --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Interactive Example</h2>
          <.card>
            <.card_header>
              <.card_title>Adjust Progress</.card_title>
              <.card_description>Use the buttons to change the progress value</.card_description>
            </.card_header>
            <.card_content>
              <.stack gap="md">
                <div class="space-y-2">
                  <.flex justify="center" items="center" class="justify-between">
                    <span class="text-sm font-medium text-foreground">Progress</span>
                    <span class="text-sm text-muted-foreground">{@progress_value}%</span>
                  </.flex>
                  <.progress value={@progress_value} />
                </div>

                <div class="space-y-3">
                  <div>
                    <p class="text-sm font-medium text-foreground mb-2">Adjust by 10%</p>
                    <.flex justify="center" items="center" class="gap-2">
                      <.button size="sm" variant="outline" phx-click="decrement">
                        <.icon name="hero-minus" /> -10%
                      </.button>
                      <.button size="sm" variant="outline" phx-click="increment">
                        <.icon name="hero-plus" /> +10%
                      </.button>
                    </.flex>
                  </div>

                  <div>
                    <p class="text-sm font-medium text-foreground mb-2">Set to specific value</p>
                    <.flex justify="center" items="center" class="gap-2 flex-wrap">
                      <.button
                        size="sm"
                        variant="outline"
                        type="button"
                        phx-click="set_to"
                        phx-value-val="0"
                      >
                        0%
                      </.button>
                      <.button
                        size="sm"
                        variant="outline"
                        type="button"
                        phx-click="set_to"
                        phx-value-val="25"
                      >
                        25%
                      </.button>
                      <.button
                        size="sm"
                        variant="outline"
                        type="button"
                        phx-click="set_to"
                        phx-value-val="50"
                      >
                        50%
                      </.button>
                      <.button
                        size="sm"
                        variant="outline"
                        type="button"
                        phx-click="set_to"
                        phx-value-val="75"
                      >
                        75%
                      </.button>
                      <.button
                        size="sm"
                        variant="outline"
                        type="button"
                        phx-click="set_to"
                        phx-value-val="100"
                      >
                        100%
                      </.button>
                    </.flex>
                  </div>
                </div>
              </.stack>
            </.card_content>
          </.card>
        </section>

        <%!-- With Labels --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">With Labels</h2>
          <.stack gap="lg">
            <.card>
              <.card_header>
                <.card_title>File Upload</.card_title>
                <.card_description>Uploading document.pdf</.card_description>
              </.card_header>
              <.card_content>
                <div class="space-y-2">
                  <.flex justify="center" items="center" class="justify-between">
                    <span class="text-sm font-medium text-foreground">Uploading...</span>
                    <span class="text-sm text-muted-foreground">75%</span>
                  </.flex>
                  <.progress value={75} />
                </div>
              </.card_content>
            </.card>

            <.card>
              <.card_header>
                <.card_title>Profile Completion</.card_title>
                <.card_description>Complete your profile to get started</.card_description>
              </.card_header>
              <.card_content>
                <div class="space-y-2">
                  <.flex justify="center" items="center" class="justify-between">
                    <span class="text-sm font-medium text-foreground">4 of 6 steps completed</span>
                    <span class="text-sm text-muted-foreground">66%</span>
                  </.flex>
                  <.progress value={66} />
                  <p class="text-xs text-muted-foreground">
                    Add your profile photo and bio to continue
                  </p>
                </div>
              </.card_content>
            </.card>
          </.stack>
        </section>

        <%!-- In Cards - Multiple Progress Indicators --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Multiple Progress Indicators</h2>
          <.card>
            <.card_header>
              <.card_title>Project Tasks</.card_title>
              <.card_description>Track progress across multiple areas</.card_description>
            </.card_header>
            <.card_content>
              <.stack gap="md">
                <div class="space-y-1">
                  <.flex justify="center" items="center" class="justify-between">
                    <span class="text-sm font-medium text-foreground">Design</span>
                    <span class="text-xs text-muted-foreground">90%</span>
                  </.flex>
                  <.progress value={90} class="h-1.5" />
                </div>

                <div class="space-y-1">
                  <.flex justify="center" items="center" class="justify-between">
                    <span class="text-sm font-medium text-foreground">Development</span>
                    <span class="text-xs text-muted-foreground">45%</span>
                  </.flex>
                  <.progress value={45} class="h-1.5" />
                </div>

                <div class="space-y-1">
                  <.flex justify="center" items="center" class="justify-between">
                    <span class="text-sm font-medium text-foreground">Testing</span>
                    <span class="text-xs text-muted-foreground">20%</span>
                  </.flex>
                  <.progress value={20} class="h-1.5" />
                </div>

                <div class="space-y-1">
                  <.flex justify="center" items="center" class="justify-between">
                    <span class="text-sm font-medium text-foreground">Documentation</span>
                    <span class="text-xs text-muted-foreground">10%</span>
                  </.flex>
                  <.progress value={10} class="h-1.5" />
                </div>
              </.stack>
            </.card_content>
          </.card>
        </section>

        <%!-- Edge Cases --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Edge Cases</h2>
          <.stack gap="lg">
            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">Empty (0%)</p>
              <.progress value={0} />
            </div>

            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">Complete (100%)</p>
              <.progress value={100} />
            </div>

            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">Nearly empty (1%)</p>
              <.progress value={1} />
            </div>

            <div class="space-y-2">
              <p class="text-sm text-muted-foreground">Nearly complete (99%)</p>
              <.progress value={99} />
            </div>
          </.stack>
        </section>
      </.stack>
    </.container>
    """
  end
end
