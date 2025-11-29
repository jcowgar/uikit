defmodule UiKit.Components.CoreComponents do
  # credo:disable-for-this-file
  @moduledoc """
  Provides core UI components.

  At first glance, this module may seem daunting, but its goal is to provide
  core building blocks for your application, such as tables, forms, and
  inputs. The components consist mostly of markup and are well-documented
  with doc strings and declarative assigns. You may customize and style
  them in any way you want, based on your application growth and needs.

  The foundation for styling is Tailwind CSS with semantic design tokens
  that support light and dark themes. Here are useful references:

    * [Tailwind CSS](https://tailwindcss.com) - the foundational framework
      we build on. You will use it for layout, sizing, flexbox, grid, and
      spacing.

    * [Heroicons](https://heroicons.com) - see `icon/1` for usage.

    * [Phoenix.Component](https://hexdocs.pm/phoenix_live_view/Phoenix.Component.html) -
      the component system used by Phoenix. Some components, such as `<.link>`
      and `<.form>`, are defined there.

  ## Design Tokens

  This application uses semantic design tokens for theming:

    * Colors: `bg-background`, `bg-surface`, `bg-card`, `text-foreground`, `text-muted-foreground`
    * Borders: `border-border`, `border-input`
    * Brand: `bg-primary`, `text-primary`, `text-primary-foreground`
    * States: `bg-destructive`, `bg-success`, `bg-warning`, `bg-info`

  Components use these tokens for theme-aware colors, but may use raw Tailwind
  utilities (px-4, py-2, etc.) for internal spacing and layout.

  """
  use Phoenix.Component
  use Gettext, backend: UiKit.Gettext

  import UiKit.Components.LayoutComponents, only: [flex: 1]

  alias Phoenix.LiveView.JS

  @doc """
  Renders flash notices.

  ## Examples

      <.flash kind={:info} flash={@flash} />
      <.flash kind={:info} phx-mounted={show("#flash")}>Welcome Back!</.flash>
  """
  attr(:id, :string, doc: "the optional id of flash container")
  attr(:flash, :map, default: %{}, doc: "the map of flash messages to display")
  attr(:title, :string, default: nil)
  attr(:kind, :atom, values: [:info, :error], doc: "used for styling and flash lookup")
  attr(:rest, :global, doc: "the arbitrary HTML attributes to add to the flash container")

  slot(:inner_block, doc: "the optional inner block that renders the flash message")

  def flash(assigns) do
    assigns = assign_new(assigns, :id, fn -> "flash-#{assigns.kind}" end)

    ~H"""
    <div
      :if={msg = render_slot(@inner_block) || Phoenix.Flash.get(@flash, @kind)}
      id={@id}
      phx-click={JS.push("lv:clear-flash", value: %{key: @kind}) |> hide("##{@id}")}
      role="alert"
      class="fixed top-4 right-4 z-50"
      {@rest}
    >
      <div class={[
        "w-80 sm:w-96 max-w-80 sm:max-w-96 text-wrap p-4 rounded-lg border shadow-lg",
        @kind == :info && "bg-info border-info/20 text-info-foreground",
        @kind == :error && "bg-destructive border-destructive/20 text-destructive-foreground"
      ]}>
        <.icon :if={@kind == :info} name="hero-information-circle" class="size-5 shrink-0" />
        <.icon :if={@kind == :error} name="hero-exclamation-circle" class="size-5 shrink-0" />
        <div>
          <p :if={@title} class="font-semibold">{@title}</p>
          <p>{msg}</p>
        </div>
        <div class="flex-1" />
        <UiKit.Components.Ui.FormInput.close_button size="lg" sr_text={gettext("close")} class="self-start" />
      </div>
    </div>
    """
  end

  @doc """
  Renders a header with title.
  """
  slot(:inner_block, required: true)
  slot(:subtitle)
  slot(:actions)

  def header(assigns) do
    ~H"""
    <header :if={@actions != []} class="pb-4">
      <.flex justify="between" items="center" gap="lg">
        <div>
          <h1 class="text-lg font-semibold leading-8 text-foreground">
            {render_slot(@inner_block)}
          </h1>
          <p :if={@subtitle != []} class="text-sm text-muted-foreground">
            {render_slot(@subtitle)}
          </p>
        </div>
        <div class="flex-none">{render_slot(@actions)}</div>
      </.flex>
    </header>
    <header :if={@actions == []} class="pb-4">
      <div>
        <h1 class="text-lg font-semibold leading-8 text-foreground">
          {render_slot(@inner_block)}
        </h1>
        <p :if={@subtitle != []} class="text-sm text-muted-foreground">
          {render_slot(@subtitle)}
        </p>
      </div>
    </header>
    """
  end

  @doc """
  Renders a data list.

  ## Examples

      <.list>
        <:item title="Title">{@post.title}</:item>
        <:item title="Views">{@post.views}</:item>
      </.list>

  Each item is displayed with the title and content in a vertical layout:

      <.flex direction="col" gap="xs">
        <div class="font-semibold text-foreground">{item.title}</div>
        <div class="text-sm text-muted-foreground">{render_slot(item)}</div>
      </.flex>
  """
  slot :item, required: true do
    attr(:title, :string, required: true)
  end

  def list(assigns) do
    ~H"""
    <ul class="divide-y divide-border">
      <li :for={item <- @item} class="py-4">
        <.flex direction="col" gap="xs">
          <div class="font-semibold text-foreground">{item.title}</div>
          <div class="text-sm text-muted-foreground">{render_slot(item)}</div>
        </.flex>
      </li>
    </ul>
    """
  end

  @doc """
  Renders a [Heroicon](https://heroicons.com).

  Heroicons come in three styles – outline, solid, and mini.
  By default, the outline style is used, but solid and mini may
  be applied by using the `-solid` and `-mini` suffix.

  You can customize the size and colors of the icons by setting
  width, height, and background color classes.

  Icons are extracted from the `deps/heroicons` directory and bundled within
  your compiled app.css by the plugin in `assets/vendor/heroicons.js`.

  ## Examples

      <.icon name="hero-x-mark" />
      <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
  """
  attr(:name, :string, required: true)
  attr(:class, :string, default: "size-4")

  def icon(%{name: "hero-" <> _} = assigns) do
    ~H"""
    <span class={[@name, @class]} />
    """
  end

  def icon(assigns) do
    # Fallback for invalid icon names - show a default icon or nothing
    ~H"""
    <span class={["hero-question-mark-circle", @class]} />
    """
  end

  @doc """
  Renders a datetime value with automatic timezone conversion.

  This component displays dates and times in the user's local timezone automatically.
  It renders a semantic `<time>` HTML element with the datetime in ISO8601 format,
  then uses JavaScript to convert and format it based on the user's browser timezone.

  ## Examples

      <.datetime value={~U[2025-11-16 14:00:00Z]} />
      <.datetime value={~U[2025-11-16 14:00:00Z]} format="relative" />
      <.datetime value={~U[2025-11-16 14:00:00Z]} format="short" />
      <.datetime value={~U[2025-11-16 14:00:00Z]} format="long" />

  ## Formats

    * `:relative` - "2 hours ago", "in 3 days" (default)
    * `:short` - "Nov 16, 2:00 PM"
    * `:long` - "November 16, 2025 at 2:00 PM"
    * `:date` - "November 16, 2025"
    * `:time` - "2:00 PM"
  """
  attr(:value, :any, required: true, doc: "DateTime, NaiveDateTime, or ISO8601 string")
  attr(:format, :atom, default: :relative, values: [:relative, :short, :long, :date, :time])
  attr(:class, :string, default: nil)
  attr(:id, :string, default: nil, doc: "Optional DOM ID, auto-generated if not provided")
  attr(:rest, :global)

  @spec datetime(map()) :: Phoenix.LiveView.Rendered.t()
  def datetime(assigns) do
    # Convert various datetime formats to ISO8601 string
    iso_string =
      case assigns.value do
        %DateTime{} = dt ->
          DateTime.to_iso8601(dt)

        %NaiveDateTime{} = ndt ->
          NaiveDateTime.to_iso8601(ndt) <> "Z"

        string when is_binary(string) ->
          string

        _nil_value ->
          nil
      end

    # Generate a unique ID if not provided
    id = assigns[:id] || "datetime-#{System.unique_integer([:positive, :monotonic])}"

    assigns =
      assigns
      |> assign(:iso_string, iso_string)
      |> assign(:id, id)

    ~H"""
    <time
      :if={@iso_string}
      id={@id}
      datetime={@iso_string}
      data-local-time
      data-format={@format}
      class={@class}
      phx-hook="LocalTime"
      {@rest}
    >
      {fallback_format(@iso_string, @format)}
    </time>
    """
  end

  # Fallback formatting for when JS hasn't loaded yet or fails
  @spec fallback_format(String.t(), atom()) :: String.t()
  defp fallback_format(iso_string, format) do
    case DateTime.from_iso8601(iso_string) do
      {:ok, datetime, _offset} ->
        case format do
          :relative -> Calendar.strftime(datetime, "%Y-%m-%d %H:%M UTC")
          :short -> Calendar.strftime(datetime, "%b %-d, %Y %-I:%M %p UTC")
          :long -> Calendar.strftime(datetime, "%B %-d, %Y at %-I:%M %p UTC")
          :date -> Calendar.strftime(datetime, "%b %-d, %Y")
          :time -> Calendar.strftime(datetime, "%-I:%M %p UTC")
        end

      _error ->
        iso_string
    end
  end

  ## JS Commands

  def show(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      time: 300,
      transition:
        {"transition-all ease-out duration-300",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
  end

  def hide(js \\ %JS{}, selector) do
    JS.hide(js,
      to: selector,
      time: 200,
      transition:
        {"transition-all ease-in duration-200", "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # However the error messages in our forms and APIs are generated
    # dynamically, so we need to translate them by calling Gettext
    # with our gettext backend as first argument. Translations are
    # available in the errors.po file (as we use the "errors" domain).
    if count = opts[:count] do
      Gettext.dngettext(UiKit.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(UiKit.Gettext, "errors", msg, opts)
    end
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end
end
