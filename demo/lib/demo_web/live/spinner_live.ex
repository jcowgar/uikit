defmodule DemoWeb.Ui.SpinnerLive do
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
          <h1 class="text-3xl font-bold text-foreground">Spinner Component</h1>
          <p class="text-muted-foreground mt-2">
            A loading state indicator component that displays a rotating icon to show that content is being processed.
          </p>
        </div>

        <%!-- Basic Spinner --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Basic Usage</h2>
          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>Default Spinner</.card_title>
              <.card_description>
                The basic spinner with default size (16px)
              </.card_description>
            </.card_header>
            <.card_content>
              <div class="flex items-center gap-4">
                <.spinner />
                <span class="text-sm text-muted-foreground">Loading...</span>
              </div>
            </.card_content>
          </.card>
        </section>

        <%!-- Size Variations --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Size Variations</h2>
          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>Different Sizes</.card_title>
              <.card_description>
                Control the size using Tailwind's size-* utilities
              </.card_description>
            </.card_header>
            <.card_content>
              <.stack gap="md">
                <div class="flex items-center gap-4">
                  <.spinner class="size-3" />
                  <code class="text-xs">size-3</code>
                  <span class="text-sm text-muted-foreground">Extra small (12px)</span>
                </div>
                <div class="flex items-center gap-4">
                  <.spinner class="size-4" />
                  <code class="text-xs">size-4</code>
                  <span class="text-sm text-muted-foreground">Small / Default (16px)</span>
                </div>
                <div class="flex items-center gap-4">
                  <.spinner class="size-5" />
                  <code class="text-xs">size-5</code>
                  <span class="text-sm text-muted-foreground">Medium (20px)</span>
                </div>
                <div class="flex items-center gap-4">
                  <.spinner class="size-6" />
                  <code class="text-xs">size-6</code>
                  <span class="text-sm text-muted-foreground">Large (24px)</span>
                </div>
                <div class="flex items-center gap-4">
                  <.spinner class="size-8" />
                  <code class="text-xs">size-8</code>
                  <span class="text-sm text-muted-foreground">Extra large (32px)</span>
                </div>
                <div class="flex items-center gap-4">
                  <.spinner class="size-12" />
                  <code class="text-xs">size-12</code>
                  <span class="text-sm text-muted-foreground">XX Large (48px)</span>
                </div>
              </.stack>
            </.card_content>
          </.card>
        </section>

        <%!-- Color Variations --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Color Variations</h2>
          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>Different Colors</.card_title>
              <.card_description>
                Control the color using Tailwind's text-* utilities
              </.card_description>
            </.card_header>
            <.card_content>
              <.stack gap="md">
                <div class="flex items-center gap-4">
                  <.spinner class="size-6 text-primary" />
                  <code class="text-xs">text-primary</code>
                  <span class="text-sm text-muted-foreground">Primary brand color</span>
                </div>
                <div class="flex items-center gap-4">
                  <.spinner class="size-6 text-muted-foreground" />
                  <code class="text-xs">text-muted-foreground</code>
                  <span class="text-sm text-muted-foreground">Muted appearance</span>
                </div>
                <div class="flex items-center gap-4">
                  <.spinner class="size-6 text-success" />
                  <code class="text-xs">text-success</code>
                  <span class="text-sm text-muted-foreground">Success state</span>
                </div>
                <div class="flex items-center gap-4">
                  <.spinner class="size-6 text-warning" />
                  <code class="text-xs">text-warning</code>
                  <span class="text-sm text-muted-foreground">Warning state</span>
                </div>
                <div class="flex items-center gap-4">
                  <.spinner class="size-6 text-destructive" />
                  <code class="text-xs">text-destructive</code>
                  <span class="text-sm text-muted-foreground">Error state</span>
                </div>
                <div class="flex items-center gap-4">
                  <.spinner class="size-6 text-info" />
                  <code class="text-xs">text-info</code>
                  <span class="text-sm text-muted-foreground">Info state</span>
                </div>
              </.stack>
            </.card_content>
          </.card>
        </section>

        <%!-- In Components --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Component Integration</h2>
          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>Spinners in Other Components</.card_title>
              <.card_description>
                Examples of using spinners within buttons, badges, and other components
              </.card_description>
            </.card_header>
            <.card_content>
              <.stack gap="lg">
                <div>
                  <h3 class="text-sm font-medium mb-2">In Buttons</h3>
                  <.flex justify="start" items="start">
                    <.button disabled>
                      <.spinner class="size-4" /> Loading...
                    </.button>

                    <.button variant="outline" disabled>
                      <.spinner class="size-4" /> Processing
                    </.button>

                    <.button variant="destructive" disabled>
                      <.spinner class="size-4" /> Deleting...
                    </.button>
                  </.flex>
                </div>

                <.separator />

                <div>
                  <h3 class="text-sm font-medium mb-2">In Badges</h3>
                  <.flex justify="start" items="start">
                    <.badge>
                      <.spinner class="size-3" /> Syncing
                    </.badge>

                    <.badge variant="secondary">
                      <.spinner class="size-3" /> Processing
                    </.badge>

                    <.badge variant="outline">
                      <.spinner class="size-3" /> Updating
                    </.badge>
                  </.flex>
                </div>

                <.separator />

                <div>
                  <h3 class="text-sm font-medium mb-2">Centered Loading State</h3>
                  <div class="flex items-center justify-center h-32 border border-border rounded-lg bg-surface">
                    <div class="flex flex-col items-center gap-2">
                      <.spinner class="size-8 text-primary" />
                      <p class="text-sm text-muted-foreground">Loading content...</p>
                    </div>
                  </div>
                </div>
              </.stack>
            </.card_content>
          </.card>
        </section>

        <%!-- Usage Example --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Usage Examples</h2>
          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>Common Patterns</.card_title>
            </.card_header>
            <.card_content>
              <.stack gap="md">
                <div>
                  <h3 class="text-sm font-medium mb-2">Basic Spinner</h3>
                  <code class="text-xs block bg-muted p-2 rounded">
                    &lt;.spinner /&gt;
                  </code>
                </div>

                <div>
                  <h3 class="text-sm font-medium mb-2">Custom Size</h3>
                  <code class="text-xs block bg-muted p-2 rounded">
                    &lt;.spinner class="size-8" /&gt;
                  </code>
                </div>

                <div>
                  <h3 class="text-sm font-medium mb-2">Custom Color</h3>
                  <code class="text-xs block bg-muted p-2 rounded">
                    &lt;.spinner class="text-primary" /&gt;
                  </code>
                </div>

                <div>
                  <h3 class="text-sm font-medium mb-2">In a Button</h3>
                  <code class="text-xs block bg-muted p-2 rounded">
                    &lt;.button disabled&gt;<br /> &nbsp;&nbsp;&lt;.spinner class="size-4" /&gt;<br />
                    &nbsp;&nbsp;Loading...<br /> &lt;/.button&gt;
                  </code>
                </div>

                <div>
                  <h3 class="text-sm font-medium mb-2">Loading State Container</h3>
                  <code class="text-xs block bg-muted p-2 rounded">
                    &lt;div class="flex items-center justify-center h-screen"&gt;<br />
                    &nbsp;&nbsp;&lt;.spinner class="size-8 text-primary" /&gt;<br /> &lt;/div&gt;
                  </code>
                </div>
              </.stack>
            </.card_content>
          </.card>
        </section>

        <%!-- Accessibility --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Accessibility</h2>
          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>Accessibility Features</.card_title>
            </.card_header>
            <.card_content>
              <ul class="text-sm text-muted-foreground space-y-2 list-disc list-inside">
                <li>
                  Includes <code class="text-xs">role="status"</code> for screen reader compatibility
                </li>
                <li>
                  Features <code class="text-xs">aria-label="Loading"</code> for clear context
                </li>
                <li>Screen readers will announce "Loading" when the spinner appears</li>
                <li>
                  Uses <code class="text-xs">motion-safe:animate-spin</code>
                  to respect user's motion preferences
                </li>
                <li>Semantic HTML structure for better accessibility</li>
              </ul>
            </.card_content>
          </.card>
        </section>

        <%!-- Notes --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Implementation Notes</h2>
          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>Design Decisions</.card_title>
            </.card_header>
            <.card_content>
              <.stack gap="md">
                <p class="text-sm text-muted-foreground">
                  <strong>Icon Choice:</strong>
                  Uses <code class="text-xs">hero-arrow-path</code>
                  (circular arrows) instead of lucide-react's Loader2Icon, as it's the closest equivalent in Heroicons and provides the same visual loading indication.
                </p>

                <.separator />

                <p class="text-sm text-muted-foreground">
                  <strong>Motion Preferences:</strong>
                  The spinner respects the user's <code class="text-xs">prefers-reduced-motion</code>
                  setting by using <code class="text-xs">motion-safe:animate-spin</code>. Users who prefer reduced motion won't see the animation.
                </p>

                <.separator />

                <p class="text-sm text-muted-foreground">
                  <strong>Default Size:</strong>
                  The default size is <code class="text-xs">size-4</code>
                  (16px), which matches the shadcn/ui default and works well inline with text.
                </p>
              </.stack>
            </.card_content>
          </.card>
        </section>
      </.stack>
    </.container>
    """
  end
end
