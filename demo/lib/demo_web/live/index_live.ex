defmodule DemoWeb.Ui.IndexLive do
  @moduledoc """
  Index page showing all available UI component demonstrations.

  This page serves as a navigation hub for browsing and testing all
  shadcn/ui components that have been converted to Phoenix LiveView.
  """
  use DemoWeb, :live_view

  alias Phoenix.LiveView.Socket

  @spec mount(map(), map(), Socket.t()) :: {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @spec render(map()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <.container class="!py-12">
      <.stack size="xl">
        <%!-- Header --%>
        <div class="text-center">
          <h1 class="text-4xl font-bold tracking-tight text-foreground">
            UI Component Library
          </h1>
          <p class="mt-4 text-lg text-muted-foreground">
            Browse all shadcn/ui components converted to Phoenix LiveView
          </p>
        </div>

        <%!-- Overview Cards --%>
        <.grid cols={3}>
          <.card>
            <.card_header>
              <.icon name="hero-squares-2x2" class="size-8 text-primary mb-2" />
              <.card_title>Component Categories</.card_title>
              <.card_description>
                Components are organized into 6 main categories for easy navigation
              </.card_description>
            </.card_header>
          </.card>

          <.card>
            <.card_header>
              <.icon name="hero-swatch" class="size-8 text-primary mb-2" />
              <.card_title>Theme System</.card_title>
              <.card_description>
                Automatic dark mode support with semantic color tokens
              </.card_description>
            </.card_header>
          </.card>

          <.card>
            <.card_header>
              <.icon name="hero-code-bracket" class="size-8 text-primary mb-2" />
              <.card_title>Phoenix LiveView</.card_title>
              <.card_description>
                All components built with Phoenix LiveView and HEEx templates
              </.card_description>
            </.card_header>
          </.card>
        </.grid>

        <%!-- Getting Started --%>
        <.card>
          <.card_header>
            <.card_title>Getting Started</.card_title>
            <.card_description>
              Use the sidebar to navigate through different component categories
            </.card_description>
          </.card_header>
          <.card_content>
            <.stack size="small">
              <div class="flex items-start gap-3">
                <div class="flex size-6 shrink-0 items-center justify-center rounded-full bg-primary/10 text-primary">
                  1
                </div>
                <div>
                  <p class="font-medium text-foreground">Browse Categories</p>
                  <p class="text-sm text-muted-foreground">
                    Use the sidebar to explore Form & Input, Layout & Navigation, Overlays & Dialogs, and more
                  </p>
                </div>
              </div>

              <div class="flex items-start gap-3">
                <div class="flex size-6 shrink-0 items-center justify-center rounded-full bg-primary/10 text-primary">
                  2
                </div>
                <div>
                  <p class="font-medium text-foreground">View Examples</p>
                  <p class="text-sm text-muted-foreground">
                    Each component page shows live examples with code snippets
                  </p>
                </div>
              </div>

              <div class="flex items-start gap-3">
                <div class="flex size-6 shrink-0 items-center justify-center rounded-full bg-primary/10 text-primary">
                  3
                </div>
                <div>
                  <p class="font-medium text-foreground">Copy & Use</p>
                  <p class="text-sm text-muted-foreground">
                    Copy the component code and integrate it into your Phoenix LiveView application
                  </p>
                </div>
              </div>
            </.stack>
          </.card_content>
        </.card>

        <%!-- Quick Links --%>
        <div>
          <h2 class="mb-4 text-2xl font-bold text-foreground">Popular Components</h2>
          <.grid cols={4}>
            <.link navigate={~p"/button"}>
              <.card class="hover:border-primary/50 transition-colors cursor-pointer">
                <.card_content class="pt-6 text-center">
                  <.icon name="hero-cursor-arrow-ripple" class="size-8 mx-auto mb-2 text-primary" />
                  <p class="font-medium text-foreground">Button</p>
                </.card_content>
              </.card>
            </.link>

            <.link navigate={~p"/input"}>
              <.card class="hover:border-primary/50 transition-colors cursor-pointer">
                <.card_content class="pt-6 text-center">
                  <.icon name="hero-pencil-square" class="size-8 mx-auto mb-2 text-primary" />
                  <p class="font-medium text-foreground">Input</p>
                </.card_content>
              </.card>
            </.link>

            <.link navigate={~p"/input-group"}>
              <.card class="hover:border-primary/50 transition-colors cursor-pointer">
                <.card_content class="pt-6 text-center">
                  <.icon name="hero-rectangle-stack" class="size-8 mx-auto mb-2 text-primary" />
                  <p class="font-medium text-foreground">Input Group</p>
                </.card_content>
              </.card>
            </.link>

            <.link navigate={~p"/dialog"}>
              <.card class="hover:border-primary/50 transition-colors cursor-pointer">
                <.card_content class="pt-6 text-center">
                  <.icon name="hero-window" class="size-8 mx-auto mb-2 text-primary" />
                  <p class="font-medium text-foreground">Dialog</p>
                </.card_content>
              </.card>
            </.link>

            <.link navigate={~p"/command"}>
              <.card class="hover:border-primary/50 transition-colors cursor-pointer">
                <.card_content class="pt-6 text-center">
                  <.icon name="hero-command-line" class="size-8 mx-auto mb-2 text-primary" />
                  <p class="font-medium text-foreground">Command</p>
                </.card_content>
              </.card>
            </.link>

            <.link navigate={~p"/card"}>
              <.card class="hover:border-primary/50 transition-colors cursor-pointer">
                <.card_content class="pt-6 text-center">
                  <.icon name="hero-rectangle-group" class="size-8 mx-auto mb-2 text-primary" />
                  <p class="font-medium text-foreground">Card</p>
                </.card_content>
              </.card>
            </.link>
          </.grid>
        </div>
      </.stack>
    </.container>
    """
  end
end
