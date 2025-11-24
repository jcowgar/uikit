defmodule DemoWeb.TabBarLive do
  use DemoWeb, :live_view

  import UiKit.Components.Ui.LayoutNavigation

  def mount(_params, _session, socket) do
    {:ok, assign(socket, active_path: "/tab-bar")}
  end

  def render(assigns) do
    ~H"""
    <div class="flex h-full flex-col">
      <header class="bg-primary text-primary-foreground p-4 text-center">
        <h1 class="text-xl font-bold">Tab Bar Demo</h1>
      </header>

      <main class="flex-1 overflow-auto p-4">
        <h2 class="text-lg font-semibold mb-4">Current Path: {@active_path}</h2>

        <p class="mb-4">
          This is a demonstration of the mobile-first bottom tab bar component.
          Resize your browser to a mobile viewport (e.g., less than 768px width) to see it in action.
        </p>

        <div class="border rounded-lg p-4 bg-card text-card-foreground">
          <h3 class="font-medium text-lg mb-2">Example Tab Bar</h3>
          <.tab_bar active_path={@active_path}>
            <.tab_bar_item icon="hero-home" label="Home" navigate={~p"/tab-bar"} />
            <.tab_bar_item icon="hero-calendar" label="Schedule" navigate={~p"/tab-bar/schedule"} />
            <.tab_bar_item icon="hero-trophy" label="Standings" navigate={~p"/tab-bar/standings"} />
            <.tab_bar_item icon="hero-bell" label="Alerts" navigate={~p"/tab-bar/alerts"} badge="5" />
            <.tab_bar_item icon="hero-ellipsis-horizontal" label="More" navigate={~p"/tab-bar/more"} />
          </.tab_bar>
          <p class="mt-4 text-sm text-muted-foreground">
            The tab bar is fixed at the bottom and responds to route changes.
            Click on items to see the active state change.
          </p>
        </div>
      </main>

      <footer class="bg-secondary text-secondary-foreground p-2 text-center text-sm">
        UiKit Tab Bar Demo Footer
      </footer>
    </div>
    """
  end

  def handle_params(_params, url, socket) do
    {:noreply, assign(socket, active_path: url)}
  end
end
