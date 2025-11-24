defmodule UiKit.Components.Ui.ChipInput do
  @moduledoc """
  Chip Input component for managing arrays as removable chips.

  Displays a list of values as chips (badges) with remove buttons, plus an input
  field for adding new values. Supports keyboard shortcuts and optional suggestions.

  ## Features

  - Display values as removable chips using Badge component
  - Input field for typing new values
  - Enter, Space, or Comma adds new chip
  - Backspace on empty input removes last chip
  - Click X button to remove specific chip
  - Optional suggestions dropdown while typing
  - Keyboard accessible navigation
  - Semantic token styling

  ## Basic Usage

      <.chip_input
        id="tags-input"
        values={@current_tags}
        placeholder="Add tag..."
        on_add={JS.push("add_tag")}
        on_remove={JS.push("remove_tag")}
      />

  ## With Suggestions

      <.chip_input
        id="tags-input"
        values={@current_tags}
        placeholder="Add tag..."
        suggestions={@available_tags}
        on_add="add_tag"
        on_remove="remove_tag"
      />

  ## LiveView Event Handling

      def handle_event("add_tag", %{"value" => tag}, socket) do
        {:noreply, update(socket, :current_tags, fn tags -> [tag | tags] end)}
      end

      def handle_event("remove_tag", %{"value" => tag}, socket) do
        {:noreply, update(socket, :current_tags, &List.delete(&1, tag))}
      end

  """
  use Phoenix.Component

  import UiKit.Components.CoreComponents, only: [icon: 1]
  import UiKit.Components.Ui.FeedbackStatus, only: [badge: 1]

  alias Phoenix.LiveView.JS
  alias Phoenix.LiveView.Rendered

  @doc """
  Renders a chip input component for managing array values.

  Values are displayed as badges with remove buttons. The input field allows
  adding new values via keyboard shortcuts (Enter, Space, Comma).

  ## Modes

  The component operates in two modes:

  ### Client-side mode (default)
  When `on_add` and `on_remove` are NOT provided, the component manages its own
  state entirely in JavaScript. Values are stored in a hidden input field with
  the name attribute, making it perfect for standard form submissions.

      <.chip_input
        id="tags-input"
        name="post[tags]"
        value={@post.tags}
      />

  ### Server-side mode
  When `on_add` or `on_remove` are provided, the component sends events to the
  server for every add/remove operation. Use this when you need server-side
  validation or real-time updates.

      <.chip_input
        id="tags-input"
        values={@tags}
        on_add="add_tag"
        on_remove="remove_tag"
      />

  ## Attributes

  - `id` - Required unique identifier
  - `name` - Form field name for client-side mode (e.g., "post[tags][]")
  - `value` - Initial values (client-side mode, can be list or comma-separated string)
  - `values` - Current values (server-side mode, list only)
  - `placeholder` - Placeholder text for input field (default: "Add value...")
  - `suggestions` - Optional list of suggested values to show in dropdown
  - `on_add` - Event name or JS command for adding a chip (enables server-side mode)
  - `on_remove` - Event name or JS command for removing a chip (enables server-side mode)
  - `class` - Additional CSS classes for the container
  - `input_class` - Additional CSS classes for the input field
  - `allow_duplicates` - Whether to allow duplicate values (default: false)

  """
  attr(:id, :string, required: true)
  attr(:name, :string, default: nil)
  attr(:value, :any, default: nil)
  attr(:values, :list, default: [])
  attr(:placeholder, :string, default: "Add value...")
  attr(:suggestions, :list, default: [])
  attr(:on_add, :any, default: nil)
  attr(:on_remove, :any, default: nil)
  attr(:class, :string, default: nil)
  attr(:input_class, :string, default: nil)
  attr(:allow_duplicates, :boolean, default: false)
  attr(:rest, :global)

  @spec chip_input(map()) :: Rendered.t()
  def chip_input(assigns) do
    # Determine mode first
    server_mode = !is_nil(assigns.on_add) || !is_nil(assigns.on_remove)

    # Determine initial values based on mode
    initial_values =
      cond do
        # Server-side mode uses :values
        server_mode -> assigns.values
        # Client-side mode uses :value
        is_list(assigns.value) -> assigns.value
        is_binary(assigns.value) -> String.split(assigns.value, ",", trim: true)
        true -> []
      end

    assigns =
      assigns
      |> assign(:server_mode, server_mode)
      |> assign(:initial_values, initial_values)
      |> assign_new(:has_suggestions, fn -> !Enum.empty?(assigns.suggestions) end)

    ~H"""
    <div
      id={@id}
      class={["chip-input-container", @class]}
      phx-hook="ChipInput"
      data-allow-duplicates={to_string(@allow_duplicates)}
      data-server-mode={to_string(@server_mode)}
      {@rest}
    >
      <%!-- Hidden input for form submission (client-side mode only) --%>
      <%= if !@server_mode && @name do %>
        <input type="hidden" name={@name} value="" data-chip-input-field />
        <%= for value <- @initial_values do %>
          <input type="hidden" name={@name <> "[]"} value={value} data-chip-hidden-value />
        <% end %>
      <% end %>

      <div class={[
        "flex min-h-10 flex-wrap items-center gap-2 rounded-md border border-input bg-background px-3 py-2",
        "focus-within:ring-2 focus-within:ring-ring focus-within:ring-offset-2 focus-within:ring-offset-background"
      ]}>
        <%!-- Existing chips/badges --%>
        <%= for value <- @initial_values do %>
          <.badge variant="secondary" class="gap-1 pl-2 pr-1" data-chip-value={value}>
            {value}
            <button
              type="button"
              data-chip-remove
              phx-click={if @server_mode, do: build_remove_event(@on_remove, @id, value), else: nil}
              class="ml-1 rounded-sm hover:bg-secondary-foreground/20 focus-visible:outline-hidden focus-visible:ring-1 focus-visible:ring-ring"
              aria-label={"Remove #{value}"}
            >
              <.icon name="hero-x-mark" class="size-3" />
            </button>
          </.badge>
        <% end %>

        <%!-- Input field --%>
        <input
          type="text"
          id={"#{@id}-input"}
          data-chip-input
          placeholder={@placeholder}
          class={[
            "flex-1 min-w-[120px] bg-transparent text-sm outline-hidden placeholder:text-muted-foreground",
            "disabled:cursor-not-allowed disabled:opacity-50",
            @input_class
          ]}
          autocomplete="off"
        />
      </div>

      <%!-- Suggestions dropdown (optional) --%>
      <%= if @has_suggestions do %>
        <div data-popover data-state="closed" class="relative">
          <div class="hidden" data-suggestions-trigger></div>
          <div
            data-popover-content
            data-state="closed"
            class={[
              "absolute z-50 mt-1 w-full min-w-[200px] rounded-md border border-border bg-popover p-1 text-popover-foreground shadow-md",
              "data-[state=open]:animate-in data-[state=closed]:animate-out",
              "data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0",
              "data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95",
              "data-[state=closed]:hidden"
            ]}
          >
            <div class="max-h-[200px] overflow-y-auto" role="listbox">
              <%= for suggestion <- @suggestions do %>
                <div
                  role="option"
                  data-suggestion={suggestion}
                  phx-click={build_add_event(@on_add, @id, suggestion)}
                  class={[
                    "flex cursor-pointer items-center rounded-sm px-2 py-1.5 text-sm outline-hidden",
                    "hover:bg-accent hover:text-accent-foreground",
                    "focus-visible:bg-accent focus-visible:text-accent-foreground"
                  ]}
                  tabindex="0"
                >
                  {suggestion}
                </div>
              <% end %>
            </div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  # Builds the event for removing a chip
  @spec build_remove_event(any(), String.t(), String.t()) :: JS.t() | String.t()
  defp build_remove_event(nil, _id, _value), do: ""

  defp build_remove_event(event_name, id, value) when is_binary(event_name) do
    JS.push(event_name, value: %{id: id, value: value})
  end

  defp build_remove_event(js_command, _id, _value) when is_struct(js_command, JS) do
    js_command
  end

  # Builds the event for adding a chip
  @spec build_add_event(any(), String.t(), String.t()) :: JS.t() | String.t()
  defp build_add_event(nil, _id, _value), do: ""

  defp build_add_event(event_name, id, value) when is_binary(event_name) do
    event_name
    |> JS.push(value: %{id: id, value: value})
    |> hide_suggestions(id)
  end

  defp build_add_event(js_command, id, _value) when is_struct(js_command, JS) do
    hide_suggestions(js_command, id)
  end

  # Hides the suggestions popover
  @spec hide_suggestions(JS.t(), String.t()) :: JS.t()
  defp hide_suggestions(js, id) do
    js
    |> JS.hide(
      to: "##{id}-suggestions-content",
      transition: {
        "transition ease-in duration-75",
        "opacity-100 scale-100",
        "opacity-0 scale-95"
      }
    )
    |> JS.set_attribute({"data-state", "closed"}, to: "##{id}-suggestions-content")
  end
end
