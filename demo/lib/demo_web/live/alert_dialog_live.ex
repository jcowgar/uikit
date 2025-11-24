defmodule DemoWeb.Ui.AlertDialogLive do
  @moduledoc false
  use DemoWeb, :live_view

  alias Phoenix.LiveView.Socket

  @impl true
  @spec mount(map(), map(), Socket.t()) ::
          {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:item_count, 42)
      |> assign(:account_name, "JohnDoe")

    {:ok, socket}
  end

  @impl true
  @spec handle_event(String.t(), map(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("delete-account", _params, socket) do
    # Simulate account deletion logic
    # In real app: Accounts.delete_user(socket.assigns.current_user)

    {:noreply,
     socket
     |> put_flash(:info, "Account deleted successfully")
     |> push_event("close-alert-dialog", %{id: "delete-account"})}
  end

  def handle_event("delete-item", _params, socket) do
    # Simulate item deletion logic
    # In real app: Items.delete(item_id)

    {:noreply,
     socket
     |> put_flash(:info, "Item deleted")
     |> push_event("close-alert-dialog", %{id: "delete-item"})}
  end

  def handle_event("save-changes", _params, socket) do
    # Simulate save logic
    # In real app: save changes to database

    {:noreply,
     socket
     |> put_flash(:info, "Changes saved successfully")
     |> push_event("close-alert-dialog", %{id: "save-changes"})}
  end

  def handle_event("accept-terms", _params, socket) do
    # Simulate accepting terms
    # In real app: User.update(user, %{terms_accepted: true})

    {:noreply,
     socket
     |> put_flash(:info, "Terms accepted")
     |> push_event("close-alert-dialog", %{id: "terms"})}
  end

  def handle_event("confirm-action", %{"action" => action, "dialog_id" => dialog_id}, socket) do
    # Generic confirmation handler
    {:noreply,
     socket
     |> put_flash(:info, "Action confirmed: #{action}")
     |> push_event("close-alert-dialog", %{id: dialog_id})}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.container>
      <.stack size="large">
        <%!-- Header --%>
        <div>
          <h1 class="text-3xl font-bold text-foreground">Alert Dialog Component</h1>
          <p class="text-muted-foreground mt-2">
            A modal dialog that interrupts the user with important content and expects a response.
          </p>
        </div>

        <%!-- Basic Example --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Basic Alert Dialog</h2>
          <.alert_dialog id="basic-alert">
            <:trigger>
              <.button variant="outline">Show Alert</.button>
            </:trigger>
            <:content>
              <.alert_dialog_header>
                <.alert_dialog_title>Are you absolutely sure?</.alert_dialog_title>
                <.alert_dialog_description>
                  This action cannot be undone. This will permanently delete your
                  account and remove your data from our servers.
                </.alert_dialog_description>
              </.alert_dialog_header>
              <.alert_dialog_footer>
                <.alert_dialog_cancel dialog_id="basic-alert">Cancel</.alert_dialog_cancel>
                <.alert_dialog_action
                  phx-click="confirm-action"
                  phx-value-action="basic"
                  phx-value-dialog_id="basic-alert"
                >
                  Continue
                </.alert_dialog_action>
              </.alert_dialog_footer>
            </:content>
          </.alert_dialog>
        </section>

        <%!-- Destructive Action --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Destructive Action</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Use for actions that can't be undone, like deleting data.
          </p>
          <.flex align="start" class="gap-4">
            <%!-- Delete Account --%>
            <.alert_dialog id="delete-account">
              <:trigger>
                <.button variant="destructive">
                  <.icon name="hero-trash" /> Delete Account
                </.button>
              </:trigger>
              <:content>
                <.alert_dialog_header>
                  <.alert_dialog_title>Delete Account?</.alert_dialog_title>
                  <.alert_dialog_description>
                    This will permanently delete your account
                    <strong class="font-semibold">{@account_name}</strong>
                    and remove all your data from our servers. This action cannot be undone.
                  </.alert_dialog_description>
                </.alert_dialog_header>
                <.alert_dialog_footer>
                  <.alert_dialog_cancel dialog_id="delete-account">Cancel</.alert_dialog_cancel>
                  <.alert_dialog_action
                    class="bg-destructive text-destructive-foreground hover:bg-destructive/90"
                    phx-click="delete-account"
                  >
                    Delete Account
                  </.alert_dialog_action>
                </.alert_dialog_footer>
              </:content>
            </.alert_dialog>

            <%!-- Delete Item --%>
            <.alert_dialog id="delete-item">
              <:trigger>
                <.button variant="outline" class="text-destructive">
                  <.icon name="hero-trash" /> Delete Item
                </.button>
              </:trigger>
              <:content>
                <.alert_dialog_header>
                  <.alert_dialog_title>Delete this item?</.alert_dialog_title>
                  <.alert_dialog_description>
                    This will permanently delete the item. This action cannot be undone.
                  </.alert_dialog_description>
                </.alert_dialog_header>
                <.alert_dialog_footer>
                  <.alert_dialog_cancel dialog_id="delete-item">Keep Item</.alert_dialog_cancel>
                  <.alert_dialog_action
                    class="bg-destructive text-destructive-foreground hover:bg-destructive/90"
                    phx-click="delete-item"
                  >
                    Delete
                  </.alert_dialog_action>
                </.alert_dialog_footer>
              </:content>
            </.alert_dialog>
          </.flex>
        </section>

        <%!-- Confirmation Dialog --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Confirmation Dialog</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Use for confirming important actions that aren't destructive.
          </p>
          <.alert_dialog id="save-changes">
            <:trigger>
              <.button>
                <.icon name="hero-check" /> Save Changes
              </.button>
            </:trigger>
            <:content>
              <.alert_dialog_header>
                <.alert_dialog_title>Save changes?</.alert_dialog_title>
                <.alert_dialog_description>
                  You have unsaved changes. Would you like to save them before leaving?
                </.alert_dialog_description>
              </.alert_dialog_header>
              <.alert_dialog_footer>
                <.alert_dialog_cancel dialog_id="save-changes">Don't Save</.alert_dialog_cancel>
                <.alert_dialog_action phx-click="save-changes">
                  Save Changes
                </.alert_dialog_action>
              </.alert_dialog_footer>
            </:content>
          </.alert_dialog>
        </section>

        <%!-- Important Notice --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Important Notice</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Use for displaying critical information that requires acknowledgment.
          </p>
          <.alert_dialog id="terms">
            <:trigger>
              <.button variant="outline">
                <.icon name="hero-document-text" /> View Terms
              </.button>
            </:trigger>
            <:content>
              <.alert_dialog_header>
                <.alert_dialog_title>Terms of Service</.alert_dialog_title>
                <.alert_dialog_description>
                  Please read and accept our terms of service before continuing.
                </.alert_dialog_description>
              </.alert_dialog_header>
              <div class="py-4 max-h-64 overflow-y-auto">
                <div class="space-y-4 text-sm text-muted-foreground">
                  <p>
                    <strong class="text-foreground">1. Acceptance of Terms</strong>
                    <br />
                    By accessing and using this service, you accept and agree to be bound by the terms and provision of this agreement.
                  </p>
                  <p>
                    <strong class="text-foreground">2. Use License</strong>
                    <br />
                    Permission is granted to temporarily use this service for personal, non-commercial transitory viewing only.
                  </p>
                  <p>
                    <strong class="text-foreground">3. Disclaimer</strong>
                    <br />
                    The materials on this service are provided on an 'as is' basis. We make no warranties, expressed or implied.
                  </p>
                  <p>
                    <strong class="text-foreground">4. Limitations</strong>
                    <br />
                    In no event shall our company be liable for any damages arising out of the use or inability to use the service.
                  </p>
                </div>
              </div>
              <.alert_dialog_footer>
                <.alert_dialog_cancel dialog_id="terms">Decline</.alert_dialog_cancel>
                <.alert_dialog_action phx-click="accept-terms">
                  Accept & Continue
                </.alert_dialog_action>
              </.alert_dialog_footer>
            </:content>
          </.alert_dialog>
        </section>

        <%!-- Multiple Actions --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">With Multiple Options</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Alert dialogs can include additional content and custom layouts.
          </p>
          <.alert_dialog id="export-data">
            <:trigger>
              <.button variant="outline">
                <.icon name="hero-arrow-down-tray" /> Export Data
              </.button>
            </:trigger>
            <:content>
              <.alert_dialog_header>
                <.alert_dialog_title>Export your data</.alert_dialog_title>
                <.alert_dialog_description>
                  Choose how you'd like to export your data. This may take a few moments.
                </.alert_dialog_description>
              </.alert_dialog_header>
              <div class="py-4 space-y-2">
                <div class="flex items-center gap-3 p-3 border border-border rounded-md hover:bg-accent cursor-pointer">
                  <.icon name="hero-document-text" class="size-5 text-muted-foreground" />
                  <div>
                    <p class="text-sm font-medium text-foreground">CSV Format</p>
                    <p class="text-xs text-muted-foreground">
                      Export as comma-separated values
                    </p>
                  </div>
                </div>
                <div class="flex items-center gap-3 p-3 border border-border rounded-md hover:bg-accent cursor-pointer">
                  <.icon name="hero-document-text" class="size-5 text-muted-foreground" />
                  <div>
                    <p class="text-sm font-medium text-foreground">JSON Format</p>
                    <p class="text-xs text-muted-foreground">
                      Export as JavaScript Object Notation
                    </p>
                  </div>
                </div>
                <div class="flex items-center gap-3 p-3 border border-border rounded-md hover:bg-accent cursor-pointer">
                  <.icon name="hero-document-text" class="size-5 text-muted-foreground" />
                  <div>
                    <p class="text-sm font-medium text-foreground">Excel Format</p>
                    <p class="text-xs text-muted-foreground">Export as Microsoft Excel file</p>
                  </div>
                </div>
              </div>
              <.alert_dialog_footer>
                <.alert_dialog_cancel dialog_id="export-data">Cancel</.alert_dialog_cancel>
                <.alert_dialog_action
                  phx-click="confirm-action"
                  phx-value-action="export"
                  phx-value-dialog_id="export-data"
                >
                  Export
                </.alert_dialog_action>
              </.alert_dialog_footer>
            </:content>
          </.alert_dialog>
        </section>

        <%!-- Custom Styling --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Custom Styling</h2>
          <p class="text-sm text-muted-foreground mb-4">
            You can customize the appearance using the class attribute.
          </p>
          <.alert_dialog id="custom-style">
            <:trigger>
              <.button variant="outline">Custom Style</.button>
            </:trigger>
            <:content>
              <.alert_dialog_header class="bg-warning/10 -m-6 mb-0 p-6 rounded-t-lg">
                <.alert_dialog_title class="flex items-center gap-2 text-warning">
                  <.icon name="hero-exclamation-triangle" class="size-5" /> Warning
                </.alert_dialog_title>
                <.alert_dialog_description class="text-foreground/80">
                  This action requires your attention before proceeding.
                </.alert_dialog_description>
              </.alert_dialog_header>
              <div class="py-4">
                <p class="text-sm text-muted-foreground">
                  Proceeding with this action will apply changes that may affect your existing configuration.
                  Please review carefully before confirming.
                </p>
              </div>
              <.alert_dialog_footer>
                <.alert_dialog_cancel dialog_id="custom-style">Go Back</.alert_dialog_cancel>
                <.alert_dialog_action
                  phx-click="confirm-action"
                  phx-value-action="custom"
                  phx-value-dialog_id="custom-style"
                >
                  I Understand
                </.alert_dialog_action>
              </.alert_dialog_footer>
            </:content>
          </.alert_dialog>
        </section>

        <%!-- Usage Guidelines --%>
        <section class="border-t border-border pt-8">
          <h2 class="text-xl font-semibold text-foreground mb-4">Usage Guidelines</h2>
          <div class="space-y-4 text-sm">
            <div>
              <h3 class="font-medium text-foreground mb-2">When to Use</h3>
              <ul class="list-disc list-inside space-y-1 text-muted-foreground">
                <li>For critical actions that require explicit user confirmation</li>
                <li>When the action is irreversible or has significant consequences</li>
                <li>To display important information that requires acknowledgment</li>
                <li>For destructive operations like deletion or permanent changes</li>
              </ul>
            </div>
            <div>
              <h3 class="font-medium text-foreground mb-2">Best Practices</h3>
              <ul class="list-disc list-inside space-y-1 text-muted-foreground">
                <li>Keep the title clear and concise</li>
                <li>Explain the consequences in the description</li>
                <li>Use action verbs in buttons ("Delete", "Continue", "Accept")</li>
                <li>
                  Make the cancel button less prominent than the action button (unless destructive)
                </li>
                <li>
                  For destructive actions, style the action button with the destructive variant
                </li>
              </ul>
            </div>
            <div>
              <h3 class="font-medium text-foreground mb-2">Accessibility</h3>
              <ul class="list-disc list-inside space-y-1 text-muted-foreground">
                <li>Dialog traps focus within the modal</li>
                <li>Escape key closes the dialog</li>
                <li>Clicking outside the dialog closes it</li>
                <li>Proper ARIA attributes for screen readers</li>
              </ul>
            </div>
          </div>
        </section>
      </.stack>
    </.container>
    """
  end
end
