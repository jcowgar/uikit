defmodule DemoWeb.Ui.TextareaLive do
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
            <h1 class="text-3xl font-bold text-foreground">Textarea Component</h1>
            <p class="text-muted-foreground mt-2">
              Multi-line text input from shadcn/ui with content-based sizing and consistent styling.
            </p>
          </div>

          <%!-- Basic Textarea --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Basic Textarea</h2>
            <.stack size="medium">
              <div>
                <.label for="basic-textarea" class="mb-1.5">Message</.label>
                <.textarea id="basic-textarea" placeholder="Enter your message..." />
              </div>

              <div>
                <.label for="textarea-with-value" class="mb-1.5">With Initial Value</.label>
                <.textarea
                  id="textarea-with-value"
                  value="This textarea has some initial content that demonstrates the component."
                />
              </div>
            </.stack>
          </section>

          <%!-- With Helper Text --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">With Helper Text</h2>
            <.stack size="medium">
              <div>
                <.label for="textarea-helper" class="mb-1.5">Bio</.label>
                <.textarea
                  id="textarea-helper"
                  placeholder="Tell us about yourself..."
                  aria-describedby="bio-description"
                />
                <p id="bio-description" class="text-sm text-muted-foreground mt-1.5">
                  This will be displayed on your public profile.
                </p>
              </div>

              <div>
                <.label for="textarea-comment" class="mb-1.5">Comment</.label>
                <.textarea
                  id="textarea-comment"
                  placeholder="Add your comment..."
                  aria-describedby="comment-description"
                />
                <p id="comment-description" class="text-sm text-muted-foreground mt-1.5">
                  Your comment will be visible to everyone.
                </p>
              </div>
            </.stack>
          </section>

          <%!-- Disabled State --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Disabled</h2>
            <.stack size="medium">
              <div>
                <.label for="disabled-textarea" class="mb-1.5">Disabled Textarea</.label>
                <.textarea id="disabled-textarea" placeholder="This textarea is disabled" disabled />
              </div>

              <div>
                <.label for="disabled-value-textarea" class="mb-1.5">
                  Disabled with Value
                </.label>
                <.textarea
                  id="disabled-value-textarea"
                  value="This content cannot be edited because the textarea is disabled."
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
                <.label for="error-textarea" class="mb-1.5">Invalid Content</.label>
                <.textarea
                  id="error-textarea"
                  placeholder="Enter your feedback..."
                  value="Too short"
                  aria-invalid="true"
                  aria-describedby="feedback-error"
                />
                <p id="feedback-error" class="text-sm text-destructive mt-1.5">
                  Feedback must be at least 10 characters long
                </p>
              </div>

              <div>
                <.label for="required-textarea" class="mb-1.5">Required Field</.label>
                <.textarea
                  id="required-textarea"
                  placeholder="This field is required"
                  aria-invalid="true"
                  aria-describedby="required-error"
                  required
                />
                <p id="required-error" class="text-sm text-destructive mt-1.5">
                  This field is required
                </p>
              </div>
            </.stack>
          </section>

          <%!-- With Fixed Rows --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Fixed Rows</h2>
            <.stack size="medium">
              <div>
                <.label for="textarea-3-rows" class="mb-1.5">
                  3 Rows (No Content Sizing)
                </.label>
                <.textarea
                  id="textarea-3-rows"
                  rows="3"
                  placeholder="This textarea has 3 fixed rows"
                />
                <p class="text-sm text-muted-foreground mt-1.5">
                  Note: Setting rows disables content-based sizing
                </p>
              </div>

              <div>
                <.label for="textarea-8-rows" class="mb-1.5">
                  8 Rows (Larger Fixed Height)
                </.label>
                <.textarea
                  id="textarea-8-rows"
                  rows="8"
                  placeholder="This textarea has 8 fixed rows for longer content"
                />
              </div>
            </.stack>
          </section>

          <%!-- With Custom Width --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Custom Width</h2>
            <.stack size="medium">
              <div>
                <.label for="textarea-max-w-md" class="mb-1.5">Medium Width (max-w-md)</.label>
                <.textarea
                  id="textarea-max-w-md"
                  placeholder="This textarea has a max width of medium"
                  class="max-w-md"
                />
              </div>

              <div>
                <.label for="textarea-max-w-xs" class="mb-1.5">Small Width (max-w-xs)</.label>
                <.textarea
                  id="textarea-max-w-xs"
                  placeholder="Narrow textarea"
                  class="max-w-xs"
                />
              </div>

              <div>
                <.label for="textarea-full" class="mb-1.5">Full Width (default)</.label>
                <.textarea id="textarea-full" placeholder="This textarea spans the full width" />
              </div>
            </.stack>
          </section>

          <%!-- Form Example --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Form Example</h2>
            <.card class="max-w-2xl">
              <.card_header>
                <.card_title>Submit Feedback</.card_title>
                <.card_description>
                  We'd love to hear your thoughts about our service
                </.card_description>
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
                      <.label for="form-feedback" class="mb-1.5">Feedback</.label>
                      <.textarea
                        id="form-feedback"
                        placeholder="Share your thoughts..."
                        name="feedback"
                        aria-describedby="feedback-help"
                      />
                      <p id="feedback-help" class="text-sm text-muted-foreground mt-1.5">
                        Please provide as much detail as possible.
                      </p>
                    </div>

                    <.button class="w-full">Submit Feedback</.button>
                  </.stack>
                </form>
              </.card_content>
            </.card>
          </section>

          <%!-- Character Counter Example --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">With Character Counter</h2>
            <.stack size="medium">
              <div>
                <.label for="textarea-counter" class="mb-1.5">Description</.label>
                <.textarea
                  id="textarea-counter"
                  placeholder="Enter description..."
                  maxlength="200"
                  aria-describedby="counter-help"
                />
                <p id="counter-help" class="text-sm text-muted-foreground mt-1.5">
                  Maximum 200 characters
                </p>
              </div>
            </.stack>
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
                    The textarea component includes several accessibility features:
                  </p>
                  <ul class="text-sm text-muted-foreground space-y-2 list-disc list-inside">
                    <li>Focus visible ring styles for keyboard navigation</li>
                    <li>
                      Error state styling via <code class="text-xs">aria-invalid</code> attribute
                    </li>
                    <li>
                      Support for <code class="text-xs">aria-describedby</code>
                      for helper text and error messages
                    </li>
                    <li>
                      Support for <code class="text-xs">aria-label</code> for screen readers
                    </li>
                    <li>Proper disabled state that prevents interaction</li>
                    <li>Required field support with native browser validation</li>
                    <li>
                      Content-based sizing with <code class="text-xs">field-sizing-content</code>
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
