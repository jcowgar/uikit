defmodule DemoWeb.Ui.InputGroupLive do
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
          <h1 class="text-3xl font-bold text-foreground">Input Group Component</h1>
          <p class="text-muted-foreground mt-2">
            Display additional information or actions alongside inputs or textareas.
          </p>
        </div>

        <%!-- Search Input with Icon --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Search Input</h2>
          <.stack gap="lg">
            <div>
              <.label for="search-1" class="mb-1.5">Search with Icon</.label>
              <.input_group>
                <.input_group_addon align="inline-start">
                  <span class="hero-magnifying-glass size-4" />
                </.input_group_addon>
                <.input_group_input id="search-1" placeholder="Search..." />
              </.input_group>
            </div>

            <div>
              <.label for="search-2" class="mb-1.5">Search with Result Count</.label>
              <.input_group>
                <.input_group_addon align="inline-start">
                  <span class="hero-magnifying-glass size-4" />
                </.input_group_addon>
                <.input_group_input id="search-2" placeholder="Search files..." />
                <.input_group_addon align="inline-end">
                  <.input_group_text>42 results</.input_group_text>
                </.input_group_addon>
              </.input_group>
            </div>
          </.stack>
        </section>

        <%!-- URL Input --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">URL Input</h2>
          <.stack gap="lg">
            <div>
              <.label for="url-1" class="mb-1.5">Website URL</.label>
              <.input_group>
                <.input_group_addon align="inline-start">
                  <.input_group_text>https://</.input_group_text>
                </.input_group_addon>
                <.input_group_input id="url-1" placeholder="example.com" />
              </.input_group>
            </div>

            <div>
              <.label for="url-2" class="mb-1.5">Full URL with Domain</.label>
              <.input_group>
                <.input_group_addon align="inline-start">
                  <.input_group_text>
                    <span class="hero-globe-alt size-4" /> https://
                  </.input_group_text>
                </.input_group_addon>
                <.input_group_input id="url-2" placeholder="www.example" />
                <.input_group_addon align="inline-end">
                  <.input_group_text>.com</.input_group_text>
                </.input_group_addon>
              </.input_group>
            </div>
          </.stack>
        </section>

        <%!-- Currency Input --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Currency Input</h2>
          <.stack gap="lg">
            <div>
              <.label for="currency-1" class="mb-1.5">Price</.label>
              <.input_group>
                <.input_group_addon align="inline-start">
                  <.input_group_text>$</.input_group_text>
                </.input_group_addon>
                <.input_group_input id="currency-1" type="number" placeholder="0.00" />
              </.input_group>
            </div>

            <div>
              <.label for="currency-2" class="mb-1.5">Amount with Currency</.label>
              <.input_group>
                <.input_group_addon align="inline-start">
                  <.input_group_text>$</.input_group_text>
                </.input_group_addon>
                <.input_group_input id="currency-2" type="number" placeholder="0.00" />
                <.input_group_addon align="inline-end">
                  <.input_group_text>USD</.input_group_text>
                </.input_group_addon>
              </.input_group>
            </div>
          </.stack>
        </section>

        <%!-- Email Input --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Email Input</h2>
          <.stack gap="lg">
            <div>
              <.label for="email-1" class="mb-1.5">Email with Icon</.label>
              <.input_group>
                <.input_group_addon align="inline-start">
                  <span class="hero-envelope size-4" />
                </.input_group_addon>
                <.input_group_input id="email-1" type="email" placeholder="Email" />
              </.input_group>
            </div>

            <div>
              <.label for="email-2" class="mb-1.5">Email with Domain</.label>
              <.input_group>
                <.input_group_input id="email-2" type="text" placeholder="username" />
                <.input_group_addon align="inline-end">
                  <.input_group_text>@example.com</.input_group_text>
                </.input_group_addon>
              </.input_group>
            </div>
          </.stack>
        </section>

        <%!-- Input with Buttons --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Input with Buttons</h2>
          <.stack gap="lg">
            <div>
              <.label for="password-1" class="mb-1.5">Password with Show Button</.label>
              <.input_group>
                <.input_group_input id="password-1" type="password" placeholder="Password" />
                <.input_group_addon align="inline-end">
                  <.input_group_button
                    size="icon-xs"
                    variant="ghost"
                    aria-label="Show password"
                    phx-hook="PasswordToggle"
                    data-input-id="password-1"
                    id="password-toggle-1"
                  >
                    <span class="hero-eye size-3.5" />
                  </.input_group_button>
                </.input_group_addon>
              </.input_group>
            </div>

            <div>
              <.label for="search-3" class="mb-1.5">Search with Button</.label>
              <.input_group>
                <.input_group_addon align="inline-start">
                  <span class="hero-magnifying-glass size-4" />
                </.input_group_addon>
                <.input_group_input id="search-3" placeholder="Search..." />
                <.input_group_addon align="inline-end">
                  <.input_group_button size="xs" variant="default">Search</.input_group_button>
                </.input_group_addon>
              </.input_group>
            </div>
          </.stack>
        </section>

        <%!-- Textarea with Actions --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Textarea with Actions</h2>
          <.stack gap="lg">
            <div>
              <.label for="message-1" class="mb-1.5">Message with Send Button</.label>
              <.input_group>
                <.input_group_textarea id="message-1" placeholder="Write a message..." rows="3" />
                <.input_group_addon align="block-end">
                  <.input_group_button size="sm" variant="default">
                    <span class="hero-paper-airplane size-4" /> Send
                  </.input_group_button>
                </.input_group_addon>
              </.input_group>
            </div>

            <div>
              <.label for="comment-1" class="mb-1.5">Comment with Character Count</.label>
              <.input_group>
                <.input_group_textarea id="comment-1" placeholder="Add a comment..." rows="3" />
                <.input_group_addon align="block-end">
                  <.input_group_button size="sm" variant="default">
                    <span class="hero-paper-airplane size-4" /> Post
                  </.input_group_button>
                  <.input_group_text>0/280</.input_group_text>
                </.input_group_addon>
              </.input_group>
            </div>

            <div>
              <.label for="note-1" class="mb-1.5">Note with Multiple Actions</.label>
              <.input_group>
                <.input_group_textarea id="note-1" placeholder="Write a note..." rows="4" />
                <.input_group_addon align="block-end">
                  <.input_group_button size="xs" variant="ghost" aria-label="Bold">
                    <span class="hero-bold size-3.5" />
                  </.input_group_button>
                  <.input_group_button size="xs" variant="ghost" aria-label="Italic">
                    <span class="hero-italic size-3.5" />
                  </.input_group_button>
                  <.input_group_button size="xs" variant="ghost" aria-label="Link">
                    <span class="hero-link size-3.5" />
                  </.input_group_button>
                  <div class="flex-1"></div>
                  <.input_group_text>Autosaved</.input_group_text>
                  <.input_group_button size="sm" variant="default">Save</.input_group_button>
                </.input_group_addon>
              </.input_group>
            </div>
          </.stack>
        </section>

        <%!-- Error State --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Error State</h2>
          <.stack gap="lg">
            <div>
              <.label for="error-email" class="mb-1.5">Invalid Email</.label>
              <.input_group>
                <.input_group_addon align="inline-start">
                  <span class="hero-envelope size-4" />
                </.input_group_addon>
                <.input_group_input
                  id="error-email"
                  type="email"
                  value="invalid-email"
                  aria-invalid="true"
                />
              </.input_group>
              <p class="text-sm text-destructive mt-1.5">
                Please enter a valid email address
              </p>
            </div>
          </.stack>
        </section>

        <%!-- Disabled State --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Disabled State</h2>
          <.stack gap="lg">
            <div>
              <.label for="disabled-1" class="mb-1.5">Disabled Input</.label>
              <.input_group disabled>
                <.input_group_addon align="inline-start">
                  <span class="hero-magnifying-glass size-4" />
                </.input_group_addon>
                <.input_group_input id="disabled-1" placeholder="Disabled..." disabled />
              </.input_group>
            </div>
          </.stack>
        </section>

        <%!-- Login Form Example --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Login Form Example</h2>
          <.card class="max-w-md">
            <.card_header>
              <.card_title>Sign In</.card_title>
              <.card_description>Enter your credentials to access your account</.card_description>
            </.card_header>
            <.card_content>
              <form>
                <.stack gap="lg">
                  <div>
                    <.label for="login-email" class="mb-1.5">Email</.label>
                    <.input_group>
                      <.input_group_addon align="inline-start">
                        <span class="hero-envelope size-4" />
                      </.input_group_addon>
                      <.input_group_input
                        id="login-email"
                        type="email"
                        placeholder="you@example.com"
                      />
                    </.input_group>
                  </div>

                  <div>
                    <.label for="login-password" class="mb-1.5">Password</.label>
                    <.input_group>
                      <.input_group_input
                        id="login-password"
                        type="password"
                        placeholder="Enter your password"
                      />
                      <.input_group_addon align="inline-end">
                        <.input_group_button
                          size="icon-xs"
                          variant="ghost"
                          aria-label="Show password"
                          phx-hook="PasswordToggle"
                          data-input-id="login-password"
                          id="login-password-toggle"
                        >
                          <span class="hero-eye size-3.5" />
                        </.input_group_button>
                      </.input_group_addon>
                    </.input_group>
                  </div>

                  <.button class="w-full">Sign In</.button>
                </.stack>
              </form>
            </.card_content>
          </.card>
        </section>

        <%!-- Product Form Example --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Product Form Example</h2>
          <.card class="max-w-md">
            <.card_header>
              <.card_title>Create Product</.card_title>
              <.card_description>Enter product information</.card_description>
            </.card_header>
            <.card_content>
              <form>
                <.stack gap="lg">
                  <div>
                    <.label for="product-name" class="mb-1.5">Product Name</.label>
                    <.input_group>
                      <.input_group_addon align="inline-start">
                        <span class="hero-cube size-4" />
                      </.input_group_addon>
                      <.input_group_input id="product-name" placeholder="Enter product name" />
                    </.input_group>
                  </div>

                  <div>
                    <.label for="product-price" class="mb-1.5">Price</.label>
                    <.input_group>
                      <.input_group_addon align="inline-start">
                        <.input_group_text>$</.input_group_text>
                      </.input_group_addon>
                      <.input_group_input id="product-price" type="number" placeholder="0.00" />
                      <.input_group_addon align="inline-end">
                        <.input_group_text>USD</.input_group_text>
                      </.input_group_addon>
                    </.input_group>
                  </div>

                  <div>
                    <.label for="product-url" class="mb-1.5">Product URL</.label>
                    <.input_group>
                      <.input_group_addon align="inline-start">
                        <.input_group_text>https://</.input_group_text>
                      </.input_group_addon>
                      <.input_group_input id="product-url" placeholder="example.com/product" />
                    </.input_group>
                  </div>

                  <div>
                    <.label for="product-description" class="mb-1.5">Description</.label>
                    <.input_group>
                      <.input_group_textarea
                        id="product-description"
                        placeholder="Enter product description..."
                        rows="3"
                      />
                      <.input_group_addon align="block-end">
                        <.input_group_text>0/500</.input_group_text>
                      </.input_group_addon>
                    </.input_group>
                  </div>

                  <.button class="w-full">Create Product</.button>
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
              <.stack gap="md">
                <p class="text-sm text-muted-foreground">
                  The Input Group component includes several accessibility features:
                </p>
                <ul class="text-sm text-muted-foreground space-y-2 list-disc list-inside">
                  <li>
                    Focus ring encompasses the entire group for better keyboard navigation visibility
                  </li>
                  <li>
                    Error state styling via <code class="text-xs">aria-invalid</code> attribute
                  </li>
                  <li>
                    Clicking on addons automatically focuses the input for better usability
                  </li>
                  <li>
                    Disabled state affects the entire group and all child elements
                  </li>
                  <li>
                    Proper role attributes (<code class="text-xs">role="group"</code>) for screen readers
                  </li>
                  <li>
                    Icon-only buttons should include <code class="text-xs">aria-label</code>
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
