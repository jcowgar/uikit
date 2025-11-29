defmodule DemoWeb.Ui.LayoutLive do
  @moduledoc """
  Interactive reference for layout components.

  Demonstrates all layout components with different spacing options
  to help developers choose the right spacing for their needs.
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
          Layout Components Reference
          <:subtitle>Visual guide to grids, stacks, flex, and spacing</:subtitle>
        </.header>

        <.stack gap="xl" class="mt-8">
          <%!-- Grid Component --%>
          <section>
            <h2 class="text-2xl font-bold text-foreground mb-6 pb-2 border-b border-border">
              Grid Layouts
            </h2>

            <.stack gap="xl">
              <%!-- 3 Column Grid with different gaps --%>
              <div>
                <h3 class="text-lg font-semibold text-foreground mb-4">
                  3 Columns with Different Gap Sizes
                </h3>

                <.stack gap="lg">
                  <div>
                    <p class="text-sm text-muted-foreground mb-2">
                      <code>gap="xs"</code> - Very tight spacing
                    </p>
                    <.grid cols={3} gap="xs">
                      <div class="bg-card border border-border rounded-lg p-4">
                        <p class="text-sm text-foreground">Card 1</p>
                      </div>
                      <div class="bg-card border border-border rounded-lg p-4">
                        <p class="text-sm text-foreground">Card 2</p>
                      </div>
                      <div class="bg-card border border-border rounded-lg p-4">
                        <p class="text-sm text-foreground">Card 3</p>
                      </div>
                    </.grid>
                  </div>

                  <div>
                    <p class="text-sm text-muted-foreground mb-2">
                      <code>gap="sm"</code> - Compact spacing
                    </p>
                    <.grid cols={3} gap="sm">
                      <div class="bg-card border border-border rounded-lg p-4">
                        <p class="text-sm text-foreground">Card 1</p>
                      </div>
                      <div class="bg-card border border-border rounded-lg p-4">
                        <p class="text-sm text-foreground">Card 2</p>
                      </div>
                      <div class="bg-card border border-border rounded-lg p-4">
                        <p class="text-sm text-foreground">Card 3</p>
                      </div>
                    </.grid>
                  </div>

                  <div>
                    <p class="text-sm text-muted-foreground mb-2">
                      <code>gap="md"</code> - Standard spacing (default)
                    </p>
                    <.grid cols={3} gap="md">
                      <div class="bg-card border border-border rounded-lg p-4">
                        <p class="text-sm text-foreground">Card 1</p>
                      </div>
                      <div class="bg-card border border-border rounded-lg p-4">
                        <p class="text-sm text-foreground">Card 2</p>
                      </div>
                      <div class="bg-card border border-border rounded-lg p-4">
                        <p class="text-sm text-foreground">Card 3</p>
                      </div>
                    </.grid>
                  </div>

                  <div>
                    <p class="text-sm text-muted-foreground mb-2">
                      <code>gap="lg"</code> - Generous spacing
                    </p>
                    <.grid cols={3} gap="lg">
                      <div class="bg-card border border-border rounded-lg p-4">
                        <p class="text-sm text-foreground">Card 1</p>
                      </div>
                      <div class="bg-card border border-border rounded-lg p-4">
                        <p class="text-sm text-foreground">Card 2</p>
                      </div>
                      <div class="bg-card border border-border rounded-lg p-4">
                        <p class="text-sm text-foreground">Card 3</p>
                      </div>
                    </.grid>
                  </div>

                  <div>
                    <p class="text-sm text-muted-foreground mb-2">
                      <code>gap="xl"</code> - Extra large spacing
                    </p>
                    <.grid cols={3} gap="xl">
                      <div class="bg-card border border-border rounded-lg p-4">
                        <p class="text-sm text-foreground">Card 1</p>
                      </div>
                      <div class="bg-card border border-border rounded-lg p-4">
                        <p class="text-sm text-foreground">Card 2</p>
                      </div>
                      <div class="bg-card border border-border rounded-lg p-4">
                        <p class="text-sm text-foreground">Card 3</p>
                      </div>
                    </.grid>
                  </div>
                </.stack>
              </div>

              <%!-- Different Column Counts --%>
              <div>
                <h3 class="text-lg font-semibold text-foreground mb-4">
                  Responsive Column Patterns
                </h3>

                <.stack gap="lg">
                  <div>
                    <p class="text-sm text-muted-foreground mb-2">
                      <code>cols={2}</code> - 1 → 2 columns (mobile → desktop)
                    </p>
                    <.grid cols={2}>
                      <div class="bg-card border border-border rounded-lg p-4">
                        <p class="text-sm text-foreground">Left</p>
                      </div>
                      <div class="bg-card border border-border rounded-lg p-4">
                        <p class="text-sm text-foreground">Right</p>
                      </div>
                    </.grid>
                  </div>

                  <div>
                    <p class="text-sm text-muted-foreground mb-2">
                      <code>cols={4}</code> - 1 → 2 → 4 columns (mobile → tablet → desktop)
                    </p>
                    <.grid cols={4}>
                      <div class="bg-card border border-border rounded-lg p-4">
                        <p class="text-sm text-foreground">1</p>
                      </div>
                      <div class="bg-card border border-border rounded-lg p-4">
                        <p class="text-sm text-foreground">2</p>
                      </div>
                      <div class="bg-card border border-border rounded-lg p-4">
                        <p class="text-sm text-foreground">3</p>
                      </div>
                      <div class="bg-card border border-border rounded-lg p-4">
                        <p class="text-sm text-foreground">4</p>
                      </div>
                    </.grid>
                  </div>
                </.stack>
              </div>
            </.stack>
          </section>

          <%!-- Stack Component --%>
          <section>
            <h2 class="text-2xl font-bold text-foreground mb-6 pb-2 border-b border-border">
              Vertical Stacks
            </h2>

            <p class="text-sm text-muted-foreground mb-6">
              Use <code>&lt;.stack&gt;</code> for consistent vertical spacing between elements.
            </p>

            <.grid cols={2} gap="lg">
              <div class="bg-card border border-border rounded-lg p-6">
                <h3 class="text-base font-semibold text-foreground mb-4">
                  Tight Spacing Sizes
                </h3>

                <.stack gap="xl">
                  <div>
                    <p class="text-sm font-medium text-foreground mb-2">
                      gap="xs" <span class="text-muted-foreground">(0.25rem)</span>
                    </p>
                    <div class="bg-muted rounded-lg p-3">
                      <.stack gap="sm">
                        <div class="bg-background rounded p-2 text-xs text-foreground">Item 1</div>
                        <div class="bg-background rounded p-2 text-xs text-foreground">Item 2</div>
                        <div class="bg-background rounded p-2 text-xs text-foreground">Item 3</div>
                      </.stack>
                    </div>
                  </div>

                  <div>
                    <p class="text-sm font-medium text-foreground mb-2">
                      gap="sm" <span class="text-muted-foreground">(0.5rem)</span>
                    </p>
                    <div class="bg-muted rounded-lg p-3">
                      <.stack gap="md">
                        <div class="bg-background rounded p-2 text-xs text-foreground">Item 1</div>
                        <div class="bg-background rounded p-2 text-xs text-foreground">Item 2</div>
                        <div class="bg-background rounded p-2 text-xs text-foreground">Item 3</div>
                      </.stack>
                    </div>
                  </div>

                  <div>
                    <p class="text-sm font-medium text-foreground mb-2">
                      gap="default" <span class="text-muted-foreground">(0.75rem)</span>
                    </p>
                    <div class="bg-muted rounded-lg p-3">
                      <.stack gap="lg">
                        <div class="bg-background rounded p-2 text-xs text-foreground">Item 1</div>
                        <div class="bg-background rounded p-2 text-xs text-foreground">Item 2</div>
                        <div class="bg-background rounded p-2 text-xs text-foreground">Item 3</div>
                      </.stack>
                    </div>
                  </div>
                </.stack>
              </div>

              <div class="bg-card border border-border rounded-lg p-6">
                <h3 class="text-base font-semibold text-foreground mb-4">
                  Generous Spacing Sizes
                </h3>

                <.stack gap="xl">
                  <div>
                    <p class="text-sm font-medium text-foreground mb-2">
                      gap="md" <span class="text-muted-foreground">(1rem)</span>
                    </p>
                    <div class="bg-muted rounded-lg p-3">
                      <.stack gap="xl">
                        <div class="bg-background rounded p-2 text-xs text-foreground">Item 1</div>
                        <div class="bg-background rounded p-2 text-xs text-foreground">Item 2</div>
                        <div class="bg-background rounded p-2 text-xs text-foreground">Item 3</div>
                      </.stack>
                    </div>
                  </div>

                  <div>
                    <p class="text-sm font-medium text-foreground mb-2">
                      gap="lg" <span class="text-muted-foreground">(1.5rem)</span>
                    </p>
                    <div class="bg-muted rounded-lg p-3">
                      <.stack gap="xl">
                        <div class="bg-background rounded p-2 text-xs text-foreground">Item 1</div>
                        <div class="bg-background rounded p-2 text-xs text-foreground">Item 2</div>
                        <div class="bg-background rounded p-2 text-xs text-foreground">Item 3</div>
                      </.stack>
                    </div>
                  </div>

                  <div>
                    <p class="text-sm font-medium text-foreground mb-2">
                      gap="xl" <span class="text-muted-foreground">(2rem)</span>
                    </p>
                    <div class="bg-muted rounded-lg p-3">
                      <.stack gap="xl">
                        <div class="bg-background rounded p-2 text-xs text-foreground">Item 1</div>
                        <div class="bg-background rounded p-2 text-xs text-foreground">Item 2</div>
                        <div class="bg-background rounded p-2 text-xs text-foreground">Item 3</div>
                      </.stack>
                    </div>
                  </div>
                </.stack>
              </div>
            </.grid>
          </section>

          <%!-- Flex Component --%>
          <section>
            <h2 class="text-2xl font-bold text-foreground mb-6 pb-2 border-b border-border">
              Flex Layouts
            </h2>

            <.stack gap="xl">
              <%!-- Alignment options --%>
              <div>
                <h3 class="text-lg font-semibold text-foreground mb-4">Alignment Options</h3>

                <.stack gap="lg">
                  <div>
                    <p class="text-sm text-muted-foreground mb-2">
                      <code>justify="start" items="start"</code>
                    </p>
                    <div class="bg-card border border-border rounded-lg p-4">
                      <.flex justify="start" items="start">
                        <div class="bg-primary text-primary-foreground px-3 py-1 rounded">Left</div>
                        <div class="bg-primary text-primary-foreground px-3 py-1 rounded">
                          Center
                        </div>
                        <div class="bg-primary text-primary-foreground px-3 py-1 rounded">
                          Right
                        </div>
                      </.flex>
                    </div>
                  </div>

                  <div>
                    <p class="text-sm text-muted-foreground mb-2">
                      <code>justify="center" items="center"</code>
                    </p>
                    <div class="bg-card border border-border rounded-lg p-4">
                      <.flex justify="center" items="center">
                        <div class="bg-primary text-primary-foreground px-3 py-1 rounded">
                          Centered
                        </div>
                        <div class="bg-primary text-primary-foreground px-3 py-1 rounded">
                          Items
                        </div>
                      </.flex>
                    </div>
                  </div>

                  <div>
                    <p class="text-sm text-muted-foreground mb-2">
                      <code>justify="between" items="center"</code> (common for headers)
                    </p>
                    <div class="bg-card border border-border rounded-lg p-4">
                      <.flex justify="between" items="center">
                        <div class="bg-primary text-primary-foreground px-3 py-1 rounded">Left</div>
                        <div class="bg-primary text-primary-foreground px-3 py-1 rounded">
                          Right
                        </div>
                      </.flex>
                    </div>
                  </div>

                  <div>
                    <p class="text-sm text-muted-foreground mb-2">
                      <code>justify="end" items="end"</code>
                    </p>
                    <div class="bg-card border border-border rounded-lg p-4">
                      <.flex justify="end" items="end">
                        <div class="bg-primary text-primary-foreground px-3 py-1 rounded">All</div>
                        <div class="bg-primary text-primary-foreground px-3 py-1 rounded">
                          Items
                        </div>
                        <div class="bg-primary text-primary-foreground px-3 py-1 rounded">
                          Right
                        </div>
                      </.flex>
                    </div>
                  </div>
                </.stack>
              </div>

              <%!-- Gap sizes --%>
              <div>
                <h3 class="text-lg font-semibold text-foreground mb-4">Gap Sizes</h3>

                <.stack gap="lg">
                  <div>
                    <p class="text-sm text-muted-foreground mb-2">
                      <code>gap="xs"</code> - Very tight
                    </p>
                    <div class="bg-card border border-border rounded-lg p-4">
                      <.flex gap="xs">
                        <div class="bg-secondary text-secondary-foreground px-2 py-1 rounded text-xs">
                          Tag
                        </div>
                        <div class="bg-secondary text-secondary-foreground px-2 py-1 rounded text-xs">
                          Tag
                        </div>
                        <div class="bg-secondary text-secondary-foreground px-2 py-1 rounded text-xs">
                          Tag
                        </div>
                      </.flex>
                    </div>
                  </div>

                  <div>
                    <p class="text-sm text-muted-foreground mb-2">
                      <code>gap="sm"</code> - Compact
                    </p>
                    <div class="bg-card border border-border rounded-lg p-4">
                      <.flex gap="sm">
                        <div class="bg-secondary text-secondary-foreground px-2 py-1 rounded text-xs">
                          Tag
                        </div>
                        <div class="bg-secondary text-secondary-foreground px-2 py-1 rounded text-xs">
                          Tag
                        </div>
                        <div class="bg-secondary text-secondary-foreground px-2 py-1 rounded text-xs">
                          Tag
                        </div>
                      </.flex>
                    </div>
                  </div>

                  <div>
                    <p class="text-sm text-muted-foreground mb-2">
                      <code>gap="md"</code> - Standard (default)
                    </p>
                    <div class="bg-card border border-border rounded-lg p-4">
                      <.flex gap="md">
                        <div class="bg-secondary text-secondary-foreground px-2 py-1 rounded text-xs">
                          Tag
                        </div>
                        <div class="bg-secondary text-secondary-foreground px-2 py-1 rounded text-xs">
                          Tag
                        </div>
                        <div class="bg-secondary text-secondary-foreground px-2 py-1 rounded text-xs">
                          Tag
                        </div>
                      </.flex>
                    </div>
                  </div>

                  <div>
                    <p class="text-sm text-muted-foreground mb-2">
                      <code>gap="lg"</code> - Generous
                    </p>
                    <div class="bg-card border border-border rounded-lg p-4">
                      <.flex gap="lg">
                        <div class="bg-secondary text-secondary-foreground px-2 py-1 rounded text-xs">
                          Tag
                        </div>
                        <div class="bg-secondary text-secondary-foreground px-2 py-1 rounded text-xs">
                          Tag
                        </div>
                        <div class="bg-secondary text-secondary-foreground px-2 py-1 rounded text-xs">
                          Tag
                        </div>
                      </.flex>
                    </div>
                  </div>
                </.stack>
              </div>

              <%!-- Direction --%>
              <div>
                <h3 class="text-lg font-semibold text-foreground mb-4">Direction</h3>

                <.grid cols={2}>
                  <div>
                    <p class="text-sm text-muted-foreground mb-2">
                      <code>direction="row"</code> (default)
                    </p>
                    <div class="bg-card border border-border rounded-lg p-4">
                      <.flex direction="row">
                        <div class="bg-primary text-primary-foreground px-3 py-1 rounded">1</div>
                        <div class="bg-primary text-primary-foreground px-3 py-1 rounded">2</div>
                        <div class="bg-primary text-primary-foreground px-3 py-1 rounded">3</div>
                      </.flex>
                    </div>
                  </div>

                  <div>
                    <p class="text-sm text-muted-foreground mb-2">
                      <code>direction="col"</code>
                    </p>
                    <div class="bg-card border border-border rounded-lg p-4">
                      <.flex direction="col">
                        <div class="bg-primary text-primary-foreground px-3 py-1 rounded">1</div>
                        <div class="bg-primary text-primary-foreground px-3 py-1 rounded">2</div>
                        <div class="bg-primary text-primary-foreground px-3 py-1 rounded">3</div>
                      </.flex>
                    </div>
                  </div>
                </.grid>
              </div>
            </.stack>
          </section>

          <%!-- Sidebar Layout --%>
          <section>
            <h2 class="text-2xl font-bold text-foreground mb-6 pb-2 border-b border-border">
              Sidebar Layout
            </h2>

            <.stack gap="xl">
              <div>
                <p class="text-sm text-muted-foreground mb-2">
                  <code>sidebar_width="narrow"</code> (12rem)
                </p>
                <div class="bg-card border border-border rounded-lg p-4">
                  <.sidebar_layout sidebar_width="narrow">
                    <:sidebar>
                      <div class="bg-muted rounded p-3 text-sm text-foreground">Narrow sidebar</div>
                    </:sidebar>
                    <:main>
                      <div class="bg-background border border-border rounded p-3 text-sm text-foreground">
                        Main content area
                      </div>
                    </:main>
                  </.sidebar_layout>
                </div>
              </div>

              <div>
                <p class="text-sm text-muted-foreground mb-2">
                  <code>sidebar_width="medium"</code> (16rem, default)
                </p>
                <div class="bg-card border border-border rounded-lg p-4">
                  <.sidebar_layout sidebar_width="medium">
                    <:sidebar>
                      <div class="bg-muted rounded p-3 text-sm text-foreground">
                        Standard sidebar
                      </div>
                    </:sidebar>
                    <:main>
                      <div class="bg-background border border-border rounded p-3 text-sm text-foreground">
                        Main content area
                      </div>
                    </:main>
                  </.sidebar_layout>
                </div>
              </div>

              <div>
                <p class="text-sm text-muted-foreground mb-2">
                  <code>sidebar_width="wide"</code> (20rem)
                </p>
                <div class="bg-card border border-border rounded-lg p-4">
                  <.sidebar_layout sidebar_width="wide">
                    <:sidebar>
                      <div class="bg-muted rounded p-3 text-sm text-foreground">Wide sidebar</div>
                    </:sidebar>
                    <:main>
                      <div class="bg-background border border-border rounded p-3 text-sm text-foreground">
                        Main content area
                      </div>
                    </:main>
                  </.sidebar_layout>
                </div>
              </div>
            </.stack>
          </section>

          <%!-- Container --%>
          <section>
            <h2 class="text-2xl font-bold text-foreground mb-6 pb-2 border-b border-border">
              Container
            </h2>

            <p class="text-sm text-muted-foreground mb-4">
              The <code>&lt;.container&gt;</code>
              component centers content with responsive padding and a max-width. It's used throughout this page!
            </p>

            <div class="bg-card border border-border rounded-lg p-6">
              <pre class="text-sm text-foreground"><code phx-no-curly-interpolation>              &lt;.container&gt;
                &lt;!-- Your page content here --&gt;
                &lt;!-- Automatically centered with max-width --&gt;
                &lt;!-- Responsive padding on all sides --&gt;
              &lt;/.container&gt;
              </code></pre>
            </div>
          </section>

          <%!-- Usage Tips --%>
          <section>
            <h2 class="text-2xl font-bold text-foreground mb-6 pb-2 border-b border-border">
              Usage Tips
            </h2>

            <.grid cols={2} gap="md">
              <div class="bg-card border border-border rounded-lg p-6">
                <h3 class="text-lg font-semibold text-foreground mb-3">When spacing feels...</h3>
                <.stack gap="md">
                  <div class="text-sm">
                    <span class="font-medium text-foreground">Too tight?</span>
                    <span class="text-muted-foreground">Try the next size up</span>
                  </div>
                  <div class="text-sm">
                    <code class="text-xs text-foreground bg-muted px-2 py-1 rounded">
                      gap="sm"
                    </code>
                    →
                    <code class="text-xs text-foreground bg-muted px-2 py-1 rounded">
                      gap="md"
                    </code>
                  </div>
                  <div class="text-sm pt-2">
                    <span class="font-medium text-foreground">Too loose?</span>
                    <span class="text-muted-foreground">Try the next size down</span>
                  </div>
                  <div class="text-sm">
                    <code class="text-xs text-foreground bg-muted px-2 py-1 rounded">
                      gap="lg"
                    </code>
                    →
                    <code class="text-xs text-foreground bg-muted px-2 py-1 rounded">
                      gap="md"
                    </code>
                  </div>
                </.stack>
              </div>

              <div class="bg-card border border-border rounded-lg p-6">
                <h3 class="text-lg font-semibold text-foreground mb-3">
                  Common patterns
                </h3>
                <.stack gap="md">
                  <div class="text-sm">
                    <span class="font-medium text-foreground">Page sections:</span>
                    <code class="text-xs text-foreground bg-muted px-2 py-1 rounded ml-2">
                      gap="xl"
                    </code>
                  </div>
                  <div class="text-sm">
                    <span class="font-medium text-foreground">Card grids:</span>
                    <code class="text-xs text-foreground bg-muted px-2 py-1 rounded ml-2">
                      gap="md"
                    </code>
                  </div>
                  <div class="text-sm">
                    <span class="font-medium text-foreground">Form fields:</span>
                    <code class="text-xs text-foreground bg-muted px-2 py-1 rounded ml-2">
                      gap="sm"
                    </code>
                  </div>
                  <div class="text-sm">
                    <span class="font-medium text-foreground">Tags/badges:</span>
                    <code class="text-xs text-foreground bg-muted px-2 py-1 rounded ml-2">
                      gap="xs"
                    </code>
                  </div>
                </.stack>
              </div>
            </.grid>
          </section>
        </.stack>
      </.container>
    </div>
    """
  end
end
