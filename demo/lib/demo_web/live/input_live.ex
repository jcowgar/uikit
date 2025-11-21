defmodule DemoWeb.Ui.InputLive do
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
            <h1 class="text-3xl font-bold text-foreground">Input Component</h1>
            <p class="text-muted-foreground mt-2">
              Base input field from shadcn/ui with consistent styling and accessibility features.
            </p>
          </div>

          <%!-- Basic Inputs --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Input Types</h2>
            <.stack size="medium">
              <div>
                <.label for="text-input" class="mb-1.5">Text Input</.label>
                <.input type="text" id="text-input" placeholder="Enter text" />
              </div>

              <div>
                <.label for="email-input" class="mb-1.5">Email Input</.label>
                <.input type="email" id="email-input" placeholder="Email" />
              </div>

              <div>
                <.label for="password-input" class="mb-1.5">Password Input</.label>
                <.input type="password" id="password-input" placeholder="Password" />
              </div>

              <div>
                <.label for="number-input" class="mb-1.5">Number Input</.label>
                <.input type="number" id="number-input" placeholder="Enter number" />
              </div>

              <div>
                <.label for="tel-input" class="mb-1.5">Telephone Input</.label>
                <.input type="tel" id="tel-input" placeholder="(555) 123-4567" />
              </div>

              <div>
                <.label for="url-input" class="mb-1.5">URL Input</.label>
                <.input type="url" id="url-input" placeholder="https://example.com" />
              </div>
            </.stack>
          </section>

          <%!-- Disabled State --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Disabled</h2>
            <.stack size="medium">
              <div>
                <.label for="disabled-input" class="mb-1.5">Disabled Input</.label>
                <.input type="text" id="disabled-input" placeholder="Disabled input" disabled />
              </div>

              <div>
                <.label for="disabled-value-input" class="mb-1.5">
                  Disabled with Value
                </.label>
                <.input
                  type="text"
                  id="disabled-value-input"
                  value="Cannot edit this"
                  disabled
                />
              </div>
            </.stack>
          </section>

          <%!-- Error/Invalid State --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Error State</h2>
            <.stack size="medium">
              <div>
                <.label for="REPLACE_ID" class="mb-1.5">
                  Invalid Email
                </.label>
                <.input
                  type="email"
                  placeholder="Email"
                  value="invalid-email"
                  aria-invalid="true"
                  aria-describedby="email-error"
                />
                <p id="email-error" class="text-sm text-destructive mt-1.5">
                  Please enter a valid email address
                </p>
              </div>

              <div>
                <.label for="REPLACE_ID" class="mb-1.5">
                  Required Field
                </.label>
                <.input
                  type="text"
                  placeholder="Required field"
                  aria-invalid="true"
                  aria-describedby="required-error"
                />
                <p id="required-error" class="text-sm text-destructive mt-1.5">
                  This field is required
                </p>
              </div>
            </.stack>
          </section>

          <%!-- File Input --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">File Input</h2>
            <.stack size="medium">
              <div>
                <.label for="REPLACE_ID" class="mb-1.5">
                  Upload File
                </.label>
                <.input type="file" id="file-upload" />
              </div>

              <div>
                <.label for="REPLACE_ID" class="mb-1.5">
                  Upload Multiple Files
                </.label>
                <.input type="file" id="file-multiple" multiple />
              </div>

              <div>
                <.label for="REPLACE_ID" class="mb-1.5">
                  Upload Image
                </.label>
                <.input type="file" id="file-image" accept="image/*" />
              </div>
            </.stack>
          </section>

          <%!-- With Custom Width --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Custom Width</h2>
            <.stack size="medium">
              <div>
                <.label for="REPLACE_ID" class="mb-1.5">
                  Half Width (max-w-md)
                </.label>
                <.input type="text" id="width-md" placeholder="Max width medium" class="max-w-md" />
              </div>

              <div>
                <.label for="REPLACE_ID" class="mb-1.5">
                  Small Width (max-w-xs)
                </.label>
                <.input type="text" id="width-xs" placeholder="Max width small" class="max-w-xs" />
              </div>

              <div>
                <.label for="REPLACE_ID" class="mb-1.5">
                  Full Width (default)
                </.label>
                <.input type="text" id="width-full" placeholder="Full width" />
              </div>
            </.stack>
          </section>

          <%!-- Form Example --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Form Example</h2>
            <.card class="max-w-md">
              <.card_header>
                <.card_title>Create Account</.card_title>
                <.card_description>Enter your information to create an account</.card_description>
              </.card_header>
              <.card_content>
                <form>
                  <.stack size="medium">
                    <div>
                      <.label for="form-name" class="mb-1.5">Name</.label>
                      <.input
                        type="text"
                        id="form-name"
                        placeholder="John Doe"
                        name="name"
                        autocomplete="name"
                      />
                    </div>

                    <div>
                      <.label for="form-email" class="mb-1.5">Email</.label>
                      <.input
                        type="email"
                        id="form-email"
                        placeholder="john@example.com"
                        name="email"
                      />
                    </div>

                    <div>
                      <.label for="REPLACE_ID" class="mb-1.5">
                        Password
                      </.label>
                      <.input
                        type="password"
                        placeholder="••••••••"
                        name="password"
                        autocomplete="new-password"
                      />
                    </div>

                    <.button class="w-full">Create Account</.button>
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
                    The input component includes several accessibility features:
                  </p>
                  <ul class="text-sm text-muted-foreground space-y-2 list-disc list-inside">
                    <li>Focus visible ring styles for keyboard navigation</li>
                    <li>
                      Error state styling via <code class="text-xs">aria-invalid</code> attribute
                    </li>
                    <li>
                      Support for <code class="text-xs">aria-describedby</code> for error messages
                    </li>
                    <li>
                      Support for <code class="text-xs">aria-label</code> for screen readers
                    </li>
                    <li>Proper disabled state that prevents interaction</li>
                    <li>Required field support with native browser validation</li>
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
