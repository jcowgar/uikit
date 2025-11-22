defmodule DemoWeb.Ui.TypographyLive do
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
      <.header>
        Typography
        <:subtitle>
          Semantic typography styles for your application.
        </:subtitle>
      </.header>

      <div class="flex flex-col gap-8 mt-8">
        <!-- Headings -->
        <section class="flex flex-col gap-4">
          <.typography variant={:h3}>Headings</.typography>
          <div class="flex flex-col gap-4 border p-4 rounded-lg">
            <div class="grid gap-4">
              <div>
                <.typography variant={:h1}>Heading 1</.typography>
                <span class="text-xs text-muted-foreground">variant="h1"</span>
              </div>
              <div>
                <.typography variant={:h2}>Heading 2</.typography>
                <span class="text-xs text-muted-foreground">variant="h2"</span>
              </div>
              <div>
                <.typography variant={:h3}>Heading 3</.typography>
                <span class="text-xs text-muted-foreground">variant="h3"</span>
              </div>
              <div>
                <.typography variant={:h4}>Heading 4</.typography>
                <span class="text-xs text-muted-foreground">variant="h4"</span>
              </div>
            </div>
          </div>
        </section>

        <!-- Body Text -->
        <section class="flex flex-col gap-4">
          <.typography variant={:h3}>Body Text</.typography>
          <div class="flex flex-col gap-4 border p-4 rounded-lg">
            <div>
              <.typography variant={:lead}>
                This is a lead paragraph. It stands out from regular body text.
              </.typography>
              <span class="text-xs text-muted-foreground">variant="lead"</span>
            </div>
            <div>
              <.typography variant={:p}>
                This is standard body text. It is used for most content paragraphs.
                Lorem ipsum dolor sit amet, consectetur adipiscing elit.
              </.typography>
              <span class="text-xs text-muted-foreground">variant="p"</span>
            </div>
            <div>
              <.typography variant={:large}>
                This is large text. Slightly bigger than body text.
              </.typography>
              <span class="text-xs text-muted-foreground">variant="large"</span>
            </div>
            <div>
              <.typography variant={:small}>
                This is small text. Useful for captions or fine print.
              </.typography>
              <span class="text-xs text-muted-foreground">variant="small"</span>
            </div>
            <div>
              <.typography variant={:muted}>
                This is muted text. It has less visual prominence.
              </.typography>
              <span class="text-xs text-muted-foreground">variant="muted"</span>
            </div>
          </div>
        </section>

        <!-- Custom Elements -->
        <section class="flex flex-col gap-4">
          <.typography variant={:h3}>Custom Elements</.typography>
          <div class="flex flex-col gap-4 border p-4 rounded-lg">
            <div>
               <.typography variant={:h1} element="div">
                  This is styled as H1 but rendered as a DIV
               </.typography>
               <span class="text-xs text-muted-foreground">variant="h1" element="div"</span>
            </div>
            <div>
               <.typography variant={:p} element="span" class="text-primary">
                  This is a span with primary color override
               </.typography>
               <span class="text-xs text-muted-foreground">variant="p" element="span" class="text-primary"</span>
            </div>
          </div>
        </section>
      </div>
    </.container>
    """
  end
end
