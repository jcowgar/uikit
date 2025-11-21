defmodule DemoWeb.Ui.BreadcrumbLive do
  @moduledoc false
  use DemoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    
      <.container>
        <.stack size="large">
          <%!-- Header --%>
          <div>
            <h1 class="text-3xl font-bold text-foreground">Breadcrumb Component</h1>
            <p class="text-muted-foreground mt-2">
              Display hierarchical navigation showing the user's location within the site structure.
            </p>
          </div>

          <%!-- Basic Breadcrumb --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Basic Breadcrumb</h2>
            <.card class="max-w-2xl">
              <.card_content class="pt-6">
                <.breadcrumb>
                  <.breadcrumb_list>
                    <.breadcrumb_item>
                      <.breadcrumb_link href={~p"/"}>Home</.breadcrumb_link>
                    </.breadcrumb_item>
                    <.breadcrumb_separator />
                    <.breadcrumb_item>
                      <.breadcrumb_link navigate={~p"/"}>Documentation</.breadcrumb_link>
                    </.breadcrumb_item>
                    <.breadcrumb_separator />
                    <.breadcrumb_item>
                      <.breadcrumb_link navigate={~p"/"}>Components</.breadcrumb_link>
                    </.breadcrumb_item>
                    <.breadcrumb_separator />
                    <.breadcrumb_item>
                      <.breadcrumb_page>Breadcrumb</.breadcrumb_page>
                    </.breadcrumb_item>
                  </.breadcrumb_list>
                </.breadcrumb>
              </.card_content>
            </.card>
          </section>

          <%!-- Custom Separator --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Custom Separator</h2>
            <.card class="max-w-2xl">
              <.card_content class="pt-6">
                <.breadcrumb>
                  <.breadcrumb_list>
                    <.breadcrumb_item>
                      <.breadcrumb_link href={~p"/"}>Home</.breadcrumb_link>
                    </.breadcrumb_item>
                    <.breadcrumb_separator>
                      <.icon name="hero-slash" class="w-4 h-4" />
                    </.breadcrumb_separator>
                    <.breadcrumb_item>
                      <.breadcrumb_link navigate={~p"/"}>Projects</.breadcrumb_link>
                    </.breadcrumb_item>
                    <.breadcrumb_separator>
                      <.icon name="hero-slash" class="w-4 h-4" />
                    </.breadcrumb_separator>
                    <.breadcrumb_item>
                      <.breadcrumb_page>Settings</.breadcrumb_page>
                    </.breadcrumb_item>
                  </.breadcrumb_list>
                </.breadcrumb>
              </.card_content>
            </.card>
          </section>

          <%!-- With Ellipsis --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">With Ellipsis (Truncated)</h2>
            <.card class="max-w-2xl">
              <.card_content class="pt-6">
                <.breadcrumb>
                  <.breadcrumb_list>
                    <.breadcrumb_item>
                      <.breadcrumb_link href={~p"/"}>Home</.breadcrumb_link>
                    </.breadcrumb_item>
                    <.breadcrumb_separator />
                    <.breadcrumb_item>
                      <.breadcrumb_ellipsis />
                    </.breadcrumb_item>
                    <.breadcrumb_separator />
                    <.breadcrumb_item>
                      <.breadcrumb_link navigate={~p"/"}>Components</.breadcrumb_link>
                    </.breadcrumb_item>
                    <.breadcrumb_separator />
                    <.breadcrumb_item>
                      <.breadcrumb_link navigate={~p"/"}>Layout & Navigation</.breadcrumb_link>
                    </.breadcrumb_item>
                    <.breadcrumb_separator />
                    <.breadcrumb_item>
                      <.breadcrumb_page>Breadcrumb</.breadcrumb_page>
                    </.breadcrumb_item>
                  </.breadcrumb_list>
                </.breadcrumb>
              </.card_content>
            </.card>
          </section>

          <%!-- Multiple Examples --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Various Contexts</h2>
            <.card class="max-w-2xl">
              <.card_content class="pt-6">
                <.stack size="large">
                  <div>
                    <h3 class="font-semibold text-foreground mb-3">Dashboard Navigation</h3>
                    <.breadcrumb>
                      <.breadcrumb_list>
                        <.breadcrumb_item>
                          <.breadcrumb_link href={~p"/"}>Dashboard</.breadcrumb_link>
                        </.breadcrumb_item>
                        <.breadcrumb_separator />
                        <.breadcrumb_item>
                          <.breadcrumb_link navigate={~p"/"}>Analytics</.breadcrumb_link>
                        </.breadcrumb_item>
                        <.breadcrumb_separator />
                        <.breadcrumb_item>
                          <.breadcrumb_page>Reports</.breadcrumb_page>
                        </.breadcrumb_item>
                      </.breadcrumb_list>
                    </.breadcrumb>
                  </div>

                  <.separator />

                  <div>
                    <h3 class="font-semibold text-foreground mb-3">E-commerce Navigation</h3>
                    <.breadcrumb>
                      <.breadcrumb_list>
                        <.breadcrumb_item>
                          <.breadcrumb_link href={~p"/"}>Shop</.breadcrumb_link>
                        </.breadcrumb_item>
                        <.breadcrumb_separator />
                        <.breadcrumb_item>
                          <.breadcrumb_link navigate={~p"/"}>Electronics</.breadcrumb_link>
                        </.breadcrumb_item>
                        <.breadcrumb_separator />
                        <.breadcrumb_item>
                          <.breadcrumb_link navigate={~p"/"}>Laptops</.breadcrumb_link>
                        </.breadcrumb_item>
                        <.breadcrumb_separator />
                        <.breadcrumb_item>
                          <.breadcrumb_page>MacBook Pro</.breadcrumb_page>
                        </.breadcrumb_item>
                      </.breadcrumb_list>
                    </.breadcrumb>
                  </div>

                  <.separator />

                  <div>
                    <h3 class="font-semibold text-foreground mb-3">Settings Navigation</h3>
                    <.breadcrumb>
                      <.breadcrumb_list>
                        <.breadcrumb_item>
                          <.breadcrumb_link href={~p"/"}>Settings</.breadcrumb_link>
                        </.breadcrumb_item>
                        <.breadcrumb_separator />
                        <.breadcrumb_item>
                          <.breadcrumb_link navigate={~p"/"}>Account</.breadcrumb_link>
                        </.breadcrumb_item>
                        <.breadcrumb_separator />
                        <.breadcrumb_item>
                          <.breadcrumb_page>Security</.breadcrumb_page>
                        </.breadcrumb_item>
                      </.breadcrumb_list>
                    </.breadcrumb>
                  </div>
                </.stack>
              </.card_content>
            </.card>
          </section>

          <%!-- Component Features --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Features</h2>
            <.card class="max-w-2xl">
              <.card_content class="pt-6">
                <.stack size="medium">
                  <div class="flex items-start gap-3">
                    <.icon name="hero-check-circle" class="w-5 h-5 text-success mt-0.5" />
                    <div>
                      <p class="font-medium text-foreground">Semantic Navigation</p>
                      <p class="text-sm text-muted-foreground">
                        Uses proper HTML5 nav element with aria-label for accessibility
                      </p>
                    </div>
                  </div>

                  <div class="flex items-start gap-3">
                    <.icon name="hero-check-circle" class="w-5 h-5 text-success mt-0.5" />
                    <div>
                      <p class="font-medium text-foreground">Theme-Aware</p>
                      <p class="text-sm text-muted-foreground">
                        Automatically adapts to light and dark themes using semantic color tokens
                      </p>
                    </div>
                  </div>

                  <div class="flex items-start gap-3">
                    <.icon name="hero-check-circle" class="w-5 h-5 text-success mt-0.5" />
                    <div>
                      <p class="font-medium text-foreground">Flexible Navigation</p>
                      <p class="text-sm text-muted-foreground">
                        Supports both href (page reload) and navigate (LiveView) links
                      </p>
                    </div>
                  </div>

                  <div class="flex items-start gap-3">
                    <.icon name="hero-check-circle" class="w-5 h-5 text-success mt-0.5" />
                    <div>
                      <p class="font-medium text-foreground">Customizable Separators</p>
                      <p class="text-sm text-muted-foreground">
                        Default chevron separator can be replaced with any custom content
                      </p>
                    </div>
                  </div>

                  <div class="flex items-start gap-3">
                    <.icon name="hero-check-circle" class="w-5 h-5 text-success mt-0.5" />
                    <div>
                      <p class="font-medium text-foreground">Ellipsis Support</p>
                      <p class="text-sm text-muted-foreground">
                        Built-in ellipsis component for indicating truncated paths
                      </p>
                    </div>
                  </div>
                </.stack>
              </.card_content>
            </.card>
          </section>
        </.stack>
      </.container>
    
    """
  end
end
