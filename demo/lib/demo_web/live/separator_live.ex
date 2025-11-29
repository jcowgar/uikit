defmodule DemoWeb.Ui.SeparatorLive do
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
      <.stack gap="xl">
        <%!-- Header --%>
        <div>
          <h1 class="text-3xl font-bold text-foreground">Separator Component</h1>
          <p class="text-muted-foreground mt-2">
            Visually or semantically separate content with horizontal or vertical dividers.
          </p>
        </div>

        <%!-- Horizontal Separator --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Horizontal Separator</h2>
          <.card class="max-w-md">
            <.card_content class="pt-6">
              <.stack gap="lg">
                <div>
                  <h3 class="font-semibold text-foreground">Section 1</h3>
                  <p class="text-sm text-muted-foreground">
                    This is the first section of content.
                  </p>
                </div>

                <.separator />

                <div>
                  <h3 class="font-semibold text-foreground">Section 2</h3>
                  <p class="text-sm text-muted-foreground">
                    This is the second section of content.
                  </p>
                </div>

                <.separator />

                <div>
                  <h3 class="font-semibold text-foreground">Section 3</h3>
                  <p class="text-sm text-muted-foreground">
                    This is the third section of content.
                  </p>
                </div>
              </.stack>
            </.card_content>
          </.card>
        </section>

        <%!-- Vertical Separator --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Vertical Separator</h2>
          <.card class="max-w-md">
            <.card_content class="pt-6">
              <div class="flex items-center gap-4">
                <.link navigate={~p"/"} class="text-sm font-medium text-foreground hover:underline">
                  Home
                </.link>
                <.separator orientation="vertical" class="h-4" />
                <.link navigate={~p"/"} class="text-sm font-medium text-foreground hover:underline">
                  Blog
                </.link>
                <.separator orientation="vertical" class="h-4" />
                <.link navigate={~p"/"} class="text-sm font-medium text-foreground hover:underline">
                  Docs
                </.link>
                <.separator orientation="vertical" class="h-4" />
                <.link navigate={~p"/"} class="text-sm font-medium text-foreground hover:underline">
                  Contact
                </.link>
              </div>
            </.card_content>
          </.card>
        </section>

        <%!-- Custom Spacing --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Custom Spacing</h2>
          <.card class="max-w-md">
            <.card_content class="pt-6">
              <div class="space-y-1">
                <h3 class="font-semibold text-foreground">Header</h3>
                <p class="text-sm text-muted-foreground">
                  Some introductory text goes here.
                </p>
              </div>

              <.separator class="my-6" />

              <div class="space-y-1">
                <h3 class="font-semibold text-foreground">Main Content</h3>
                <p class="text-sm text-muted-foreground">
                  The main content of this section with more spacing around the separator.
                </p>
              </div>

              <.separator class="my-4" />

              <div class="space-y-1">
                <h3 class="font-semibold text-foreground">Footer</h3>
                <p class="text-sm text-muted-foreground">
                  Some concluding text with less spacing.
                </p>
              </div>
            </.card_content>
          </.card>
        </section>

        <%!-- In Forms --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">In Forms</h2>
          <.card class="max-w-md">
            <.card_header>
              <.card_title>Account Settings</.card_title>
              <.card_description>Manage your account preferences</.card_description>
            </.card_header>
            <.card_content>
              <form>
                <.stack gap="lg">
                  <%!-- Personal Information --%>
                  <div>
                    <h3 class="font-medium text-foreground mb-3">Personal Information</h3>
                    <.stack gap="md">
                      <.form_item>
                        <.form_label for="form-name">Name</.form_label>
                        <.input type="text" id="form-name" name="name" placeholder="John Doe" />
                      </.form_item>

                      <.form_item>
                        <.form_label for="form-email">Email</.form_label>
                        <.input
                          type="email"
                          id="form-email"
                          name="email"
                          placeholder="john@example.com"
                        />
                      </.form_item>
                    </.stack>
                  </div>

                  <.separator />

                  <%!-- Security --%>
                  <div>
                    <h3 class="font-medium text-foreground mb-3">Security</h3>
                    <.stack gap="md">
                      <.form_item>
                        <.form_label for="form-current-password">Current Password</.form_label>
                        <.input
                          type="password"
                          id="form-current-password"
                          name="current_password"
                          placeholder="••••••••"
                        />
                      </.form_item>

                      <.form_item>
                        <.form_label for="form-new-password">New Password</.form_label>
                        <.input
                          type="password"
                          id="form-new-password"
                          name="new_password"
                          placeholder="••••••••"
                        />
                      </.form_item>
                    </.stack>
                  </div>

                  <.separator />

                  <%!-- Preferences --%>
                  <div>
                    <h3 class="font-medium text-foreground mb-3">Preferences</h3>
                    <.stack gap="md">
                      <div class="flex items-center gap-3">
                        <.checkbox id="pref-newsletter" name="newsletter" />
                        <.label for="pref-newsletter" class="cursor-pointer">
                          Subscribe to newsletter
                        </.label>
                      </div>

                      <div class="flex items-center gap-3">
                        <.checkbox id="pref-notifications" name="notifications" checked />
                        <.label for="pref-notifications" class="cursor-pointer">
                          Enable notifications
                        </.label>
                      </div>
                    </.stack>
                  </div>

                  <.button class="w-full">Save Changes</.button>
                </.stack>
              </form>
            </.card_content>
          </.card>
        </section>

        <%!-- Auth Screen Example --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Auth Screen Example</h2>
          <.card class="max-w-md">
            <.card_header>
              <.card_title>Sign In</.card_title>
              <.card_description>Choose your preferred sign in method</.card_description>
            </.card_header>
            <.card_content>
              <.stack gap="lg">
                <%!-- Magic Link --%>
                <div>
                  <h3 class="font-medium text-foreground mb-3">Magic Link</h3>
                  <form>
                    <.stack gap="md">
                      <.form_item>
                        <.form_label for="magic-email">Email</.form_label>
                        <.input
                          type="email"
                          id="magic-email"
                          name="email"
                          placeholder="Enter your email"
                        />
                      </.form_item>
                      <.button class="w-full">Send Magic Link</.button>
                    </.stack>
                  </form>
                </div>

                <.separator />

                <%!-- Password --%>
                <div>
                  <h3 class="font-medium text-foreground mb-3">Password</h3>
                  <form>
                    <.stack gap="md">
                      <.form_item>
                        <.form_label for="pass-email">Email</.form_label>
                        <.input
                          type="email"
                          id="pass-email"
                          name="email"
                          placeholder="Enter your email"
                        />
                      </.form_item>

                      <.form_item>
                        <.form_label for="password">Password</.form_label>
                        <.input
                          type="password"
                          id="password"
                          name="password"
                          placeholder="Enter password"
                        />
                      </.form_item>

                      <.button class="w-full">Sign In</.button>
                    </.stack>
                  </form>
                </div>
              </.stack>
            </.card_content>
          </.card>
        </section>

        <%!-- Accessibility --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Accessibility</h2>
          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>Accessibility Features</.card_title>
            </.card_header>
            <.card_content>
              <.stack gap="md">
                <p class="text-sm text-muted-foreground">
                  The separator component includes several accessibility features:
                </p>
                <ul class="text-sm text-muted-foreground space-y-2 list-disc list-inside">
                  <li>
                    By default, separators are <strong>decorative</strong>
                    (<code class="text-xs">role="none"</code>) and hidden from screen readers
                  </li>
                  <li>
                    Set <code class="text-xs">decorative={false}</code>
                    to make the separator semantic with <code class="text-xs">role="separator"</code>
                  </li>
                  <li>
                    Semantic separators include <code class="text-xs">aria-orientation</code>
                    for proper navigation
                  </li>
                  <li>Uses semantic border color that adapts to light/dark themes</li>
                  <li>
                    Proper sizing defaults (1px height for horizontal, 1px width for vertical)
                  </li>
                </ul>
              </.stack>
            </.card_content>
          </.card>
        </section>

        <%!-- Usage Guidelines --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Usage Guidelines</h2>
          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>When to Use</.card_title>
            </.card_header>
            <.card_content>
              <.stack gap="md">
                <div>
                  <h3 class="font-semibold text-foreground mb-2">Horizontal Separators</h3>
                  <p class="text-sm text-muted-foreground">
                    Use to divide sections of content vertically, such as between form groups, settings categories, or distinct content areas.
                  </p>
                </div>

                <div>
                  <h3 class="font-semibold text-foreground mb-2">Vertical Separators</h3>
                  <p class="text-sm text-muted-foreground">
                    Use for inline content separation, such as between navigation items, breadcrumbs, or action buttons in a toolbar.
                  </p>
                </div>

                <div>
                  <h3 class="font-semibold text-foreground mb-2">Spacing</h3>
                  <p class="text-sm text-muted-foreground">
                    Add margin classes (<code class="text-xs">my-4</code>, <code class="text-xs">my-6</code>) to control spacing around separators. More spacing indicates stronger separation.
                  </p>
                </div>

                <div>
                  <h3 class="font-semibold text-foreground mb-2">Decorative vs Semantic</h3>
                  <p class="text-sm text-muted-foreground">
                    Most separators should be decorative (default). Only use semantic separators when the division has meaning for screen reader users navigating the content.
                  </p>
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
