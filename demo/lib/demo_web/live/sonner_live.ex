defmodule DemoWeb.Ui.SonnerLive do
  @moduledoc false
  use DemoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :toasts, [])}
  end

  @impl true
  def handle_event("show-info", _params, socket) do
    {:noreply, add_toast(socket, :info, "This is an informational message")}
  end

  def handle_event("show-success", _params, socket) do
    {:noreply, add_toast(socket, :success, "Your changes have been saved successfully!")}
  end

  def handle_event("show-warning", _params, socket) do
    {:noreply, add_toast(socket, :warning, "Please review your settings before continuing")}
  end

  def handle_event("show-error", _params, socket) do
    {:noreply, add_toast(socket, :error, "An error occurred while processing your request")}
  end

  def handle_event("show-multiple", _params, socket) do
    {:noreply,
     socket
     |> add_toast(:info, "Info: Processing your request...")
     |> add_toast(:success, "Success: Operation completed!")
     |> add_toast(:warning, "Warning: Check your email")
     |> add_toast(:error, "Error: Something went wrong")}
  end

  def handle_event("dismiss-toast", %{"id" => id}, socket) do
    toasts = Enum.reject(socket.assigns.toasts, fn {toast_id, _kind, _message} -> toast_id == id end)
    {:noreply, assign(socket, :toasts, toasts)}
  end

  defp add_toast(socket, kind, message) do
    id = "toast-#{System.unique_integer([:positive])}"
    toast = {id, kind, message}
    assign(socket, :toasts, [toast | socket.assigns.toasts])
  end

  @impl true
  def render(assigns) do
    ~H"""
    
      <%!-- Toast notifications in bottom-right --%>
      <div
        id="toast-container"
        class="fixed bottom-0 right-0 z-50 flex max-h-screen w-full flex-col-reverse gap-2 p-4 sm:bottom-0 sm:right-0 sm:top-auto sm:flex-col md:max-w-[420px]"
        aria-live="polite"
      >
        <div
          :for={{id, kind, message} <- @toasts}
          id={id}
          role={if kind == :error, do: "alert", else: "status"}
          class={[
            "group pointer-events-auto relative flex w-full items-center justify-between gap-3 overflow-hidden rounded-lg border p-4 shadow-lg transition-all",
            toast_classes(kind)
          ]}
        >
          <div class="flex shrink-0 items-center gap-3">
            <.icon :if={kind == :info} name="hero-information-circle" class="size-5" />
            <.icon :if={kind == :success} name="hero-check-circle" class="size-5" />
            <.icon :if={kind == :warning} name="hero-exclamation-triangle" class="size-5" />
            <.icon :if={kind == :error} name="hero-x-circle" class="size-5" />
            <div class="grid gap-1 text-sm font-medium">
              {message}
            </div>
          </div>
          <button
            type="button"
            phx-click="dismiss-toast"
            phx-value-id={id}
            class="absolute right-2 top-2 rounded-md p-1 opacity-70 transition-opacity hover:opacity-100"
            aria-label="Close"
          >
            <.icon name="hero-x-mark" class="size-4" />
          </button>
        </div>
      </div>

      <.container>
        <.stack size="large">
          <%!-- Header --%>
          <div>
            <h1 class="text-3xl font-bold text-foreground">Sonner Component</h1>
            <p class="text-muted-foreground mt-2">
              Toast notifications for displaying temporary messages and feedback using Phoenix LiveView flash messages.
            </p>
          </div>

          <%!-- Toast Types --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Toast Types</h2>
            <.card class="max-w-2xl">
              <.card_header>
                <.card_title>All Toast Variants</.card_title>
                <.card_description>
                  Click the buttons below to trigger different types of toast notifications
                </.card_description>
              </.card_header>
              <.card_content>
                <.grid cols={2}>
                  <.button variant="outline" phx-click="show-info">
                    <.icon name="hero-information-circle" /> Show Info Toast
                  </.button>

                  <.button variant="outline" phx-click="show-success">
                    <.icon name="hero-check-circle" /> Show Success Toast
                  </.button>

                  <.button variant="outline" phx-click="show-warning">
                    <.icon name="hero-exclamation-triangle" /> Show Warning Toast
                  </.button>

                  <.button variant="destructive" phx-click="show-error">
                    <.icon name="hero-x-circle" /> Show Error Toast
                  </.button>
                </.grid>
              </.card_content>
            </.card>
          </section>

          <%!-- Multiple Toasts --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Multiple Toasts</h2>
            <.card class="max-w-2xl">
              <.card_header>
                <.card_title>Stacked Toasts</.card_title>
                <.card_description>
                  Display multiple toasts at once - they will stack vertically
                </.card_description>
              </.card_header>
              <.card_content>
                <.button phx-click="show-multiple">
                  <.icon name="hero-squares-plus" /> Show All Toast Types
                </.button>
              </.card_content>
            </.card>
          </section>

          <%!-- Usage Example --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Usage in LiveView</h2>
            <.card class="max-w-2xl">
              <.card_header>
                <.card_title>How to Use Sonner</.card_title>
              </.card_header>
              <.card_content>
                <.stack size="small">
                  <p class="text-sm text-muted-foreground">
                    <strong>1. Add to Layout:</strong>
                    The Sonner component is already added to the app layout, so it will automatically display flash messages as toasts.
                  </p>

                  <.separator />

                  <p class="text-sm text-muted-foreground">
                    <strong>2. Trigger from LiveView:</strong>
                    Use put_flash in your event handlers with keys :success, :error, :info, or :warning.
                  </p>

                  <.separator />

                  <p class="text-sm text-muted-foreground">
                    <strong>3. Auto-dismiss:</strong>
                    Toasts automatically dismiss after 5 seconds by default. Users can also manually dismiss them by clicking the close button.
                  </p>
                </.stack>
              </.card_content>
            </.card>
          </section>

          <%!-- Features --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Features</h2>
            <.card class="max-w-2xl">
              <.card_header>
                <.card_title>Component Features</.card_title>
              </.card_header>
              <.card_content>
                <ul class="text-sm text-muted-foreground space-y-2 list-disc list-inside">
                  <li>
                    <strong>Automatic Icons</strong>
                    - Each toast type displays an appropriate icon (info, success, warning, error)
                  </li>
                  <li>
                    <strong>Auto-dismiss</strong>
                    - Toasts automatically hide after 5 seconds (configurable)
                  </li>
                  <li>
                    <strong>Manual Dismiss</strong> - Users can close toasts early via the X button
                  </li>
                  <li>
                    <strong>Stacking</strong>
                    - Multiple toasts stack vertically in the bottom-right corner
                  </li>
                  <li>
                    <strong>Smooth Animations</strong> - Slide-in and fade-out transitions
                  </li>
                  <li>
                    <strong>Theme Support</strong>
                    - Automatically adapts to light/dark mode using semantic color tokens
                  </li>
                  <li>
                    <strong>Accessibility</strong>
                    - Proper ARIA roles and live regions for screen readers
                  </li>
                  <li>
                    <strong>Flash Integration</strong>
                    - Works seamlessly with Phoenix LiveView's flash system
                  </li>
                </ul>
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
                <.stack size="small">
                  <p class="text-sm text-muted-foreground">
                    The Sonner component includes several accessibility features:
                  </p>
                  <ul class="text-sm text-muted-foreground space-y-2 list-disc list-inside">
                    <li>
                      Error toasts use <code class="text-xs">role="alert"</code>
                      for immediate screen reader announcement
                    </li>
                    <li>
                      Other toast types use <code class="text-xs">role="status"</code>
                      for non-intrusive announcements
                    </li>
                    <li>
                      Container has <code class="text-xs">aria-live="polite"</code>
                      for proper live region behavior
                    </li>
                    <li>Close button includes proper <code class="text-xs">aria-label</code></li>
                    <li>Keyboard accessible - close button can be focused and activated</li>
                    <li>Color combinations meet WCAG contrast requirements</li>
                  </ul>
                </.stack>
              </.card_content>
            </.card>
          </section>
        </.stack>
      </.container>
    
    """
  end

  defp toast_classes(:info),
    do:
      "bg-info/10 text-foreground border-info/20 [&>div>span[class*='hero-']]:text-info dark:bg-info/20 dark:border-info/30"

  defp toast_classes(:success),
    do:
      "bg-success/10 text-foreground border-success/20 [&>div>span[class*='hero-']]:text-success dark:bg-success/20 dark:border-success/30"

  defp toast_classes(:warning),
    do:
      "bg-warning/10 text-foreground border-warning/20 [&>div>span[class*='hero-']]:text-warning dark:bg-warning/20 dark:border-warning/30"

  defp toast_classes(:error),
    do:
      "bg-destructive/10 text-foreground border-destructive/20 [&>div>span[class*='hero-']]:text-destructive dark:bg-destructive/20 dark:border-destructive/30"
end
