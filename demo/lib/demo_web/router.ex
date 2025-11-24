defmodule DemoWeb.Router do
  use DemoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DemoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DemoWeb do
    pipe_through :browser

    live_session :ui_components,
      on_mount: [{DemoWeb.UiBreadcrumbs, :default}],
      layout: {DemoWeb.Layouts, :ui} do
      live "/", Ui.IndexLive
      live "/styling", Ui.StylingLive
      live "/typography", Ui.TypographyLive
      live "/layout", Ui.LayoutLive
      live "/accordion", Ui.AccordionLive
      live "/button", Ui.ButtonLive
      live "/button-group", Ui.ButtonGroupLive
      live "/card", Ui.CardLive
      live "/badge", Ui.BadgeLive
      live "/input", Ui.InputLive
      live "/input-group", Ui.InputGroupLive
      live "/textarea", Ui.TextareaLive
      live "/checkbox", Ui.CheckboxLive
      live "/switch", Ui.SwitchLive
      live "/radio-group", Ui.RadioGroupLive
      live "/radio-card", Ui.RadioCardLive
      live "/select", Ui.SelectLive
      live "/combobox", Ui.ComboboxLive
      live "/chip-input", Ui.ChipInputLive
      live "/form", Ui.FormLive
      live "/alert", Ui.AlertLive
      live "/separator", Ui.SeparatorLive
      live "/breadcrumb", Ui.BreadcrumbLive
      live "/tabs", Ui.TabsLive
      live "/sidebar", Ui.SidebarLive
      live "/scroll-area", Ui.ScrollAreaLive
      live "/tab-bar", TabBarLive
      live "/tab-bar/:_tab_path", TabBarLive
      live "/sonner", Ui.SonnerLive
      live "/spinner", Ui.SpinnerLive
      live "/skeleton", Ui.SkeletonLive
      live "/segmented-progress-bar", Ui.SegmentedProgressBarLive
      live "/progress", Ui.ProgressLive
      live "/avatar", Ui.AvatarLive
      live "/table", Ui.TableLive
      live "/dropdown-menu", Ui.DropdownMenuLive
      live "/popover", Ui.PopoverLive
      live "/sheet", Ui.SheetLive
      live "/alert-dialog", Ui.AlertDialogLive
      live "/dialog", Ui.DialogLive
      live "/drawer", Ui.DrawerLive
      live "/command", Ui.CommandLive
      live "/miscellaneous", Ui.MiscellaneousLive
      live "/kanban", Ui.KanbanLive
      live "/marketing", Ui.MarketingLive
      live "/chart", Ui.ChartLive
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", DemoWeb do
  #   pipe_through :api
  # end
end
