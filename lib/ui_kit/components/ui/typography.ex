defmodule UiKit.Components.Ui.Typography do
  @moduledoc """
  Typography component for semantic text styling.
  """
  use Phoenix.Component

  @doc """
  Renders semantic typography.

  ## Attributes

  - `variant` - The style of the text. Options:

    Semantic variants:
    - `:h1` - Main heading
    - `:h2` - Section heading
    - `:h3` - Subsection heading
    - `:h4` - Minor heading
    - `:p` (or `:body`) - Standard body text
    - `:lead` - Large body text
    - `:muted` - Muted text

    Standard size scale (maps to Tailwind text sizes):
    - `:xs` - Extra small (0.75rem)
    - `:sm` - Small (0.875rem)
    - `:md` - Medium/base (1rem)
    - `:lg` - Large (1.125rem)
    - `:xl` - Extra large (1.25rem)
    - `:"2xl"` - 2x large (1.5rem)
    - `:"3xl"` - 3x large (1.875rem)
    - `:"4xl"` - 4x large (2.25rem)
    - `:"5xl"` - 5x large (3rem)
    - `:"6xl"` - 6x large (3.75rem)
    - `:"7xl"` - 7x large (4.5rem)
    - `:"8xl"` - 8x large (6rem)
    - `:"9xl"` - 9x large (8rem)

    Legacy (kept for compatibility):
    - `:large` - Large text with semibold
    - `:small` - Small text with medium weight
    - `:tiny` - Tiny text (9px)

  - `element` - The HTML tag to use (e.g., "h1", "p", "span"). Defaults based on variant.
    When set to an inline element like "span" without a variant, no styling is applied
    (inherits from parent context).
  - `class` - Additional CSS classes.

  ## Examples

      <.typography variant={:h1}>Main Title</.typography>
      <.typography variant={:h2}>Subtitle</.typography>
      <.typography variant={:p}>Body text...</.typography>
      <.typography variant={:muted} element="span">Muted label</.typography>
      <.typography variant={:"6xl"} class="font-bold">Large number</.typography>
      <.typography element="span" class="text-primary">Inherits, plus custom class</.typography>
  """
  attr(:variant, :atom,
    default: nil,
    values: [
      nil,
      # Semantic variants
      :h1,
      :h2,
      :h3,
      :h4,
      :p,
      :body,
      :lead,
      :muted,
      # Legacy size variants (kept for compatibility)
      :large,
      :small,
      :tiny,
      # Standard size scale
      :xs,
      :sm,
      :md,
      :lg,
      :xl,
      :"2xl",
      :"3xl",
      :"4xl",
      :"5xl",
      :"6xl",
      :"7xl",
      :"8xl",
      :"9xl"
    ]
  )

  attr(:element, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @inline_elements ~w(span a strong em b i u s mark sub sup code abbr cite q)

  def typography(assigns) do
    # Determine effective variant and element
    {element, variant_class} = resolve_element_and_class(assigns.variant, assigns.element)

    classes = [
      variant_class,
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

  # When variant is explicitly set, use it
  defp resolve_element_and_class(variant, element) when not is_nil(variant) do
    el = element || default_element(variant)
    {el, variant_class(variant)}
  end

  # When no variant but element is inline, inherit (no styling)
  defp resolve_element_and_class(nil, element) when element in @inline_elements do
    {element, nil}
  end

  # When no variant and no element (or block element), default to :p
  defp resolve_element_and_class(nil, element) do
    el = element || "p"
    {el, variant_class(:p)}
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
  defp default_element(:tiny), do: "span"
  defp default_element(:muted), do: "p"
  # Standard size scale - use span for flexibility
  defp default_element(:xs), do: "span"
  defp default_element(:sm), do: "span"
  defp default_element(:md), do: "span"
  defp default_element(:lg), do: "span"
  defp default_element(:xl), do: "span"
  defp default_element(:"2xl"), do: "span"
  defp default_element(:"3xl"), do: "span"
  defp default_element(:"4xl"), do: "span"
  defp default_element(:"5xl"), do: "span"
  defp default_element(:"6xl"), do: "span"
  defp default_element(:"7xl"), do: "span"
  defp default_element(:"8xl"), do: "span"
  defp default_element(:"9xl"), do: "span"

  defp variant_class(:h1), do: "text-heading-xl"
  defp variant_class(:h2), do: "text-heading-lg"
  defp variant_class(:h3), do: "text-heading"
  defp variant_class(:h4), do: "text-heading-sm"
  defp variant_class(:lead), do: "text-body-lg"
  defp variant_class(:p), do: "text-body"
  defp variant_class(:body), do: "text-body"
  defp variant_class(:large), do: "text-lg font-semibold"
  defp variant_class(:small), do: "text-body-sm font-medium leading-none"
  defp variant_class(:tiny), do: "text-[0.5625rem] font-normal leading-none"
  defp variant_class(:muted), do: "text-muted-text"
  # Standard size scale - maps to Tailwind text sizes
  defp variant_class(:xs), do: "text-xs"
  defp variant_class(:sm), do: "text-sm"
  defp variant_class(:md), do: "text-base"
  defp variant_class(:lg), do: "text-lg"
  defp variant_class(:xl), do: "text-xl"
  defp variant_class(:"2xl"), do: "text-2xl"
  defp variant_class(:"3xl"), do: "text-3xl"
  defp variant_class(:"4xl"), do: "text-4xl"
  defp variant_class(:"5xl"), do: "text-5xl"
  defp variant_class(:"6xl"), do: "text-6xl"
  defp variant_class(:"7xl"), do: "text-7xl"
  defp variant_class(:"8xl"), do: "text-8xl"
  defp variant_class(:"9xl"), do: "text-9xl"

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
