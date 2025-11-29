defmodule DemoWeb.Ui.MarkdownLive do
  @moduledoc false
  use DemoWeb, :live_view

  alias Phoenix.LiveView.Socket

  @impl true
  @spec mount(map(), map(), Socket.t()) :: {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:basic_content, basic_markdown())
      |> assign(:code_content, code_markdown())
      |> assign(:mermaid_content, mermaid_markdown())
      |> assign(:math_content, math_markdown())
      |> assign(:full_content, full_markdown())

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.container>
      <.stack gap="xl">
        <div>
          <h1 class="text-3xl font-bold text-foreground">Markdown</h1>
          <p class="text-muted-foreground mt-2">
            Render markdown content with syntax highlighting, diagrams, and math equations.
          </p>
        </div>

        <%!-- Basic Markdown --%>
        <section class="space-y-4">
          <div>
            <h2 class="text-2xl font-semibold text-foreground">Basic Markdown</h2>
            <p class="text-muted-foreground">
              Standard markdown with headings, lists, links, and text formatting.
            </p>
          </div>

          <.card>
            <.card_header>
              <.card_title>Documentation Example</.card_title>
            </.card_header>
            <.card_content>
              <.markdown id="basic-markdown" content={@basic_content} />
            </.card_content>
          </.card>
        </section>

        <%!-- Syntax Highlighting --%>
        <section class="space-y-4">
          <div>
            <h2 class="text-2xl font-semibold text-foreground">Syntax Highlighting</h2>
            <p class="text-muted-foreground">
              Code blocks with automatic language detection and highlight.js theming.
            </p>
          </div>

          <.card>
            <.card_header>
              <.card_title>Code Examples</.card_title>
            </.card_header>
            <.card_content>
              <.markdown id="code-markdown" content={@code_content} />
            </.card_content>
          </.card>
        </section>

        <%!-- Mermaid Diagrams --%>
        <section class="space-y-4">
          <div>
            <h2 class="text-2xl font-semibold text-foreground">Mermaid Diagrams</h2>
            <p class="text-muted-foreground">
              Create flowcharts, sequence diagrams, and more using Mermaid syntax.
            </p>
          </div>

          <.card>
            <.card_header>
              <.card_title>Diagram Examples</.card_title>
            </.card_header>
            <.card_content>
              <.markdown id="mermaid-markdown" content={@mermaid_content} />
            </.card_content>
          </.card>
        </section>

        <%!-- Math Equations --%>
        <section class="space-y-4">
          <div>
            <h2 class="text-2xl font-semibold text-foreground">Math Equations</h2>
            <p class="text-muted-foreground">
              Render LaTeX math equations using MathJax.
            </p>
          </div>

          <.card>
            <.card_header>
              <.card_title>Mathematical Notation</.card_title>
            </.card_header>
            <.card_content>
              <.markdown id="math-markdown" content={@math_content} />
            </.card_content>
          </.card>
        </section>

        <%!-- Compact Variant --%>
        <section class="space-y-4">
          <div>
            <h2 class="text-2xl font-semibold text-foreground">Compact Variant</h2>
            <p class="text-muted-foreground">
              Use the compact variant for tighter spacing in constrained layouts.
            </p>
          </div>

          <.flex gap="lg">
            <.card class="flex-1">
              <.card_header>
                <.card_title>Default</.card_title>
              </.card_header>
              <.card_content>
                <.markdown id="default-spacing" content={@basic_content} />
              </.card_content>
            </.card>

            <.card class="flex-1">
              <.card_header>
                <.card_title>Compact</.card_title>
              </.card_header>
              <.card_content>
                <.markdown id="compact-spacing" content={@basic_content} variant="compact" />
              </.card_content>
            </.card>
          </.flex>
        </section>

        <%!-- Full Example --%>
        <section class="space-y-4">
          <div>
            <h2 class="text-2xl font-semibold text-foreground">Full Example</h2>
            <p class="text-muted-foreground">
              A complete example combining all features.
            </p>
          </div>

          <.card>
            <.card_header>
              <.card_title>Project README</.card_title>
              <.card_description>A realistic documentation example</.card_description>
            </.card_header>
            <.card_content>
              <.markdown id="full-markdown" content={@full_content} />
            </.card_content>
          </.card>
        </section>

        <%!-- Usage --%>
        <section class="space-y-4">
          <div>
            <h2 class="text-2xl font-semibold text-foreground">Usage</h2>
            <p class="text-muted-foreground">
              How to use the markdown component in your LiveView.
            </p>
          </div>

          <.card>
            <.card_content>
              <pre class="text-sm p-4 bg-muted rounded-lg overflow-x-auto" phx-no-format><code phx-no-curly-interpolation># Basic usage
    &lt;.markdown id="readme" content={@readme_content} /&gt;

    # Compact variant for tighter spacing
    &lt;.markdown id="notes" content={@notes} variant="compact" /&gt;

    # With custom styling
    &lt;.markdown id="article" content={@article} class="prose-lg" /&gt;

    # Inside a card
    &lt;.card&gt;
      &lt;.card_header&gt;
        &lt;.card_title&gt;Documentation&lt;/.card_title&gt;
      &lt;/.card_header&gt;
      &lt;.card_content&gt;
        &lt;.markdown id="docs" content={@doc_content} /&gt;
      &lt;/.card_content&gt;
    &lt;/.card&gt;</code></pre>
            </.card_content>
          </.card>
        </section>
      </.stack>
    </.container>
    """
  end

  @spec basic_markdown() :: String.t()
  defp basic_markdown do
    """
    ## Getting Started

    Welcome to the **markdown viewer** component! This component supports:

    - *Italic* and **bold** text formatting
    - [Links](https://example.com) to external resources
    - Inline `code` snippets

    ### Lists

    Here's an ordered list:

    1. First item
    2. Second item
    3. Third item

    > **Note:** Blockquotes are also supported for callouts and quotes.

    ---

    That's all for basic formatting!
    """
  end

  @spec code_markdown() :: String.t()
  defp code_markdown do
    """
    ### Elixir

    ```elixir
    defmodule Example do
      @moduledoc "An example module"

      def hello(name) do
        "Hello, \#{name}!"
      end
    end
    ```

    ### JavaScript

    ```javascript
    function greet(name) {
      return `Hello, ${name}!`;
    }

    const result = greet("World");
    console.log(result);
    ```

    ### SQL

    ```sql
    SELECT users.name, COUNT(orders.id) as order_count
    FROM users
    LEFT JOIN orders ON users.id = orders.user_id
    GROUP BY users.id
    HAVING order_count > 5;
    ```
    """
  end

  @spec mermaid_markdown() :: String.t()
  defp mermaid_markdown do
    """
    ### Flowchart

    ```mermaid
    graph TD
        A[Start] --> B{Is it working?}
        B -->|Yes| C[Great!]
        B -->|No| D[Debug]
        D --> B
        C --> E[End]
    ```

    ### Sequence Diagram

    ```mermaid
    sequenceDiagram
        participant User
        participant Server
        participant Database

        User->>Server: Request data
        Server->>Database: Query
        Database-->>Server: Results
        Server-->>User: Response
    ```
    """
  end

  @spec math_markdown() :: String.t()
  defp math_markdown do
    """
    ### Inline Math

    The famous equation $E = mc^2$ describes the relationship between mass and energy.

    The quadratic formula is $x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}$.

    ### Display Math

    The integral of the Gaussian function:

    $$\\int_{-\\infty}^{\\infty} e^{-x^2} dx = \\sqrt{\\pi}$$

    Maxwell's equations in differential form:

    $$\\nabla \\cdot \\mathbf{E} = \\frac{\\rho}{\\epsilon_0}$$

    $$\\nabla \\times \\mathbf{B} = \\mu_0 \\mathbf{J} + \\mu_0 \\epsilon_0 \\frac{\\partial \\mathbf{E}}{\\partial t}$$
    """
  end

  @spec full_markdown() :: String.t()
  defp full_markdown do
    """
    # MyApp

    A Phoenix application with LiveView components.

    ## Installation

    Add `my_app` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [
        {:my_app, "~> 1.0.0"}
      ]
    end
    ```

    Then run:

    ```bash
    mix deps.get
    mix phx.server
    ```

    ## Architecture

    ```mermaid
    graph LR
        A[Browser] --> B[Phoenix]
        B --> C[LiveView]
        C --> D[Ecto]
        D --> E[(Database)]
    ```

    ## Features

    | Feature | Status | Notes |
    |---------|--------|-------|
    | Authentication | Done | Uses Argon2 |
    | Authorization | Done | Role-based |
    | API | In Progress | REST + GraphQL |

    ## Math Support

    For applications requiring mathematical notation, we support LaTeX:

    The time complexity is $O(n \\log n)$ for sorting operations.

    > **Tip:** Use the compact variant when embedding in tight layouts.
    """
  end
end
