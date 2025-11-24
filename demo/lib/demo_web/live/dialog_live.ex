defmodule DemoWeb.Ui.DialogLive do
  @moduledoc false
  use DemoWeb, :live_view

  alias Phoenix.LiveView.Socket

  @impl true
  @spec mount(map(), map(), Socket.t()) ::
          {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:profile_name, "Jane Doe")
      |> assign(:profile_email, "jane@example.com")
      |> assign(:profile_bio, "Software developer and UI enthusiast")

    {:ok, socket}
  end

  @impl true
  @spec handle_event(String.t(), map(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("save-settings", _params, socket) do
    # Simulate save settings logic
    {:noreply,
     socket
     |> put_flash(:info, "Settings saved successfully")
     |> push_event("close-dialog", %{id: "basic-dialog"})}
  end

  def handle_event("save-profile", _params, socket) do
    # Simulate save profile logic
    {:noreply,
     socket
     |> put_flash(:info, "Profile updated successfully")
     |> push_event("close-dialog", %{id: "edit-profile"})}
  end

  def handle_event("create-project", _params, socket) do
    # Simulate project creation logic
    {:noreply,
     socket
     |> put_flash(:info, "Project created successfully")
     |> push_event("close-dialog", %{id: "wide-dialog"})}
  end

  def handle_event("share-document", %{"method" => method}, socket) do
    # Simulate sharing logic
    {:noreply,
     socket
     |> put_flash(:info, "Document shared via #{method}")
     |> push_event("close-dialog", %{id: "share-dialog"})}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.container>
      <.stack size="large">
        <%!-- Header --%>
        <div>
          <h1 class="text-3xl font-bold text-foreground">Dialog Component</h1>
          <p class="text-muted-foreground mt-2">
            A modal dialog that overlays the primary window for important content that requires user attention.
          </p>
        </div>

        <%!-- Basic Example --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Basic Dialog</h2>
          <.dialog id="basic-dialog">
            <:trigger>
              <.button variant="outline">Open Dialog</.button>
            </:trigger>
            <:content>
              <.dialog_header>
                <.dialog_title>Account Settings</.dialog_title>
                <.dialog_description>
                  Make changes to your account here. Click save when you're done.
                </.dialog_description>
              </.dialog_header>

              <div class="py-4">
                <p class="text-sm text-muted-foreground">
                  This is a basic dialog with header, content area, and footer.
                  You can include any content you like here.
                </p>
              </div>

              <.dialog_footer dialog_id="basic-dialog">
                <.button phx-click="save-settings">Save Changes</.button>
              </.dialog_footer>
            </:content>
          </.dialog>
        </section>

        <%!-- Form Dialog --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Dialog with Form</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Dialogs are perfect for forms that don't require a full page.
          </p>
          <.dialog id="edit-profile">
            <:trigger>
              <.button>
                <.icon name="hero-pencil" /> Edit Profile
              </.button>
            </:trigger>
            <:content>
              <.dialog_header>
                <.dialog_title>Edit Profile</.dialog_title>
                <.dialog_description>
                  Update your profile information below.
                </.dialog_description>
              </.dialog_header>

              <div class="py-4 space-y-4">
                <div>
                  <label class="text-sm font-medium text-foreground">Name</label>
                  <input
                    type="text"
                    value={@profile_name}
                    autofocus
                    class="mt-1.5 flex w-full rounded-md border border-input bg-background px-3 py-2 text-sm text-foreground placeholder:text-muted-foreground focus:ring-2 focus:ring-ring focus:ring-offset-2 focus:outline-hidden disabled:cursor-not-allowed disabled:opacity-50"
                    placeholder="Your name"
                  />
                </div>
                <div>
                  <label class="text-sm font-medium text-foreground">Email</label>
                  <input
                    type="email"
                    value={@profile_email}
                    class="mt-1.5 flex w-full rounded-md border border-input bg-background px-3 py-2 text-sm text-foreground placeholder:text-muted-foreground focus:ring-2 focus:ring-ring focus:ring-offset-2 focus:outline-hidden disabled:cursor-not-allowed disabled:opacity-50"
                    placeholder="your@email.com"
                  />
                </div>
                <div>
                  <label class="text-sm font-medium text-foreground">Bio</label>
                  <textarea
                    rows="3"
                    class="mt-1.5 flex w-full rounded-md border border-input bg-background px-3 py-2 text-sm text-foreground placeholder:text-muted-foreground focus:ring-2 focus:ring-ring focus:ring-offset-2 focus:outline-hidden disabled:cursor-not-allowed disabled:opacity-50"
                    placeholder="Tell us about yourself"
                  >{@profile_bio}</textarea>
                </div>
              </div>

              <.dialog_footer dialog_id="edit-profile">
                <.button phx-click="save-profile">Save Changes</.button>
              </.dialog_footer>
            </:content>
          </.dialog>
        </section>

        <%!-- Without Close Button --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Dialog Without Close Button</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Use when you want to force the user to take an action before closing.
          </p>
          <.dialog id="required-action">
            <:trigger>
              <.button variant="outline">Start Process</.button>
            </:trigger>
            <:content show_close_button={false}>
              <.dialog_header>
                <.dialog_title>Processing Request</.dialog_title>
                <.dialog_description>
                  Please wait while we process your request. This may take a few moments.
                </.dialog_description>
              </.dialog_header>

              <div class="py-8 flex justify-center">
                <div class="flex flex-col items-center gap-4">
                  <.spinner class="size-8" />
                  <p class="text-sm text-muted-foreground">Processing...</p>
                </div>
              </div>
            </:content>
          </.dialog>
        </section>

        <%!-- Custom Width --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Custom Width Dialog</h2>
          <p class="text-sm text-muted-foreground mb-4">
            You can customize the dialog size using the class attribute.
          </p>
          <.dialog id="wide-dialog">
            <:trigger>
              <.button variant="outline">
                <.icon name="hero-document-plus" /> Create Project
              </.button>
            </:trigger>
            <:content>
              <.dialog_header>
                <.dialog_title>Create New Project</.dialog_title>
                <.dialog_description>
                  Set up your project details and configuration.
                </.dialog_description>
              </.dialog_header>

              <div class="py-4 grid grid-cols-2 gap-4">
                <div>
                  <label class="text-sm font-medium text-foreground">Project Name</label>
                  <input
                    type="text"
                    autofocus
                    class="mt-1.5 flex w-full rounded-md border border-input bg-background px-3 py-2 text-sm text-foreground placeholder:text-muted-foreground focus:ring-2 focus:ring-ring focus:ring-offset-2 focus:outline-hidden"
                    placeholder="My Awesome Project"
                  />
                </div>
                <div>
                  <label class="text-sm font-medium text-foreground">Template</label>
                  <select class="mt-1.5 flex w-full rounded-md border border-input bg-background px-3 py-2 text-sm text-foreground focus:ring-2 focus:ring-ring focus:ring-offset-2 focus:outline-hidden">
                    <option>Blank</option>
                    <option>Web Application</option>
                    <option>Mobile App</option>
                    <option>API Service</option>
                  </select>
                </div>
                <div class="col-span-2">
                  <label class="text-sm font-medium text-foreground">Description</label>
                  <textarea
                    rows="3"
                    class="mt-1.5 flex w-full rounded-md border border-input bg-background px-3 py-2 text-sm text-foreground placeholder:text-muted-foreground focus:ring-2 focus:ring-ring focus:ring-offset-2 focus:outline-hidden"
                    placeholder="Brief description of your project"
                  ></textarea>
                </div>
              </div>

              <.dialog_footer dialog_id="wide-dialog">
                <.button phx-click="create-project">Create Project</.button>
              </.dialog_footer>
            </:content>
          </.dialog>
        </section>

        <%!-- Rich Content --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Dialog with Rich Content</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Dialogs can contain any type of content including lists, images, and custom layouts.
          </p>
          <.dialog id="share-dialog">
            <:trigger>
              <.button variant="outline">
                <.icon name="hero-share" /> Share
              </.button>
            </:trigger>
            <:content>
              <.dialog_header>
                <.dialog_title>Share this document</.dialog_title>
                <.dialog_description>
                  Anyone with the link can view this document.
                </.dialog_description>
              </.dialog_header>

              <div class="py-4 space-y-4">
                <div class="flex items-center gap-3">
                  <input
                    type="text"
                    value="https://example.com/doc/abc123"
                    readonly
                    class="flex-1 rounded-md border border-input bg-background px-3 py-2 text-sm text-foreground"
                  />
                  <.button variant="outline" size="sm">
                    <.icon name="hero-clipboard" /> Copy
                  </.button>
                </div>

                <div class="border-t border-border pt-4">
                  <p class="text-sm font-medium text-foreground mb-3">Share via</p>
                  <div class="grid grid-cols-3 gap-2">
                    <button
                      phx-click="share-document"
                      phx-value-method="email"
                      class="flex flex-col items-center gap-2 p-3 rounded-md border border-border hover:bg-accent transition-colors"
                    >
                      <.icon name="hero-envelope" class="size-5 text-muted-foreground" />
                      <span class="text-xs text-foreground">Email</span>
                    </button>
                    <button
                      phx-click="share-document"
                      phx-value-method="slack"
                      class="flex flex-col items-center gap-2 p-3 rounded-md border border-border hover:bg-accent transition-colors"
                    >
                      <.icon
                        name="hero-chat-bubble-left-right"
                        class="size-5 text-muted-foreground"
                      />
                      <span class="text-xs text-foreground">Slack</span>
                    </button>
                    <button
                      phx-click="share-document"
                      phx-value-method="link"
                      class="flex flex-col items-center gap-2 p-3 rounded-md border border-border hover:bg-accent transition-colors"
                    >
                      <.icon name="hero-link" class="size-5 text-muted-foreground" />
                      <span class="text-xs text-foreground">Copy Link</span>
                    </button>
                  </div>
                </div>
              </div>

              <.dialog_footer dialog_id="share-dialog" cancel_label="Close"></.dialog_footer>
            </:content>
          </.dialog>
        </section>

        <%!-- Nested Content --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Dialog with Scrollable Content</h2>
          <p class="text-sm text-muted-foreground mb-4">
            For longer content, the dialog body can scroll while keeping the header and footer fixed.
          </p>
          <.dialog id="long-content">
            <:trigger>
              <.button variant="outline">
                <.icon name="hero-document-text" /> View Details
              </.button>
            </:trigger>
            <:content>
              <.dialog_header>
                <.dialog_title>Privacy Policy</.dialog_title>
                <.dialog_description>
                  Last updated: November 12, 2025
                </.dialog_description>
              </.dialog_header>

              <div class="py-4 max-h-96 overflow-y-auto space-y-4 text-sm text-muted-foreground">
                <section>
                  <h3 class="font-semibold text-foreground mb-2">1. Information We Collect</h3>
                  <p>
                    We collect information you provide directly to us, such as when you create an account,
                    make a purchase, or communicate with us. This may include your name, email address,
                    postal address, phone number, and payment information.
                  </p>
                </section>

                <section>
                  <h3 class="font-semibold text-foreground mb-2">2. How We Use Your Information</h3>
                  <p>
                    We use the information we collect to provide, maintain, and improve our services,
                    to process transactions, to send you technical notices and support messages,
                    and to communicate with you about products, services, and events.
                  </p>
                </section>

                <section>
                  <h3 class="font-semibold text-foreground mb-2">3. Information Sharing</h3>
                  <p>
                    We do not share your personal information with third parties except as described in
                    this policy. We may share information with vendors, consultants, and other service
                    providers who need access to such information to carry out work on our behalf.
                  </p>
                </section>

                <section>
                  <h3 class="font-semibold text-foreground mb-2">4. Data Security</h3>
                  <p>
                    We take reasonable measures to help protect your personal information from loss,
                    theft, misuse, unauthorized access, disclosure, alteration, and destruction.
                  </p>
                </section>

                <section>
                  <h3 class="font-semibold text-foreground mb-2">5. Your Rights</h3>
                  <p>
                    You have the right to access, update, or delete your personal information.
                    You may also have the right to object to or restrict certain types of processing
                    of your personal information.
                  </p>
                </section>

                <section>
                  <h3 class="font-semibold text-foreground mb-2">6. Changes to This Policy</h3>
                  <p>
                    We may update this privacy policy from time to time. We will notify you of any
                    changes by posting the new policy on this page and updating the "Last updated" date.
                  </p>
                </section>
              </div>

              <.dialog_footer dialog_id="long-content" cancel_label="Close"></.dialog_footer>
            </:content>
          </.dialog>
        </section>

        <%!-- Usage Guidelines --%>
        <section class="border-t border-border pt-8">
          <h2 class="text-xl font-semibold text-foreground mb-4">Usage Guidelines</h2>
          <div class="space-y-4 text-sm">
            <div>
              <h3 class="font-medium text-foreground mb-2">When to Use</h3>
              <ul class="list-disc list-inside space-y-1 text-muted-foreground">
                <li>For forms and data entry that don't require a full page</li>
                <li>To display detailed information without navigating away</li>
                <li>For focused tasks that benefit from modal presentation</li>
                <li>When you want to maintain context of the underlying page</li>
              </ul>
            </div>
            <div>
              <h3 class="font-medium text-foreground mb-2">Dialog vs Alert Dialog</h3>
              <ul class="list-disc list-inside space-y-1 text-muted-foreground">
                <li>
                  Use <strong class="text-foreground">Dialog</strong>
                  for general content, forms, and information
                </li>
                <li>
                  Use <strong class="text-foreground">Alert Dialog</strong>
                  for critical decisions requiring explicit confirmation
                </li>
                <li>Dialogs are more flexible and can contain any content</li>
                <li>
                  Alert Dialogs are specifically designed for interrupting the user with important decisions
                </li>
              </ul>
            </div>
            <div>
              <h3 class="font-medium text-foreground mb-2">Best Practices</h3>
              <ul class="list-disc list-inside space-y-1 text-muted-foreground">
                <li>Keep dialogs focused on a single task or topic</li>
                <li>Use clear, descriptive titles</li>
                <li>Provide a way to close the dialog (X button or Cancel button)</li>
                <li>
                  For long content, make the body scrollable while keeping header/footer visible
                </li>
                <li>Avoid nesting dialogs within dialogs</li>
              </ul>
            </div>
            <div>
              <h3 class="font-medium text-foreground mb-2">Accessibility</h3>
              <ul class="list-disc list-inside space-y-1 text-muted-foreground">
                <li>Dialog traps focus within the modal</li>
                <li>Escape key closes the dialog</li>
                <li>Clicking outside the dialog closes it</li>
                <li>Screen readers announce the dialog title when opened</li>
              </ul>
            </div>
          </div>
        </section>
      </.stack>
    </.container>
    """
  end
end
