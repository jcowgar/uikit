defmodule UiKit.Components.Ui.FeedbackStatus do
  @moduledoc """
  Feedback & Status components for conveying system state.

  Components ported from shadcn/ui.
  """
  use Phoenix.Component

  import UiKit.Components.CoreComponents, only: [icon: 1]
  import UiKit.Components.Ui.FormInput, only: [close_button: 1]

  alias Phoenix.LiveView.JS
  alias Phoenix.LiveView.Rendered

  @doc """
  Renders a badge component.

  Badges are small status indicators used to highlight information or categorize content.

  ## Variants

  - `default` - Standard badge with primary styling
  - `secondary` - Alternative styling with reduced emphasis
  - `destructive` - For error or warning states
  - `outline` - Border-based variant without fill

  ## Examples

      <.badge>Default</.badge>
      <.badge variant="secondary">Secondary</.badge>
      <.badge variant="destructive">Error</.badge>
      <.badge variant="outline">Outline</.badge>

      <%!-- With icon --%>
      <.badge>
        <.icon name="hero-check" />
        Success
      </.badge>

      <%!-- As a link --%>
      <.badge>
        <.link navigate={~p"/path"}>Link Badge</.link>
      </.badge>

  """
  attr(:variant, :string,
    default: "default",
    values:
      ~w(default secondary destructive success info warning info-subtle success-subtle warning-subtle destructive-subtle outline)
  )

  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec badge(map()) :: Rendered.t()
  def badge(assigns) do
    ~H"""
    <span
      class={
        [
          # Base styles
          "inline-flex items-center justify-center rounded-md border px-2 py-0.5",
          "text-xs font-medium w-fit whitespace-nowrap shrink-0",
          "[&>svg]:size-3 gap-1 [&>svg]:pointer-events-none",
          "focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]",
          "transition-[color,box-shadow] overflow-hidden",
          # Variant styles
          badge_variant(@variant),
          # Custom classes
          @class
        ]
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end

  defp badge_variant("default"),
    do:
      "border-transparent bg-primary text-primary-foreground hover:bg-primary/90 [a_&]:hover:bg-primary/90"

  defp badge_variant("secondary"),
    do:
      "border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/90 [a_&]:hover:bg-secondary/90"

  defp badge_variant("destructive"),
    do:
      "border-transparent bg-destructive text-white hover:bg-destructive/90 [a_&]:hover:bg-destructive/90 focus-visible:ring-destructive/20 dark:focus-visible:ring-destructive/40 dark:bg-destructive/60"

  defp badge_variant("success"),
    do: "border-transparent bg-success text-white hover:bg-success/90 [a_&]:hover:bg-success/90"

  defp badge_variant("info"),
    do: "border-transparent bg-info text-white hover:bg-info/90 [a_&]:hover:bg-info/90"

  defp badge_variant("warning"),
    do: "border-transparent bg-warning text-white hover:bg-warning/90 [a_&]:hover:bg-warning/90"

  # Subtle variants with light backgrounds
  defp badge_variant("info-subtle"),
    do: "border-transparent bg-info/10 text-info hover:bg-info/20 [a_&]:hover:bg-info/20"

  defp badge_variant("success-subtle"),
    do:
      "border-transparent bg-success/10 text-success hover:bg-success/20 [a_&]:hover:bg-success/20"

  defp badge_variant("warning-subtle"),
    do:
      "border-transparent bg-warning/10 text-warning hover:bg-warning/20 [a_&]:hover:bg-warning/20"

  defp badge_variant("destructive-subtle"),
    do:
      "border-transparent bg-destructive/10 text-destructive hover:bg-destructive/20 [a_&]:hover:bg-destructive/20"

  defp badge_variant("outline"),
    do: "text-foreground hover:bg-accent hover:text-accent-foreground [a_&]:hover:bg-accent"

  @doc """
  Renders an alert component for displaying important messages to users.

  Alerts are used to communicate system messages, feedback, or contextual information
  with appropriate visual emphasis through variants and optional icons.

  ## Variants

  - `default` - Standard neutral alert
  - `info` - Informational messages (blue/info color scheme)
  - `warning` - Warning messages (yellow/warning color scheme)
  - `destructive` - Error or critical messages (red/destructive color scheme)
  - `success` - Success confirmations (green/success color scheme)

  ## Features

  - Icon support with automatic grid layout
  - Composable with alert_title and alert_description
  - Semantic color tokens for theme support
  - Proper accessibility with role="alert"
  - Flexible content with nested elements

  ## Examples

      # Basic alert
      <.alert>
        <.alert_title>Heads up!</.alert_title>
        <.alert_description>
          You can add components to your app using the cli.
        </.alert_description>
      </.alert>

      # With icon
      <.alert variant="info">
        <.icon name="hero-information-circle" />
        <.alert_title>Did you know?</.alert_title>
        <.alert_description>
          You can switch between light and dark themes.
        </.alert_description>
      </.alert>

      # Error alert
      <.alert variant="destructive">
        <.icon name="hero-exclamation-circle" />
        <.alert_title>Error</.alert_title>
        <.alert_description>
          Your session has expired. Please log in again.
        </.alert_description>
      </.alert>

      # Success alert
      <.alert variant="success">
        <.icon name="hero-check-circle" />
        <.alert_title>Success!</.alert_title>
        <.alert_description>
          Your changes have been saved.
        </.alert_description>
      </.alert>

      # Title only (no description)
      <.alert variant="warning">
        <.icon name="hero-exclamation-triangle" />
        <.alert_title>Maintenance scheduled for tonight</.alert_title>
      </.alert>

  """
  attr(:variant, :string,
    default: "default",
    values: ~w(default info warning destructive success)
  )

  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(id))
  slot(:inner_block, required: true)

  @spec alert(map()) :: Rendered.t()
  def alert(assigns) do
    ~H"""
    <div
      data-slot="alert"
      role="alert"
      class={
        [
          # Base styles
          "relative w-full rounded-lg border px-4 py-3 text-sm",
          # Grid layout for icon support (targets span.hero-* icons)
          "grid has-[>span[class*='hero-']]:grid-cols-[calc(var(--spacing)*4)_1fr] grid-cols-[0_1fr] has-[>span[class*='hero-']]:gap-x-3 gap-y-0.5 items-start",
          # Icon styling - explicit column placement for heroicons (span elements)
          "[&>span[class*='hero-']]:col-start-1 [&>span[class*='hero-']]:size-4 [&>span[class*='hero-']]:translate-y-0.5 [&>span[class*='hero-']]:text-current",
          # Variant styles
          alert_variant(@variant),
          # Custom classes
          @class
        ]
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  defp alert_variant("default"), do: "bg-card text-card-foreground border-border"

  defp alert_variant("info"),
    do:
      "bg-info/10 text-foreground border-info/20 [&>svg]:text-info dark:bg-info/20 dark:border-info/30"

  defp alert_variant("warning"),
    do:
      "bg-warning/10 text-foreground border-warning/20 [&>svg]:text-warning dark:bg-warning/20 dark:border-warning/30"

  defp alert_variant("destructive"),
    do:
      "bg-destructive/10 text-foreground border-destructive/20 [&>svg]:text-destructive dark:bg-destructive/20 dark:border-destructive/30"

  defp alert_variant("success"),
    do:
      "bg-success/10 text-foreground border-success/20 [&>svg]:text-success dark:bg-success/20 dark:border-success/30"

  @doc """
  Renders the title for an alert.

  The alert title provides a brief heading for the alert message. It uses medium
  font weight and proper grid positioning when used with icons.

  ## Examples

      <.alert>
        <.alert_title>Important Notice</.alert_title>
        <.alert_description>Details here</.alert_description>
      </.alert>

      # With icon - title automatically positions in grid
      <.alert variant="info">
        <.icon name="hero-information-circle" />
        <.alert_title>New Feature Available</.alert_title>
        <.alert_description>Check out what's new</.alert_description>
      </.alert>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec alert_title(map()) :: Rendered.t()
  def alert_title(assigns) do
    ~H"""
    <div
      data-slot="alert-title"
      class={[
        "col-start-2 line-clamp-1 min-h-4 font-medium tracking-tight",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders the description content for an alert.

  The alert description provides detailed information or context for the alert.
  It uses muted foreground color and supports rich content including paragraphs,
  lists, and other nested elements.

  ## Examples

      <.alert>
        <.alert_title>Update Available</.alert_title>
        <.alert_description>
          A new version is available. Update now to get the latest features.
        </.alert_description>
      </.alert>

      # With rich content
      <.alert variant="info">
        <.alert_title>Getting Started</.alert_title>
        <.alert_description>
          <p>Follow these steps:</p>
          <ul>
            <li>Create an account</li>
            <li>Verify your email</li>
            <li>Complete your profile</li>
          </ul>
        </.alert_description>
      </.alert>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec alert_description(map()) :: Rendered.t()
  def alert_description(assigns) do
    ~H"""
    <div
      data-slot="alert-description"
      class={[
        "text-muted-foreground col-start-2 grid justify-items-start gap-1 text-sm [&_p]:leading-relaxed",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a Sonner-style toast notification container that displays flash messages.

  The Sonner component provides non-intrusive notifications that appear temporarily
  to communicate actions, confirmations, or updates. It integrates with Phoenix
  LiveView's flash message system and automatically dismisses after a timeout.

  This component is ported from shadcn/ui's Sonner component but adapted for Phoenix
  LiveView's flash system. It should be placed in your root layout to display
  flash messages as toast notifications.

  ## Toast Types

  Toast messages are determined by the flash key:
  - `info` - Informational messages (blue/info color scheme)
  - `success` - Success confirmations (green/success color scheme)
  - `warning` - Warning messages (yellow/warning color scheme)
  - `error` - Error or critical messages (red/destructive color scheme)

  ## Features

  - Automatic icon display based on toast type
  - Auto-dismiss after 5 seconds (configurable)
  - Manual dismiss via close button
  - Smooth slide-in/slide-out animations
  - Stacks multiple toasts vertically
  - Integrates with Phoenix flash messages
  - Theme-aware colors using semantic tokens

  ## Usage in Layout

  Add to your root layout (typically `lib/decree_web/components/layouts/root.html.heex`):

      <.sonner flash={@flash} />

  ## Triggering Toasts in LiveView

      # Success toast
      {:noreply, put_flash(socket, :success, "Profile updated successfully")}

      # Error toast
      {:noreply, put_flash(socket, :error, "Unable to save changes")}

      # Info toast
      {:noreply, put_flash(socket, :info, "New features available")}

      # Warning toast
      {:noreply, put_flash(socket, :warning, "Session expiring soon")}

  ## Accessibility

  - Uses `role="status"` for non-critical messages
  - Uses `role="alert"` for errors
  - Screen reader announcements via `aria-live`
  - Keyboard accessible close button

  """
  attr(:flash, :map, required: true, doc: "Phoenix flash messages map")
  attr(:duration, :integer, default: 5000, doc: "Auto-dismiss duration in milliseconds")
  attr(:class, :string, default: nil)

  @spec sonner(map()) :: Rendered.t()
  def sonner(assigns) do
    # Convert flash to list of {kind, msg} tuples, filtering for toast types
    # Phoenix.LiveView.Flash is enumerable, so we can work with it directly
    flash_list =
      [:info, :success, :warning, :error]
      |> Enum.map(fn kind ->
        case Phoenix.Flash.get(assigns.flash, kind) do
          nil -> nil
          msg -> {kind, msg}
        end
      end)
      |> Enum.reject(&is_nil/1)

    assigns = assign(assigns, :flash_list, flash_list)

    ~H"""
    <div
      id="sonner-container"
      class={[
        "fixed bottom-0 right-0 z-50 flex max-h-screen w-full flex-col-reverse gap-2 p-4 sm:bottom-0 sm:right-0 sm:top-auto sm:flex-col md:max-w-[420px]",
        @class
      ]}
      aria-live="polite"
    >
      <.sonner_toast
        :for={{kind, msg} <- @flash_list}
        id={"sonner-#{kind}"}
        kind={kind}
        duration={@duration}
      >
        {msg}
      </.sonner_toast>
    </div>
    """
  end

  @doc """
  Renders an individual Sonner toast notification.

  Typically used internally by `sonner/1`, but can be used standalone
  for custom toast implementations.

  ## Examples

      <.sonner_toast kind="success">Changes saved!</.sonner_toast>
      <.sonner_toast kind="error">An error occurred</.sonner_toast>
      <.sonner_toast kind="info" duration={3000}>Quick tip</.sonner_toast>

  """
  attr(:id, :string, required: true)
  attr(:kind, :atom, required: true, values: [:info, :success, :warning, :error])
  attr(:duration, :integer, default: 5000)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec sonner_toast(map()) :: Rendered.t()
  def sonner_toast(assigns) do
    ~H"""
    <div
      id={@id}
      data-slot="toast"
      role={if @kind == :error, do: "alert", else: "status"}
      phx-hook="SonnerToast"
      phx-mounted={show_toast(@id, @duration)}
      class={
        [
          # Base styles
          "group pointer-events-auto relative flex w-full items-center justify-between gap-3 rounded-lg border p-4 pr-10 shadow-lg transition-all",
          # Toast variant colors
          toast_variant(@kind),
          # Animation classes (controlled by JS)
          "data-[state=open]:animate-in data-[state=closed]:animate-out",
          "data-[state=closed]:fade-out-80 data-[state=open]:fade-in-0",
          "data-[state=closed]:slide-out-to-right-full data-[state=open]:slide-in-from-bottom-full",
          "sm:data-[state=closed]:slide-out-to-right-full sm:data-[state=open]:slide-in-from-bottom-full",
          # Custom classes
          @class
        ]
      }
      {@rest}
    >
      <%!-- Icon --%>
      <div class="flex shrink-0 items-center gap-3 min-w-0 flex-1">
        <.sonner_icon kind={@kind} class="shrink-0" />
        <div class="grid gap-1 text-sm font-medium min-w-0 break-words">
          {render_slot(@inner_block)}
        </div>
      </div>

      <%!-- Close button --%>
      <.close_button phx-click={hide_sonner(@id)} class="absolute right-2 top-2" />
    </div>
    """
  end

  # Renders the appropriate icon for a Sonner toast type
  @spec sonner_icon(map()) :: Rendered.t()
  defp sonner_icon(%{kind: :success} = assigns) do
    assigns = assign_new(assigns, :class, fn -> "" end)

    ~H"""
    <.icon name="hero-check-circle" class={"size-5 #{@class}"} />
    """
  end

  defp sonner_icon(%{kind: :error} = assigns) do
    assigns = assign_new(assigns, :class, fn -> "" end)

    ~H"""
    <.icon name="hero-x-circle" class={"size-5 #{@class}"} />
    """
  end

  defp sonner_icon(%{kind: :info} = assigns) do
    assigns = assign_new(assigns, :class, fn -> "" end)

    ~H"""
    <.icon name="hero-information-circle" class={"size-5 #{@class}"} />
    """
  end

  defp sonner_icon(%{kind: :warning} = assigns) do
    assigns = assign_new(assigns, :class, fn -> "" end)

    ~H"""
    <.icon name="hero-exclamation-triangle" class={"size-5 #{@class}"} />
    """
  end

  # Sonner toast variant colors - matching alert component pattern
  defp toast_variant(:info),
    do:
      "bg-info/90 text-info-foreground border-info/20 [&>div>span[class*='hero-']]:text-info-foreground dark:bg-info/90 dark:border-info/30"

  defp toast_variant(:success),
    do:
      "bg-success/90 text-success-foreground border-success/20 [&>div>span[class*='hero-']]:text-success-foreground dark:bg-success/90 dark:border-success/30"

  defp toast_variant(:warning),
    do:
      "bg-warning/90 text-warning-foreground border-warning/20 [&>div>span[class*='hero-']]:text-warning-foreground dark:bg-warning/90 dark:border-warning/30"

  defp toast_variant(:error),
    do:
      "bg-destructive/90 text-destructive-foreground border-destructive/20 [&>div>span[class*='hero-']]:text-destructive-foreground dark:bg-destructive/90 dark:border-destructive/30"

  # JS commands for showing/hiding Sonner toasts
  defp show_toast(id, duration) do
    %JS{}
    |> JS.set_attribute({"data-state", "open"}, to: "##{id}")
    |> JS.dispatch("sonner:auto-dismiss", to: "##{id}", detail: %{duration: duration})
  end

  defp hide_sonner(id) do
    %JS{}
    |> JS.set_attribute({"data-state", "closed"}, to: "##{id}")
    |> JS.hide(
      to: "##{id}",
      time: 300,
      transition: {"ease-in duration-300", "opacity-100", "opacity-0"}
    )
    |> JS.push("lv:clear-flash", value: %{key: String.replace(id, "sonner-", "")})
  end

  @doc """
  Renders a spinner component for loading states.

  The Spinner is a rotating loader icon that indicates content is being processed or loaded.
  It uses the Heroicons loader icon with an animation to provide visual feedback during
  asynchronous operations.

  ## Size Variations

  Control the size using Tailwind's `size-*` utilities via the `class` attribute:
  - `size-3` - Extra small (12px)
  - `size-4` - Small/default (16px)
  - `size-5` - Medium (20px)
  - `size-6` - Large (24px)
  - `size-8` - Extra large (32px)

  ## Color Variations

  Control the color using Tailwind's `text-*` utilities via the `class` attribute:
  - `text-primary` - Primary brand color
  - `text-muted-foreground` - Muted/subtle appearance
  - `text-destructive` - Error/warning states
  - Any other text color utility

  ## Examples

      # Default spinner
      <.spinner />

      # Large spinner
      <.spinner class="size-8" />

      # Colored spinner
      <.spinner class="text-primary" />

      # Custom size and color
      <.spinner class="size-10 text-success" />

      # In a button
      <.button disabled>
        <.spinner class="size-4" />
        Loading...
      </.button>

      # In a badge
      <.badge>
        <.spinner class="size-3" />
        Processing
      </.badge>

      # Centered in a container
      <div class="flex items-center justify-center h-screen">
        <.spinner class="size-8 text-primary" />
      </div>

  ## Accessibility

  The spinner includes proper accessibility attributes:
  - `role="status"` for screen reader compatibility
  - `aria-label="Loading"` to provide context
  - Screen readers will announce "Loading" when the spinner appears

  """
  attr(:class, :string,
    default: nil,
    doc: "Additional CSS classes for size and color customization"
  )

  attr(:rest, :global, doc: "Additional HTML attributes")

  @spec spinner(map()) :: Rendered.t()
  def spinner(assigns) do
    # Build the icon class string, defaulting to size-4 if no class provided
    icon_class =
      if assigns[:class] do
        "motion-safe:animate-spin #{assigns[:class]}"
      else
        "size-4 motion-safe:animate-spin"
      end

    assigns = assign(assigns, :icon_class, icon_class)

    ~H"""
    <span role="status" aria-label="Loading" {@rest}>
      <.icon name="hero-arrow-path" class={@icon_class} />
    </span>
    """
  end

  @doc """
  Renders a skeleton loading placeholder.

  Skeleton components display a placeholder preview of content before data has finished loading,
  improving perceived performance by showing users that content is on its way.

  The skeleton is a simple animated pulse effect that can be customized with any dimensions
  and shape through CSS classes.

  ## Features

  - Automatic pulse animation to indicate loading
  - Fully customizable dimensions via `class` attribute
  - Flexible shape control (rounded corners, circles, etc.)
  - Uses semantic accent color that adapts to theme
  - Composable for complex loading layouts

  ## Common Patterns

  **Avatar placeholder:**
      <.skeleton class="h-12 w-12 rounded-full" />

  **Text line placeholders:**
      <div class="space-y-2">
        <.skeleton class="h-4 w-[250px]" />
        <.skeleton class="h-4 w-[200px]" />
      </div>

  **Card placeholder:**
      <div class="flex flex-col space-y-3">
        <.skeleton class="h-[125px] w-[250px] rounded-xl" />
        <div class="space-y-2">
          <.skeleton class="h-4 w-[250px]" />
          <.skeleton class="h-4 w-[200px]" />
        </div>
      </div>

  **Profile with avatar:**
      <div class="flex items-center space-x-4">
        <.skeleton class="h-12 w-12 rounded-full" />
        <div class="space-y-2">
          <.skeleton class="h-4 w-[250px]" />
          <.skeleton class="h-4 w-[200px]" />
        </div>
      </div>

  **Table row placeholder:**
      <div class="space-y-2">
        <.skeleton class="h-12 w-full" />
        <.skeleton class="h-12 w-full" />
        <.skeleton class="h-12 w-full" />
      </div>

  ## Sizing

  Use Tailwind utility classes to control dimensions:
  - Height: `h-4`, `h-8`, `h-[125px]` (any height utility)
  - Width: `w-full`, `w-[250px]`, `w-1/2` (any width utility)
  - Aspect ratio: `aspect-square`, `aspect-video`

  ## Shape

  Control corner rounding with Tailwind utilities:
  - `rounded-md` - Default rounded corners
  - `rounded-lg` - Large rounded corners
  - `rounded-xl` - Extra large rounded corners
  - `rounded-full` - Circular (for avatars)
  - `rounded-none` - Square corners

  ## Examples

      # Basic skeleton
      <.skeleton class="h-4 w-full" />

      # Avatar skeleton
      <.skeleton class="h-12 w-12 rounded-full" />

      # Custom dimensions
      <.skeleton class="h-[200px] w-[300px] rounded-xl" />

      # Full-width content block
      <.skeleton class="h-24 w-full rounded-lg" />

      # Button skeleton
      <.skeleton class="h-10 w-24 rounded-md" />

  ## Accessibility

  The skeleton includes proper accessibility:
  - `role="status"` for screen reader compatibility
  - `aria-label="Loading"` to provide context
  - `aria-live="polite"` for non-intrusive announcements

  """
  attr(:class, :string,
    default: nil,
    doc: "Additional CSS classes for dimensions and shape (e.g., 'h-4 w-full rounded-md')"
  )

  attr(:rest, :global, doc: "Additional HTML attributes")

  @spec skeleton(map()) :: Rendered.t()
  def skeleton(assigns) do
    ~H"""
    <div
      data-slot="skeleton"
      role="status"
      aria-label="Loading"
      aria-live="polite"
      class={[
        "bg-accent motion-safe:animate-pulse rounded-md",
        @class
      ]}
      {@rest}
    />
    """
  end

  @doc """
  Renders a segmented progress bar component.

  A segmented progress bar displays progress through distinct segments, making it ideal for
  visualizing race-to-target scenarios such as game scoring (e.g., "first to 5 wins") or
  multi-step processes where each segment represents a completed milestone.

  ## Features

  - Flexible segment count (any number of segments)
  - Customizable filled and empty segment colors
  - Responsive sizing that scales to container
  - Automatic segment width calculation
  - Clean, modern design with rounded corners
  - Semantic color tokens for theme support
  - Configurable gap between segments

  ## Examples

      # Basic usage - 2 of 5 segments filled
      <.segmented_progress_bar total={5} filled={2} />

      # Race to 7 - 3 wins so far
      <.segmented_progress_bar total={7} filled={3} />

      # Custom colors
      <.segmented_progress_bar
        total={5}
        filled={2}
        filled_class="bg-success"
        empty_class="bg-muted"
      />

      # Custom size and gap
      <.segmented_progress_bar
        total={5}
        filled={2}
        class="h-3"
        gap={1}
      />

      # Full width with larger segments
      <.segmented_progress_bar
        total={5}
        filled={4}
        class="w-full h-4"
      />

  ## Attributes

  - `total` - Total number of segments (required)
  - `filled` - Number of filled segments (required, must be <= total)
  - `filled_class` - CSS class for filled segments (default: "bg-primary")
  - `empty_class` - CSS class for empty segments (default: "bg-accent")
  - `gap` - Gap between segments in Tailwind spacing units (default: 2)
  - `class` - Additional CSS classes for the container

  ## Use Cases

  - Pool game scoring (race to N games)
  - Tournament brackets progress
  - Set progress in sports
  - Multi-stage achievements
  - Progress toward a goal or quota
  - Skill level indicators

  """
  attr(:total, :integer, required: true, doc: "Total number of segments")
  attr(:filled, :integer, required: true, doc: "Number of filled segments")

  attr(:filled_class, :string,
    default: "bg-primary",
    doc: "CSS class for filled segments"
  )

  attr(:empty_class, :string,
    default: "bg-accent",
    doc: "CSS class for empty segments"
  )

  attr(:gap, :integer,
    default: 2,
    doc: "Gap between segments in Tailwind spacing units (e.g., 1, 2, 3)"
  )

  attr(:class, :string,
    default: nil,
    doc: "Additional CSS classes for size and appearance"
  )

  attr(:rest, :global, doc: "Additional HTML attributes")

  @spec segmented_progress_bar(map()) :: Rendered.t()
  def segmented_progress_bar(assigns) do
    # Validate that filled <= total
    filled = min(assigns.filled, assigns.total)
    assigns = assign(assigns, :filled, filled)

    # Generate list of segment states
    segments =
      Enum.map(1..assigns.total, fn i ->
        i <= filled
      end)

    assigns = assign(assigns, :segments, segments)

    # Add default height if no height class provided
    has_height = assigns.class && String.contains?(assigns.class, "h-")
    default_height = if has_height, do: "", else: "h-2"
    assigns = assign(assigns, :default_height, default_height)

    ~H"""
    <div
      data-slot="segmented-progress-bar"
      role="progressbar"
      aria-valuenow={@filled}
      aria-valuemin="0"
      aria-valuemax={@total}
      aria-label={"#{@filled} of #{@total} complete"}
      class={[
        "flex w-full items-center",
        @default_height,
        gap_class(@gap),
        @class
      ]}
      {@rest}
    >
      <div
        :for={is_filled <- @segments}
        class={[
          "flex-1 h-full rounded-full transition-colors duration-200",
          if(is_filled, do: @filled_class, else: @empty_class)
        ]}
      />
    </div>
    """
  end

  # Helper function to generate gap class
  @spec gap_class(integer()) :: String.t()
  defp gap_class(0), do: "gap-0"
  defp gap_class(1), do: "gap-1"
  defp gap_class(2), do: "gap-2"
  defp gap_class(3), do: "gap-3"
  defp gap_class(4), do: "gap-4"
  defp gap_class(5), do: "gap-5"
  defp gap_class(6), do: "gap-6"
  defp gap_class(gap), do: "gap-#{gap}"

  @doc """
  Renders a progress bar component.

  Displays an indicator showing the completion progress of a task, typically
  displayed as a progress bar. The progress value ranges from 0 to 100.

  ## Features

  - Smooth transition animations when progress changes
  - Customizable width via CSS classes
  - Semantic color tokens (bg-primary)
  - Proper accessibility attributes
  - Overflow handling with rounded corners

  ## Examples

      # Basic usage with 33% progress
      <.progress value={33} />

      # 66% progress with custom width
      <.progress value={66} class="w-[60%]" />

      # Full progress
      <.progress value={100} />

      # In a card with label
      <div class="space-y-2">
        <div class="flex justify-between text-sm">
          <span>Loading...</span>
          <span>66%</span>
        </div>
        <.progress value={66} />
      </div>

      # Custom styling
      <.progress value={75} class="h-3 w-full" />

  ## Attributes

  - `value` - Progress value from 0 to 100 (default: 0)
  - `class` - Additional CSS classes for the progress container
  - `rest` - Additional HTML attributes to pass to the progress element

  ## Accessibility

  The progress component includes proper ARIA attributes:
  - `role="progressbar"` for screen reader compatibility
  - `aria-valuenow` with current progress value
  - `aria-valuemin` and `aria-valuemax` for range context

  """
  attr :value, :integer, default: 0, doc: "Progress value from 0 to 100"
  attr :class, :string, default: nil, doc: "Additional CSS classes"
  attr :rest, :global, doc: "Additional HTML attributes"

  @spec progress(map()) :: Rendered.t()
  def progress(assigns) do
    # Ensure value is between 0 and 100
    assigns = assign(assigns, :value, min(max(assigns.value, 0), 100))

    ~H"""
    <div
      role="progressbar"
      aria-valuemin="0"
      aria-valuemax="100"
      aria-valuenow={@value}
      data-slot="progress"
      class={[
        "relative h-2 w-full overflow-hidden rounded-full bg-primary/20",
        @class
      ]}
      {@rest}
    >
      <div
        data-slot="progress-indicator"
        class="h-full w-full flex-1 bg-primary transition-all"
        style={"transform: translateX(-#{100 - @value}%)"}
      />
    </div>
    """
  end
end
