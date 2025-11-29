defmodule DemoWeb.Ui.AspectRatioLive do
  @moduledoc false
  use DemoWeb, :live_view

  alias Phoenix.LiveView.Socket

  @impl true
  @spec mount(map(), map(), Socket.t()) ::
          {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  @spec render(map()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <.container>
      <.stack gap="xl">
        <%!-- Header --%>
        <div>
          <h1 class="text-3xl font-bold text-foreground">Aspect Ratio Component</h1>
          <p class="text-muted-foreground mt-2">
            Displays content within a desired ratio, maintaining consistent proportions for media.
          </p>
        </div>

        <%!-- Basic Usage: 16:9 --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">16:9 Aspect Ratio (Widescreen)</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Standard widescreen ratio, commonly used for videos and hero images.
          </p>
          <div class="max-w-xl">
            <.aspect_ratio ratio={16 / 9} class="bg-muted rounded-xl overflow-hidden">
              <img
                src="https://images.unsplash.com/photo-1588345921523-c2dcdb7f1dcd?w=800&dpr=2&q=80"
                alt="Photo by Drew Beamer"
                class="object-cover w-full h-full"
              />
            </.aspect_ratio>
          </div>
        </section>

        <%!-- 4:3 Ratio --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">4:3 Aspect Ratio (Classic)</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Classic photo and older video format ratio.
          </p>
          <div class="max-w-md">
            <.aspect_ratio ratio={4 / 3} class="bg-muted rounded-lg overflow-hidden">
              <img
                src="https://images.unsplash.com/photo-1535025183041-0991a977e25b?w=600&dpr=2&q=80"
                alt="Mountain landscape"
                class="object-cover w-full h-full"
              />
            </.aspect_ratio>
          </div>
        </section>

        <%!-- 1:1 Square --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">1:1 Aspect Ratio (Square)</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Perfect square ratio, ideal for profile images and thumbnails.
          </p>
          <.flex class="gap-4 flex-wrap">
            <div class="w-32">
              <.aspect_ratio ratio={1} class="bg-muted rounded-lg overflow-hidden">
                <img
                  src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&dpr=2&q=80"
                  alt="Profile photo"
                  class="object-cover w-full h-full"
                />
              </.aspect_ratio>
            </div>
            <div class="w-32">
              <.aspect_ratio ratio={1} class="bg-muted rounded-lg overflow-hidden">
                <img
                  src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&dpr=2&q=80"
                  alt="Profile photo"
                  class="object-cover w-full h-full"
                />
              </.aspect_ratio>
            </div>
            <div class="w-32">
              <.aspect_ratio ratio={1} class="bg-muted rounded-lg overflow-hidden">
                <img
                  src="https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200&dpr=2&q=80"
                  alt="Profile photo"
                  class="object-cover w-full h-full"
                />
              </.aspect_ratio>
            </div>
          </.flex>
        </section>

        <%!-- 21:9 Ultra-wide --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">21:9 Aspect Ratio (Ultrawide)</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Cinematic ultrawide ratio for panoramic content.
          </p>
          <div class="max-w-2xl">
            <.aspect_ratio ratio={21 / 9} class="bg-muted rounded-xl overflow-hidden">
              <img
                src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200&dpr=2&q=80"
                alt="Panoramic mountain view"
                class="object-cover w-full h-full"
              />
            </.aspect_ratio>
          </div>
        </section>

        <%!-- 9:16 Portrait --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">9:16 Aspect Ratio (Portrait)</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Vertical video format, common for stories and mobile content.
          </p>
          <.flex class="gap-4 flex-wrap">
            <div class="w-40">
              <.aspect_ratio ratio={9 / 16} class="bg-muted rounded-xl overflow-hidden">
                <img
                  src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&dpr=2&q=80"
                  alt="Portrait photo"
                  class="object-cover w-full h-full"
                />
              </.aspect_ratio>
            </div>
            <div class="w-40">
              <.aspect_ratio ratio={9 / 16} class="bg-muted rounded-xl overflow-hidden">
                <img
                  src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&dpr=2&q=80"
                  alt="Portrait photo"
                  class="object-cover w-full h-full"
                />
              </.aspect_ratio>
            </div>
          </.flex>
        </section>

        <%!-- With Placeholder --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">With Placeholder Content</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Aspect ratio containers can hold any content, not just images.
          </p>
          <.flex class="gap-4 flex-wrap">
            <div class="w-64">
              <.aspect_ratio
                ratio={16 / 9}
                class="bg-muted rounded-lg flex items-center justify-center"
              >
                <div class="text-center">
                  <.icon name="hero-photo" class="size-8 text-muted-foreground" />
                  <p class="text-sm text-muted-foreground mt-2">16:9 Placeholder</p>
                </div>
              </.aspect_ratio>
            </div>
            <div class="w-48">
              <.aspect_ratio ratio={1} class="bg-muted rounded-lg flex items-center justify-center">
                <div class="text-center">
                  <.icon name="hero-photo" class="size-8 text-muted-foreground" />
                  <p class="text-sm text-muted-foreground mt-2">1:1</p>
                </div>
              </.aspect_ratio>
            </div>
          </.flex>
        </section>

        <%!-- In Cards --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">In Cards</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Combine with cards for consistent media presentation.
          </p>
          <.grid cols={3} class="gap-6">
            <.card class="overflow-hidden py-0 gap-0">
              <.aspect_ratio ratio={16 / 9}>
                <img
                  src="https://images.unsplash.com/photo-1588345921523-c2dcdb7f1dcd?w=400&dpr=2&q=80"
                  alt="Abstract art"
                  class="object-cover w-full h-full"
                />
              </.aspect_ratio>
              <.card_header>
                <.card_title>Abstract Collection</.card_title>
                <.card_description>Exploring form and color</.card_description>
              </.card_header>
            </.card>

            <.card class="overflow-hidden py-0 gap-0">
              <.aspect_ratio ratio={16 / 9}>
                <img
                  src="https://images.unsplash.com/photo-1535025183041-0991a977e25b?w=400&dpr=2&q=80"
                  alt="Mountain landscape"
                  class="object-cover w-full h-full"
                />
              </.aspect_ratio>
              <.card_header>
                <.card_title>Nature Series</.card_title>
                <.card_description>Mountains and valleys</.card_description>
              </.card_header>
            </.card>

            <.card class="overflow-hidden py-0 gap-0">
              <.aspect_ratio ratio={16 / 9}>
                <img
                  src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&dpr=2&q=80"
                  alt="Panoramic view"
                  class="object-cover w-full h-full"
                />
              </.aspect_ratio>
              <.card_header>
                <.card_title>Panoramas</.card_title>
                <.card_description>Wide angle captures</.card_description>
              </.card_header>
            </.card>
          </.grid>
        </section>

        <%!-- Video Embed Example --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Video Embed</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Perfect for maintaining video aspect ratios with iframes.
          </p>
          <div class="max-w-xl">
            <.aspect_ratio ratio={16 / 9} class="bg-muted rounded-xl overflow-hidden">
              <div class="w-full h-full flex items-center justify-center bg-foreground/5">
                <div class="text-center">
                  <.icon name="hero-play-circle" class="size-16 text-muted-foreground" />
                  <p class="text-sm text-muted-foreground mt-2">Video would embed here</p>
                  <p class="text-xs text-muted-foreground">16:9 responsive container</p>
                </div>
              </div>
            </.aspect_ratio>
          </div>
        </section>

        <%!-- Custom Ratios --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Custom Ratios</h2>
          <p class="text-sm text-muted-foreground mb-4">
            You can use any numeric ratio value.
          </p>
          <.flex class="gap-4 flex-wrap items-end">
            <div class="w-24 text-center">
              <.aspect_ratio
                ratio={1.618}
                class="bg-primary/10 rounded-lg flex items-center justify-center"
              >
                <span class="text-xs text-primary font-medium">φ</span>
              </.aspect_ratio>
              <p class="text-xs text-muted-foreground mt-2">Golden Ratio (1.618:1)</p>
            </div>
            <div class="w-24 text-center">
              <.aspect_ratio
                ratio={3 / 2}
                class="bg-primary/10 rounded-lg flex items-center justify-center"
              >
                <span class="text-xs text-primary font-medium">3:2</span>
              </.aspect_ratio>
              <p class="text-xs text-muted-foreground mt-2">35mm Film</p>
            </div>
            <div class="w-24 text-center">
              <.aspect_ratio
                ratio={2.35}
                class="bg-primary/10 rounded-lg flex items-center justify-center"
              >
                <span class="text-xs text-primary font-medium">2.35:1</span>
              </.aspect_ratio>
              <p class="text-xs text-muted-foreground mt-2">Cinemascope</p>
            </div>
          </.flex>
        </section>
      </.stack>
    </.container>
    """
  end
end
