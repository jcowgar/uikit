defmodule UiKit.Components.Ui.FormInput do
  @moduledoc """
  Form & Input components for user interactions.

  Components ported from shadcn/ui.
  """
  use Phoenix.Component

  import UiKit.Components.CoreComponents, only: [translate_error: 1, icon: 1]
  import UiKit.Components.LayoutComponents, only: [flex: 1, stack: 1]

  alias Phoenix.HTML.FormField
  alias Phoenix.LiveView.JS
  alias Phoenix.LiveView.Rendered

  @doc """
  Renders a button component with various styling variants and sizes.

  This component intelligently renders as either a `<button>` or `<.link>` based on the attributes provided:
  - If `href`, `navigate`, or `patch` is provided, renders as a styled link
  - Otherwise, renders as a button element

  ## Button Type

  When rendering as a button (no href/navigate/patch), the default type is `"submit"` which
  is the HTML standard for form buttons. For non-submitting buttons (e.g., for JavaScript
  click handlers), explicitly set `type="button"`.

  ## Variants

  - `default` - Standard button with primary styling
  - `destructive` - Red/warning styling for delete or dangerous actions
  - `outline` - Border-only button with transparent background
  - `secondary` - Alternative button style
  - `ghost` - Minimal styling, often for secondary actions
  - `link` - Styled to appear as a clickable link
  - `unstyled` - No styling applied, useful for building custom trigger components

  ## Sizes

  - `default` - Standard button dimensions
  - `sm` - Small button
  - `lg` - Large button
  - `icon` - Square button for icon-only usage
  - `icon-sm` - Small square icon button
  - `icon-lg` - Large square icon button

  ## Examples

      <%!-- Submit button (default) --%>
      <.button>Submit Form</.button>

      <%!-- Non-submitting button --%>
      <.button type="button" phx-click="do_something">Click Me</.button>

      <%!-- Link styled as button --%>
      <.button href={~p"/register"}>Sign Up</.button>
      <.button navigate={~p"/dashboard"}>Dashboard</.button>

      <%!-- Variants and sizes --%>
      <.button variant="destructive">Delete</.button>
      <.button variant="outline" size="sm">Small Outline</.button>
      <.button variant="ghost" size="icon" aria-label="Menu">
        <.icon name="hero-bars-3" />
      </.button>

      <%!-- Unstyled for custom trigger components --%>
      <.button variant="unstyled" type="button" role="tab" aria-selected="true" class="my-tab-styles">
        Tab 1
      </.button>

  """
  attr(:variant, :string,
    default: "default",
    values: ~w(default destructive outline secondary ghost link unstyled)
  )

  attr(:size, :string, default: "default", values: ~w(default sm lg icon icon-sm icon-lg))
  attr(:class, :any, default: nil, doc: "Additional CSS classes (string or list)")

  attr(:rest, :global,
    include:
      ~w(disabled type form name value navigate patch href phx-click phx-value-val role aria-label aria-expanded aria-controls aria-pressed aria-haspopup aria-describedby)
  )

  slot(:inner_block, required: true)

  @spec button(map()) :: Rendered.t()
  def button(assigns) do
    # Determine if this should be a link or a button
    assigns =
      assign(
        assigns,
        :is_link,
        Map.has_key?(assigns.rest, :navigate) || Map.has_key?(assigns.rest, :patch) ||
          Map.has_key?(assigns.rest, :href)
      )

    ~H"""
    <.link
      :if={@is_link}
      class={button_classes(@variant, @size, @class)}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    <button
      :if={!@is_link}
      type={@rest[:type] || "submit"}
      class={button_classes(@variant, @size, @class)}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  defp button_classes("unstyled", _size, class), do: class

  defp button_classes(variant, size, class) do
    [
      # Base styles
      "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-all",
      "disabled:pointer-events-none disabled:opacity-50",
      "[&_svg]:pointer-events-none [&_svg:not([class*='size-'])]:size-4 [&_svg]:shrink-0",
      "outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]",
      # Variant styles
      button_variant(variant),
      # Size styles
      button_size(size),
      # Custom classes
      class
    ]
  end

  defp button_variant("default"), do: "bg-primary text-primary-foreground hover:bg-primary/90"

  defp button_variant("destructive"),
    do:
      "bg-destructive text-white hover:bg-destructive/90 focus-visible:ring-destructive/20 dark:focus-visible:ring-destructive/40 dark:bg-destructive/60"

  defp button_variant("outline"),
    do:
      "border border-border bg-background text-foreground shadow-xs hover:bg-accent hover:text-accent-foreground dark:bg-input/30 dark:border-input dark:hover:bg-input/50"

  defp button_variant("secondary"),
    do: "bg-secondary text-secondary-foreground hover:bg-secondary/80"

  defp button_variant("ghost"),
    do: "text-foreground hover:bg-accent hover:text-accent-foreground dark:hover:bg-accent/50"

  defp button_variant("link"), do: "text-primary underline-offset-4 hover:underline"

  defp button_size("default"), do: "h-9 px-4 py-2 has-[>svg]:px-3"
  defp button_size("sm"), do: "h-8 rounded-md gap-1.5 px-3 has-[>svg]:px-2.5"
  defp button_size("lg"), do: "h-10 rounded-md px-6 has-[>svg]:px-4"
  defp button_size("icon"), do: "size-9"
  defp button_size("icon-sm"), do: "size-8"
  defp button_size("icon-lg"), do: "size-10"

  @doc """
  Renders a close button, typically used for dismissing modals, dialogs, sheets, and toasts.

  This component provides a consistent close button pattern with an X icon,
  proper accessibility attributes, and hover/focus states.

  ## Variants

  - `default` - Standard close button with opacity transition
  - `ghost` - Minimal styling that blends into the background
  - `chip` - Compact styling for use inside badges/chips

  ## Sizes

  - `sm` - Small close button (size-3 icon)
  - `default` - Standard close button (size-4 icon)
  - `lg` - Large close button (size-5 icon)

  ## Examples

      <%!-- Basic close button --%>
      <.close_button phx-click="close" />

      <%!-- With screen reader text --%>
      <.close_button phx-click={hide_modal("my-modal")} sr_text="Close dialog" />

      <%!-- Absolutely positioned (common for modals) --%>
      <.close_button phx-click="close" class="absolute top-4 right-4" />

      <%!-- Ghost variant for subtle appearance --%>
      <.close_button variant="ghost" phx-click="close" />

      <%!-- Chip variant for use in badges --%>
      <.close_button variant="chip" size="sm" phx-click="remove_chip" />

  """
  attr(:variant, :string, default: "default", values: ~w(default ghost chip))
  attr(:size, :string, default: "default", values: ~w(sm default lg))
  attr(:sr_text, :string, default: "Close", doc: "Screen reader text for accessibility")
  attr(:class, :string, default: nil)

  attr(:rest, :global,
    include:
      ~w(phx-click aria-label disabled data-combobox-remove data-remove-value data-combobox-id data-event-name data-chip-remove)
  )

  @spec close_button(map()) :: Rendered.t()
  def close_button(assigns) do
    ~H"""
    <button
      type="button"
      aria-label={@sr_text}
      class={[
        close_button_classes(@variant),
        close_button_size(@size),
        @class
      ]}
      {@rest}
    >
      <.icon name="hero-x-mark" class={close_button_icon_size(@size)} />
      <span class="sr-only">{@sr_text}</span>
    </button>
    """
  end

  defp close_button_classes("default") do
    [
      "rounded-md opacity-70 transition-opacity",
      "hover:opacity-100 focus:opacity-100",
      "focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 ring-offset-background",
      "disabled:pointer-events-none"
    ]
  end

  defp close_button_classes("ghost") do
    [
      "rounded-md opacity-70 transition-opacity",
      "hover:opacity-100 focus:opacity-100 hover:bg-accent hover:text-accent-foreground",
      "focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2",
      "disabled:pointer-events-none"
    ]
  end

  defp close_button_classes("chip") do
    [
      "ml-1 rounded-sm",
      "hover:bg-secondary-foreground/20",
      "focus-visible:outline-hidden focus-visible:ring-1 focus-visible:ring-ring"
    ]
  end

  defp close_button_size("sm"), do: "p-0.5"
  defp close_button_size("default"), do: "p-1"
  defp close_button_size("lg"), do: "p-1.5"

  defp close_button_icon_size("sm"), do: "size-3"
  defp close_button_icon_size("default"), do: "size-4"
  defp close_button_icon_size("lg"), do: "size-5"

  @doc """
  Renders a button-styled label for file uploads.

  This component wraps a file input (typically `Phoenix.Component.live_file_input/1`)
  in a label styled as a button. The actual file input should be passed as the
  inner block and will be visually hidden while remaining accessible.

  ## Features

  - Button-styled clickable area for file selection
  - Supports all button variants and sizes
  - Visually hides the file input while keeping it accessible
  - Works with Phoenix LiveView's `live_file_input`

  ## Examples

      # Basic file upload button
      <.file_upload_button>
        <.live_file_input upload={@uploads.avatar} />
      </.file_upload_button>

      # With custom label text
      <.file_upload_button label="Choose Image">
        <.live_file_input upload={@uploads.photo} />
      </.file_upload_button>

      # Different variant and size
      <.file_upload_button variant="default" size="lg" label="Upload Document">
        <.live_file_input upload={@uploads.document} />
      </.file_upload_button>

      # Without icon
      <.file_upload_button icon={false}>
        <.live_file_input upload={@uploads.file} />
      </.file_upload_button>

  """
  attr(:variant, :string,
    default: "outline",
    values: ~w(default destructive outline secondary ghost)
  )

  attr(:size, :string, default: "default", values: ~w(default sm lg))
  attr(:label, :string, default: "Choose File")
  attr(:icon, :boolean, default: true, doc: "Whether to show the upload icon")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true, doc: "The file input element (e.g., live_file_input)")

  @spec file_upload_button(map()) :: Rendered.t()
  def file_upload_button(assigns) do
    ~H"""
    <label
      class={[
        # Base styles (same as button)
        "inline-flex cursor-pointer items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-all",
        "[&_svg]:pointer-events-none [&_svg:not([class*='size-'])]:size-4 [&_svg]:shrink-0",
        "outline-none focus-within:border-ring focus-within:ring-ring/50 focus-within:ring-[3px]",
        # Variant styles
        button_variant(@variant),
        # Size styles
        button_size(@size),
        # Hide the file input visually
        "[&_input[type=file]]:sr-only",
        # Custom classes
        @class
      ]}
      {@rest}
    >
      <span :if={@icon} class="hero-arrow-up-tray size-4" />
      {@label}
      {render_slot(@inner_block)}
    </label>
    """
  end

  @doc """
  Renders a shadcn-style input field with consistent styling and accessibility features.

  This is the base input component from shadcn/ui. It supports all standard HTML input
  types and includes built-in styling for focus states, validation states, disabled
  states, and file inputs.

  **Note:** For form integration with Phoenix forms (with labels and error messages),
  use the `<.form_field>` component instead of this low-level `<.input>` component.

  ## Features

  - Semantic color tokens for theme support
  - Focus visible ring styles
  - Error state styling via `aria-invalid`
  - File input styling
  - Text selection with primary color
  - Disabled state handling
  - **Automatic autocomplete attributes** - Password managers will work automatically!
    - `type="email"` → `autocomplete="email"`
    - `type="password"` → `autocomplete="current-password"`
    - `type="tel"` → `autocomplete="tel"`
    - `type="url"` → `autocomplete="url"`

  ## Attributes

  - `type` - Input type (text, email, password, number, file, etc.). Defaults to "text"
  - `name` - Input name for form submission
  - `value` - Input value
  - `placeholder` - Placeholder text
  - `disabled` - Disables the input
  - `required` - Makes the input required
  - `autocomplete` - Autocomplete attribute (auto-set for common types, can be overridden)
  - `class` - Additional CSS classes to merge with base styles

  ## Examples

      # Basic text input
      <.input type="text" name="username" placeholder="Enter username" />

      # Email input (autocomplete="email" added automatically)
      <.input type="email" name="email" placeholder="Email" />

      # Password input (autocomplete="current-password" added automatically)
      <.input type="password" name="password" placeholder="Password" />

      # Override autocomplete for new password
      <.input type="password" name="password" autocomplete="new-password" />

      # Disabled input
      <.input type="text" name="disabled" disabled placeholder="Disabled input" />

      # File input
      <.input type="file" name="attachment" />

      # With error state (via aria-invalid)
      <.input type="email" name="email" aria-invalid="true" />

      # With custom classes
      <.input type="text" name="custom" class="w-full" />

  """
  attr(:type, :string, default: "text")
  attr(:name, :string, default: nil)
  attr(:value, :string, default: nil)
  attr(:placeholder, :string, default: nil)
  attr(:class, :string, default: nil)

  attr(:rest, :global,
    include:
      ~w(disabled required autocomplete readonly maxlength minlength pattern id aria-label aria-invalid aria-describedby form autofocus multiple accept)
  )

  @spec input(map()) :: Rendered.t()
  def input(assigns) do
    # Set default autocomplete based on input type if not explicitly provided
    assigns =
      assign_new(assigns, :computed_autocomplete, fn ->
        # If autocomplete is explicitly set in @rest, use that
        # Otherwise, provide sensible defaults based on type
        cond do
          Map.has_key?(assigns.rest, :autocomplete) -> assigns.rest.autocomplete
          assigns.type == "email" -> "email"
          assigns.type == "password" -> "current-password"
          assigns.type == "tel" -> "tel"
          assigns.type == "url" -> "url"
          true -> nil
        end
      end)

    ~H"""
    <input
      type={@type}
      name={@name}
      value={@value}
      placeholder={@placeholder}
      autocomplete={@computed_autocomplete}
      data-slot="input"
      class={
        [
          # Base styles
          "h-9 w-full min-w-0 rounded-md border border-input bg-transparent px-3 py-1",
          "text-base md:text-sm text-foreground shadow-xs transition-[color,box-shadow] outline-none",
          # Dark mode input background
          "dark:bg-input/30",
          # Placeholder styling
          "placeholder:text-muted-foreground",
          # Text selection styling
          "selection:bg-primary selection:text-primary-foreground",
          # File input styling
          "file:inline-flex file:h-7 file:border-0 file:bg-transparent file:text-sm file:font-medium file:text-foreground",
          # Focus styles
          "focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]",
          # Error/invalid state
          "aria-invalid:border-destructive aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40",
          # Disabled state - keep text readable, just reduce overall opacity
          "disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50",
          # Custom classes
          @class
        ]
      }
      {@rest}
    />
    """
  end

  @doc """
  Renders a multi-line text input (textarea) with consistent styling and accessibility features.

  This is the base textarea component from shadcn/ui. It supports automatic content-based
  sizing and includes built-in styling for focus states, validation states, and disabled states.

  **Note:** For form integration with Phoenix forms (with labels and error messages),
  use the `<.form_field>` component with `type="textarea"` instead of this low-level component.

  ## Features

  - Semantic color tokens for theme support
  - Focus visible ring styles
  - Error state styling via `aria-invalid`
  - Field-sizing for content-based height
  - Text selection with primary color
  - Disabled state handling
  - Minimum height of 4rem (min-h-16)

  ## Attributes

  - `name` - Input name for form submission
  - `value` - Initial textarea content
  - `placeholder` - Placeholder text
  - `disabled` - Disables the textarea
  - `required` - Makes the textarea required
  - `rows` - Number of visible text lines (optional, defaults to content-based sizing)
  - `class` - Additional CSS classes to merge with base styles

  ## Examples

      # Basic textarea
      <.textarea name="message" placeholder="Enter your message..." />

      # With initial value
      <.textarea name="bio" value="Tell us about yourself..." />

      # Disabled
      <.textarea name="readonly" disabled value="This cannot be edited" />

      # With error state
      <.textarea name="comment" aria-invalid="true" />

      # With fixed rows
      <.textarea name="description" rows="5" />

      # With custom classes
      <.textarea name="custom" class="w-full" />

  """
  attr(:name, :string, default: nil)
  attr(:value, :string, default: nil)
  attr(:placeholder, :string, default: nil)
  attr(:class, :string, default: nil)

  attr(:rest, :global,
    include:
      ~w(disabled required readonly maxlength minlength rows id aria-label aria-invalid aria-describedby form autofocus)
  )

  @spec textarea(map()) :: Rendered.t()
  def textarea(assigns) do
    ~H"""
    <textarea
      name={@name}
      placeholder={@placeholder}
      data-slot="textarea"
      class={
        [
          # Base styles
          "flex min-h-16 w-full rounded-md border border-input bg-transparent px-3 py-2",
          "text-base md:text-sm text-foreground shadow-xs transition-[color,box-shadow] outline-none",
          # Dark mode input background
          "dark:bg-input/30",
          # Field sizing - content-based height adjustment
          "field-sizing-content",
          # Placeholder styling
          "placeholder:text-muted-foreground",
          # Text selection styling
          "selection:bg-primary selection:text-primary-foreground",
          # Focus styles
          "focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]",
          # Error/invalid state
          "aria-invalid:border-destructive aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40",
          # Disabled state
          "disabled:cursor-not-allowed disabled:opacity-50",
          # Custom classes
          @class
        ]
      }
      {@rest}
    >{@value}</textarea>
    """
  end

  @doc """
  Renders a WYSIWYG markdown editor using TipTap.

  The markdown editor provides a rich text editing experience that outputs markdown.
  Content is displayed as formatted text while editing (WYSIWYG), and converts to
  markdown for form submission.

  ## Features

  - WYSIWYG editing (what you see is what you get)
  - Toolbar with formatting buttons (bold, italic, headings, lists, etc.)
  - Outputs clean markdown
  - Loads existing markdown content
  - Code block support
  - Blockquote support
  - Undo/redo support
  - Optional action buttons in toolbar

  ## Attributes

  - `id` - Unique identifier (required)
  - `name` - Input name for form submission
  - `value` - Initial markdown content
  - `placeholder` - Placeholder text when empty
  - `autofocus` - Focus editor on mount (default: false)
  - `class` - Additional CSS classes

  ## Slots

  - `actions` - Optional action buttons to display at the start of the toolbar

  ## Examples

      # Basic markdown editor
      <.markdown_editor id="readme" name="content" />

      # With initial content
      <.markdown_editor id="notes" name="notes" value={@notes_content} />

      # With placeholder
      <.markdown_editor id="comment" name="comment" placeholder="Write a comment..." />

      # With autofocus
      <.markdown_editor id="editor" name="content" autofocus />

      # In a form with toolbar actions
      <.form for={@form} phx-change="validate" phx-submit="save">
        <.markdown_editor id="editor" name="content" value={@form[:content].value}>
          <:actions>
            <button type="button" phx-click="cancel">Cancel</button>
            <button type="submit">Save</button>
          </:actions>
        </.markdown_editor>
      </.form>

  """
  attr :id, :string, required: true, doc: "Unique identifier for the editor"
  attr :name, :string, default: nil, doc: "Input name for form submission"
  attr :value, :string, default: nil, doc: "Initial markdown content"
  attr :placeholder, :string, default: nil, doc: "Placeholder text when empty"
  attr :autofocus, :boolean, default: false, doc: "Focus editor on mount"
  attr :class, :string, default: nil, doc: "Additional CSS classes"
  attr :rest, :global, include: ~w(disabled required form)

  slot :actions, doc: "Optional action buttons to display at the start of the toolbar"

  @spec markdown_editor(map()) :: Rendered.t()
  def markdown_editor(assigns) do
    ~H"""
    <div
      id={@id}
      phx-hook="MarkdownEditor"
      phx-update="ignore"
      data-slot="markdown-editor"
      data-placeholder={@placeholder}
      data-autofocus={to_string(@autofocus)}
      class={["markdown-editor", @class]}
      {@rest}
    >
      <textarea id={"#{@id}-textarea"} name={@name}>{@value}</textarea>
      <div :if={@actions != []} data-slot="toolbar-actions" style="display: none;">
        {render_slot(@actions)}
      </div>
    </div>
    """
  end

  @doc """
  Renders an accessible label associated with form controls.

  The label component provides proper semantic association with form inputs through
  the `for` attribute, enabling click-to-focus functionality and improving accessibility
  for screen readers and keyboard navigation.

  ## Features

  - Semantic HTML with proper `for` attribute
  - Click label to focus associated input
  - Disabled state support (via group data attribute)
  - Peer-disabled support for adjacent disabled inputs
  - Flexible layout with gap support for icons/indicators
  - User-select disabled to prevent text selection on click

  ## Attributes

  - `for` - ID of the associated form control (maps to `htmlFor` in React)
  - `class` - Additional CSS classes to merge with base styles
  - All other HTML label attributes are supported via `@rest`

  ## Examples

      # Basic label for an input
      <.label for="email">Email address</.label>
      <.input type="email" id="email" name="email" />

      # Label with required indicator
      <.label for="password">
        Password <span class="text-destructive">*</span>
      </.label>
      <.input type="password" id="password" name="password" required />

      # Label with icon
      <.label for="terms" class="cursor-pointer">
        <.icon name="hero-check-circle" class="size-4" />
        I agree to the terms
      </.label>

      # Label in a disabled group
      <div data-disabled="true" class="group">
        <.label for="disabled-input">Disabled field</.label>
        <.input type="text" id="disabled-input" disabled />
      </div>

      # Label with inline help popover
      <.label for="email" help_title="Email Format" help_text="Enter a valid email address in the format: username@domain.com">
        Email Address
      </.label>

  """
  attr(:for, :string, default: nil, doc: "The ID of the associated form control")
  attr(:class, :string, default: nil)
  attr(:help_title, :string, default: nil, doc: "Title for inline help popover")
  attr(:help_text, :string, default: nil, doc: "Body text for inline help popover")
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec label(map()) :: Rendered.t()
  def label(assigns) do
    ~H"""
    <div
      :if={@help_title || @help_text}
      class="flex items-center gap-1 h-5"
    >
      <label
        for={@for}
        data-slot="label"
        class={
          [
            # Base styles
            "text-sm leading-none font-medium text-foreground select-none flex items-center",
            # Disabled state via group data attribute
            "group-data-[disabled=true]:pointer-events-none group-data-[disabled=true]:opacity-50",
            # Peer disabled support (for adjacent disabled inputs)
            "peer-disabled:cursor-not-allowed peer-disabled:opacity-50",
            # Custom classes
            @class
          ]
        }
        {@rest}
      >
        {render_slot(@inner_block)}
      </label>
      <UiKit.Components.Ui.OverlaysDialogs.popover id={"#{@for}-help-popover"}>
        <:trigger>
          <.button variant="ghost" size="sm" class="p-0 hover:bg-accent" type="button">
            <.icon name="hero-question-mark-circle" class="size-5" />
          </.button>
        </:trigger>
        <:content>
          <.stack gap="sm">
            <h4 :if={@help_title} class="text-sm font-medium">{@help_title}</h4>
            <p :if={@help_text} class="text-xs text-muted-foreground">{@help_text}</p>
          </.stack>
        </:content>
      </UiKit.Components.Ui.OverlaysDialogs.popover>
    </div>

    <label
      :if={!@help_title && !@help_text}
      for={@for}
      data-slot="label"
      class={
        [
          # Base styles
          "flex items-center gap-2 text-sm leading-none font-medium text-foreground select-none",
          # Disabled state via group data attribute
          "group-data-[disabled=true]:pointer-events-none group-data-[disabled=true]:opacity-50",
          # Peer disabled support (for adjacent disabled inputs)
          "peer-disabled:cursor-not-allowed peer-disabled:opacity-50",
          # Custom classes
          @class
        ]
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </label>
    """
  end

  @doc """
  Renders a checkbox control that allows toggling between checked and unchecked states.

  The checkbox component provides proper form integration with Phoenix forms, including
  a hidden input for unchecked state values and proper accessibility attributes.

  ## Features

  - Semantic color tokens for theme support
  - Checked and unchecked states with visual feedback
  - Disabled state support
  - Focus visible ring styles
  - Error state styling via `aria-invalid`
  - Hidden input for unchecked values (Phoenix form convention)
  - Peer support for adjacent label styling

  ## Attributes

  - `id` - ID for associating with a label
  - `name` - Input name for form submission
  - `value` - Value when checked (defaults to "true")
  - `checked` - Boolean to set checked state
  - `disabled` - Disables the checkbox
  - `class` - Additional CSS classes to merge with base styles

  ## Examples

      # Basic checkbox
      <.checkbox id="terms" name="terms" />

      # With label
      <.flex gap="default">
        <.checkbox id="terms" name="terms" />
        <.label for="terms">Accept terms and conditions</.label>
      </.flex>

      # Checked by default
      <.checkbox id="newsletter" name="newsletter" checked />

      # Disabled
      <.checkbox id="disabled" name="disabled" disabled />

      # With error state
      <.checkbox id="required" name="required" aria-invalid="true" />

  """
  attr(:id, :string, required: true)
  attr(:name, :string, required: true)
  attr(:value, :string, default: "true")
  attr(:checked, :boolean, default: false)
  attr(:class, :string, default: nil)

  attr(:rest, :global,
    include: ~w(disabled required aria-invalid aria-describedby form autofocus)
  )

  @spec checkbox(map()) :: Rendered.t()
  def checkbox(assigns) do
    # Only add hidden input for single boolean checkboxes, not for array checkboxes
    assigns = assign(assigns, :is_array_field, String.ends_with?(assigns.name, "[]"))

    ~H"""
    <div class="inline-flex items-center">
      <%!-- Hidden input for unchecked value (Phoenix form convention) --%>
      <%!-- Only include for single checkboxes, not for checkbox arrays --%>
      <input
        :if={!@is_array_field}
        type="hidden"
        name={@name}
        value="false"
        disabled={@rest[:disabled]}
      />
      <%!-- Actual checkbox --%>
      <input
        type="checkbox"
        id={@id}
        name={@name}
        value={@value}
        checked={@checked}
        data-slot="checkbox"
        class={
          [
            # Base styles
            "peer size-4 shrink-0 rounded-[4px] border border-input shadow-xs transition-shadow outline-none",
            # Background
            "bg-transparent dark:bg-input/30",
            # Checked state
            "checked:bg-primary checked:text-primary-foreground checked:border-primary",
            "dark:checked:bg-primary",
            # Focus styles
            "focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]",
            # Error/invalid state
            "aria-invalid:border-destructive aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40",
            # Disabled state
            "disabled:cursor-not-allowed disabled:opacity-50",
            # Custom classes
            @class
          ]
        }
        {@rest}
      />
    </div>
    """
  end

  @doc """
  Renders a form field wrapper with consistent spacing and layout.

  This component provides the container structure for form fields, applying consistent
  spacing between label, input, description, and error messages. It's part of the
  shadcn/ui Form composition pattern.

  ## Features

  - Consistent vertical spacing with `gap-2` grid layout
  - Data attribute for styling hooks
  - Flexible inner content via slot

  ## Attributes

  - `class` - Additional CSS classes to merge with base styles
  - All other HTML attributes supported via `@rest`

  ## Examples

      <.form_item>
        <.form_label for="email">Email</.form_label>
        <.input type="email" id="email" name="email" />
        <.form_description>We'll never share your email.</.form_description>
      </.form_item>

      # With error message
      <.form_item>
        <.form_label for="username">Username</.form_label>
        <.input type="text" id="username" name="username" aria-invalid="true" />
        <.form_message>Username is required</.form_message>
      </.form_item>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec form_item(map()) :: Rendered.t()
  def form_item(assigns) do
    ~H"""
    <div data-slot="form-item" class={["grid gap-2", @class]} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a form label with error state styling.

  This is an enhanced version of the base `<.label>` component that automatically
  applies error styling when used with form fields. Part of the shadcn/ui Form pattern.

  ## Features

  - Automatic error state styling via `data-error` attribute
  - Semantic color tokens (`text-destructive` for errors)
  - All base label features (click-to-focus, accessibility)

  ## Attributes

  - `for` - ID of the associated form control
  - `error` - Boolean indicating error state (applies destructive color)
  - `class` - Additional CSS classes to merge with base styles

  ## Examples

      <.form_label for="email">Email address</.form_label>

      # With error state
      <.form_label for="password" error>Password</.form_label>

      # With required indicator
      <.form_label for="username">
        Username <span class="text-destructive">*</span>
      </.form_label>

  """
  attr(:for, :string, default: nil, doc: "The ID of the associated form control")
  attr(:error, :boolean, default: false, doc: "Whether the field has an error")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec form_label(map()) :: Rendered.t()
  def form_label(assigns) do
    ~H"""
    <label
      for={@for}
      data-slot="form-label"
      data-error={@error}
      class={
        [
          # Base styles from label component
          "flex items-center gap-2 text-sm leading-none font-medium text-foreground select-none h-5",
          # Error state
          "data-[error=true]:text-destructive",
          # Disabled state via group data attribute
          "group-data-[disabled=true]:pointer-events-none group-data-[disabled=true]:opacity-50",
          # Peer disabled support
          "peer-disabled:cursor-not-allowed peer-disabled:opacity-50",
          # Custom classes
          @class
        ]
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </label>
    """
  end

  @doc """
  Renders helper text for form fields.

  Provides additional context or instructions for form inputs. Automatically associated
  with inputs via `aria-describedby` when used within the Form pattern.

  ## Features

  - Muted text styling for subtle appearance
  - Small text size (`text-sm`)
  - Semantic color token (`text-muted-foreground`)

  ## Attributes

  - `id` - Optional ID for explicit `aria-describedby` association
  - `class` - Additional CSS classes to merge with base styles

  ## Examples

      <.form_description>
        Your email will only be used for account notifications.
      </.form_description>

      <.form_description id="password-hint">
        Must be at least 8 characters with one number and one special character.
      </.form_description>

  """
  attr(:id, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec form_description(map()) :: Rendered.t()
  def form_description(assigns) do
    ~H"""
    <p
      id={@id}
      data-slot="form-description"
      class={["text-muted-foreground text-sm", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </p>
    """
  end

  @doc """
  Renders error messages for form fields.

  Displays validation errors with destructive styling. Automatically shows error messages
  from Phoenix form fields when integrated with changesets.

  ## Features

  - Destructive color for error visibility
  - Small text size (`text-sm`)
  - Only renders when error content exists
  - Semantic color token (`text-destructive`)

  ## Attributes

  - `id` - Optional ID for explicit `aria-describedby` association
  - `field` - Optional Phoenix.HTML.FormField struct to extract errors from
  - `class` - Additional CSS classes to merge with base styles

  ## Examples

      # Manual error message
      <.form_message>This field is required</.form_message>

      # With Phoenix form field (extracts errors automatically)
      <.form_message field={@form[:email]} />

      # Custom content
      <.form_message :if={@custom_error}>
        {custom_error_message(@custom_error)}
      </.form_message>

  """
  attr(:id, :string, default: nil)
  attr(:field, FormField, default: nil, doc: "Phoenix form field to extract errors from")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block)

  @spec form_message(map()) :: Rendered.t()
  def form_message(assigns) do
    # Extract error from field if provided
    assigns =
      assign_new(assigns, :error_message, fn ->
        cond do
          # If inner_block provided, use that
          assigns.inner_block != [] ->
            nil

          # If field provided and has errors, use first error
          assigns.field != nil && assigns.field.errors != [] ->
            {msg, opts} = hd(assigns.field.errors)
            # Translate error message with options
            translate_error({msg, opts})

          # Otherwise no message
          true ->
            nil
        end
      end)

    ~H"""
    <p
      :if={@error_message || @inner_block != []}
      id={@id}
      data-slot="form-message"
      class={["text-destructive text-sm", @class]}
      {@rest}
    >
      {@error_message}
      {render_slot(@inner_block)}
    </p>
    """
  end

  @doc """
  Renders a form field with integrated label, input, description, and error handling.

  This is a high-level composition component that combines form_item, form_label, input/textarea,
  form_description, and form_message into a single convenient component. It's the
  recommended way to build form fields as it handles all the boilerplate for you.

  ## Features

  - Automatic ID generation for label/input association
  - Automatic error extraction from Phoenix form fields
  - Automatic `aria-describedby` for description and errors
  - Automatic `aria-invalid` for error states
  - Support for all input types including textarea
  - Optional description text
  - Automatic error message display

  ## Attributes

  - `field` - Phoenix.HTML.FormField struct (from @form[:field_name])
  - `type` - Input type (text, email, password, textarea, etc.)
  - `label` - Label text
  - `description` - Optional helper text
  - `placeholder` - Input placeholder
  - All other input/textarea attributes supported

  ## Examples

      # Basic text field
      <.form_field field={@form[:name]} type="text" label="Name" />

      # Email with description
      <.form_field
        field={@form[:email]}
        type="email"
        label="Email"
        description="We'll never share your email with anyone."
      />

      # Password with all features
      <.form_field
        field={@form[:password]}
        type="password"
        label="Password"
        description="Must be at least 8 characters"
        placeholder="Enter password"
        required
      />

      # Textarea
      <.form_field
        field={@form[:message]}
        type="textarea"
        label="Message"
        placeholder="Enter your message..."
      />

  """
  attr(:field, FormField,
    required: true,
    doc: "Phoenix form field struct retrieved from the form, for example: @form[:email]"
  )

  attr(:type, :string, default: "text")
  attr(:label, :string, required: true)
  attr(:description, :string, default: nil)
  attr(:placeholder, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:help_title, :string, default: nil, doc: "Title for inline help popover")
  attr(:help_text, :string, default: nil, doc: "Body text for inline help popover")

  attr(:rest, :global,
    include:
      ~w(disabled required autocomplete readonly maxlength minlength pattern aria-label autofocus multiple accept rows)
  )

  @spec form_field(map()) :: Rendered.t()
  def form_field(assigns) do
    # Generate consistent IDs for accessibility
    field_id = assigns.field.id || "field-#{assigns.field.name}"
    description_id = "#{field_id}-description"
    message_id = "#{field_id}-message"

    # Check if field has errors
    has_errors = assigns.field.errors != []

    # Build aria-describedby
    aria_describedby =
      [
        assigns.description && description_id,
        has_errors && message_id
      ]
      |> Enum.filter(& &1)
      |> Enum.join(" ")
      |> case do
        "" -> nil
        ids -> ids
      end

    assigns =
      assigns
      |> assign(:field_id, field_id)
      |> assign(:description_id, description_id)
      |> assign(:message_id, message_id)
      |> assign(:has_errors, has_errors)
      |> assign(:aria_describedby, aria_describedby)

    ~H"""
    <.form_item>
      <.label
        :if={@help_title || @help_text}
        for={@field_id}
        help_title={@help_title}
        help_text={@help_text}
      >
        {@label}
      </.label>
      <.form_label :if={!@help_title && !@help_text} for={@field_id} error={@has_errors}>
        {@label}
      </.form_label>
      <.textarea
        :if={@type == "textarea"}
        id={@field_id}
        name={@field.name}
        value={@field.value}
        placeholder={@placeholder}
        aria-invalid={@has_errors}
        aria-describedby={@aria_describedby}
        {@rest}
      />
      <.input
        :if={@type != "textarea"}
        type={@type}
        id={@field_id}
        name={@field.name}
        value={@field.value}
        placeholder={@placeholder}
        aria-invalid={@has_errors}
        aria-describedby={@aria_describedby}
        {@rest}
      />
      <.form_description :if={@description} id={@description_id}>
        {@description}
      </.form_description>
      <.form_message field={@field} id={@message_id} />
    </.form_item>
    """
  end

  @doc """
  Renders a toggle switch control for binary on/off states.

  The switch component provides a visual toggle interface that allows users to change
  between checked and unchecked states. It follows the shadcn/ui design with smooth
  animations and proper accessibility support.

  ## Usage Modes

  The switch supports two usage patterns:

  1. **Form usage** (default) - Works like a checkbox in a form, submits with form data:
     ```
     <.switch id="notifications" name="notifications" />
     ```

  2. **Interactive with server events** - Triggers LiveView event for immediate server updates:
     ```
     <.switch id="dark-mode" name="dark_mode" phx-click="toggle_dark_mode" />
     ```

  In both cases, the switch toggles visually on click (client-side), but with `phx-click`
  you can also handle the event on the server.

  ## Features

  - Client-side toggle for instant visual feedback
  - Works seamlessly in forms (submits checked/unchecked state)
  - Optional server-side events with phx-click
  - Semantic color tokens for theme support
  - Smooth sliding animation for thumb
  - Disabled state support
  - Focus visible ring styles
  - Proper accessibility (ARIA attributes)

  ## Attributes

  - `id` - ID for associating with a label
  - `name` - Input name for form submission
  - `value` - Value when checked (defaults to "true")
  - `checked` - Boolean to set initial checked state
  - `disabled` - Disables the switch
  - `class` - Additional CSS classes to merge with base styles
  - `phx-click` - Optional LiveView event to trigger on toggle

  ## Examples

      # In a form (no phx-click needed)
      <form phx-submit="save_settings">
        <.switch id="notifications" name="notifications" checked />
        <button type="submit">Save</button>
      </form>

      # With server event for immediate updates
      <.switch id="dark-mode" name="dark_mode" phx-click="toggle_dark_mode" />

      # With label
      <.flex gap="default">
        <.switch id="airplane-mode" name="airplane_mode" />
        <.label for="airplane-mode">Airplane Mode</.label>
      </.flex>

  """
  attr(:id, :string, required: true)
  attr(:name, :string, required: true)
  attr(:value, :string, default: "true")
  attr(:checked, :boolean, default: false)
  attr(:class, :string, default: nil)

  attr(:rest, :global,
    include:
      ~w(disabled required aria-label aria-describedby form autofocus phx-click phx-value-id)
  )

  @spec switch(map()) :: Rendered.t()
  def switch(assigns) do
    # Generate a unique ID for the checkbox input
    assigns = assign(assigns, :checkbox_id, "#{assigns.id}-checkbox")

    ~H"""
    <button
      type="button"
      role="switch"
      id={@id}
      aria-checked={to_string(@checked)}
      data-slot="switch"
      data-state={if @checked, do: "checked", else: "unchecked"}
      phx-click={
        if @rest[:"phx-click"] do
          # If phx-click provided, use it AND toggle visually
          JS.dispatch("click", to: "##{@checkbox_id}")
          |> JS.push(@rest[:"phx-click"])
        else
          # Otherwise just toggle the checkbox (for form usage)
          JS.dispatch("click", to: "##{@checkbox_id}")
        end
      }
      phx-value-id={@rest[:"phx-value-id"]}
      disabled={@rest[:disabled]}
      class={
        [
          # Base styles
          "peer inline-flex h-[1.15rem] w-8 shrink-0 items-center rounded-full border border-transparent shadow-xs",
          "transition-all outline-none",
          # Checked state - use semantic tokens
          "data-[state=checked]:bg-primary",
          # Unchecked state - use semantic tokens
          "data-[state=unchecked]:bg-input dark:data-[state=unchecked]:bg-input/80",
          # Focus styles
          "focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]",
          # Disabled state
          "disabled:cursor-not-allowed disabled:opacity-50",
          # Custom classes
          @class
        ]
      }
      {@rest}
    >
      <%!-- Hidden input for form submission (Phoenix form convention) --%>
      <input type="hidden" name={@name} value="false" disabled={@rest[:disabled]} />
      <input
        type="checkbox"
        id={@checkbox_id}
        name={@name}
        value={@value}
        checked={@checked}
        disabled={@rest[:disabled]}
        tabindex="-1"
        class="sr-only"
        aria-hidden="true"
        phx-update="ignore"
        phx-hook="SwitchToggle"
        data-switch-button-id={@id}
      />

      <%!-- Thumb --%>
      <span
        data-slot="switch-thumb"
        data-state={if @checked, do: "checked", else: "unchecked"}
        class={
          [
            # Base styles
            "pointer-events-none block size-4 rounded-full ring-0 transition-transform",
            # Background color - use semantic tokens
            "bg-background",
            "dark:data-[state=unchecked]:bg-foreground dark:data-[state=checked]:bg-primary-foreground",
            # Translation based on state
            "data-[state=checked]:translate-x-[calc(100%-2px)] data-[state=unchecked]:translate-x-0"
          ]
        }
      />
    </button>
    """
  end

  @doc """
  Renders a radio group container for radio button items.

  The radio group component provides a container for radio buttons where only one
  option can be selected at a time. This is the wrapper component that should contain
  multiple `<.radio_group_item>` components.

  ## Features

  - Grid layout with consistent spacing
  - Native radio button behavior (only one selectable)
  - Works with Phoenix forms
  - Keyboard navigation support
  - Semantic color tokens for theme support

  ## Attributes

  - `name` - The form field name (required for form submission)
  - `value` - The currently selected value
  - `class` - Additional CSS classes to merge with base styles

  ## Examples

      # Basic radio group
      <.radio_group name="notification_method" value="email">
        <.flex gap="default">
          <.radio_group_item value="email" id="email" name="notification_method" />
          <.label for="email">Email</.label>
        </.flex>
        <.flex gap="default">
          <.radio_group_item value="sms" id="sms" name="notification_method" />
          <.label for="sms">SMS</.label>
        </.flex>
        <.flex gap="default">
          <.radio_group_item value="push" id="push" name="notification_method" />
          <.label for="push">Push Notification</.label>
        </.flex>
      </.radio_group>

      # In a form
      <.form for={@form} phx-submit="save">
        <.radio_group name="plan" value={@form[:plan].value}>
          <.flex gap="default">
            <.radio_group_item value="free" id="plan-free" name="plan" />
            <.label for="plan-free">Free Plan</.label>
          </.flex>
          <.flex gap="default">
            <.radio_group_item value="pro" id="plan-pro" name="plan" />
            <.label for="plan-pro">Pro Plan</.label>
          </.flex>
        </.radio_group>
      </.form>

  """
  attr(:name, :string, required: true)
  attr(:value, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec radio_group(map()) :: Rendered.t()
  def radio_group(assigns) do
    ~H"""
    <div
      role="radiogroup"
      data-slot="radio-group"
      class={["grid gap-3", @class]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a single radio button item within a radio group.

  The radio button component displays a circular button that can be selected. It should
  be used within a `<.radio_group>` container and typically paired with a `<.label>`
  for accessibility.

  ## Usage Modes

  The radio button supports two usage patterns:

  1. **Form usage** (default, recommended) - Works like a native radio button in a form,
     manages state client-side with JavaScript, submits with form data:
     ```
     <form phx-submit="save">
       <.radio_group_item value="option" id="opt" name="choice" />
     </form>
     ```

  2. **Interactive with server events** - Optionally triggers LiveView events for
     immediate server updates (useful for settings that should apply immediately):
     ```
     <.radio_group_item value="dark" id="theme" name="theme"
       phx-click="change_theme" phx-value-theme="dark" />
     ```

  In both cases, the radio button toggles visually on click (client-side). With additional
  `phx-click` attributes, you can also handle events on the server for immediate updates.

  ## Features

  - Semantic color tokens for theme support
  - Checked indicator with circle icon
  - Focus visible ring styles
  - Error state styling via `aria-invalid`
  - Disabled state support
  - Smooth transitions
  - Client-side state management (no server round-trip unless you add phx-click)

  ## Attributes

  - `id` - ID for associating with a label (required)
  - `name` - Input name for form submission (required)
  - `value` - Value for this radio option (required)
  - `checked` - Boolean to set checked state
  - `disabled` - Disables the radio button
  - `class` - Additional CSS classes to merge with base styles
  - `phx-click` - Optional LiveView event to trigger on selection

  ## Examples

      # In a form (no phx-click needed - recommended)
      <form phx-submit="save_settings">
        <.radio_group name="plan" value="free">
          <.flex gap="default">
            <.radio_group_item value="free" id="plan-free" name="plan" checked />
            <.label for="plan-free">Free</.label>
          </.flex>
          <.flex gap="default">
            <.radio_group_item value="pro" id="plan-pro" name="plan" />
            <.label for="plan-pro">Pro</.label>
          </.flex>
        </.radio_group>
        <button type="submit">Save</button>
      </form>

      # With server event for immediate updates (optional)
      <.radio_group_item value="dark" id="theme-dark" name="theme"
        checked={@theme == "dark"}
        phx-click="change_theme" phx-value-theme="dark" />

      # Disabled
      <.radio_group_item value="disabled" id="disabled" name="choice" disabled />

  """
  attr(:id, :string, required: true)
  attr(:name, :string, required: true)
  attr(:value, :string, required: true)
  attr(:checked, :boolean, default: false)
  attr(:class, :string, default: nil)

  attr(:rest, :global,
    include:
      ~w(disabled required aria-invalid aria-describedby form autofocus phx-click phx-value-method phx-value-theme phx-value-plan)
  )

  @spec radio_group_item(map()) :: Rendered.t()
  def radio_group_item(assigns) do
    ~H"""
    <button
      type="button"
      role="radio"
      id={@id}
      aria-checked={to_string(@checked)}
      data-slot="radio-group-item"
      data-state={if @checked, do: "checked", else: "unchecked"}
      disabled={@rest[:disabled]}
      onclick={"document.getElementById('#{@id}-input').click()"}
      class={
        [
          # Base styles
          "border-input text-primary aspect-square size-4 shrink-0 rounded-full border shadow-xs",
          "transition-[color,box-shadow] outline-none cursor-pointer",
          # Dark mode background
          "dark:bg-input/30",
          # Focus styles
          "focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]",
          # Error/invalid state
          "aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive",
          # Disabled state
          "disabled:cursor-not-allowed disabled:opacity-50",
          # Custom classes
          @class
        ]
      }
      {@rest}
    >
      <%!-- Hidden radio input --%>
      <input
        type="radio"
        id={"#{@id}-input"}
        name={@name}
        value={@value}
        checked={@checked}
        disabled={@rest[:disabled]}
        tabindex="-1"
        class="sr-only"
        style="scroll-margin-top: -9999px !important;"
        aria-hidden="true"
        phx-update="ignore"
        phx-hook="RadioToggle"
        data-radio-button-id={@id}
      />

      <%!-- Indicator with circle icon --%>
      <span
        data-slot="radio-group-indicator"
        class={[
          "relative flex items-center justify-center",
          !@checked && "hidden"
        ]}
      >
        <span class="fill-primary absolute top-1/2 left-1/2 size-2 -translate-x-1/2 -translate-y-1/2 rounded-full bg-primary" />
      </span>
    </button>
    """
  end

  @doc """
  Renders a selectable card with a radio button.

  The radio card component displays a bordered card that contains a radio button
  and customizable content. Clicking anywhere on the card selects the radio button.
  Perfect for selection interfaces where users need to choose between multiple
  options with more context than a simple radio button.

  ## Usage Patterns

  Common use cases include:
  - Theme selection (Light, Dark, System)
  - Plan selection (Free, Pro, Enterprise)
  - Payment method selection
  - Shipping method selection
  - Game type selection (8-ball, 9-ball, 10-ball)
  - Break type selection (Winner, Loser, Alternating)

  ## Content Options

  You can use the component in two ways:

  1. **Structured layout** - Use convenience slots for common patterns:
     - `:visual` - Optional icon/image at the top
     - `:title` - Main heading
     - `:description` - Explanatory text
     - `:content` - Additional custom content

  2. **Fully custom** - Use `:inner_block` for complete control over layout

  ## Features

  - Entire card is clickable to select the radio button
  - Hover effect with background color transition
  - Integrates with existing radio_group_item component
  - Supports all radio_group_item attributes
  - Flexible content layout
  - Semantic color tokens for theme support
  - Accessible with proper ARIA attributes

  ## Examples

      # Basic card with title and description (structured)
      <.radio_group name="theme" value="system">
        <.radio_card value="system" id="theme-system" name="theme" checked>
          <:title>System</:title>
          <:description>Automatically match your device's system theme</:description>
        </.radio_card>

        <.radio_card value="light" id="theme-light" name="theme">
          <:title>Light Mode</:title>
          <:description>Always use light theme</:description>
        </.radio_card>
      </.radio_group>

      # Card with visual element (structured)
      <.radio_card value="8ball" id="game-8ball" name="game_type">
        <:visual>
          <img src="/images/8ball.svg" class="size-12" alt="8-Ball" />
        </:visual>
        <:title>8-Ball</:title>
        <:description>Standard 8-ball pool game</:description>
      </.radio_card>

      # Completely custom content layout
      <.radio_card value="pro" id="plan-pro" name="plan">
        <.flex items="start" gap="md">
          <.flex justify="center" class="size-12 rounded-full bg-primary/10">
            <.icon name="hero-star" class="size-6" />
          </.flex>
          <div class="flex-1">
            <h3 class="font-semibold">Pro Plan</h3>
            <p class="text-sm text-muted-foreground">For professionals</p>
            <div class="mt-2 text-2xl font-bold">$29/mo</div>
          </div>
        </.flex>
      </.radio_card>

  """
  attr(:id, :string, required: true)
  attr(:name, :string, required: true)
  attr(:value, :string, required: true)
  attr(:checked, :boolean, default: false)
  attr(:class, :string, default: nil)

  attr(:rest, :global,
    include:
      ~w(disabled required aria-invalid aria-describedby form autofocus phx-click phx-value-action)
  )

  slot(:visual, doc: "Optional visual element like an icon or image")
  slot(:title, doc: "Main title/label for the option")
  slot(:description, doc: "Optional description text")
  slot(:content, doc: "Optional additional custom content")
  slot(:inner_block, doc: "Completely custom content (alternative to structured slots)")

  @spec radio_card(map()) :: Rendered.t()
  def radio_card(assigns) do
    # Determine if using structured layout or custom content
    # Check if any structured slots are provided
    title = Map.get(assigns, :title, [])
    visual = Map.get(assigns, :visual, [])
    description = Map.get(assigns, :description, [])
    has_structured_content = title != [] or visual != [] or description != []

    assigns =
      assigns
      |> assign(:has_structured_content, has_structured_content)
      |> assign(:title, title)
      |> assign(:visual, visual)
      |> assign(:description, description)

    ~H"""
    <label
      for={@id}
      class={[
        "flex items-start gap-3 rounded-lg border border-border p-4 transition-colors cursor-pointer",
        "hover:bg-accent/50",
        @class
      ]}
    >
      <.radio_group_item
        value={@value}
        id={@id}
        name={@name}
        checked={@checked}
        class="mt-1 pointer-events-none"
        {@rest}
      />

      <%= if @has_structured_content do %>
        <%!-- Structured layout with convenience slots --%>
        <.flex direction="col" items="start" gap="sm" class="flex-1">
          <%= if @visual != [] do %>
            <div class="flex-shrink-0">
              {render_slot(@visual)}
            </div>
          <% end %>

          <.stack gap="xs" class="flex-1">
            <%= if @title != [] do %>
              <div class="font-medium text-sm leading-none">
                {render_slot(@title)}
              </div>
            <% end %>

            <%= if @description != [] do %>
              <p class="text-sm text-muted-foreground">
                {render_slot(@description)}
              </p>
            <% end %>
          </.stack>

          <%= if @content != [] do %>
            <div class="mt-2">
              {render_slot(@content)}
            </div>
          <% end %>
        </.flex>
      <% else %>
        <%!-- Fully custom content via inner_block --%>
        <div class="flex-1">
          {render_slot(@inner_block)}
        </div>
      <% end %>
    </label>
    """
  end

  @doc """
  Renders a custom select dropdown that allows users to pick from a list of options.

  This component matches the shadcn/ui Select design with a custom dropdown menu
  instead of a native select element. It provides full styling control and proper
  dark mode support.

  ## Features

  - Custom dropdown with full styling control
  - Semantic color tokens for theme support
  - Keyboard navigation (Arrow keys, Enter, Escape)
  - Search by typing
  - Focus visible ring styles
  - Error state styling via `aria-invalid`
  - Disabled state support
  - Smooth animations
  - Click outside to close

  ## Attributes

  - `id` - ID for the component (required)
  - `name` - Input name for form submission (required)
  - `value` - Currently selected value
  - `disabled` - Disables the select
  - `class` - Additional CSS classes for the trigger button
  - `placeholder` - Placeholder text when no value selected
  - `options` - List of `{label, value}` tuples or simple value list (required)

  ## Examples

      # Basic select
      <.select
        id="country"
        name="country"
        value={@country}
        placeholder="Select a country..."
        options={[{"United States", "us"}, {"Canada", "ca"}, {"Mexico", "mx"}]}
      />

      # With form integration
      <.select
        id="role"
        name="role"
        value={@form[:role].value}
        placeholder="Select a role..."
        options={[{"Admin", "admin"}, {"User", "user"}, {"Guest", "guest"}]}
      />

      # Disabled state
      <.select
        id="locked"
        name="locked"
        value="default"
        disabled
        options={[{"Default", "default"}]}
      />

      # With error state
      <.select
        id="category"
        name="category"
        aria-invalid="true"
        placeholder="Select category..."
        options={[{"Tech", "tech"}, {"Design", "design"}]}
      />

  """
  attr(:id, :string, required: true)
  attr(:name, :string, required: true)
  attr(:value, :any, default: nil)
  attr(:placeholder, :string, default: "Select an option...")
  attr(:options, :list, required: true)
  attr(:class, :string, default: nil)
  attr(:disabled, :boolean, default: false)

  attr(:rest, :global,
    include: ~w(required aria-invalid aria-describedby form phx-change phx-target)
  )

  @spec select(map()) :: Rendered.t()
  def select(assigns) do
    # Find the selected option label
    assigns =
      assigns
      |> assign_new(:selected_label, fn -> find_selected_label(assigns) end)
      |> assign_new(:has_phx_change, fn -> Map.has_key?(assigns.rest, :"phx-change") end)

    ~H"""
    <div
      id={"#{@id}-container"}
      class="relative w-fit"
      phx-click-away={JS.hide(to: "##{@id}-content")}
      phx-hook="SelectDropdown"
      data-select-id={@id}
    >
      <%!-- Hidden input for form submission --%>
      <input type="hidden" name={@name} value={@value || ""} id={"#{@id}-input"} />
      <%!-- Trigger Button --%>
      <button
        type="button"
        id={"#{@id}-trigger"}
        role="combobox"
        aria-expanded="false"
        aria-controls={"#{@id}-content"}
        aria-haspopup="listbox"
        disabled={@disabled}
        phx-click={
          JS.toggle(
            to: "##{@id}-content",
            in: {"ease-out duration-100", "opacity-0 scale-95", "opacity-100 scale-100"},
            out: {"ease-in duration-75", "opacity-100 scale-100", "opacity-0 scale-95"}
          )
          |> JS.toggle_attribute({"aria-expanded", "true", "false"}, to: "##{@id}-trigger")
        }
        data-slot="select-trigger"
        class={
          [
            # Base styles
            "flex h-9 w-fit min-w-[180px] items-center justify-between gap-2 rounded-md border border-input bg-transparent px-3 py-2",
            "text-sm whitespace-nowrap shadow-xs transition-[color,box-shadow] outline-none",
            # Text color
            @selected_label && "text-foreground",
            !@selected_label && "text-muted-foreground",
            # Dark mode background
            "dark:bg-input/30 dark:hover:bg-input/50",
            # Focus styles
            "focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]",
            # Error/invalid state
            "aria-invalid:border-destructive aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40",
            # Disabled state
            "disabled:cursor-not-allowed disabled:opacity-50",
            # Custom classes
            @class
          ]
        }
      >
        <span class="line-clamp-1 flex items-center gap-2">
          {@selected_label || @placeholder}
        </span>
        <%!-- Chevron Down Icon --%>
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="16"
          height="16"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
          class="size-4 opacity-50 shrink-0"
        >
          <path d="m6 9 6 6 6-6" />
        </svg>
      </button>
      <%!-- Dropdown Content --%>
      <div
        id={"#{@id}-content"}
        role="listbox"
        aria-labelledby={"#{@id}-trigger"}
        class="hidden absolute z-50 mt-1 min-w-[var(--radix-select-trigger-width)] max-h-[300px] overflow-y-auto rounded-md border border-border bg-popover text-popover-foreground shadow-md animate-in fade-in-0 zoom-in-95"
        style="width: max-content; min-width: 180px;"
      >
        <div class="p-1">
          <%= for option <- @options do %>
            <% {label, value} = if is_tuple(option), do: option, else: {option, option} %>
            <% is_selected = to_string(@value) == to_string(value) %>
            <button
              type="button"
              role="option"
              aria-selected={to_string(is_selected)}
              data-value={value}
              phx-click={
                js_commands =
                  JS.set_attribute({"value", value}, to: "##{@id}-input")
                  |> JS.hide(to: "##{@id}-content")
                  |> JS.toggle_attribute({"aria-expanded", "true", "false"}, to: "##{@id}-trigger")
                  |> JS.dispatch("change", to: "##{@id}-input")

                if @has_phx_change do
                  push_opts =
                    [value: %{@name => value}] ++
                      if(@rest[:"phx-target"], do: [target: @rest[:"phx-target"]], else: [])

                  JS.push(js_commands, @rest[:"phx-change"], push_opts)
                else
                  js_commands
                end
              }
              class={
                [
                  # Base styles
                  "relative flex w-full cursor-pointer items-center gap-2 rounded-sm py-1.5 pr-8 pl-2 text-sm outline-none select-none",
                  # Hover and focus
                  "hover:bg-accent hover:text-accent-foreground focus:bg-accent focus:text-accent-foreground",
                  # Disabled
                  "data-[disabled]:pointer-events-none data-[disabled]:opacity-50"
                ]
              }
            >
              <span class="flex items-center gap-2 line-clamp-1">
                {label}
              </span>
              <%!-- Check Icon for selected (always in DOM, hidden/shown by JS) --%>
              <span class={[
                "absolute right-2 flex size-3.5 items-center justify-center",
                !is_selected && "hidden"
              ]}>
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  width="16"
                  height="16"
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  class="size-4"
                >
                  <path d="M20 6 9 17l-5-5" />
                </svg>
              </span>
            </button>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  # Helper function to find the selected label from options
  @spec find_selected_label(map()) :: String.t() | nil
  defp find_selected_label(%{value: nil}), do: nil

  defp find_selected_label(%{value: _value} = assigns) do
    selected_option =
      Enum.find(assigns.options, fn opt ->
        if is_tuple(opt) do
          elem(opt, 1) == to_string(assigns.value)
        else
          to_string(opt) == to_string(assigns.value)
        end
      end)

    case selected_option do
      {label, _option_value} -> label
      value when is_binary(value) -> value
      _other -> nil
    end
  end

  @doc """
  Renders a container that groups related buttons together with consistent styling.

  The button_group component creates a visual grouping of buttons, commonly used for
  toolbars, segmented controls, and related actions. Buttons within the group have
  their borders merged and rounded corners adjusted to create a unified appearance.

  ## Features

  - Horizontal and vertical orientation support
  - Automatic border and radius adjustments for grouped buttons
  - Focus management with z-index stacking
  - Spacing for nested groups
  - Works with any button-like elements

  ## Attributes

  - `orientation` - Layout direction: "horizontal" (default) or "vertical"
  - `class` - Additional CSS classes to merge with base styles

  ## Examples

      # Basic horizontal button group
      <.button_group>
        <.button variant="outline">First</.button>
        <.button variant="outline">Second</.button>
        <.button variant="outline">Third</.button>
      </.button_group>

      # Vertical orientation
      <.button_group orientation="vertical">
        <.button variant="outline">Top</.button>
        <.button variant="outline">Middle</.button>
        <.button variant="outline">Bottom</.button>
      </.button_group>

      # With separators
      <.button_group>
        <.button variant="outline">Cut</.button>
        <.button variant="outline">Copy</.button>
        <.button_group_separator />
        <.button variant="outline">Paste</.button>
      </.button_group>

      # Nested groups (automatically spaced)
      <.button_group>
        <.button_group>
          <.button variant="outline">Bold</.button>
          <.button variant="outline">Italic</.button>
        </.button_group>
        <.button_group>
          <.button variant="outline">Link</.button>
          <.button variant="outline">Quote</.button>
        </.button_group>
      </.button_group>

      # With other elements (inputs, selects)
      <.button_group>
        <.input type="text" placeholder="Search..." />
        <.button variant="outline">Search</.button>
      </.button_group>

  """
  attr(:orientation, :string, default: "horizontal", values: ~w(horizontal vertical))
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec button_group(map()) :: Rendered.t()
  def button_group(assigns) do
    ~H"""
    <div
      role="group"
      data-slot="button-group"
      data-orientation={@orientation}
      class={
        [
          # Base styles with focus management
          "flex w-fit items-stretch",
          "[&>*]:focus-visible:z-10 [&>*]:focus-visible:relative",
          # Handle select elements
          "[&>[data-slot=select-trigger]:not([class*='w-'])]:w-fit",
          # Input flex behavior
          "[&>input]:flex-1",
          # Special handling for selects with hidden elements
          "has-[select[aria-hidden=true]:last-child]:[&>[data-slot=select-trigger]:last-of-type]:rounded-r-md",
          # Gap for nested button groups
          "has-[>[data-slot=button-group]]:gap-2",
          # Orientation-specific styles
          button_group_orientation_styles(@orientation),
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

  defp button_group_orientation_styles("horizontal") do
    [
      # Remove rounded corners and borders between elements
      "[&>*:not(:first-child)]:rounded-l-none",
      "[&>*:not(:first-child)]:border-l-0",
      "[&>*:not(:last-child)]:rounded-r-none"
    ]
  end

  defp button_group_orientation_styles("vertical") do
    [
      # Stack vertically
      "flex-col",
      # Remove rounded corners and borders between elements
      "[&>*:not(:first-child)]:rounded-t-none",
      "[&>*:not(:first-child)]:border-t-0",
      "[&>*:not(:last-child)]:rounded-b-none"
    ]
  end

  @doc """
  Renders a visual separator between buttons in a button group.

  The button_group_separator provides a visual divider within button groups,
  useful for separating different sets of related actions.

  ## Features

  - Automatic orientation detection from parent button_group
  - Semantic color token for theme support
  - Minimal styling that adapts to context

  ## Attributes

  - `orientation` - "vertical" (default) or "horizontal" - usually auto-detected from parent
  - `class` - Additional CSS classes to merge with base styles

  ## Examples

      # In horizontal button group (vertical separator)
      <.button_group>
        <.button variant="outline">Undo</.button>
        <.button variant="outline">Redo</.button>
        <.button_group_separator />
        <.button variant="outline">Cut</.button>
        <.button variant="outline">Copy</.button>
      </.button_group>

      # In vertical button group (horizontal separator)
      <.button_group orientation="vertical">
        <.button variant="outline">View</.button>
        <.button_group_separator orientation="horizontal" />
        <.button variant="outline">Edit</.button>
      </.button_group>

  """
  attr(:orientation, :string, default: "vertical", values: ~w(vertical horizontal))
  attr(:class, :string, default: nil)
  attr(:rest, :global)

  @spec button_group_separator(map()) :: Rendered.t()
  def button_group_separator(assigns) do
    ~H"""
    <div
      data-slot="button-group-separator"
      role="separator"
      aria-orientation={@orientation}
      class={
        [
          # Base styles
          "bg-input relative !m-0 self-stretch",
          # Vertical separator (in horizontal groups)
          @orientation == "vertical" && "h-auto w-px",
          # Horizontal separator (in vertical groups)
          @orientation == "horizontal" && "h-px w-full",
          # Custom classes
          @class
        ]
      }
      {@rest}
    />
    """
  end

  @doc """
  Renders text content within a button group with appropriate styling.

  The button_group_text component displays non-interactive text elements within
  button groups, such as labels or status indicators, with consistent styling
  that matches the button appearance.

  ## Features

  - Matches button styling for visual consistency
  - Semantic color tokens for theme support
  - Icon support with automatic sizing
  - Disabled appearance support

  ## Attributes

  - `class` - Additional CSS classes to merge with base styles

  ## Examples

      # Label in button group
      <.button_group>
        <.button_group_text>Format:</.button_group_text>
        <.button variant="outline">Bold</.button>
        <.button variant="outline">Italic</.button>
      </.button_group>

      # With icon
      <.button_group>
        <.button_group_text>
          <.icon name="hero-document-text" />
          Document
        </.button_group_text>
        <.button variant="outline">Edit</.button>
        <.button variant="outline">Share</.button>
      </.button_group>

      # Status indicator
      <.button_group>
        <.button variant="outline">Start</.button>
        <.button_group_text>Status: Running</.button_group_text>
        <.button variant="outline">Stop</.button>
      </.button_group>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec button_group_text(map()) :: Rendered.t()
  def button_group_text(assigns) do
    ~H"""
    <div
      data-slot="button-group-text"
      class={
        [
          # Base styles matching button appearance
          "bg-muted flex items-center gap-2 rounded-md border border-input px-4",
          "text-sm font-medium shadow-xs",
          # Icon handling
          "[&_svg]:pointer-events-none [&_svg:not([class*='size-'])]:size-4",
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

  @doc """
  Renders a container that groups inputs or textareas with additional information or actions.

  The InputGroup component displays supplementary content (icons, text, buttons) alongside
  inputs or textareas, enabling enhanced user interactions. It follows the shadcn/ui design
  with automatic focus management and proper theme support.

  ## Features

  - Support for inline and block alignment
  - Automatic focus state management
  - Error state styling via `aria-invalid`
  - Disabled state support
  - Semantic color tokens for theme support
  - Focus ring styles that encompass the entire group
  - Works with custom input controls via `data-slot="input-group-control"`

  ## Attributes

  - `disabled` - Boolean to disable the entire group
  - `class` - Additional CSS classes to merge with base styles

  ## Examples

      # Search input with icon
      <.input_group>
        <.input_group_addon align="inline-start">
          <.icon name="hero-magnifying-glass" />
        </.input_group_addon>
        <.input_group_input placeholder="Search..." />
      </.input_group>

      # URL input with prefix and suffix
      <.input_group>
        <.input_group_addon align="inline-start">
          <.input_group_text>https://</.input_group_text>
        </.input_group_addon>
        <.input_group_input placeholder="example.com" />
        <.input_group_addon align="inline-end">
          <.input_group_text>.com</.input_group_text>
        </.input_group_addon>
      </.input_group>

      # Currency input
      <.input_group>
        <.input_group_addon align="inline-start">
          <.input_group_text>$</.input_group_text>
        </.input_group_addon>
        <.input_group_input type="number" placeholder="0.00" />
        <.input_group_addon align="inline-end">
          <.input_group_text>USD</.input_group_text>
        </.input_group_addon>
      </.input_group>

      # Textarea with action buttons
      <.input_group>
        <.input_group_textarea placeholder="Write a message..." />
        <.input_group_addon align="block-end">
          <.input_group_button size="sm">
            <.icon name="hero-paper-airplane" />
            Send
          </.input_group_button>
          <.input_group_text>0/280</.input_group_text>
        </.input_group_addon>
      </.input_group>

  """
  attr(:disabled, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec input_group(map()) :: Rendered.t()
  def input_group(assigns) do
    ~H"""
    <div
      data-slot="input-group"
      data-disabled={@disabled}
      role="group"
      class={
        [
          # Base styles
          "group/input-group border-input dark:bg-input/30 relative flex w-full items-center rounded-md border shadow-xs transition-[color,box-shadow] outline-none",
          "h-9 min-w-0 has-[>textarea]:h-auto",
          # Variants based on alignment - add padding to inputs when addons are present
          "has-[>[data-align=inline-start]]:[&>[data-slot=input-group-control]]:pl-2",
          "has-[>[data-align=inline-end]]:[&>[data-slot=input-group-control]]:pr-2",
          "has-[>[data-align=block-start]]:h-auto has-[>[data-align=block-start]]:flex-col has-[>[data-align=block-start]]:[&>[data-slot=input-group-control]]:pb-3",
          "has-[>[data-align=block-end]]:h-auto has-[>[data-align=block-end]]:flex-col has-[>[data-align=block-end]]:[&>[data-slot=input-group-control]]:pt-3",
          # Focus state
          "has-[[data-slot=input-group-control]:focus-visible]:border-ring has-[[data-slot=input-group-control]:focus-visible]:ring-ring/50 has-[[data-slot=input-group-control]:focus-visible]:ring-[3px]",
          # Error state
          "has-[[data-slot][aria-invalid=true]]:ring-destructive/20 has-[[data-slot][aria-invalid=true]]:border-destructive dark:has-[[data-slot][aria-invalid=true]]:ring-destructive/40",
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

  @doc """
  Renders supplementary content alongside inputs or textareas in an InputGroup.

  The InputGroupAddon provides a container for icons, text, buttons, or other content
  that enhances the input field. It supports multiple alignment options and automatically
  focuses the input when clicked (unless clicking a button).

  ## Features

  - Four alignment options: inline-start, inline-end, block-start, block-end
  - Automatic input focus on click (skips buttons)
  - Icon auto-sizing
  - Muted text styling for subtle appearance
  - Semantic color tokens for theme support

  ## Attributes

  - `align` - Position of the addon: "inline-start" (left), "inline-end" (right),
              "block-start" (top), "block-end" (bottom). Default: "inline-start"
  - `class` - Additional CSS classes to merge with base styles

  ## Examples

      # Icon on the left
      <.input_group>
        <.input_group_addon align="inline-start">
          <.icon name="hero-envelope" />
        </.input_group_addon>
        <.input_group_input type="email" />
      </.input_group>

      # Text on the right
      <.input_group>
        <.input_group_input placeholder="Username" />
        <.input_group_addon align="inline-end">
          <.input_group_text>@example.com</.input_group_text>
        </.input_group_addon>
      </.input_group>

      # Multiple items in addon
      <.input_group>
        <.input_group_textarea />
        <.input_group_addon align="block-end">
          <.input_group_button size="sm">Submit</.input_group_button>
          <.input_group_text>Max 280 chars</.input_group_text>
        </.input_group_addon>
      </.input_group>

  """
  attr(:align, :string,
    default: "inline-start",
    values: ~w(inline-start inline-end block-start block-end)
  )

  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec input_group_addon(map()) :: Rendered.t()
  def input_group_addon(assigns) do
    ~H"""
    <div
      role="group"
      data-slot="input-group-addon"
      data-align={@align}
      phx-click={JS.dispatch("focus", to: "[data-slot=input-group-control]")}
      class={
        [
          # Base styles
          "text-muted-foreground flex h-auto cursor-text items-center justify-center gap-2 py-1.5 text-sm font-medium select-none [&>svg:not([class*='size-'])]:size-4 [&>kbd]:rounded-[calc(var(--radius)-5px)] group-data-[disabled=true]/input-group:opacity-50",
          # Alignment styles
          input_group_addon_align(@align),
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

  defp input_group_addon_align("inline-start") do
    [
      "order-first pl-3 has-[>button]:ml-[-0.45rem] has-[>kbd]:ml-[-0.35rem]"
    ]
  end

  defp input_group_addon_align("inline-end") do
    [
      "order-last pr-3 has-[>button]:mr-[-0.45rem] has-[>kbd]:mr-[-0.35rem]"
    ]
  end

  defp input_group_addon_align("block-start") do
    [
      "order-first w-full justify-start px-3 pt-3 [.border-b]:pb-3 group-has-[>input]/input-group:pt-2.5"
    ]
  end

  defp input_group_addon_align("block-end") do
    [
      "order-last w-full justify-start px-3 pb-3 [.border-t]:pt-3 group-has-[>input]/input-group:pb-2.5"
    ]
  end

  @doc """
  Renders a button optimized for use within InputGroup components.

  The InputGroupButton provides action buttons that integrate seamlessly with
  input groups, with smaller sizes appropriate for inline use.

  ## Features

  - Compact sizes optimized for input groups
  - Ghost variant by default for subtle appearance
  - Icon auto-sizing
  - Semantic color tokens for theme support
  - All button variants supported

  ## Attributes

  - `variant` - Button variant (default, destructive, outline, secondary, ghost, link)
  - `size` - Button size: "xs", "sm", "icon-xs", "icon-sm". Default: "xs"
  - `type` - Button type attribute. Default: "button"
  - `class` - Additional CSS classes to merge with base styles

  ## Examples

      # Submit button in textarea
      <.input_group>
        <.input_group_textarea />
        <.input_group_addon align="block-end">
          <.input_group_button size="sm" variant="default">
            <.icon name="hero-paper-airplane" />
            Send
          </.input_group_button>
        </.input_group_addon>
      </.input_group>

      # Icon-only button
      <.input_group>
        <.input_group_input type="password" />
        <.input_group_addon align="inline-end">
          <.input_group_button size="icon-xs" variant="ghost" aria-label="Show password">
            <.icon name="hero-eye" />
          </.input_group_button>
        </.input_group_addon>
      </.input_group>

  """
  attr(:variant, :string,
    default: "ghost",
    values: ~w(default destructive outline secondary ghost link)
  )

  attr(:size, :string, default: "xs", values: ~w(xs sm icon-xs icon-sm))
  attr(:type, :string, default: "button")
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(disabled aria-label phx-click phx-value-id))
  slot(:inner_block, required: true)

  @spec input_group_button(map()) :: Rendered.t()
  def input_group_button(assigns) do
    ~H"""
    <button
      type={@type}
      data-size={@size}
      class={
        [
          # Base styles from button component
          "inline-flex items-center justify-center gap-2 whitespace-nowrap font-medium transition-all",
          "disabled:pointer-events-none disabled:opacity-50",
          "[&_svg]:pointer-events-none [&_svg]:shrink-0",
          "outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]",
          # Variant styles
          button_variant(@variant),
          # Input group button size styles
          input_group_button_size(@size),
          # Custom classes
          @class
        ]
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  defp input_group_button_size("xs") do
    "h-6 gap-1 px-2 rounded-[calc(var(--radius)-5px)] [&>svg:not([class*='size-'])]:size-3.5 has-[>svg]:px-2 text-sm shadow-none"
  end

  defp input_group_button_size("sm") do
    "h-8 px-2.5 gap-1.5 rounded-md has-[>svg]:px-2.5 text-sm shadow-none"
  end

  defp input_group_button_size("icon-xs") do
    "size-6 rounded-[calc(var(--radius)-5px)] p-0 has-[>svg]:p-0 [&>svg:not([class*='size-'])]:size-3.5 text-sm shadow-none"
  end

  defp input_group_button_size("icon-sm") do
    "size-8 p-0 has-[>svg]:p-0 [&>svg:not([class*='size-'])]:size-4 text-sm shadow-none"
  end

  @doc """
  Renders text content within InputGroup addons.

  The InputGroupText provides styled text elements for displaying labels,
  units, domain names, or other textual information within input groups.

  ## Features

  - Muted text styling for subtle appearance
  - Icon auto-sizing
  - Gap spacing between multiple elements
  - Semantic color tokens for theme support

  ## Attributes

  - `class` - Additional CSS classes to merge with base styles

  ## Examples

      # Currency symbol
      <.input_group>
        <.input_group_addon align="inline-start">
          <.input_group_text>$</.input_group_text>
        </.input_group_addon>
        <.input_group_input type="number" />
      </.input_group>

      # Domain suffix
      <.input_group>
        <.input_group_input placeholder="username" />
        <.input_group_addon align="inline-end">
          <.input_group_text>@example.com</.input_group_text>
        </.input_group_addon>
      </.input_group>

      # With icon
      <.input_group>
        <.input_group_addon align="inline-start">
          <.input_group_text>
            <.icon name="hero-globe-alt" />
            https://
          </.input_group_text>
        </.input_group_addon>
        <.input_group_input />
      </.input_group>

  """
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  @spec input_group_text(map()) :: Rendered.t()
  def input_group_text(assigns) do
    ~H"""
    <span
      class={[
        "text-muted-foreground flex items-center gap-2 text-sm [&_svg]:pointer-events-none [&_svg:not([class*='size-'])]:size-4",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </span>
    """
  end

  @doc """
  Renders an input optimized for use within InputGroup components.

  The InputGroupInput is a specialized version of the base input component,
  designed to work seamlessly within input groups with transparent backgrounds
  and no borders or shadows.

  ## Features

  - Transparent background and border
  - No shadow or focus ring (handled by parent InputGroup)
  - Flexible width (flex-1)
  - All standard input features and types supported
  - Automatic focus state management via parent

  ## Attributes

  - `type` - Input type (text, email, password, number, etc.). Default: "text"
  - `name` - Input name for form submission
  - `value` - Input value
  - `placeholder` - Placeholder text
  - `class` - Additional CSS classes to merge with base styles

  ## Examples

      # Basic usage
      <.input_group>
        <.input_group_input placeholder="Enter text..." />
      </.input_group>

      # Email input with icon
      <.input_group>
        <.input_group_addon align="inline-start">
          <.icon name="hero-envelope" />
        </.input_group_addon>
        <.input_group_input type="email" name="email" placeholder="Email" />
      </.input_group>

      # With error state
      <.input_group>
        <.input_group_input type="text" name="username" aria-invalid="true" />
      </.input_group>

  """
  attr(:type, :string, default: "text")
  attr(:name, :string, default: nil)
  attr(:value, :string, default: nil)
  attr(:placeholder, :string, default: nil)
  attr(:class, :string, default: nil)

  attr(:rest, :global,
    include:
      ~w(disabled required autocomplete readonly maxlength minlength pattern id aria-label aria-invalid aria-describedby form autofocus)
  )

  @spec input_group_input(map()) :: Rendered.t()
  def input_group_input(assigns) do
    ~H"""
    <input
      type={@type}
      name={@name}
      value={@value}
      placeholder={@placeholder}
      data-slot="input-group-control"
      class={[
        "flex-1 rounded-none border-0 bg-transparent shadow-none focus-visible:ring-0 dark:bg-transparent",
        "px-3 text-base md:text-sm text-foreground outline-none",
        "placeholder:text-muted-foreground",
        "disabled:cursor-not-allowed disabled:opacity-50",
        @class
      ]}
      {@rest}
    />
    """
  end

  @doc """
  Renders a textarea optimized for use within InputGroup components.

  The InputGroupTextarea is a specialized version of the base textarea component,
  designed to work seamlessly within input groups with transparent backgrounds,
  no borders or shadows, and automatic content-based sizing.

  ## Features

  - Transparent background and border
  - No shadow or focus ring (handled by parent InputGroup)
  - Flexible width (flex-1)
  - Resize-none to prevent layout issues
  - Content-based height with field-sizing
  - Automatic focus state management via parent

  ## Attributes

  - `name` - Input name for form submission
  - `value` - Textarea content
  - `placeholder` - Placeholder text
  - `rows` - Number of visible text lines (optional)
  - `class` - Additional CSS classes to merge with base styles

  ## Examples

      # Basic usage
      <.input_group>
        <.input_group_textarea placeholder="Write a message..." />
      </.input_group>

      # With action buttons at bottom
      <.input_group>
        <.input_group_textarea name="comment" placeholder="Add a comment..." />
        <.input_group_addon align="block-end">
          <.input_group_button size="sm" variant="default">
            <.icon name="hero-paper-airplane" />
            Send
          </.input_group_button>
          <.input_group_text>0/280</.input_group_text>
        </.input_group_addon>
      </.input_group>

  """
  attr(:name, :string, default: nil)
  attr(:value, :string, default: nil)
  attr(:placeholder, :string, default: nil)
  attr(:class, :string, default: nil)

  attr(:rest, :global,
    include:
      ~w(disabled required readonly maxlength minlength rows id aria-label aria-invalid aria-describedby form autofocus)
  )

  @spec input_group_textarea(map()) :: Rendered.t()
  def input_group_textarea(assigns) do
    ~H"""
    <textarea
      name={@name}
      placeholder={@placeholder}
      data-slot="input-group-control"
      class={[
        "flex-1 resize-none rounded-none border-0 bg-transparent px-3 py-3 shadow-none focus-visible:ring-0 dark:bg-transparent",
        "text-base md:text-sm text-foreground outline-none",
        "placeholder:text-muted-foreground",
        "disabled:cursor-not-allowed disabled:opacity-50",
        @class
      ]}
      {@rest}
    >{@value}</textarea>
    """
  end

  @doc """
  Renders a slider input for selecting a value from within a given range.

  The slider component provides a visual interface for selecting numeric values
  along a track. It supports both single value and range selection, with full
  keyboard accessibility and consistent styling.

  ## Features

  - Native HTML5 range input with custom styling
  - Semantic color tokens for theme support
  - Smooth thumb transitions and hover effects
  - Focus visible ring styles for keyboard navigation
  - Disabled state support
  - Optional value display
  - Vertical orientation support
  - Form integration with proper name/value

  ## Attributes

  - `id` - ID for the slider (required)
  - `name` - Input name for form submission (required)
  - `value` - Current value (defaults to min)
  - `min` - Minimum value (default: 0)
  - `max` - Maximum value (default: 100)
  - `step` - Step increment (default: 1)
  - `orientation` - "horizontal" (default) or "vertical"
  - `disabled` - Disables the slider
  - `show_value` - Shows the current value next to the slider
  - `class` - Additional CSS classes

  ## Examples

      # Basic slider
      <.slider id="volume" name="volume" />

      # With value
      <.slider id="brightness" name="brightness" value={75} />

      # With custom range
      <.slider id="price" name="price" min={0} max={1000} step={10} />

      # With value display
      <.slider id="opacity" name="opacity" value={50} show_value />

      # Disabled
      <.slider id="locked" name="locked" value={30} disabled />

      # In a form
      <form phx-submit="save">
        <.slider id="rating" name="rating" min={1} max={5} step={1} value={3} />
        <button type="submit">Submit</button>
      </form>

      # With LiveView event
      <.slider
        id="volume"
        name="volume"
        value={@volume}
        phx-change="volume_changed"
      />

  """
  attr(:id, :string, required: true)
  attr(:name, :string, required: true)
  attr(:value, :any, default: nil)
  attr(:min, :integer, default: 0)
  attr(:max, :integer, default: 100)
  attr(:step, :integer, default: 1)
  attr(:orientation, :string, default: "horizontal", values: ~w(horizontal vertical))
  attr(:show_value, :boolean, default: false)
  attr(:class, :string, default: nil)

  attr(:rest, :global,
    include: ~w(disabled aria-label aria-describedby form autofocus phx-change phx-target)
  )

  @spec slider(map()) :: Rendered.t()
  def slider(assigns) do
    # Default value to min if not provided
    assigns =
      assign_new(assigns, :current_value, fn ->
        if assigns.value, do: assigns.value, else: assigns.min
      end)

    ~H"""
    <div
      data-slot="slider"
      data-orientation={@orientation}
      class={[
        "relative flex touch-none select-none items-center",
        @orientation == "horizontal" && "w-full",
        @orientation == "vertical" && "h-full min-h-44 w-auto flex-col",
        @rest[:disabled] && "opacity-50",
        @class
      ]}
    >
      <input
        type="range"
        id={@id}
        name={@name}
        value={@current_value}
        min={@min}
        max={@max}
        step={@step}
        data-orientation={@orientation}
        phx-hook="Slider"
        class={[
          # Base styles - Reset browser default appearance
          "appearance-none bg-transparent cursor-pointer outline-none",
          # Horizontal orientation
          @orientation == "horizontal" && "w-full h-1.5",
          # Vertical orientation
          @orientation == "vertical" && "h-full w-1.5 writing-mode-vertical-lr",
          # Track styles (Webkit - Chrome, Safari, Edge)
          "[&::-webkit-slider-runnable-track]:h-1.5 [&::-webkit-slider-runnable-track]:w-full",
          "[&::-webkit-slider-runnable-track]:rounded-full [&::-webkit-slider-runnable-track]:bg-muted",
          # Track styles (Firefox)
          "[&::-moz-range-track]:h-1.5 [&::-moz-range-track]:w-full",
          "[&::-moz-range-track]:rounded-full [&::-moz-range-track]:bg-muted",
          # Thumb styles (Webkit)
          "[&::-webkit-slider-thumb]:appearance-none",
          "[&::-webkit-slider-thumb]:size-4 [&::-webkit-slider-thumb]:rounded-full",
          "[&::-webkit-slider-thumb]:border [&::-webkit-slider-thumb]:border-primary",
          "[&::-webkit-slider-thumb]:bg-background [&::-webkit-slider-thumb]:shadow-sm",
          "[&::-webkit-slider-thumb]:transition-[transform,box-shadow]",
          "[&::-webkit-slider-thumb]:-mt-[5px]",
          # Thumb hover (Webkit)
          "[&::-webkit-slider-thumb:hover]:ring-4 [&::-webkit-slider-thumb:hover]:ring-ring/50",
          # Thumb styles (Firefox)
          "[&::-moz-range-thumb]:size-4 [&::-moz-range-thumb]:rounded-full",
          "[&::-moz-range-thumb]:border [&::-moz-range-thumb]:border-primary",
          "[&::-moz-range-thumb]:bg-background [&::-moz-range-thumb]:shadow-sm",
          "[&::-moz-range-thumb]:transition-[transform,box-shadow]",
          # Thumb hover (Firefox)
          "[&::-moz-range-thumb:hover]:ring-4 [&::-moz-range-thumb:hover]:ring-ring/50",
          # Focus styles (Webkit)
          "focus-visible:[&::-webkit-slider-thumb]:ring-4 focus-visible:[&::-webkit-slider-thumb]:ring-ring/50",
          # Focus styles (Firefox)
          "focus-visible:[&::-moz-range-thumb]:ring-4 focus-visible:[&::-moz-range-thumb]:ring-ring/50",
          # Disabled state
          "disabled:pointer-events-none disabled:opacity-50"
        ]}
        {@rest}
      />
      <span
        :if={@show_value}
        class={[
          "text-sm font-medium text-foreground tabular-nums",
          @orientation == "horizontal" && "ml-3",
          @orientation == "vertical" && "mt-3"
        ]}
      >
        {@current_value}
      </span>
    </div>
    """
  end

  @doc """
  Renders a slider with a filled range track showing the selected value visually.

  This enhanced slider component shows the filled portion of the track from min
  to the current value, providing better visual feedback. It uses a custom
  implementation with proper styling for both light and dark modes.

  ## Features

  - Filled track showing selected range
  - All features from the basic slider component
  - Visual feedback for the selected value
  - Smooth animations and transitions
  - Full keyboard accessibility

  ## Attributes

  Same as `slider/1` with identical behavior.

  ## Examples

      # Basic filled slider
      <.slider_filled id="volume" name="volume" value={50} />

      # With value display
      <.slider_filled id="progress" name="progress" value={75} show_value />

      # Custom range
      <.slider_filled id="price" name="price" min={100} max={500} step={25} value={250} />

  """
  attr(:id, :string, required: true)
  attr(:name, :string, required: true)
  attr(:value, :any, default: nil)
  attr(:min, :integer, default: 0)
  attr(:max, :integer, default: 100)
  attr(:step, :integer, default: 1)
  attr(:orientation, :string, default: "horizontal", values: ~w(horizontal vertical))
  attr(:show_value, :boolean, default: false)
  attr(:class, :string, default: nil)

  attr(:rest, :global,
    include: ~w(disabled aria-label aria-describedby form autofocus phx-change phx-target)
  )

  @spec slider_filled(map()) :: Rendered.t()
  def slider_filled(assigns) do
    # Default value to min if not provided
    current_value = if assigns.value, do: assigns.value, else: assigns.min
    # Calculate fill percentage
    range = assigns.max - assigns.min
    fill_percent = if range > 0, do: (current_value - assigns.min) / range * 100, else: 0

    assigns =
      assigns
      |> assign(:current_value, current_value)
      |> assign(:fill_percent, fill_percent)

    ~H"""
    <div
      data-slot="slider"
      data-orientation={@orientation}
      class={[
        "flex touch-none select-none items-center",
        @orientation == "horizontal" && "w-full",
        @orientation == "vertical" && "h-full min-h-44 w-auto flex-col",
        @rest[:disabled] && "opacity-50",
        @class
      ]}
    >
      <%!-- Slider track wrapper - contains both custom track and input --%>
      <div
        class={[
          "relative flex-1",
          @orientation == "horizontal" && "h-4 w-full",
          @orientation == "vertical" && "h-full w-4"
        ]}
      >
        <%!-- Custom track background --%>
        <div
          class={[
            "absolute rounded-full bg-muted",
            @orientation == "horizontal" && "h-1.5 w-full top-1/2 -translate-y-1/2",
            @orientation == "vertical" && "w-1.5 h-full left-1/2 -translate-x-1/2"
          ]}
        >
          <%!-- Filled range --%>
          <div
            class={[
              "absolute bg-primary rounded-full",
              @orientation == "horizontal" && "h-full left-0",
              @orientation == "vertical" && "w-full bottom-0"
            ]}
            style={
              if @orientation == "horizontal",
                do: "width: #{@fill_percent}%",
                else: "height: #{@fill_percent}%"
            }
          />
        </div>
        <%!-- Range input overlay --%>
        <input
          type="range"
          id={@id}
          name={@name}
          value={@current_value}
          min={@min}
          max={@max}
          step={@step}
          data-orientation={@orientation}
          phx-hook="SliderFilled"
          data-slider-container={@id}
          class={[
            # Position to fill the wrapper
            "absolute inset-0 appearance-none bg-transparent cursor-pointer outline-none",
            @orientation == "horizontal" && "w-full h-full",
            @orientation == "vertical" && "h-full w-full",
            # Hide track (we use custom track above)
            "[&::-webkit-slider-runnable-track]:bg-transparent [&::-webkit-slider-runnable-track]:h-full",
            "[&::-moz-range-track]:bg-transparent [&::-moz-range-track]:h-full",
            # Thumb styles (Webkit)
            "[&::-webkit-slider-thumb]:appearance-none",
            "[&::-webkit-slider-thumb]:size-4 [&::-webkit-slider-thumb]:rounded-full",
            "[&::-webkit-slider-thumb]:border [&::-webkit-slider-thumb]:border-primary",
            "[&::-webkit-slider-thumb]:bg-background [&::-webkit-slider-thumb]:shadow-sm",
            "[&::-webkit-slider-thumb]:transition-[transform,box-shadow]",
            # Thumb hover (Webkit)
            "[&::-webkit-slider-thumb:hover]:ring-4 [&::-webkit-slider-thumb:hover]:ring-ring/50",
            # Thumb styles (Firefox)
            "[&::-moz-range-thumb]:size-4 [&::-moz-range-thumb]:rounded-full",
            "[&::-moz-range-thumb]:border [&::-moz-range-thumb]:border-primary",
            "[&::-moz-range-thumb]:bg-background [&::-moz-range-thumb]:shadow-sm",
            "[&::-moz-range-thumb]:transition-[transform,box-shadow]",
            # Thumb hover (Firefox)
            "[&::-moz-range-thumb:hover]:ring-4 [&::-moz-range-thumb:hover]:ring-ring/50",
            # Focus styles
            "focus-visible:[&::-webkit-slider-thumb]:ring-4 focus-visible:[&::-webkit-slider-thumb]:ring-ring/50",
            "focus-visible:[&::-moz-range-thumb]:ring-4 focus-visible:[&::-moz-range-thumb]:ring-ring/50",
            # Disabled state
            "disabled:pointer-events-none disabled:opacity-50"
          ]}
          {@rest}
        />
      </div>
      <span
        :if={@show_value}
        class={[
          "text-sm font-medium text-foreground tabular-nums shrink-0",
          @orientation == "horizontal" && "ml-3",
          @orientation == "vertical" && "mt-3"
        ]}
      >
        {@current_value}
      </span>
    </div>
    """
  end
end
