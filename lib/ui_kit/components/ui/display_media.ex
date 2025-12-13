defmodule UiKit.Components.Ui.DisplayMedia do
  @moduledoc """
  Display & Media components for content presentation.

  Components ported from shadcn/ui.
  """
  use Phoenix.Component

  import UiKit.Components.LayoutComponents, only: [flex: 1]

  alias Phoenix.LiveView.Rendered

  @doc """
  Renders a container with a specified aspect ratio.

  Displays content within a desired width-to-height ratio. Useful for maintaining
  consistent proportions for images, videos, embeds, and other media.

  ## Examples

      <%!-- 16:9 aspect ratio (widescreen video) --%>
      <.aspect_ratio ratio={16 / 9}>
        <img src="/images/landscape.jpg" alt="Landscape" class="object-cover w-full h-full" />
      </.aspect_ratio>

      <%!-- 4:3 aspect ratio (classic photo) --%>
      <.aspect_ratio ratio={4 / 3} class="rounded-lg overflow-hidden">
        <img src="/images/photo.jpg" alt="Photo" class="object-cover w-full h-full" />
      </.aspect_ratio>

      <%!-- 1:1 aspect ratio (square) --%>
      <.aspect_ratio ratio={1}>
        <img src="/images/avatar.jpg" alt="Avatar" class="object-cover w-full h-full" />
      </.aspect_ratio>

      <%!-- Video embed with 16:9 ratio --%>
      <.aspect_ratio ratio={16 / 9} class="bg-muted rounded-xl overflow-hidden">
        <iframe
          src="https://www.youtube.com/embed/..."
          class="w-full h-full"
          allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
          allowfullscreen
        />
      </.aspect_ratio>

  """
  attr(:ratio, :any,
    default: 1.0,
    doc: "The width-to-height ratio (e.g., 16/9, 4/3, 1). Defaults to 1:1 (square)."
  )

  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec aspect_ratio(map()) :: Rendered.t()
  def aspect_ratio(assigns) do
    ~H"""
    <div
      data-slot="aspect-ratio"
      style={"aspect-ratio: #{@ratio}"}
      class={["relative w-full", @class]}
      {@rest}
    >
      <div class="absolute inset-0">
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  @doc """
  Renders a card container.

  The card component provides a flexible container for grouping related content.
  Use with the card_* sub-components for consistent structure.

  ## Attributes

  - `navigate` - When provided, wraps the card in a link and adds hover effects
    (scale and shadow) for a clickable card experience.
  - `class` - Additional CSS classes.

  ## Examples

      <.card>
        <.card_header>
          <.card_title>Card Title</.card_title>
          <.card_description>Card description text</.card_description>
        </.card_header>
        <.card_content>
          Main content goes here
        </.card_content>
        <.card_footer>
          <.button>Action</.button>
        </.card_footer>
      </.card>

      <.card navigate={~p"/some/path"}>
        <.card_content>Clickable card with hover effects</.card_content>
      </.card>

  """
  attr(:navigate, :string, default: nil, doc: "Navigation path - makes card clickable with hover effects")
  attr(:gap, :string, default: "lg", doc: "Gap between card sections: none, xs, sm, md, lg, xl")

  attr(:auto_badge_padding, :boolean,
    default: true,
    doc: "Auto-add padding when card_badge is present. Disable when card content is designed to accommodate badges."
  )

  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec card(map()) :: Rendered.t()
  def card(assigns) do
    # Base card styles
    base_classes = [
      "relative bg-card text-card-foreground rounded-xl border border-border py-6 shadow-sm",
      # Remove bottom padding when card_status is present (it goes edge-to-edge)
      "has-[[data-slot=card-status]]:pb-0"
    ]

    # Auto-padding when card_badge is present using :has() selectors
    # Note: Using hyphens not underscores because Tailwind converts _ to space
    badge_padding_classes =
      if assigns.auto_badge_padding do
        [
          # Add top padding when top badges exist
          "has-[[data-slot=card-badge-top-left]]:pt-10",
          "has-[[data-slot=card-badge-top-right]]:pt-10",
          # Add bottom padding when bottom badges exist
          "has-[[data-slot=card-badge-bottom-left]]:pb-10",
          "has-[[data-slot=card-badge-bottom-right]]:pb-10"
        ]
      else
        []
      end

    assigns = assign(assigns, :base_classes, base_classes)
    assigns = assign(assigns, :badge_padding_classes, badge_padding_classes)

    ~H"""
    <%= if @navigate do %>
      <Phoenix.Component.link navigate={@navigate} class="block">
        <.flex
          direction="col"
          items="stretch"
          gap={@gap}
          class={[
            @base_classes,
            @badge_padding_classes,
            "transition-all hover:scale-[1.02] hover:shadow-md cursor-pointer",
            @class
          ]}
          {@rest}
        >
          {render_slot(@inner_block)}
        </.flex>
      </Phoenix.Component.link>
    <% else %>
      <.flex
        direction="col"
        items="stretch"
        gap={@gap}
        class={[
          @base_classes,
          @badge_padding_classes,
          @class
        ]}
        {@rest}
      >
        {render_slot(@inner_block)}
      </.flex>
    <% end %>
    """
  end

  @doc """
  Renders a card header section.

  Contains the card title, description, and optional action element.
  Automatically adjusts grid rows based on whether a description is present.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec card_header(map()) :: Rendered.t()
  def card_header(assigns) do
    ~H"""
    <div
      data-slot="card-header"
      class={[
        "grid auto-rows-min items-start gap-2 px-6",
        "has-[[data-card-description]]:grid-rows-[auto_auto]",
        "has-[[data-card-action]]:grid-cols-[1fr_auto]",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a card title.

  Typically used within card_header.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec card_title(map()) :: Rendered.t()
  def card_title(assigns) do
    ~H"""
    <div class={["leading-none font-semibold text-foreground", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a card description.

  Typically used within card_header, below the card_title.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec card_description(map()) :: Rendered.t()
  def card_description(assigns) do
    ~H"""
    <div data-card-description class={["text-muted-foreground text-sm", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a card action element.

  Positioned in the top-right corner of the card header.
  Use for actions like a close button or menu.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec card_action(map()) :: Rendered.t()
  def card_action(assigns) do
    ~H"""
    <div
      data-card-action
      class={[
        "col-start-2 row-span-2 row-start-1 self-start justify-self-end",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders the main card content area.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec card_content(map()) :: Rendered.t()
  def card_content(assigns) do
    ~H"""
    <div data-slot="card-content" class={["px-6", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a card footer section.

  Typically used for action buttons or secondary information.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec card_footer(map()) :: Rendered.t()
  def card_footer(assigns) do
    ~H"""
    <.flex class={["px-6", @class]} {@rest}>
      {render_slot(@inner_block)}
    </.flex>
    """
  end

  @doc """
  Renders corner badges on a card.

  Displays badges in any of the four corners of a card. Multiple badges in the
  same corner stack horizontally or vertically based on the direction attribute.

  Must be used inside a card component (which has `relative` positioning).

  ## Examples

      <%!-- Single badge in top-right --%>
      <.card>
        <.card_badge>
          <:top_right variant="success">NEW</:top_right>
        </.card_badge>
        <.card_content>...</.card_content>
      </.card>

      <%!-- Multiple badges stacking horizontally --%>
      <.card>
        <.card_badge>
          <:top_right variant="muted">
            <.icon name="hero-star-solid" class="size-3.5" />
          </:top_right>
          <:top_right variant="success">SL 5</:top_right>
        </.card_badge>
        <.card_content>...</.card_content>
      </.card>

      <%!-- Badges in multiple corners --%>
      <.card>
        <.card_badge>
          <:top_left variant="warning">DRAFT</:top_left>
          <:top_right variant="success">$99</:top_right>
          <:bottom_right variant="muted">v2.1</:bottom_right>
        </.card_badge>
        <.card_content>...</.card_content>
      </.card>

      <%!-- Vertical stacking --%>
      <.card>
        <.card_badge>
          <:top_right variant="muted" direction="vertical">★</:top_right>
          <:top_right variant="success" direction="vertical">SL 5</:top_right>
        </.card_badge>
        <.card_content>...</.card_content>
      </.card>

  """
  slot :top_left, doc: "Badges in the top-left corner" do
    attr :variant, :string, doc: "Color variant: default, success, warning, destructive, primary"
    attr :direction, :string, doc: "Stack direction: horizontal (default) or vertical"
  end

  slot :top_right, doc: "Badges in the top-right corner" do
    attr :variant, :string, doc: "Color variant: default, success, warning, destructive, primary"
    attr :direction, :string, doc: "Stack direction: horizontal (default) or vertical"
  end

  slot :bottom_left, doc: "Badges in the bottom-left corner" do
    attr :variant, :string, doc: "Color variant: default, success, warning, destructive, primary"
    attr :direction, :string, doc: "Stack direction: horizontal (default) or vertical"
  end

  slot :bottom_right, doc: "Badges in the bottom-right corner" do
    attr :variant, :string, doc: "Color variant: default, success, warning, destructive, primary"
    attr :direction, :string, doc: "Stack direction: horizontal (default) or vertical"
  end

  @spec card_badge(map()) :: Rendered.t()
  def card_badge(assigns) do
    ~H"""
    <.card_badge_corner
      :if={@top_left != []}
      corner={:top_left}
      badges={@top_left}
    />
    <.card_badge_corner
      :if={@top_right != []}
      corner={:top_right}
      badges={@top_right}
    />
    <.card_badge_corner
      :if={@bottom_left != []}
      corner={:bottom_left}
      badges={@bottom_left}
    />
    <.card_badge_corner
      :if={@bottom_right != []}
      corner={:bottom_right}
      badges={@bottom_right}
    />
    """
  end

  # Renders a group of badges in a specific corner
  attr :corner, :atom, required: true
  attr :badges, :list, required: true

  defp card_badge_corner(assigns) do
    direction = get_badge_direction(assigns.badges)
    badges = prepare_badges(assigns.badges, assigns.corner, direction)

    assigns =
      assigns
      |> assign(:direction, direction)
      |> assign(:prepared_badges, badges)

    ~H"""
    <div
      data-slot={"card-badge-#{corner_to_slug(@corner)}"}
      class={[
        "absolute z-10 flex",
        corner_position_class(@corner),
        if(@direction == "vertical", do: "flex-col", else: "flex-row")
      ]}
    >
      <div
        :for={badge <- @prepared_badges}
        class={[
          "px-2 py-1 text-xs font-medium flex items-center gap-1",
          badge.variant_class,
          badge.border_class,
          badge.radius_class
        ]}
      >
        {render_slot(badge.slot)}
      </div>
    </div>
    """
  end

  # Get direction from first badge (all badges in a corner share the same direction)
  defp get_badge_direction([first | _]), do: Map.get(first, :direction, "horizontal")
  defp get_badge_direction([]), do: "horizontal"

  # Prepare badges with computed classes for borders and radius
  defp prepare_badges(badges, corner, direction) do
    total = length(badges)

    badges
    |> Enum.with_index()
    |> Enum.map(fn {badge, index} ->
      is_first = index == 0
      is_last = index == total - 1

      %{
        slot: badge,
        variant_class: badge_variant_class(Map.get(badge, :variant, "default")),
        border_class: badge_border_class(corner, direction, is_first, is_last, total),
        radius_class: badge_radius_class(corner, direction, is_first, is_last, total)
      }
    end)
  end

  # Position classes for each corner
  defp corner_position_class(:top_left), do: "top-0 left-0"
  defp corner_position_class(:top_right), do: "top-0 right-0"
  defp corner_position_class(:bottom_left), do: "bottom-0 left-0"
  defp corner_position_class(:bottom_right), do: "bottom-0 right-0"

  # Convert corner atom to hyphenated slug for data attributes
  # (Tailwind converts underscores to spaces, so we use hyphens)
  defp corner_to_slug(:top_left), do: "top-left"
  defp corner_to_slug(:top_right), do: "top-right"
  defp corner_to_slug(:bottom_left), do: "bottom-left"
  defp corner_to_slug(:bottom_right), do: "bottom-right"

  # Variant color classes
  defp badge_variant_class("success"), do: "bg-success/70 text-success-foreground"
  defp badge_variant_class("warning"), do: "bg-warning/70 text-warning-foreground"
  defp badge_variant_class("destructive"), do: "bg-destructive text-destructive-foreground"
  defp badge_variant_class("primary"), do: "bg-primary text-primary-foreground"
  defp badge_variant_class(_default), do: "bg-muted text-muted-foreground"

  # Border classes based on corner, direction, and position
  # The outer badge (first) gets the full border, inner badges only get connecting borders
  defp badge_border_class(corner, direction, is_first, is_last, total)

  # Single badge - gets all inner borders
  defp badge_border_class(:top_left, _dir, true, true, 1), do: "border-r border-b border-border"
  defp badge_border_class(:top_right, _dir, true, true, 1), do: "border-l border-b border-border"
  defp badge_border_class(:bottom_left, _dir, true, true, 1), do: "border-r border-t border-border"
  defp badge_border_class(:bottom_right, _dir, true, true, 1), do: "border-l border-t border-border"

  # Multiple badges - horizontal
  defp badge_border_class(:top_left, "horizontal", true, false, _), do: "border-r border-b border-border"
  defp badge_border_class(:top_left, "horizontal", false, true, _), do: "border-b border-border"
  defp badge_border_class(:top_left, "horizontal", false, false, _), do: "border-r border-b border-border"

  defp badge_border_class(:top_right, "horizontal", true, false, _), do: "border-b border-border"
  defp badge_border_class(:top_right, "horizontal", false, true, _), do: "border-l border-b border-border"
  defp badge_border_class(:top_right, "horizontal", false, false, _), do: "border-b border-border"

  defp badge_border_class(:bottom_left, "horizontal", true, false, _), do: "border-r border-t border-border"
  defp badge_border_class(:bottom_left, "horizontal", false, true, _), do: "border-t border-border"
  defp badge_border_class(:bottom_left, "horizontal", false, false, _), do: "border-r border-t border-border"

  defp badge_border_class(:bottom_right, "horizontal", true, false, _), do: "border-t border-border"
  defp badge_border_class(:bottom_right, "horizontal", false, true, _), do: "border-l border-t border-border"
  defp badge_border_class(:bottom_right, "horizontal", false, false, _), do: "border-t border-border"

  # Multiple badges - vertical
  defp badge_border_class(:top_left, "vertical", true, false, _), do: "border-r border-b border-border"
  defp badge_border_class(:top_left, "vertical", false, true, _), do: "border-r border-border"
  defp badge_border_class(:top_left, "vertical", false, false, _), do: "border-r border-b border-border"

  defp badge_border_class(:top_right, "vertical", true, false, _), do: "border-l border-b border-border"
  defp badge_border_class(:top_right, "vertical", false, true, _), do: "border-l border-border"
  defp badge_border_class(:top_right, "vertical", false, false, _), do: "border-l border-b border-border"

  defp badge_border_class(:bottom_left, "vertical", true, false, _), do: "border-r border-border"
  defp badge_border_class(:bottom_left, "vertical", false, true, _), do: "border-r border-t border-border"
  defp badge_border_class(:bottom_left, "vertical", false, false, _), do: "border-r border-border"

  defp badge_border_class(:bottom_right, "vertical", true, false, _), do: "border-l border-border"
  defp badge_border_class(:bottom_right, "vertical", false, true, _), do: "border-l border-t border-border"
  defp badge_border_class(:bottom_right, "vertical", false, false, _), do: "border-l border-border"

  # Corner radius classes for badges
  # - Inner radius: the corner pointing into the card (rounded-br-lg for top-left, etc.)
  # - Outer radius: the corner at the card edge, matching card's rounded-xl
  defp badge_radius_class(corner, direction, is_first, is_last, total)

  # Single badge - gets both inner corner radius AND outer corner to match card
  defp badge_radius_class(:top_left, _dir, true, true, 1), do: "rounded-tl-xl rounded-br-lg"
  defp badge_radius_class(:top_right, _dir, true, true, 1), do: "rounded-tr-xl rounded-bl-lg"
  defp badge_radius_class(:bottom_left, _dir, true, true, 1), do: "rounded-bl-xl rounded-tr-lg"
  defp badge_radius_class(:bottom_right, _dir, true, true, 1), do: "rounded-br-xl rounded-tl-lg"

  # Multiple badges - horizontal
  # Left corners: first badge is AT corner, last is away
  # Right corners: first badge is AWAY from corner, last is at corner
  defp badge_radius_class(:top_left, "horizontal", true, false, _), do: "rounded-tl-xl"
  defp badge_radius_class(:top_left, "horizontal", false, true, _), do: "rounded-br-lg"
  defp badge_radius_class(:top_right, "horizontal", true, false, _), do: "rounded-bl-lg"
  defp badge_radius_class(:top_right, "horizontal", false, true, _), do: "rounded-tr-xl"
  defp badge_radius_class(:bottom_left, "horizontal", true, false, _), do: "rounded-bl-xl"
  defp badge_radius_class(:bottom_left, "horizontal", false, true, _), do: "rounded-tr-lg"
  defp badge_radius_class(:bottom_right, "horizontal", true, false, _), do: "rounded-tl-lg"
  defp badge_radius_class(:bottom_right, "horizontal", false, true, _), do: "rounded-br-xl"

  # Multiple badges - vertical
  # First badge (at corner for top, away for bottom) and last badge logic
  defp badge_radius_class(:top_left, "vertical", true, false, _), do: "rounded-tl-xl"
  defp badge_radius_class(:top_left, "vertical", false, true, _), do: "rounded-br-lg"
  defp badge_radius_class(:top_right, "vertical", true, false, _), do: "rounded-tr-xl"
  defp badge_radius_class(:top_right, "vertical", false, true, _), do: "rounded-bl-lg"
  defp badge_radius_class(:bottom_left, "vertical", true, false, _), do: "rounded-tr-lg"
  defp badge_radius_class(:bottom_left, "vertical", false, true, _), do: "rounded-bl-xl"
  defp badge_radius_class(:bottom_right, "vertical", true, false, _), do: "rounded-tl-lg"
  defp badge_radius_class(:bottom_right, "vertical", false, true, _), do: "rounded-br-xl"

  # Default - no radius (middle badges in a stack of 3+)
  defp badge_radius_class(_corner, _direction, _is_first, _is_last, _total), do: ""

  @doc """
  Renders a status bar at the bottom of a card.

  Provides a visually distinct footer area with muted background and border,
  supporting left, center, right, and actions slots for flexible layouts.

  ## Examples

      <%!-- Simple left/right layout --%>
      <.card>
        <.card_content>...</.card_content>
        <.card_status>
          <:left>
            <.icon name="hero-map-pin" class="size-3.5" />
            <span>Corner Pocket</span>
          </:left>
          <:right>12 hours ago</:right>
        </.card_status>
      </.card>

      <%!-- With actions --%>
      <.card>
        <.card_content>...</.card_content>
        <.card_status>
          <:actions>
            <.button variant="ghost" size="icon-xs">
              <.icon name="hero-paper-airplane" class="size-4" />
            </.button>
          </:actions>
          <:left>Location info</:left>
          <:right>Timestamp</:right>
        </.card_status>
      </.card>

      <%!-- With center content --%>
      <.card>
        <.card_content>...</.card_content>
        <.card_status>
          <:left>Start</:left>
          <:center>Middle</:center>
          <:right>End</:right>
        </.card_status>
      </.card>

  """
  attr :class, :string, default: nil
  attr :rest, :global

  slot :actions, doc: "Action buttons on the left side, separated with a border"
  slot :left, doc: "Content aligned to the left"
  slot :center, doc: "Content centered in the status bar"
  slot :right, doc: "Content aligned to the right"

  @spec card_status(map()) :: Rendered.t()
  def card_status(assigns) do
    ~H"""
    <div
      data-slot="card-status"
      class={[
        "flex w-full px-4 py-2 min-h-11 bg-muted/50 border-t border-border",
        "text-sm text-muted-foreground items-center gap-3",
        "rounded-b-xl mt-auto",
        @class
      ]}
      {@rest}
    >
      <%!-- Left section: actions + left content --%>
      <div class="flex items-center gap-3 flex-1 min-w-0">
        <div
          :if={@actions != []}
          class={[
            "flex items-center gap-1",
            @left != [] && "pr-3 border-r border-border"
          ]}
        >
          {render_slot(@actions)}
        </div>
        <div :if={@left != []} class="flex items-center gap-2 min-w-0">
          {render_slot(@left)}
        </div>
      </div>

      <%!-- Center section --%>
      <div :if={@center != []} class="flex items-center justify-center gap-2">
        {render_slot(@center)}
      </div>

      <%!-- Right section --%>
      <div :if={@right != []} class="flex items-center justify-end gap-2 flex-1 min-w-0">
        {render_slot(@right)}
      </div>
    </div>
    """
  end

  @doc """
  Renders an avatar container.

  An image element with a fallback for representing the user.
  Use with avatar_image and avatar_fallback sub-components.

  ## Examples

      <.avatar aria_label="John Doe">
        <.avatar_image src="https://github.com/shadcn.png" alt="@shadcn" />
        <.avatar_fallback>CN</.avatar_fallback>
      </.avatar>

      <%!-- Square avatar with rounded corners --%>
      <.avatar class="rounded-lg" aria_label="Emily Roberts">
        <.avatar_image src="..." alt="..." />
        <.avatar_fallback>ER</.avatar_fallback>
      </.avatar>

  """
  attr(:aria_label, :string, default: nil, doc: "Accessible label for screen readers")
  attr(:size, :string, default: "default", doc: "Size variant: sm, default, lg, full")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec avatar(map()) :: Rendered.t()
  def avatar(assigns) do
    ~H"""
    <.flex
      data-slot="avatar"
      aria-label={@aria_label}
      class={[
        "relative shrink-0 overflow-hidden rounded-full",
        avatar_size_class(@size),
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.flex>
    """
  end

  defp avatar_size_class("sm"), do: "size-6"
  defp avatar_size_class("lg"), do: "size-12"
  defp avatar_size_class("full"), do: "h-full aspect-square"
  defp avatar_size_class(_), do: "size-8"

  @doc """
  Renders an avatar image.

  Displays the user's profile image. If the image fails to load or `src` is nil,
  the avatar_fallback will be shown instead.

  ## Attributes

  - `src` - Image URL. If nil or empty, the image is not rendered.
  - `alt` - Alternative text for accessibility.
  """
  attr(:src, :string, default: nil)
  attr(:alt, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  @spec avatar_image(map()) :: Rendered.t()
  def avatar_image(assigns) do
    ~H"""
    <img
      :if={@src}
      data-slot="avatar-image"
      src={@src}
      alt={@alt}
      class={["aspect-square size-full relative z-10", @class]}
      {@rest}
    />
    """
  end

  @doc """
  Renders an avatar fallback.

  Displays fallback content (typically initials) when the avatar image
  fails to load or is not available.

  ## Examples

      <.avatar_fallback>JD</.avatar_fallback>
      <.avatar_fallback class="bg-primary text-primary-foreground">AB</.avatar_fallback>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec avatar_fallback(map()) :: Rendered.t()
  def avatar_fallback(assigns) do
    ~H"""
    <.flex
      data-slot="avatar-fallback"
      justify="center"
      class={[
        "bg-muted size-full rounded-[inherit]",
        "absolute inset-0 z-0",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.flex>
    """
  end

  @doc """
  Renders a responsive table container.

  A flexible table component for displaying tabular data with semantic HTML structure.
  Use with table_* sub-components for consistent styling and accessibility.

  By default, tables are horizontally scrollable when content overflows.

  ## Examples

      <.table>
        <.table_caption>A list of your recent invoices.</.table_caption>
        <.table_header>
          <.table_row>
            <.table_head>Invoice</.table_head>
            <.table_head>Status</.table_head>
            <.table_head>Amount</.table_head>
          </.table_row>
        </.table_header>
        <.table_body>
          <.table_row>
            <.table_cell>INV001</.table_cell>
            <.table_cell>Paid</.table_cell>
            <.table_cell>$250.00</.table_cell>
          </.table_row>
        </.table_body>
      </.table>

      <%!-- Striped table for better readability --%>
      <.table striped>
        ...
      </.table>

      <%!-- Disable horizontal scrolling if needed --%>
      <.table x_overflow={false}>
        ...
      </.table>

  """
  attr(:class, :string, default: nil)

  attr(:container_class, :string,
    default: nil,
    doc: "Additional classes for the table container wrapper"
  )

  attr(:striped, :boolean, default: false)

  attr(:x_overflow, :boolean,
    default: true,
    doc: "Enable horizontal scrolling when table overflows (default: true)"
  )

  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec table(map()) :: Rendered.t()
  def table(assigns) do
    ~H"""
    <div
      data-slot="table-container"
      class={[
        "relative w-full",
        if(@x_overflow, do: "overflow-x-auto", else: nil),
        @container_class
      ]}
    >
      <table
        data-slot="table"
        data-striped={if @striped, do: "true", else: "false"}
        class={["w-full caption-bottom text-sm text-foreground", @class]}
        {@rest}
      >
        {render_slot(@inner_block)}
      </table>
    </div>
    """
  end

  @doc """
  Renders a table header section.

  Contains the header rows with column titles.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec table_header(map()) :: Rendered.t()
  def table_header(assigns) do
    ~H"""
    <thead data-slot="table-header" class={["[&_tr]:border-b", @class]} {@rest}>
      {render_slot(@inner_block)}
    </thead>
    """
  end

  @doc """
  Renders a table body section.

  Contains the main data rows of the table.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec table_body(map()) :: Rendered.t()
  def table_body(assigns) do
    ~H"""
    <tbody data-slot="table-body" class={["[&_tr:last-child]:border-0", @class]} {@rest}>
      {render_slot(@inner_block)}
    </tbody>
    """
  end

  @doc """
  Renders a table footer section.

  Typically used for summary rows or totals.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec table_footer(map()) :: Rendered.t()
  def table_footer(assigns) do
    ~H"""
    <tfoot
      data-slot="table-footer"
      class={["bg-muted/50 border-t font-bold [&>tr]:last:border-b-0", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </tfoot>
    """
  end

  @doc """
  Renders a table row.

  Contains table cells (table_head or table_cell).
  Supports hover effects and selected state.
  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec table_row(map()) :: Rendered.t()
  def table_row(assigns) do
    ~H"""
    <tr
      data-slot="table-row"
      class={[
        "hover:bg-muted/50 data-[state=selected]:bg-muted border-b transition-colors",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </tr>
    """
  end

  @doc """
  Renders a table header cell.

  Used within table_header rows to define column titles.

  ## Examples

      <.table_head>Name</.table_head>
      <.table_head class="text-right">Amount</.table_head>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec table_head(map()) :: Rendered.t()
  def table_head(assigns) do
    ~H"""
    <th
      data-slot="table-head"
      class={[
        "h-10 px-2 text-left align-middle font-bold whitespace-nowrap [&:has([role=checkbox])]:pr-0 [&>[role=checkbox]]:translate-y-[2px]",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </th>
    """
  end

  @doc """
  Renders a table data cell.

  Used within table_body rows to display data.

  ## Examples

      <.table_cell>John Doe</.table_cell>
      <.table_cell class="text-right">$100.00</.table_cell>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(colspan rowspan))
  slot(:inner_block, required: true)

  @spec table_cell(map()) :: Rendered.t()
  def table_cell(assigns) do
    ~H"""
    <td
      data-slot="table-cell"
      class={[
        "p-2 align-middle whitespace-nowrap [&:has([role=checkbox])]:pr-0 [&>[role=checkbox]]:translate-y-[2px]",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </td>
    """
  end

  @doc """
  Renders a table caption.

  Provides a descriptive caption for the table, typically displayed below the table.

  ## Examples

      <.table_caption>A list of your recent invoices.</.table_caption>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec table_caption(map()) :: Rendered.t()
  def table_caption(assigns) do
    ~H"""
    <caption data-slot="table-caption" class={["text-muted-foreground mt-4 text-sm", @class]} {@rest}>
      {render_slot(@inner_block)}
    </caption>
    """
  end

  @doc """
  Renders markdown content with syntax highlighting, diagrams, and math support.

  A markdown viewer component powered by marked.js with support for:
  - GitHub Flavored Markdown (GFM)
  - Syntax highlighting via highlight.js
  - Mermaid diagrams (` ```mermaid ` code blocks)
  - MathJax equations ($...$ inline, $$...$$ display)

  ## Examples

      <%!-- Basic markdown rendering --%>
      <.markdown id="readme" content={@readme_content} />

      <%!-- Markdown in a card --%>
      <.card>
        <.card_header>
          <.card_title>Documentation</.card_title>
        </.card_header>
        <.card_content>
          <.markdown id="docs" content={@doc_content} />
        </.card_content>
      </.card>

      <%!-- With custom styling --%>
      <.markdown
        id="article"
        content={@article}
        class="prose-lg"
      />

      <%!-- Compact variant for tighter spacing --%>
      <.markdown id="notes" content={@notes} variant="compact" />

  ## Markdown Features

  The component supports the following markdown features:

  ### Code Blocks with Syntax Highlighting

      ```elixir
      defmodule Example do
        def hello, do: "world"
      end
      ```

  ### Mermaid Diagrams

      ```mermaid
      graph TD
        A[Start] --> B[Process]
        B --> C[End]
      ```

  ### Math Equations

      Inline math: $E = mc^2$

      Display math:
      $$
      \\int_0^\\infty e^{-x^2} dx = \\frac{\\sqrt{\\pi}}{2}
      $$

  ## Styling

  The component uses Tailwind Typography (`prose`) classes for consistent styling.
  It automatically adapts to light/dark themes via the `dark:prose-invert` class.

  You can customize the appearance by:
  - Using the `variant` attribute for predefined styles
  - Adding custom classes via the `class` attribute
  - The prose styles can be extended with `prose-lg`, `prose-sm`, etc.

  """
  attr(:id, :string, required: true, doc: "Unique identifier for the markdown container")
  attr(:content, :string, required: true, doc: "Raw markdown content to render")

  attr(:variant, :string,
    default: "default",
    values: ~w(default compact),
    doc: "Style variant: default (normal spacing) or compact (tighter spacing)"
  )

  attr(:class, :string, default: nil, doc: "Additional CSS classes")
  attr(:rest, :global)

  @spec markdown(map()) :: Rendered.t()
  def markdown(assigns) do
    ~H"""
    <div
      id={@id}
      data-slot="markdown"
      phx-hook="MarkdownRenderer"
      phx-update="ignore"
      data-markdown={@content}
      class={[
        "prose dark:prose-invert max-w-none",
        @variant == "compact" && "prose-compact",
        @class
      ]}
      {@rest}
    >
      <p class="text-muted-foreground">Loading...</p>
    </div>
    """
  end

  @doc """
  Renders a Chart.js chart.

  A responsive chart component powered by Chart.js. Supports all Chart.js chart types
  including bar, line, pie, doughnut, radar, and polar area charts.

  The component automatically applies theme colors for a consistent look with your design system.

  ## Configuration

  The `config` attribute should be a map that follows the Chart.js configuration structure:

  - `type` - The chart type (e.g., "bar", "line", "pie", "doughnut", "radar", "polarArea")
  - `data` - Chart data including labels and datasets
  - `options` - Chart.js options for customization (optional)

  ## Examples

      <%!-- Simple bar chart --%>
      <.chart
        id="sales-chart"
        config={%{
          type: "bar",
          data: %{
            labels: ["Jan", "Feb", "Mar", "Apr", "May"],
            datasets: [%{
              label: "Sales",
              data: [12, 19, 3, 5, 2],
              backgroundColor: "rgb(59, 130, 246)"
            }]
          },
          options: %{
            responsive: true,
            maintainAspectRatio: false
          }
        }}
      />

      <%!-- Line chart with multiple datasets --%>
      <.chart
        id="revenue-chart"
        config={%{
          type: "line",
          data: %{
            labels: ["Jan", "Feb", "Mar"],
            datasets: [
              %{
                label: "Revenue",
                data: [30, 45, 38],
                borderColor: "rgb(59, 130, 246)",
                tension: 0.1
              },
              %{
                label: "Expenses",
                data: [20, 25, 22],
                borderColor: "rgb(239, 68, 68)",
                tension: 0.1
              }
            ]
          }
        }}
      />

      <%!-- Pie chart --%>
      <.chart
        id="distribution-chart"
        config={%{
          type: "pie",
          data: %{
            labels: ["Red", "Blue", "Yellow"],
            datasets: [%{
              data: [300, 50, 100],
              backgroundColor: [
                "rgb(239, 68, 68)",
                "rgb(59, 130, 246)",
                "rgb(234, 179, 8)"
              ]
            }]
          }
        }}
      />

      <%!-- Chart in a card with custom height --%>
      <.card>
        <.card_header>
          <.card_title>Sales Overview</.card_title>
          <.card_description>Monthly sales data</.card_description>
        </.card_header>
        <.card_content>
          <.chart id="card-chart" class="h-[300px]" config={@chart_config} />
        </.card_content>
      </.card>

  ## Dynamic Updates

  You can update the chart data from your LiveView by:

  1. Reassigning the config and letting LiveView handle the update automatically
  2. Using the `chart-update` push event for more control

  ### Method 1: Automatic update via assign

      # In your LiveView
      def handle_event("refresh", _params, socket) do
        new_config = %{
          type: "bar",
          data: %{
            labels: ["Jan", "Feb", "Mar"],
            datasets: [%{
              label: "Updated",
              data: [10, 20, 30]
            }]
          }
        }

        {:noreply, assign(socket, chart_config: new_config)}
      end

  ### Method 2: Push event (advanced)

      # In your LiveView
      def handle_event("refresh", _params, socket) do
        new_config = %{...}

        {:noreply, push_event(socket, "chart-update", new_config)}
      end

  ## Styling

  The chart automatically inherits theme colors for text, borders, and tooltips.
  You can customize the appearance by:

  - Setting the `class` attribute (e.g., `class="h-[400px]"` for height)
  - Providing custom colors in the dataset configuration
  - Using Chart.js options for advanced customization

  ## Notes

  - Always provide a unique `id` for each chart
  - Set `maintainAspectRatio: false` in options and use a height class for better control
  - The canvas uses `phx-update="ignore"` to prevent LiveView from re-rendering the chart
  - Charts automatically respond to theme changes (light/dark mode)

  """
  attr(:id, :string, required: true, doc: "Unique identifier for the chart")
  attr(:config, :map, required: true, doc: "Chart.js configuration map")
  attr(:class, :string, default: nil, doc: "Additional CSS classes for the canvas container")
  attr(:rest, :global)

  @spec chart(map()) :: Rendered.t()
  def chart(assigns) do
    # Encode the config as JSON for the JavaScript hook
    assigns = assign(assigns, :config_json, Jason.encode!(assigns.config))

    ~H"""
    <div class={["relative w-full h-full", @class]} {@rest}>
      <canvas
        id={@id}
        phx-hook="Chart"
        phx-update="ignore"
        data-chart-config={@config_json}
      >
      </canvas>
    </div>
    """
  end
end
