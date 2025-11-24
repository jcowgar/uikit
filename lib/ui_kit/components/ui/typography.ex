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
end
