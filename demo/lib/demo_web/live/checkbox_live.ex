defmodule DemoWeb.Ui.CheckboxLive do
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
          <h1 class="text-3xl font-bold text-foreground">Checkbox Component</h1>
          <p class="text-muted-foreground mt-2">
            A control that allows the user to toggle between checked and unchecked states.
          </p>
        </div>

        <%!-- Basic Checkbox --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Basic Usage</h2>
          <.stack size="medium">
            <div class="flex items-center gap-3">
              <.checkbox id="basic" name="basic" />
              <.label for="basic" class="cursor-pointer">Unchecked</.label>
            </div>

            <div class="flex items-center gap-3">
              <.checkbox id="checked" name="checked" checked />
              <.label for="checked" class="cursor-pointer">Checked by default</.label>
            </div>
          </.stack>
        </section>

        <%!-- With Labels --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">With Labels</h2>
          <.stack size="medium">
            <div class="flex items-center gap-3">
              <.checkbox id="terms" name="terms" />
              <.label for="terms" class="cursor-pointer">
                Accept terms and conditions
              </.label>
            </div>

            <div class="flex items-center gap-3">
              <.checkbox id="newsletter" name="newsletter" />
              <.label for="newsletter" class="cursor-pointer">
                Subscribe to newsletter
              </.label>
            </div>

            <div class="flex items-center gap-3">
              <.checkbox id="marketing" name="marketing" checked />
              <.label for="marketing" class="cursor-pointer">
                Receive marketing emails
              </.label>
            </div>
          </.stack>
        </section>

        <%!-- Disabled State --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Disabled</h2>
          <.stack size="medium">
            <div class="flex items-center gap-3">
              <.checkbox id="disabled-unchecked" name="disabled-unchecked" disabled />
              <.label for="disabled-unchecked">Disabled unchecked</.label>
            </div>

            <div class="flex items-center gap-3">
              <.checkbox id="disabled-checked" name="disabled-checked" checked disabled />
              <.label for="disabled-checked">Disabled checked</.label>
            </div>
          </.stack>
        </section>

        <%!-- With Description --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">With Description</h2>
          <.stack size="medium">
            <div class="flex items-start gap-3">
              <.checkbox id="mobile" name="mobile" class="mt-0.5" />
              <div class="space-y-1">
                <.label for="mobile" class="cursor-pointer">
                  Use different settings for mobile
                </.label>
                <p class="text-sm text-muted-foreground">
                  You can manage your mobile notifications in the mobile settings page.
                </p>
              </div>
            </div>

            <div class="flex items-start gap-3">
              <.checkbox id="security" name="security" checked class="mt-0.5" />
              <div class="space-y-1">
                <.label for="security" class="cursor-pointer">
                  Security emails
                </.label>
                <p class="text-sm text-muted-foreground">
                  Receive emails about your account security and activity.
                </p>
              </div>
            </div>
          </.stack>
        </section>

        <%!-- Form Example --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Form Example</h2>
          <.card class="max-w-md">
            <.card_header>
              <.card_title>Account Preferences</.card_title>
              <.card_description>
                Manage your email and notification preferences
              </.card_description>
            </.card_header>
            <.card_content>
              <form>
                <.stack size="medium">
                  <div class="flex items-center gap-3">
                    <.checkbox id="pref-newsletter" name="preferences[newsletter]" checked />
                    <.label for="pref-newsletter" class="cursor-pointer">
                      Newsletter emails
                    </.label>
                  </div>

                  <div class="flex items-center gap-3">
                    <.checkbox id="pref-updates" name="preferences[updates]" checked />
                    <.label for="pref-updates" class="cursor-pointer">
                      Product updates
                    </.label>
                  </div>

                  <div class="flex items-center gap-3">
                    <.checkbox id="pref-marketing" name="preferences[marketing]" />
                    <.label for="pref-marketing" class="cursor-pointer">
                      Marketing emails
                    </.label>
                  </div>

                  <div class="flex items-center gap-3">
                    <.checkbox id="pref-social" name="preferences[social]" />
                    <.label for="pref-social" class="cursor-pointer">Social media updates</.label>
                  </div>

                  <.button class="w-full">Save Preferences</.button>
                </.stack>
              </form>
            </.card_content>
          </.card>
        </section>

        <%!-- Accessibility Features --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Accessibility</h2>
          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>Accessibility Features</.card_title>
            </.card_header>
            <.card_content>
              <.stack size="small">
                <p class="text-sm text-muted-foreground">
                  The checkbox component includes several accessibility features:
                </p>
                <ul class="text-sm text-muted-foreground space-y-2 list-disc list-inside">
                  <li>
                    Proper association with labels via <code class="text-xs">id</code>
                    and <code class="text-xs">for</code>
                    attributes
                  </li>
                  <li>Focus visible ring styles for keyboard navigation</li>
                  <li>
                    Error state styling via <code class="text-xs">aria-invalid</code> attribute
                  </li>
                  <li>Disabled state prevents interaction and reduces opacity</li>
                  <li>Hidden input for proper form submission of unchecked values</li>
                  <li>
                    Peer support for styling adjacent labels based on checkbox state
                  </li>
                </ul>
              </.stack>
            </.card_content>
          </.card>
        </section>
      </.stack>
    </.container>
    """
  end
end
