defmodule UiKit.Components.Ui.Typography do
  @moduledoc """
  Typography component for semantic text styling.
  """
  use Phoenix.Component

  @doc """
  Renders semantic typography.

  ## Attributes

  - `variant` - The semantic style of the text. Options:
    - `:h1` - Main heading
    - `:h2` - Section heading
    - `:h3` - Subsection heading
    - `:h4` - Minor heading
    - `:p` (or `:body`) - Standard body text
    - `:lead` - Large body text
    - `:large` - Large text
    - `:small` - Small text
    - `:muted` - Muted text
  - `element` - The HTML tag to use (e.g., "h1", "p", "span"). Defaults based on variant.
  - `class` - Additional CSS classes.

  ## Examples

      <.typography variant={:h1}>Main Title</.typography>
      <.typography variant={:h2}>Subtitle</.typography>
      <.typography variant={:p}>Body text...</.typography>
      <.typography variant={:muted} element="span">Muted label</.typography>
  """
  attr(:variant, :atom,
    default: :p,
    values: [:h1, :h2, :h3, :h4, :p, :body, :lead, :large, :small, :muted]
  )

  attr(:element, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def typography(assigns) do
    element = assigns.element || default_element(assigns.variant)

    classes = [
      variant_class(assigns.variant),
      assigns.class
    ]

    assigns =
      assigns
      |> assign(:element, element)
      |> assign(:classes, classes)

    ~H"""
    <Phoenix.Component.dynamic_tag tag_name={@element} class={@classes} {@rest}>
      {render_slot(@inner_block)}
    </Phoenix.Component.dynamic_tag>
    """
  end

  defp default_element(:h1), do: "h1"
  defp default_element(:h2), do: "h2"
  defp default_element(:h3), do: "h3"
  defp default_element(:h4), do: "h4"
  defp default_element(:p), do: "p"
  defp default_element(:body), do: "p"
  defp default_element(:lead), do: "p"
  defp default_element(:large), do: "div"
  defp default_element(:small), do: "small"
  defp default_element(:muted), do: "p"

  defp variant_class(:h1), do: "text-heading-xl"
  defp variant_class(:h2), do: "text-heading-lg"
  defp variant_class(:h3), do: "text-heading"
  defp variant_class(:h4), do: "text-heading-sm"
  defp variant_class(:lead), do: "text-body-lg"
  defp variant_class(:p), do: "text-body"
  defp variant_class(:body), do: "text-body"
  defp variant_class(:large), do: "text-lg font-semibold"
  defp variant_class(:small), do: "text-body-sm font-medium leading-none"
  defp variant_class(:muted), do: "text-muted-text"

  @doc """
  Renders a code block with syntax highlighting hints and optional features.

  The code block component displays preformatted code with proper styling,
  scrolling support, and semantic HTML. Perfect for documentation, demos,
  and displaying code examples.

  ## Features

  - Semantic HTML with `<pre>` and `<code>` tags
  - Scrollable for long code blocks
  - Language hint via class (e.g., `language-elixir`)
  - Dark/light theme support
  - Monospace font
  - Proper whitespace preservation
  - Copy-friendly formatting

  ## Attributes

  - `language` - Programming language for syntax highlighting hint (optional)
  - `class` - Additional CSS classes
  - `max_height` - Maximum height before scrolling (e.g., "400px")

  ## Examples

      # Basic code block
      <.code_block>
        <pre><code>def hello do
          IO.puts "Hello, World!"
        end</code></pre>
      </.code_block>

      # With language hint
      <.code_block language="elixir">
        <pre><code>defmodule MyApp do
          def start do
            :ok
          end
        end</code></pre>
      </.code_block>

      # With custom max height
      <.code_block language="javascript" max_height="300px">
        <pre><code>function hello() {
          console.log("Hello!");
        }</code></pre>
      </.code_block>

      # Inline code (use with element override)
      <code class="rounded bg-muted px-1 py-0.5 font-mono text-sm">npm install</code>

  """
  attr(:language, :string, default: nil, doc: "Programming language for syntax highlighting")
  attr(:max_height, :string, default: nil, doc: "Maximum height before scrolling (e.g., '400px')")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def code_block(assigns) do
    ~H"""
    <div class={[
      "relative rounded-lg border border-border bg-muted/50",
      @class
    ]} {@rest}>
      <div
        class={[
          "overflow-x-auto p-4",
          @max_height && "overflow-y-auto"
        ]}
        style={@max_height && "max-height: #{@max_height}"}
      >
        <div class={[
          "font-mono text-sm",
          @language && "language-#{@language}"
        ]}>
          {render_slot(@inner_block)}
        </div>
      </div>
    </div>
    """
  end
end
