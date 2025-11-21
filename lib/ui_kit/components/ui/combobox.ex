defmodule UiKit.Components.Ui.Combobox do
  @moduledoc """
  Combobox component for searchable single and multi-select inputs.

  Combines Command and Popover components (per shadcn pattern) to provide
  an autocomplete input with a list of filterable suggestions.

  ## Features

  - Single selection mode (select one item)
  - Multiple selection mode (select many items)
  - Search/filter functionality
  - Keyboard accessible (Arrow keys, Enter, Escape)
  - Empty state when no results found
  - Semantic token styling throughout

  ## Single Selection Example

      <.combobox
        id="framework-select"
        value={@selected_framework}
        options={@frameworks}
        placeholder="Select framework..."
        mode={:single}
        phx-change="select_framework"
      />

  Where `@frameworks` is a list of `%{value: "react", label: "React"}` maps.

  ## Multiple Selection Example

      <.combobox
        id="tags-select"
        value={@selected_tags}
        options={@available_tags}
        placeholder="Select tags..."
        mode={:multiple}
        phx-change="update_tags"
      />

  In multiple mode, `value` should be a list of selected values.

  ## LiveView Event Handling

      # Single selection
      def handle_event("select_framework", %{"value" => value}, socket) do
        {:noreply, assign(socket, selected_framework: value)}
      end

      # Multiple selection
      def handle_event("update_tags", %{"value" => value}, socket) do
        # value is a comma-separated string of selected values
        selected_tags = String.split(value, ",", trim: true)
        {:noreply, assign(socket, selected_tags: selected_tags)}
      end

  """
  use Phoenix.Component

  import UiKit.Components.CoreComponents, only: [icon: 1]
  import UiKit.Components.Ui.Command
  import UiKit.Components.Ui.FeedbackStatus, only: [badge: 1]
  import UiKit.Components.Ui.OverlaysDialogs, only: [popover: 1]

  alias Phoenix.LiveView.JS
  alias Phoenix.LiveView.Rendered

  @doc """
  Renders a combobox component for searchable selection.

  Composes Popover and Command components to provide an autocomplete
  input with filterable suggestions.

  ## Attributes

  - `id` - Required unique identifier
  - `value` - Current selected value(s). String for single mode, list for multiple mode
  - `options` - List of option maps with `:value` and `:label` keys
  - `placeholder` - Placeholder text when nothing is selected
  - `mode` - Selection mode: `:single` (default) or `:multiple`
  - `search_placeholder` - Placeholder for search input (default: "Search...")
  - `empty_message` - Message shown when no results (default: "No results found.")
  - `class` - Additional CSS classes for the trigger button

  ## Events

  The component emits a `phx-change` event when selection changes.
  Use standard Phoenix event attributes like `phx-change="event_name"`.

  """
  attr :id, :string, required: true
  attr :value, :any, default: nil
  attr :options, :list, default: []
  attr :placeholder, :string, default: "Select option..."
  attr :mode, :atom, default: :single, values: [:single, :multiple]
  attr :search_placeholder, :string, default: "Search..."
  attr :empty_message, :string, default: "No results found."
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(phx-change phx-blur phx-focus)

  @spec combobox(map()) :: Rendered.t()
  def combobox(assigns) do
    # Normalize value to list for consistent handling
    assigns =
      assigns
      |> assign_new(:selected_values, fn ->
        case assigns.value do
          nil -> []
          value when is_list(value) -> value
          value -> [value]
        end
      end)
      |> assign_new(:trigger_label, fn ->
        compute_trigger_label(assigns.value, assigns.options, assigns.mode, assigns.placeholder)
      end)

    ~H"""
    <div class="w-full" data-combobox={@id} phx-hook="Combobox" id={"#{@id}-hook"}>
      <.popover id={@id} class="w-full">
        <:trigger>
          <div
            role="combobox"
            aria-expanded="false"
            aria-controls={"#{@id}-list"}
            class={[
              "flex min-h-10 w-full flex-wrap items-center gap-2 rounded-md border border-input bg-background px-3 py-2",
              "hover:bg-accent hover:text-accent-foreground cursor-pointer",
              "focus-within:outline-hidden focus-within:ring-2 focus-within:ring-ring focus-within:ring-offset-2",
              @class
            ]}
          >
            <%= if @mode == :multiple && !Enum.empty?(@selected_values) do %>
              <%!-- Multiple mode: Show chips --%>
              <%= for value <- @selected_values do %>
                <% option = Enum.find(@options, fn opt -> opt.value == value end) %>
                <%= if option do %>
                  <.badge variant="secondary" class="gap-1 pl-2 pr-1" data-chip-value={value}>
                    {option.label}
                    <button
                      type="button"
                      data-combobox-remove
                      data-remove-value={value}
                      data-combobox-id={@id}
                      data-event-name={Map.get(@rest, :"phx-change")}
                      class="ml-1 rounded-sm hover:bg-secondary-foreground/20 focus-visible:outline-hidden focus-visible:ring-1 focus-visible:ring-ring"
                      aria-label={"Remove #{option.label}"}
                    >
                      <.icon name="hero-x-mark" class="size-3" />
                    </button>
                  </.badge>
                <% end %>
              <% end %>
            <% else %>
              <%!-- Single mode or empty: Show label --%>
              <span class={[
                "flex-1 text-sm",
                @trigger_label == @placeholder && "text-muted-foreground"
              ]}>
                {@trigger_label}
              </span>
            <% end %>
            <.icon name="hero-chevron-up-down" class="ml-auto size-4 shrink-0 opacity-50" />
          </div>
        </:trigger>
        <:content align="start" class="w-full p-0 min-w-[200px]">
          <.command
            id={"#{@id}-command"}
            phx-hook="CommandFilter"
            data-combobox-command
            class="border-0"
          >
            <.command_input
              id={"#{@id}-search"}
              placeholder={@search_placeholder}
              data-command-input="true"
            />
            <.command_list id={"#{@id}-list"} data-command-list="true">
              <%= if Enum.empty?(@options) do %>
                <.command_empty data-command-empty="true">
                  {@empty_message}
                </.command_empty>
              <% else %>
                <.command_group data-command-group="true">
                  <%= for option <- @options do %>
                    <.command_item
                      data-command-item="true"
                      data-command-label={option.label}
                      data-value={option.value}
                      class="cursor-pointer"
                      phx-click={
                        select_option(
                          @id,
                          option.value,
                          @mode,
                          @selected_values,
                          Map.get(@rest, :"phx-change")
                        )
                      }
                    >
                      <.icon
                        name="hero-check"
                        class={
                          if option.value in @selected_values do
                            "size-4 shrink-0 opacity-100"
                          else
                            "size-4 shrink-0 opacity-0"
                          end
                        }
                      />
                      {option.label}
                    </.command_item>
                  <% end %>
                </.command_group>
              <% end %>
            </.command_list>
          </.command>
        </:content>
      </.popover>

      <%!-- Hidden input to store selected value(s) for form submission --%>
      <%= if @mode == :single do %>
        <input type="hidden" name={"#{@id}-value"} value={@value} />
      <% else %>
        <input
          type="hidden"
          name={"#{@id}-value"}
          value={Enum.join(@selected_values, ",")}
        />
      <% end %>
    </div>
    """
  end

  # Computes the label to display on the trigger button
  @spec compute_trigger_label(any(), list(), atom(), String.t()) :: String.t()
  defp compute_trigger_label(nil, _options, _mode, placeholder), do: placeholder
  defp compute_trigger_label([], _options, _mode, placeholder), do: placeholder

  defp compute_trigger_label(value, options, :single, placeholder) do
    case Enum.find(options, fn opt -> opt.value == value end) do
      nil -> placeholder
      option -> option.label
    end
  end

  defp compute_trigger_label(values, options, :multiple, placeholder) when is_list(values) do
    count = length(values)

    cond do
      count == 0 -> placeholder
      count == 1 -> compute_single_label(hd(values), options, placeholder)
      true -> "#{count} selected"
    end
  end

  # Helper to compute label for a single value in multiple mode
  @spec compute_single_label(any(), list(), String.t()) :: String.t()
  defp compute_single_label(value, options, placeholder) do
    case Enum.find(options, fn opt -> opt.value == value end) do
      nil -> placeholder
      option -> option.label
    end
  end

  # Generates JS command to handle option selection
  @spec select_option(String.t(), any(), atom(), list(), String.t() | nil) :: JS.t()
  defp select_option(id, option_value, mode, current_values, event_name) do
    case mode do
      :single ->
        # In single mode, close popover and emit event
        js =
          if event_name do
            JS.push(event_name, value: %{id: id, value: option_value})
          else
            %JS{}
          end

        hide_popover_for_combobox(js, id)

      :multiple ->
        # In multiple mode, toggle selection and emit event
        new_values =
          if option_value in current_values do
            List.delete(current_values, option_value)
          else
            current_values ++ [option_value]
          end

        if event_name do
          JS.push(event_name, value: %{id: id, value: Enum.join(new_values, ",")})
        else
          %JS{}
        end
    end
  end

  # Hides the popover (mimics the one from OverlaysDialogs but works with JS chaining)
  @spec hide_popover_for_combobox(JS.t(), String.t()) :: JS.t()
  defp hide_popover_for_combobox(js, id) do
    js
    |> JS.hide(
      to: "##{id}-content",
      transition: {
        "transition ease-in duration-75",
        "opacity-100 scale-100",
        "opacity-0 scale-95"
      }
    )
    |> JS.set_attribute({"data-state", "closed"}, to: "##{id}-content")
  end
end
