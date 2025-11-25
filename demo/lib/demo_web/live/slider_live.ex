defmodule DemoWeb.Ui.SliderLive do
  @moduledoc false
  use DemoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:volume, 50)
      |> assign(:brightness, 75)
      |> assign(:price, 250)
      |> assign(:form_message, nil)
      |> assign(:form_data, nil)

    {:ok, socket}
  end

  @impl true
  def handle_event("volume_changed", %{"volume" => volume}, socket) do
    {:noreply, assign(socket, :volume, String.to_integer(volume))}
  end

  @impl true
  def handle_event("brightness_changed", %{"brightness" => brightness}, socket) do
    {:noreply, assign(socket, :brightness, String.to_integer(brightness))}
  end

  @impl true
  def handle_event("price_changed", %{"price" => price}, socket) do
    {:noreply, assign(socket, :price, String.to_integer(price))}
  end

  @impl true
  def handle_event("save_audio_settings", %{"audio" => audio}, socket) do
    volume = Map.get(audio, "volume", "50") |> String.to_integer()
    bass = Map.get(audio, "bass", "50") |> String.to_integer()
    treble = Map.get(audio, "treble", "50") |> String.to_integer()

    message = """
    Audio settings saved! Here's what the server received:

    • Volume: #{volume}%
    • Bass: #{bass}%
    • Treble: #{treble}%
    """

    {:noreply,
     socket
     |> assign(:form_message, message)
     |> assign(:form_data, %{volume: volume, bass: bass, treble: treble})}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.container>
      <.stack size="large">
        <%!-- Header --%>
        <div>
          <h1 class="text-3xl font-bold text-foreground">Slider Component</h1>
          <p class="text-muted-foreground mt-2">
            An input where the user selects a value from within a given range.
          </p>
        </div>

        <%!-- Basic Slider --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Basic Usage</h2>
          <.card class="max-w-md">
            <.card_content class="pt-6">
              <.stack size="medium">
                <div>
                  <.label for="basic-slider" class="mb-2 block">Default slider</.label>
                  <.slider id="basic-slider" name="basic" />
                </div>

                <div>
                  <.label for="preset-slider" class="mb-2 block">With preset value (33)</.label>
                  <.slider id="preset-slider" name="preset" value={33} />
                </div>

                <div>
                  <.label for="max-slider" class="mb-2 block">At maximum (100)</.label>
                  <.slider id="max-slider" name="max" value={100} />
                </div>
              </.stack>
            </.card_content>
          </.card>
        </section>

        <%!-- With Value Display --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">With Value Display</h2>
          <.card class="max-w-md">
            <.card_content class="pt-6">
              <.stack size="medium">
                <div>
                  <.label for="value-slider" class="mb-2 block">Shows current value</.label>
                  <.slider id="value-slider" name="with_value" value={50} show_value />
                </div>

                <div>
                  <.label for="percent-slider" class="mb-2 block">Percentage (0-100)</.label>
                  <.slider id="percent-slider" name="percent" value={75} show_value />
                </div>
              </.stack>
            </.card_content>
          </.card>
        </section>

        <%!-- Custom Range and Step --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Custom Range & Step</h2>
          <.card class="max-w-md">
            <.card_content class="pt-6">
              <.stack size="medium">
                <div>
                  <.label for="temp-slider" class="mb-2 block">Temperature (60-90°F, step 1)</.label>
                  <.slider id="temp-slider" name="temperature" min={60} max={90} value={72} show_value />
                </div>

                <div>
                  <.label for="price-slider" class="mb-2 block">Price ($0-$1000, step $50)</.label>
                  <.slider
                    id="price-slider"
                    name="price_range"
                    min={0}
                    max={1000}
                    step={50}
                    value={500}
                    show_value
                  />
                </div>

                <div>
                  <.label for="rating-slider" class="mb-2 block">Rating (1-5 stars)</.label>
                  <.slider id="rating-slider" name="rating" min={1} max={5} step={1} value={3} show_value />
                </div>
              </.stack>
            </.card_content>
          </.card>
        </section>

        <%!-- Interactive Sliders --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Interactive Sliders</h2>
          <.card class="max-w-md">
            <.card_header>
              <.card_title>Live Updates</.card_title>
              <.card_description>
                These sliders update in real-time as you drag
              </.card_description>
            </.card_header>
            <.card_content>
              <.stack size="large">
                <div>
                  <div class="flex items-center justify-between mb-2">
                    <.label for="volume-control">Volume</.label>
                    <span
                      class="text-sm text-muted-foreground tabular-nums"
                      data-slider-value="volume-control"
                      data-slider-suffix="%"
                    >{@volume}%</span>
                  </div>
                  <.slider
                    id="volume-control"
                    name="volume"
                    value={@volume}
                    show_value={false}
                    phx-change="volume_changed"
                  />
                </div>

                <div>
                  <div class="flex items-center justify-between mb-2">
                    <.label for="brightness-control">Brightness</.label>
                    <span
                      class="text-sm text-muted-foreground tabular-nums"
                      data-slider-value="brightness-control"
                      data-slider-suffix="%"
                    >{@brightness}%</span>
                  </div>
                  <.slider
                    id="brightness-control"
                    name="brightness"
                    value={@brightness}
                    show_value={false}
                    phx-change="brightness_changed"
                  />
                </div>

                <div>
                  <div class="flex items-center justify-between mb-2">
                    <.label for="price-control">Max Price</.label>
                    <span
                      class="text-sm text-muted-foreground tabular-nums"
                      data-slider-value="price-control"
                      data-slider-prefix="$"
                    >${@price}</span>
                  </div>
                  <.slider
                    id="price-control"
                    name="price"
                    min={0}
                    max={1000}
                    step={10}
                    value={@price}
                    show_value={false}
                    phx-change="price_changed"
                  />
                </div>
              </.stack>
            </.card_content>
          </.card>
        </section>

        <%!-- Filled Slider Variant --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Filled Track Variant</h2>
          <p class="text-sm text-muted-foreground mb-4">
            The filled variant shows the selected range with a colored track.
          </p>
          <.card class="max-w-md">
            <.card_content class="pt-6">
              <.stack size="medium">
                <div>
                  <.label for="filled-25" class="mb-2 block">25% filled</.label>
                  <.slider_filled id="filled-25" name="filled_25" value={25} />
                </div>

                <div>
                  <.label for="filled-50" class="mb-2 block">50% filled</.label>
                  <.slider_filled id="filled-50" name="filled_50" value={50} />
                </div>

                <div>
                  <.label for="filled-75" class="mb-2 block">75% filled</.label>
                  <.slider_filled id="filled-75" name="filled_75" value={75} />
                </div>

                <div>
                  <.label for="filled-value" class="mb-2 block">With value display</.label>
                  <.slider_filled id="filled-value" name="filled_value" value={60} show_value />
                </div>
              </.stack>
            </.card_content>
          </.card>
        </section>

        <%!-- Disabled State --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Disabled State</h2>
          <.card class="max-w-md">
            <.card_content class="pt-6">
              <.stack size="medium">
                <div>
                  <.label for="disabled-slider" class="mb-2 block">Disabled slider</.label>
                  <.slider id="disabled-slider" name="disabled" value={50} disabled />
                </div>

                <div>
                  <.label for="disabled-filled" class="mb-2 block">Disabled filled slider</.label>
                  <.slider_filled id="disabled-filled" name="disabled_filled" value={75} disabled />
                </div>
              </.stack>
            </.card_content>
          </.card>
        </section>

        <%!-- Form Example --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Form Example</h2>
          <p class="text-sm text-muted-foreground mb-4">
            This is a working form that demonstrates slider components submitting data.
            Adjust the sliders and click "Save Settings" to see the round trip.
          </p>
          <.card class="max-w-md">
            <.card_header>
              <.card_title>Audio Settings</.card_title>
              <.card_description>
                Adjust your audio preferences
              </.card_description>
            </.card_header>
            <.card_content>
              <form phx-submit="save_audio_settings">
                <.stack size="large">
                  <div>
                    <.label for="form-volume" class="mb-2 block">Volume</.label>
                    <.slider_filled id="form-volume" name="audio[volume]" value={70} show_value />
                  </div>

                  <div>
                    <.label for="form-bass" class="mb-2 block">Bass</.label>
                    <.slider_filled id="form-bass" name="audio[bass]" value={50} show_value />
                  </div>

                  <div>
                    <.label for="form-treble" class="mb-2 block">Treble</.label>
                    <.slider_filled id="form-treble" name="audio[treble]" value={50} show_value />
                  </div>

                  <.button class="w-full">Save Settings</.button>
                </.stack>
              </form>
            </.card_content>
          </.card>

          <%!-- Display form submission result --%>
          <.card :if={@form_message} class="max-w-md mt-4">
            <.card_header>
              <.card_title>Server Response</.card_title>
              <.card_description>
                This shows what the server received from the form
              </.card_description>
            </.card_header>
            <.card_content>
              <pre class="text-sm text-foreground whitespace-pre-wrap bg-muted p-4 rounded-md"><%= @form_message %></pre>
            </.card_content>
          </.card>
        </section>

        <%!-- With Labels and Icons --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">With Labels and Icons</h2>
          <.card class="max-w-md">
            <.card_content class="pt-6">
              <.stack size="large">
                <div>
                  <div class="flex items-center gap-2 mb-2">
                    <span class="hero-speaker-wave size-4 text-muted-foreground" />
                    <.label for="icon-volume">Volume</.label>
                  </div>
                  <div class="flex items-center gap-3">
                    <span class="hero-speaker-x-mark size-4 text-muted-foreground" />
                    <.slider id="icon-volume" name="icon_volume" value={50} class="flex-1" />
                    <span class="hero-speaker-wave size-4 text-muted-foreground" />
                  </div>
                </div>

                <div>
                  <div class="flex items-center gap-2 mb-2">
                    <span class="hero-sun size-4 text-muted-foreground" />
                    <.label for="icon-brightness">Brightness</.label>
                  </div>
                  <div class="flex items-center gap-3">
                    <span class="hero-moon size-4 text-muted-foreground" />
                    <.slider_filled id="icon-brightness" name="icon_brightness" value={75} class="flex-1" />
                    <span class="hero-sun size-4 text-muted-foreground" />
                  </div>
                </div>
              </.stack>
            </.card_content>
          </.card>
        </section>

        <%!-- Accessibility Features --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Accessibility</h2>
          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>Accessibility Features</.card_title>
            </.card_header>
            <.card_content>
              <.stack size="small">
                <p class="text-sm text-muted-foreground">
                  The slider component includes several accessibility features:
                </p>
                <ul class="text-sm text-muted-foreground space-y-2 list-disc list-inside">
                  <li>
                    Native HTML5 <code class="text-xs">input[type="range"]</code> for full keyboard support
                  </li>
                  <li>
                    Arrow keys to increment/decrement value
                  </li>
                  <li>
                    Home/End keys to jump to min/max values
                  </li>
                  <li>
                    Page Up/Page Down for larger increments
                  </li>
                  <li>Focus visible ring styles for keyboard navigation</li>
                  <li>
                    Support for <code class="text-xs">aria-label</code> and <code class="text-xs">aria-describedby</code>
                  </li>
                  <li>Disabled state prevents interaction and reduces opacity</li>
                  <li>Touch-friendly target size for mobile devices</li>
                </ul>
              </.stack>
            </.card_content>
          </.card>
        </section>
      </.stack>
    </.container>
    """
  end
end
