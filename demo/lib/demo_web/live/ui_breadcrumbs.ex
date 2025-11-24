defmodule DemoWeb.UiBreadcrumbs do
  @moduledoc """
  LiveView hook for setting up breadcrumb navigation in the UI component library.

  This module provides breadcrumb metadata for all UI component pages,
  organizing them by category and component name.
  """
  use DemoWeb, :verified_routes

  import Phoenix.Component, only: [assign: 2]
  import Phoenix.LiveView, only: [attach_hook: 4]

  alias Phoenix.LiveView.Socket

  @doc """
  Attaches breadcrumb information based on the current route.
  """
  @spec on_mount(:default, map(), map(), Socket.t()) ::
          {:cont, Socket.t()}
  def on_mount(:default, _params, _session, socket) do
    {:cont,
     attach_hook(socket, :set_breadcrumbs, :handle_params, fn _params, url, socket ->
       breadcrumbs = get_breadcrumbs_for_path(url)
       {:cont, assign(socket, breadcrumbs: breadcrumbs)}
     end)}
  end

  # Breadcrumb mapping: path suffix -> {category, component_name}
  @breadcrumb_map %{
    # Form & Input
    "/button" => {"Form & Input", "Button"},
    "/input" => {"Form & Input", "Input"},
    "/textarea" => {"Form & Input", "Textarea"},
    "/checkbox" => {"Form & Input", "Checkbox"},
    "/switch" => {"Form & Input", "Switch"},
    "/radio-group" => {"Form & Input", "Radio Group"},
    "/radio-card" => {"Form & Input", "Radio Card"},
    "/select" => {"Form & Input", "Select"},
    "/form" => {"Form & Input", "Form"},
    # Layout & Navigation
    "/layout" => {"Layout & Navigation", "Layout"},
    "/sidebar" => {"Layout & Navigation", "Sidebar"},
    "/breadcrumb" => {"Layout & Navigation", "Breadcrumb"},
    "/tabs" => {"Layout & Navigation", "Tabs"},
    "/scroll-area" => {"Layout & Navigation", "Scroll Area"},
    "/separator" => {"Layout & Navigation", "Separator"},
    "/kanban" => {"Layout & Navigation", "Kanban"},
    # Overlays & Dialogs
    "/dialog" => {"Overlays & Dialogs", "Dialog"},
    "/alert-dialog" => {"Overlays & Dialogs", "Alert Dialog"},
    "/drawer" => {"Overlays & Dialogs", "Drawer"},
    "/dropdown-menu" => {"Overlays & Dialogs", "Dropdown Menu"},
    "/popover" => {"Overlays & Dialogs", "Popover"},
    "/sheet" => {"Overlays & Dialogs", "Sheet"},
    # Feedback & Status
    "/alert" => {"Feedback & Status", "Alert"},
    "/badge" => {"Feedback & Status", "Badge"},
    "/spinner" => {"Feedback & Status", "Spinner"},
    "/skeleton" => {"Feedback & Status", "Skeleton"},
    "/sonner" => {"Feedback & Status", "Sonner"},
    # Display & Media
    "/card" => {"Display & Media", "Card"},
    "/avatar" => {"Display & Media", "Avatar"},
    "/table" => {"Display & Media", "Table"},
    "/aspect-ratio" => {"Display & Media", "Aspect Ratio"},
    # Miscellaneous
    "/miscellaneous" => {"Miscellaneous", "Components"},
    # Design System
    "/styling" => {"Design System", "Styling"},
    # Index
    "/" => {nil, "Overview"}
  }

  @spec get_breadcrumbs_for_path(String.t()) :: list(map())
  defp get_breadcrumbs_for_path(url) do
    uri = URI.parse(url)
    path = uri.path

    case Map.get(@breadcrumb_map, path) do
      {category, component} when is_binary(category) ->
        [
          %{label: "UI Library", path: ~p"/"},
          %{label: category, path: nil},
          %{label: component, path: nil, current: true}
        ]

      {nil, component} ->
        [
          %{label: "UI Library", path: ~p"/"},
          %{label: component, path: nil, current: true}
        ]

      nil ->
        # Fallback for unknown paths
        [
          %{label: "UI Library", path: ~p"/"},
          %{label: "Components", path: nil, current: true}
        ]
    end
  end
end
