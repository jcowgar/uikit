defmodule DemoWeb.Ui.SkeletonLive do
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
        <.stack size="large">
          <%!-- Header --%>
          <div>
            <h1 class="text-3xl font-bold text-foreground">Skeleton Component</h1>
            <p class="text-muted-foreground mt-2">
              A loading placeholder component that displays a pulsing animation while content is being loaded, improving perceived performance.
            </p>
          </div>

          <%!-- Basic Skeleton --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Basic Usage</h2>
            <.card class="max-w-2xl">
              <.card_header>
                <.card_title>Simple Skeleton</.card_title>
                <.card_description>
                  Basic skeleton with custom width and height
                </.card_description>
              </.card_header>
              <.card_content>
                <.skeleton class="h-4 w-full" />
              </.card_content>
            </.card>
          </section>

          <%!-- Shape Variations --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Shape Variations</h2>
            <.card class="max-w-2xl">
              <.card_header>
                <.card_title>Different Shapes</.card_title>
                <.card_description>
                  Control shape using rounded utilities
                </.card_description>
              </.card_header>
              <.card_content>
                <.stack size="medium">
                  <div>
                    <h3 class="text-sm font-medium mb-2">Default (rounded-md)</h3>
                    <.skeleton class="h-12 w-full" />
                  </div>

                  <div>
                    <h3 class="text-sm font-medium mb-2">Rounded Large (rounded-lg)</h3>
                    <.skeleton class="h-12 w-full rounded-lg" />
                  </div>

                  <div>
                    <h3 class="text-sm font-medium mb-2">Rounded Extra Large (rounded-xl)</h3>
                    <.skeleton class="h-[125px] w-[250px] rounded-xl" />
                  </div>

                  <div>
                    <h3 class="text-sm font-medium mb-2">Circle (rounded-full) - Avatar</h3>
                    <.skeleton class="h-12 w-12 rounded-full" />
                  </div>

                  <div>
                    <h3 class="text-sm font-medium mb-2">Square (rounded-none)</h3>
                    <.skeleton class="h-12 w-full rounded-none" />
                  </div>
                </.stack>
              </.card_content>
            </.card>
          </section>

          <%!-- Common Patterns --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Common Patterns</h2>

            <%!-- Profile with Avatar --%>
            <.card class="max-w-2xl mb-4">
              <.card_header>
                <.card_title>Profile with Avatar</.card_title>
                <.card_description>
                  Avatar skeleton with text placeholders
                </.card_description>
              </.card_header>
              <.card_content>
                <div class="flex items-center space-x-4">
                  <.skeleton class="h-12 w-12 rounded-full" />
                  <div class="space-y-2 flex-1">
                    <.skeleton class="h-4 w-[250px]" />
                    <.skeleton class="h-4 w-[200px]" />
                  </div>
                </div>
              </.card_content>
            </.card>

            <%!-- Card Layout --%>
            <.card class="max-w-2xl mb-4">
              <.card_header>
                <.card_title>Card Layout</.card_title>
                <.card_description>
                  Image with text content placeholder
                </.card_description>
              </.card_header>
              <.card_content>
                <div class="flex flex-col space-y-3">
                  <.skeleton class="h-[125px] w-[250px] rounded-xl" />
                  <div class="space-y-2">
                    <.skeleton class="h-4 w-[250px]" />
                    <.skeleton class="h-4 w-[200px]" />
                  </div>
                </div>
              </.card_content>
            </.card>

            <%!-- Text Lines --%>
            <.card class="max-w-2xl mb-4">
              <.card_header>
                <.card_title>Text Content</.card_title>
                <.card_description>
                  Multiple lines of text placeholders
                </.card_description>
              </.card_header>
              <.card_content>
                <div class="space-y-2">
                  <.skeleton class="h-4 w-full" />
                  <.skeleton class="h-4 w-full" />
                  <.skeleton class="h-4 w-3/4" />
                </div>
              </.card_content>
            </.card>

            <%!-- Table Rows --%>
            <.card class="max-w-2xl">
              <.card_header>
                <.card_title>Table Rows</.card_title>
                <.card_description>
                  Loading state for table data
                </.card_description>
              </.card_header>
              <.card_content>
                <div class="space-y-2">
                  <.skeleton class="h-12 w-full" />
                  <.skeleton class="h-12 w-full" />
                  <.skeleton class="h-12 w-full" />
                  <.skeleton class="h-12 w-full" />
                </div>
              </.card_content>
            </.card>
          </section>

          <%!-- Size Examples --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Size Examples</h2>
            <.card class="max-w-2xl">
              <.card_header>
                <.card_title>Different Dimensions</.card_title>
                <.card_description>
                  Various height and width combinations
                </.card_description>
              </.card_header>
              <.card_content>
                <.stack size="medium">
                  <div>
                    <h3 class="text-sm font-medium mb-2">Small Text Line</h3>
                    <.skeleton class="h-3 w-[200px]" />
                  </div>

                  <div>
                    <h3 class="text-sm font-medium mb-2">Default Text Line</h3>
                    <.skeleton class="h-4 w-[250px]" />
                  </div>

                  <div>
                    <h3 class="text-sm font-medium mb-2">Large Text Line</h3>
                    <.skeleton class="h-5 w-[300px]" />
                  </div>

                  <div>
                    <h3 class="text-sm font-medium mb-2">Full Width</h3>
                    <.skeleton class="h-4 w-full" />
                  </div>

                  <div>
                    <h3 class="text-sm font-medium mb-2">Button</h3>
                    <.skeleton class="h-10 w-24" />
                  </div>

                  <div>
                    <h3 class="text-sm font-medium mb-2">Image Placeholder</h3>
                    <.skeleton class="h-48 w-full rounded-lg" />
                  </div>
                </.stack>
              </.card_content>
            </.card>
          </section>

          <%!-- Complex Layout Example --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Complex Layout</h2>
            <.card class="max-w-2xl">
              <.card_header>
                <.card_title>Article Loading State</.card_title>
                <.card_description>
                  A complete article layout with header, image, and content
                </.card_description>
              </.card_header>
              <.card_content>
                <.stack size="medium">
                  <%!-- Header with avatar --%>
                  <div class="flex items-center space-x-4">
                    <.skeleton class="h-10 w-10 rounded-full" />
                    <div class="space-y-2 flex-1">
                      <.skeleton class="h-3 w-[120px]" />
                      <.skeleton class="h-3 w-[100px]" />
                    </div>
                  </div>

                  <%!-- Title --%>
                  <.skeleton class="h-8 w-3/4" />

                  <%!-- Featured Image --%>
                  <.skeleton class="h-[200px] w-full rounded-lg" />

                  <%!-- Content --%>
                  <div class="space-y-2">
                    <.skeleton class="h-4 w-full" />
                    <.skeleton class="h-4 w-full" />
                    <.skeleton class="h-4 w-full" />
                    <.skeleton class="h-4 w-4/5" />
                  </div>

                  <%!-- Tags --%>
                  <div class="flex gap-2">
                    <.skeleton class="h-6 w-16 rounded-full" />
                    <.skeleton class="h-6 w-20 rounded-full" />
                    <.skeleton class="h-6 w-14 rounded-full" />
                  </div>
                </.stack>
              </.card_content>
            </.card>
          </section>

          <%!-- Usage Examples --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Usage Examples</h2>
            <.card class="max-w-2xl">
              <.card_header>
                <.card_title>Code Examples</.card_title>
              </.card_header>
              <.card_content>
                <.stack size="small">
                  <div>
                    <h3 class="text-sm font-medium mb-2">Basic Skeleton</h3>
                    <code class="text-xs block bg-muted p-2 rounded">
                      &lt;.skeleton class="h-4 w-full" /&gt;
                    </code>
                  </div>

                  <div>
                    <h3 class="text-sm font-medium mb-2">Avatar Skeleton</h3>
                    <code class="text-xs block bg-muted p-2 rounded">
                      &lt;.skeleton class="h-12 w-12 rounded-full" /&gt;
                    </code>
                  </div>

                  <div>
                    <h3 class="text-sm font-medium mb-2">Card Layout</h3>
                    <code class="text-xs block bg-muted p-2 rounded">
                      &lt;div class="flex flex-col space-y-3"&gt;<br />
                      &nbsp;&nbsp;&lt;.skeleton class="h-[125px] w-[250px] rounded-xl" /&gt;<br />
                      &nbsp;&nbsp;&lt;div class="space-y-2"&gt;<br />
                      &nbsp;&nbsp;&nbsp;&nbsp;&lt;.skeleton class="h-4 w-[250px]" /&gt;<br />
                      &nbsp;&nbsp;&nbsp;&nbsp;&lt;.skeleton class="h-4 w-[200px]" /&gt;<br />
                      &nbsp;&nbsp;&lt;/div&gt;<br /> &lt;/div&gt;
                    </code>
                  </div>

                  <div>
                    <h3 class="text-sm font-medium mb-2">Profile with Avatar</h3>
                    <code class="text-xs block bg-muted p-2 rounded">
                      &lt;div class="flex items-center space-x-4"&gt;<br />
                      &nbsp;&nbsp;&lt;.skeleton class="h-12 w-12 rounded-full" /&gt;<br />
                      &nbsp;&nbsp;&lt;div class="space-y-2"&gt;<br />
                      &nbsp;&nbsp;&nbsp;&nbsp;&lt;.skeleton class="h-4 w-[250px]" /&gt;<br />
                      &nbsp;&nbsp;&nbsp;&nbsp;&lt;.skeleton class="h-4 w-[200px]" /&gt;<br />
                      &nbsp;&nbsp;&lt;/div&gt;<br /> &lt;/div&gt;
                    </code>
                  </div>

                  <div>
                    <h3 class="text-sm font-medium mb-2">Table Rows</h3>
                    <code class="text-xs block bg-muted p-2 rounded">
                      &lt;div class="space-y-2"&gt;<br />
                      &nbsp;&nbsp;&lt;.skeleton class="h-12 w-full" /&gt;<br />
                      &nbsp;&nbsp;&lt;.skeleton class="h-12 w-full" /&gt;<br />
                      &nbsp;&nbsp;&lt;.skeleton class="h-12 w-full" /&gt;<br /> &lt;/div&gt;
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
                    Includes <code class="text-xs">role="status"</code>
                    for screen reader compatibility
                  </li>
                  <li>
                    Features <code class="text-xs">aria-label="Loading"</code> for clear context
                  </li>
                  <li>
                    Uses <code class="text-xs">aria-live="polite"</code>
                    for non-intrusive announcements
                  </li>
                  <li>
                    Uses <code class="text-xs">motion-safe:animate-pulse</code>
                    to respect user's motion preferences
                  </li>
                  <li>Semantic HTML structure for better accessibility</li>
                </ul>
              </.card_content>
            </.card>
          </section>

          <%!-- Implementation Notes --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Implementation Notes</h2>
            <.card class="max-w-2xl">
              <.card_header>
                <.card_title>Design Decisions</.card_title>
              </.card_header>
              <.card_content>
                <.stack size="small">
                  <p class="text-sm text-muted-foreground">
                    <strong>Color Choice:</strong>
                    Uses <code class="text-xs">bg-accent</code>
                    semantic token which automatically adapts to light/dark theme. This provides a subtle, theme-aware loading indicator.
                  </p>

                  <.separator />

                  <p class="text-sm text-muted-foreground">
                    <strong>Animation:</strong>
                    Uses Tailwind's <code class="text-xs">animate-pulse</code>
                    utility which provides a smooth opacity transition. The animation respects user's motion preferences via
                    <code class="text-xs">motion-safe:</code>
                    prefix.
                  </p>

                  <.separator />

                  <p class="text-sm text-muted-foreground">
                    <strong>Flexibility:</strong>
                    The skeleton has no default dimensions, allowing complete flexibility. You control the size, shape, and layout entirely through the
                    <code class="text-xs">class</code>
                    attribute.
                  </p>

                  <.separator />

                  <p class="text-sm text-muted-foreground">
                    <strong>Composition:</strong>
                    Skeleton components are designed to be composed into complex loading layouts. Combine multiple skeletons to match your actual content structure for a seamless loading experience.
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
