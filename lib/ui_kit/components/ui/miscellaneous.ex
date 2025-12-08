defmodule UiKit.Components.Ui.Miscellaneous do
  @moduledoc """
  Miscellaneous UI components for various interactive purposes.

  Components ported from shadcn/ui.
  """
  use Phoenix.Component

  import UiKit.Components.Ui.FormInput, only: [button: 1]
  import UiKit.Components.LayoutComponents, only: [flex: 1]

  alias Phoenix.LiveView.Rendered

  @doc """
  Renders a collapsible container.

  A collapsible component allows you to show and hide content sections with smooth animations.
  Use with the collapsible_trigger and collapsible_content sub-components.

  ## Attributes

  - `id` - Required unique identifier for the collapsible (required)
  - `open` - Whether the collapsible is initially open (default: false)

  ## Examples

      <.collapsible id="features-collapsible">
        <.collapsible_trigger>
          <.flex justify="between" class="rounded-md border border-border px-4 py-3 hover:bg-accent">
            <span class="text-sm font-medium">Show Features</span>
            <.icon name="hero-chevron-down" class="size-4 transition-transform duration-200" data-collapsible-icon />
          </.flex>
        </.collapsible_trigger>
        <.collapsible_content>
          <div class="p-4 text-sm text-muted-foreground">
            Here are the feature details...
          </div>
        </.collapsible_content>
      </.collapsible>

      <%!-- With default open state --%>
      <.collapsible id="info-collapsible" open={true}>
        <.collapsible_trigger>
          <h3 class="text-base font-semibold">Additional Information</h3>
        </.collapsible_trigger>
        <.collapsible_content>
          <p class="mt-2 text-sm">This section is open by default.</p>
        </.collapsible_content>
      </.collapsible>

  """
  attr(:id, :string, required: true)
  attr(:open, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec collapsible(map()) :: Rendered.t()
  def collapsible(assigns) do
    ~H"""
    <div
      id={@id}
      data-slot="collapsible"
      data-default-open={@open}
      phx-hook="Collapsible"
      class={@class}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a collapsible trigger.

  The trigger element toggles the collapsible content's visibility.
  It should be used as a child of the collapsible component.

  ## Examples

      <.collapsible_trigger>
        <button type="button">Toggle Content</button>
      </.collapsible_trigger>

      <.collapsible_trigger>
        <.flex gap="sm">
          <.icon name="hero-information-circle" />
          <span>Click to expand</span>
        </.flex>
      </.collapsible_trigger>

  """
  attr(:target_id, :string,
    default: nil,
    doc: "ID of the collapsible container (auto-detected from parent)"
  )

  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec collapsible_trigger(map()) :: Rendered.t()
  def collapsible_trigger(assigns) do
    ~H"""
    <.button
      variant="unstyled"
      type="button"
      data-slot="collapsible-trigger"
      role="button"
      aria-expanded="false"
      aria-controls={@target_id && "#{@target_id}-content"}
      class={["cursor-pointer w-full text-left", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.button>
    """
  end

  @doc """
  Renders collapsible content.

  The content that will be shown/hidden when the collapsible is toggled.
  It should be used as a child of the collapsible component.

  The content uses smooth height transitions and can optionally start in an open state.

  ## Examples

      <.collapsible_content>
        <div class="p-4">
          Content that can be collapsed
        </div>
      </.collapsible_content>

      <.collapsible_content class="border-t border-border">
        <ul>
          <li>Item 1</li>
          <li>Item 2</li>
          <li>Item 3</li>
        </ul>
      </.collapsible_content>

  """
  attr(:id, :string, default: nil)
  attr(:open, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec collapsible_content(map()) :: Rendered.t()
  def collapsible_content(assigns) do
    ~H"""
    <div
      data-slot="collapsible-content"
      id={"#{@id || "collapsible"}-content"}
      class={[
        "grid transition-all duration-200 ease-in-out overflow-x-hidden",
        if(@open, do: "grid-rows-[1fr] opacity-100", else: "grid-rows-[0fr] opacity-0"),
        @class
      ]}
      {@rest}
    >
      <div class="min-h-0">
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  @doc """
  Renders a toggle group container.

  A set of two-state buttons that can be toggled on or off. Supports both
  single-select (radio) and multi-select (checkbox) modes.

  ## Attributes

  - `type` - Selection mode: "single" (only one active) or "multiple" (many active) (default: "single")
  - `variant` - Visual style: "default" or "outline" (default: "default")
  - `size` - Button size: "sm", "default", or "lg" (default: "default")
  - `spacing` - Gap between items in Tailwind spacing units (default: 0)
  - `value` - Currently selected value(s) - string for single, list for multiple
  - `on_value_change` - Event name to trigger when selection changes
  - `disabled` - Whether the entire group is disabled (default: false)

  ## Examples

      <%!-- Single select toggle group --%>
      <.toggle_group id="text-align" type="single" value={@align} on_value_change="align_changed">
        <.toggle_group_item value="left" aria_label="Align left">
          <.icon name="hero-bars-3-bottom-left" />
        </.toggle_group_item>
        <.toggle_group_item value="center" aria_label="Align center">
          <.icon name="hero-bars-3" />
        </.toggle_group_item>
        <.toggle_group_item value="right" aria_label="Align right">
          <.icon name="hero-bars-3-bottom-right" />
        </.toggle_group_item>
      </.toggle_group>

      <%!-- Multiple select with outline variant --%>
      <.toggle_group
        id="features"
        type="multiple"
        variant="outline"
        spacing={2}
        value={@selected_features}
        on_value_change="features_changed"
      >
        <.toggle_group_item value="bold" aria_label="Toggle bold">
          <.icon name="hero-bold" />
        </.toggle_group_item>
        <.toggle_group_item value="italic" aria_label="Toggle italic">
          <.icon name="hero-italic" />
        </.toggle_group_item>
        <.toggle_group_item value="underline" aria_label="Toggle underline">
          <.icon name="hero-underline" />
        </.toggle_group_item>
      </.toggle_group>

  """
  attr(:id, :string, required: true)
  attr(:type, :string, default: "single", values: ~w(single multiple))
  attr(:variant, :string, default: "default", values: ~w(default outline))
  attr(:size, :string, default: "default", values: ~w(sm default lg))
  attr(:spacing, :integer, default: 0)
  attr(:value, :any, default: nil, doc: "Current value (string for single, list for multiple)")
  attr(:on_value_change, :string, default: nil, doc: "Event name to trigger on change")
  attr(:disabled, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec toggle_group(map()) :: Rendered.t()
  def toggle_group(assigns) do
    # Normalize value to a list for consistent handling
    normalized_value =
      case assigns.value do
        nil -> []
        val when is_list(val) -> val
        val -> [val]
      end

    assigns = assign(assigns, :normalized_value, normalized_value)

    ~H"""
    <.flex
      id={@id}
      data-slot="toggle-group"
      data-type={@type}
      data-variant={@variant}
      data-size={@size}
      data-spacing={@spacing}
      data-on-value-change={@on_value_change}
      phx-hook={if @on_value_change, do: "ToggleGroup", else: nil}
      gap="none"
      class={[
        "group/toggle-group w-fit rounded-md",
        spacing_class(@spacing),
        @spacing == 0 && @variant == "outline" && "shadow-xs",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block, %{
        variant: @variant,
        size: @size,
        spacing: @spacing,
        selected_values: @normalized_value,
        type: @type,
        disabled: @disabled,
        on_value_change: @on_value_change
      })}
    </.flex>
    """
  end

  @doc """
  Renders a toggle group item.

  An individual button within a toggle group. Must be used as a child of toggle_group.

  ## Attributes

  - `value` - Unique identifier for this item (required)
  - `aria_label` - Accessibility label (required)
  - `variant` - Passed from parent toggle_group
  - `size` - Passed from parent toggle_group
  - `spacing` - Passed from parent toggle_group
  - `selected_values` - Passed from parent toggle_group
  - `type` - Passed from parent toggle_group
  - `disabled` - Whether this specific item is disabled (default: false)
  - `on_value_change` - Event name from parent toggle_group

  ## Examples

      <.toggle_group_item value="left" aria_label="Align left">
        <.icon name="hero-bars-3-bottom-left" />
      </.toggle_group_item>

      <.toggle_group_item value="bold" aria_label="Toggle bold" disabled={true}>
        <.icon name="hero-bold" />
        <span class="ml-2">Bold</span>
      </.toggle_group_item>

  """
  attr(:value, :string, required: true)
  attr(:aria_label, :string, required: true)
  attr(:variant, :string, default: "default")
  attr(:size, :string, default: "default")
  attr(:spacing, :integer, default: 0)
  attr(:selected_values, :list, default: [])
  attr(:type, :string, default: "single")
  attr(:disabled, :boolean, default: false)
  attr(:on_value_change, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec toggle_group_item(map()) :: Rendered.t()
  def toggle_group_item(assigns) do
    # Get context from parent toggle_group via attributes
    parent_variant = assigns.variant
    parent_size = assigns.size
    parent_spacing = assigns.spacing
    selected_values = assigns.selected_values
    parent_type = assigns.type
    parent_disabled = assigns.disabled
    on_value_change = assigns.on_value_change

    is_selected = assigns.value in selected_values
    is_disabled = assigns.disabled || parent_disabled

    assigns =
      assigns
      |> assign(:parent_variant, parent_variant)
      |> assign(:parent_size, parent_size)
      |> assign(:parent_spacing, parent_spacing)
      |> assign(:is_selected, is_selected)
      |> assign(:is_disabled, is_disabled)
      |> assign(:parent_type, parent_type)
      |> assign(:on_value_change, on_value_change)

    ~H"""
    <.button
      variant="unstyled"
      type="button"
      data-slot="toggle-group-item"
      data-value={@value}
      data-state={if @is_selected, do: "on", else: "off"}
      data-variant={@parent_variant}
      data-size={@parent_size}
      data-spacing={@parent_spacing}
      aria-label={@aria_label}
      aria-pressed={to_string(@is_selected)}
      disabled={@is_disabled}
      class={[
        toggle_item_base_classes(),
        toggle_item_variant_classes(@parent_variant),
        toggle_item_size_classes(@parent_size),
        toggle_item_spacing_classes(@parent_spacing, @parent_variant),
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.button>
    """
  end

  # Spacing utility
  @spec spacing_class(integer()) :: String.t()
  defp spacing_class(0), do: ""
  defp spacing_class(spacing), do: "gap-#{spacing}"

  # Toggle item base classes (from toggle component)
  @spec toggle_item_base_classes() :: String.t()
  defp toggle_item_base_classes do
    """
    inline-flex items-center justify-center gap-2 rounded-md text-sm font-medium
    text-foreground
    hover:bg-muted hover:text-muted-foreground
    disabled:pointer-events-none disabled:opacity-50
    [&_svg]:pointer-events-none [&_svg:not([class*='size-'])]:size-4 [&_svg]:shrink-0
    focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]
    outline-none transition-all duration-200
    aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive
    whitespace-nowrap w-auto min-w-0 shrink-0 px-3 focus:z-10 focus-visible:z-10
    """
  end

  # Toggle item variant classes
  @spec toggle_item_variant_classes(String.t()) :: String.t()
  defp toggle_item_variant_classes("default") do
    """
    bg-surface border border-border
    data-[state=on]:bg-accent data-[state=on]:text-accent-foreground data-[state=on]:border-accent
    """
  end

  defp toggle_item_variant_classes("outline") do
    """
    border border-input bg-surface shadow-xs
    hover:bg-accent hover:text-accent-foreground
    data-[state=on]:bg-accent data-[state=on]:text-accent-foreground data-[state=on]:border-accent
    """
  end

  # Toggle item size classes
  @spec toggle_item_size_classes(String.t()) :: String.t()
  defp toggle_item_size_classes("sm"), do: "h-8 px-1.5 min-w-8"
  defp toggle_item_size_classes("default"), do: "h-9 px-2 min-w-9"
  defp toggle_item_size_classes("lg"), do: "h-10 px-2.5 min-w-10"

  # Toggle item spacing classes (handle grouped appearance when spacing is 0)
  @spec toggle_item_spacing_classes(integer(), String.t()) :: String.t()
  defp toggle_item_spacing_classes(0, variant) do
    border_classes = if variant == "outline", do: "border-l-0 first:border-l", else: ""
    "rounded-none shadow-none first:rounded-l-md last:rounded-r-md #{border_classes}"
  end

  defp toggle_item_spacing_classes(_spacing, _variant), do: ""

  @doc """
  Renders a hover card container.

  A hover card displays rich content when hovering over an element. Use with
  hover_card_trigger and hover_card_content sub-components to create preview cards
  for links, profile information, or any content that benefits from additional context.

  ## Attributes

  - `id` - Unique identifier for the hover card (required)
  - `class` - Additional CSS classes

  ## Examples

      <.hover_card id="profile-preview">
        <.hover_card_trigger>
          <a href="#" class="text-primary underline">@nextjs</a>
        </.hover_card_trigger>
        <.hover_card_content class="w-80">
          <.flex gap="md" items="start">
            <.avatar size="md">
              <.avatar_image src="/avatar.jpg" alt="Next.js" />
              <.avatar_fallback>NJ</.avatar_fallback>
            </.avatar>
            <.stack gap="xs">
              <h4 class="text-sm font-semibold">@nextjs</h4>
              <p class="text-sm text-muted-foreground">
                The React Framework - created and maintained by @vercel.
              </p>
              <.flex class="pt-2">
                <span class="text-xs text-muted-foreground">Joined December 2021</span>
              </.flex>
            </.stack>
          </.flex>
        </.hover_card_content>
      </.hover_card>

  """
  attr(:id, :string, required: true)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec hover_card(map()) :: Rendered.t()
  def hover_card(assigns) do
    ~H"""
    <div
      id={@id}
      data-slot="hover-card"
      class={["group/hover-card relative inline-block", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders the trigger element for a hover card.

  The element that activates the hover card when hovered over.
  Typically contains a link or button.

  ## Examples

      <.hover_card_trigger>
        <button type="button" class="text-primary underline">Hover me</button>
      </.hover_card_trigger>

      <.hover_card_trigger>
        <a href="/user/profile" class="font-medium">@username</a>
      </.hover_card_trigger>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec hover_card_trigger(map()) :: Rendered.t()
  def hover_card_trigger(assigns) do
    ~H"""
    <div
      data-slot="hover-card-trigger"
      class={["inline-block cursor-pointer", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders the content of a hover card.

  The content displayed when hovering over the trigger. Uses CSS-based positioning
  and animations for smooth appearance. Supports alignment options.

  ## Attributes

  - `align` - Horizontal alignment relative to trigger (default: "center")
    - "start" - Align to left edge
    - "center" - Align to center
    - "end" - Align to right edge
  - `side_offset` - Distance from trigger in pixels (default: 4)
  - `class` - Additional CSS classes

  ## Examples

      <.hover_card_content>
        <p class="text-sm">Simple hover content</p>
      </.hover_card_content>

      <.hover_card_content align="start" class="w-96">
        <.stack gap="sm">
          <h4 class="font-semibold">Rich Content</h4>
          <p class="text-sm text-muted-foreground">
            More detailed information displayed on hover.
          </p>
        </.stack>
      </.hover_card_content>

  """
  attr(:align, :string, default: "center", values: ~w(start center end))
  attr(:side_offset, :integer, default: 4)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec hover_card_content(map()) :: Rendered.t()
  def hover_card_content(assigns) do
    alignment_classes = %{
      "start" => "left-0",
      "center" => "left-1/2 -translate-x-1/2",
      "end" => "right-0"
    }

    assigns =
      assign(
        assigns,
        :alignment_class,
        Map.get(alignment_classes, assigns.align, "left-1/2 -translate-x-1/2")
      )

    ~H"""
    <div
      data-slot="hover-card-content"
      class={[
        "absolute z-50 w-64 origin-top rounded-md border border-border bg-popover p-4 text-popover-foreground shadow-md outline-hidden",
        "opacity-0 scale-95 transition-all duration-200 ease-in-out pointer-events-none",
        "group-hover/hover-card:opacity-100 group-hover/hover-card:scale-100 group-hover/hover-card:pointer-events-auto",
        @alignment_class,
        @class
      ]}
      style={"top: calc(100% + #{@side_offset}px);"}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end
end
