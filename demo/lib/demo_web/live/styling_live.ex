defmodule DemoWeb.Ui.StylingLive do
  @moduledoc """
  Visual reference for typography, colors, and basic styling tokens.

  This page showcases all available design tokens and semantic styles
  to help maintain consistency across the application.
  """
  use DemoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-background">
      <.container>
        <.header>
          Design System Reference
          <:subtitle>Typography, colors, and semantic tokens</:subtitle>
        </.header>

        <.stack gap="xl" class="mt-8">
          <%!-- Typography Section --%>
          <section>
            <h2 class="text-2xl font-bold text-foreground mb-6 pb-2 border-b border-border">
              Typography
            </h2>

            <div class="space-y-8">
              <%!-- Headings --%>
              <div class="bg-card border border-border rounded-lg p-6">
                <h3 class="text-lg font-semibold text-foreground mb-4">Headings</h3>
                <div class="space-y-4">
                  <div>
                    <h1 class="text-4xl font-bold text-foreground">
                      Heading 1 - Main page titles
                    </h1>
                    <code class="text-xs text-muted-foreground">text-4xl font-bold</code>
                  </div>
                  <div>
                    <h2 class="text-3xl font-bold text-foreground">Heading 2 - Section headers</h2>
                    <code class="text-xs text-muted-foreground">text-3xl font-bold</code>
                  </div>
                  <div>
                    <h3 class="text-2xl font-semibold text-foreground">Heading 3 - Subsections</h3>
                    <code class="text-xs text-muted-foreground">text-2xl font-semibold</code>
                  </div>
                  <div>
                    <h4 class="text-xl font-semibold text-foreground">Heading 4 - Card titles</h4>
                    <code class="text-xs text-muted-foreground">text-xl font-semibold</code>
                  </div>
                  <div>
                    <h5 class="text-lg font-medium text-foreground">Heading 5 - Small sections</h5>
                    <code class="text-xs text-muted-foreground">text-lg font-medium</code>
                  </div>
                  <div>
                    <h6 class="text-base font-medium text-foreground">Heading 6 - Labels</h6>
                    <code class="text-xs text-muted-foreground">text-base font-medium</code>
                  </div>
                </div>
              </div>

              <%!-- Body Text --%>
              <div class="bg-card border border-border rounded-lg p-6">
                <h3 class="text-lg font-semibold text-foreground mb-4">Body Text</h3>
                <div class="space-y-4">
                  <div>
                    <p class="text-lg text-foreground">
                      Large body text - Used for emphasis or lead paragraphs
                    </p>
                    <code class="text-xs text-muted-foreground">text-lg text-foreground</code>
                  </div>
                  <div>
                    <p class="text-base text-foreground">
                      Regular body text - The default text size for most content
                    </p>
                    <code class="text-xs text-muted-foreground">text-base text-foreground</code>
                  </div>
                  <div>
                    <p class="text-sm text-foreground">
                      Small body text - For secondary information
                    </p>
                    <code class="text-xs text-muted-foreground">text-sm text-foreground</code>
                  </div>
                  <div>
                    <p class="text-xs text-foreground">Extra small text - For captions and labels</p>
                    <code class="text-xs text-muted-foreground">text-xs text-foreground</code>
                  </div>
                </div>
              </div>

              <%!-- Muted Text --%>
              <div class="bg-card border border-border rounded-lg p-6">
                <h3 class="text-lg font-semibold text-foreground mb-4">Muted Text</h3>
                <div class="space-y-4">
                  <div>
                    <p class="text-base text-muted-foreground">
                      Muted text - For less important content, descriptions, and help text
                    </p>
                    <code class="text-xs text-muted-foreground">text-muted-foreground</code>
                  </div>
                  <div>
                    <p class="text-sm text-muted-foreground">
                      Small muted text - For timestamps, metadata
                    </p>
                    <code class="text-xs text-muted-foreground">text-sm text-muted-foreground</code>
                  </div>
                </div>
              </div>
            </div>
          </section>

          <%!-- Color Tokens Section --%>
          <section>
            <h2 class="text-2xl font-bold text-foreground mb-6 pb-2 border-b border-border">
              Color Tokens
            </h2>

            <div class="space-y-8">
              <%!-- Background Colors --%>
              <div>
                <h3 class="text-lg font-semibold text-foreground mb-4">Background Colors</h3>
                <.grid cols={3} gap="sm">
                  <div class="border border-border rounded-lg overflow-hidden">
                    <div class="h-24 bg-background border-b border-border"></div>
                    <div class="p-4">
                      <p class="font-medium text-foreground">Background</p>
                      <code class="text-xs text-muted-foreground">bg-background</code>
                      <p class="text-sm text-muted-foreground mt-1">Page background</p>
                    </div>
                  </div>

                  <div class="border border-border rounded-lg overflow-hidden">
                    <div class="h-24 bg-surface border-b border-border"></div>
                    <div class="p-4">
                      <p class="font-medium text-foreground">Surface</p>
                      <code class="text-xs text-muted-foreground">bg-surface</code>
                      <p class="text-sm text-muted-foreground mt-1">Elevated surfaces</p>
                    </div>
                  </div>

                  <div class="border border-border rounded-lg overflow-hidden">
                    <div class="h-24 bg-card border-b border-border"></div>
                    <div class="p-4">
                      <p class="font-medium text-foreground">Card</p>
                      <code class="text-xs text-muted-foreground">bg-card</code>
                      <p class="text-sm text-muted-foreground mt-1">Card backgrounds</p>
                    </div>
                  </div>

                  <div class="border border-border rounded-lg overflow-hidden">
                    <div class="h-24 bg-muted border-b border-border"></div>
                    <div class="p-4">
                      <p class="font-medium text-foreground">Muted</p>
                      <code class="text-xs text-muted-foreground">bg-muted</code>
                      <p class="text-sm text-muted-foreground mt-1">Subdued backgrounds</p>
                    </div>
                  </div>

                  <div class="border border-border rounded-lg overflow-hidden">
                    <div class="h-24 bg-primary border-b border-border"></div>
                    <div class="p-4">
                      <p class="font-medium text-foreground">Primary</p>
                      <code class="text-xs text-muted-foreground">bg-primary</code>
                      <p class="text-sm text-muted-foreground mt-1">Brand color</p>
                    </div>
                  </div>

                  <div class="border border-border rounded-lg overflow-hidden">
                    <div class="h-24 bg-secondary border-b border-border"></div>
                    <div class="p-4">
                      <p class="font-medium text-foreground">Secondary</p>
                      <code class="text-xs text-muted-foreground">bg-secondary</code>
                      <p class="text-sm text-muted-foreground mt-1">Secondary actions</p>
                    </div>
                  </div>
                </.grid>
              </div>

              <%!-- Semantic Colors --%>
              <div>
                <h3 class="text-lg font-semibold text-foreground mb-4">Semantic Colors</h3>
                <.grid cols={2} gap="sm">
                  <div class="border border-border rounded-lg overflow-hidden">
                    <div class="h-24 bg-destructive border-b border-border flex items-center justify-center">
                      <span class="text-destructive-foreground font-semibold">Destructive</span>
                    </div>
                    <div class="p-4">
                      <p class="font-medium text-foreground">Destructive</p>
                      <code class="text-xs text-muted-foreground">bg-destructive</code>
                      <p class="text-sm text-muted-foreground mt-1">
                        Errors, deletions, dangerous actions
                      </p>
                    </div>
                  </div>

                  <div class="border border-border rounded-lg overflow-hidden">
                    <div class="h-24 bg-success border-b border-border flex items-center justify-center">
                      <span class="text-success-foreground font-semibold">Success</span>
                    </div>
                    <div class="p-4">
                      <p class="font-medium text-foreground">Success</p>
                      <code class="text-xs text-muted-foreground">bg-success</code>
                      <p class="text-sm text-muted-foreground mt-1">
                        Success states, confirmations
                      </p>
                    </div>
                  </div>

                  <div class="border border-border rounded-lg overflow-hidden">
                    <div class="h-24 bg-warning border-b border-border flex items-center justify-center">
                      <span class="text-warning-foreground font-semibold">Warning</span>
                    </div>
                    <div class="p-4">
                      <p class="font-medium text-foreground">Warning</p>
                      <code class="text-xs text-muted-foreground">bg-warning</code>
                      <p class="text-sm text-muted-foreground mt-1">Warnings, cautions</p>
                    </div>
                  </div>

                  <div class="border border-border rounded-lg overflow-hidden">
                    <div class="h-24 bg-info border-b border-border flex items-center justify-center">
                      <span class="text-info-foreground font-semibold">Info</span>
                    </div>
                    <div class="p-4">
                      <p class="font-medium text-foreground">Info</p>
                      <code class="text-xs text-muted-foreground">bg-info</code>
                      <p class="text-sm text-muted-foreground mt-1">
                        Informational messages
                      </p>
                    </div>
                  </div>
                </.grid>
              </div>

              <%!-- Text Colors --%>
              <div>
                <h3 class="text-lg font-semibold text-foreground mb-4">Text Colors</h3>
                <div class="bg-card border border-border rounded-lg p-6 space-y-3">
                  <p class="text-foreground">
                    Foreground text - <code class="text-xs">text-foreground</code>
                  </p>
                  <p class="text-muted-foreground">
                    Muted foreground - <code class="text-xs">text-muted-foreground</code>
                  </p>
                  <p class="text-primary">
                    Primary text - <code class="text-xs">text-primary</code>
                  </p>
                  <p class="text-destructive">
                    Destructive text - <code class="text-xs">text-destructive</code>
                  </p>
                  <p class="text-success">Success text - <code class="text-xs">text-success</code></p>
                  <p class="text-warning">Warning text - <code class="text-xs">text-warning</code></p>
                </div>
              </div>

              <%!-- Border Colors --%>
              <div>
                <h3 class="text-lg font-semibold text-foreground mb-4">Borders</h3>
                <div class="space-y-4">
                  <div class="border-2 border-border rounded-lg p-4">
                    <p class="text-foreground">Default border</p>
                    <code class="text-xs text-muted-foreground">border-border</code>
                  </div>
                  <div class="border-2 border-input rounded-lg p-4">
                    <p class="text-foreground">Input border (slightly darker)</p>
                    <code class="text-xs text-muted-foreground">border-input</code>
                  </div>
                  <div class="border-2 border-primary rounded-lg p-4">
                    <p class="text-foreground">Primary border</p>
                    <code class="text-xs text-muted-foreground">border-primary</code>
                  </div>
                </div>
              </div>
            </div>
          </section>

          <%!-- Spacing Section --%>
          <section>
            <h2 class="text-2xl font-bold text-foreground mb-6 pb-2 border-b border-border">
              Spacing & Layout
            </h2>

            <.stack gap="lg">
              <div class="bg-card border border-border rounded-lg p-6">
                <h3 class="text-lg font-semibold text-foreground mb-4">Shadow Variants</h3>
                <.grid cols={4} gap="md">
                  <div class="bg-background p-6 rounded-lg shadow-sm">
                    <p class="font-medium text-foreground">Small</p>
                    <code class="text-xs text-muted-foreground">shadow-sm</code>
                  </div>
                  <div class="bg-background p-6 rounded-lg shadow-md">
                    <p class="font-medium text-foreground">Medium</p>
                    <code class="text-xs text-muted-foreground">shadow-md</code>
                  </div>
                  <div class="bg-background p-6 rounded-lg shadow-lg">
                    <p class="font-medium text-foreground">Large</p>
                    <code class="text-xs text-muted-foreground">shadow-lg</code>
                  </div>
                  <div class="bg-background p-6 rounded-lg shadow-xl">
                    <p class="font-medium text-foreground">Extra Large</p>
                    <code class="text-xs text-muted-foreground">shadow-xl</code>
                  </div>
                </.grid>
              </div>

              <div class="bg-card border border-border rounded-lg p-6">
                <h3 class="text-lg font-semibold text-foreground mb-4">Border Radius</h3>
                <.grid cols={4} gap="sm">
                  <div class="bg-muted p-4 rounded-sm border border-border">
                    <code class="text-xs text-muted-foreground">rounded-sm</code>
                  </div>
                  <div class="bg-muted p-4 rounded-md border border-border">
                    <code class="text-xs text-muted-foreground">rounded-md</code>
                  </div>
                  <div class="bg-muted p-4 rounded-lg border border-border">
                    <code class="text-xs text-muted-foreground">rounded-lg</code>
                  </div>
                  <div class="bg-muted p-4 rounded-xl border border-border">
                    <code class="text-xs text-muted-foreground">rounded-xl</code>
                  </div>
                </.grid>
              </div>
            </.stack>
          </section>
        </.stack>
      </.container>
    </div>
    """
  end
end
