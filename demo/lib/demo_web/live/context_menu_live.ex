defmodule DemoWeb.Ui.ContextMenuLive do
  @moduledoc false
  use DemoWeb, :live_view

  alias Phoenix.LiveView.Socket

  @impl true
  @spec mount(map(), map(), Socket.t()) ::
          {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:show_bookmarks, true)
      |> assign(:show_full_urls, false)
      |> assign(:person, "pedro")

    {:ok, socket}
  end

  @impl true
  @spec handle_event(String.t(), map(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("toggle-bookmarks", _params, socket) do
    {:noreply, assign(socket, :show_bookmarks, !socket.assigns.show_bookmarks)}
  end

  def handle_event("toggle-full-urls", _params, socket) do
    {:noreply, assign(socket, :show_full_urls, !socket.assigns.show_full_urls)}
  end

  def handle_event("set-person", %{"person" => person}, socket) do
    {:noreply, assign(socket, :person, person)}
  end

  def handle_event("demo-action", %{"action" => action}, socket) do
    {:noreply, put_flash(socket, :info, "Action triggered: #{action}")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.container>
      <.stack gap="xl">
        <%!-- Header --%>
        <div>
          <h1 class="text-3xl font-bold text-foreground">Context Menu Component</h1>
          <p class="text-muted-foreground mt-2">
            Displays a menu to the user — such as a set of actions or functions — triggered by a right-click.
          </p>
        </div>

        <%!-- Basic Example --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Basic Context Menu</h2>
          <.context_menu id="basic-context">
            <:trigger>
              <div class="flex h-[150px] w-[300px] items-center justify-center rounded-md border border-dashed border-border text-sm text-muted-foreground">
                Right-click here
              </div>
            </:trigger>
            <:content>
              <.context_menu_item phx-click="demo-action" phx-value-action="back">
                Back
                <.context_menu_shortcut>⌘[</.context_menu_shortcut>
              </.context_menu_item>
              <.context_menu_item disabled>
                Forward
                <.context_menu_shortcut>⌘]</.context_menu_shortcut>
              </.context_menu_item>
              <.context_menu_item phx-click="demo-action" phx-value-action="reload">
                Reload
                <.context_menu_shortcut>⌘R</.context_menu_shortcut>
              </.context_menu_item>
              <.context_menu_separator />
              <.context_menu_sub id="more-tools">
                <:trigger>
                  <.context_menu_sub_trigger>
                    More Tools
                  </.context_menu_sub_trigger>
                </:trigger>
                <:content>
                  <.context_menu_sub_content>
                    <.context_menu_item phx-click="demo-action" phx-value-action="save-page">
                      Save Page As...
                      <.context_menu_shortcut>⇧⌘S</.context_menu_shortcut>
                    </.context_menu_item>
                    <.context_menu_item phx-click="demo-action" phx-value-action="create-shortcut">
                      Create Shortcut...
                    </.context_menu_item>
                    <.context_menu_item phx-click="demo-action" phx-value-action="name-window">
                      Name Window...
                    </.context_menu_item>
                    <.context_menu_separator />
                    <.context_menu_item phx-click="demo-action" phx-value-action="dev-tools">
                      Developer Tools
                    </.context_menu_item>
                  </.context_menu_sub_content>
                </:content>
              </.context_menu_sub>
              <.context_menu_separator />
              <.context_menu_checkbox_item
                checked={@show_bookmarks}
                phx-click="toggle-bookmarks"
              >
                Show Bookmarks Bar
                <.context_menu_shortcut>⌘⇧B</.context_menu_shortcut>
              </.context_menu_checkbox_item>
              <.context_menu_checkbox_item
                checked={@show_full_urls}
                phx-click="toggle-full-urls"
              >
                Show Full URLs
              </.context_menu_checkbox_item>
              <.context_menu_separator />
              <.context_menu_label inset>People</.context_menu_label>
              <.context_menu_radio_group>
                <.context_menu_radio_item
                  checked={@person == "pedro"}
                  phx-click="set-person"
                  phx-value-person="pedro"
                >
                  Pedro Duarte
                </.context_menu_radio_item>
                <.context_menu_radio_item
                  checked={@person == "colm"}
                  phx-click="set-person"
                  phx-value-person="colm"
                >
                  Colm Tuite
                </.context_menu_radio_item>
              </.context_menu_radio_group>
            </:content>
          </.context_menu>

          <p class="text-sm text-muted-foreground mt-4">
            Current state: Bookmarks Bar: {if @show_bookmarks, do: "shown", else: "hidden"},
            Full URLs: {if @show_full_urls, do: "shown", else: "hidden"},
            Selected: {String.capitalize(@person)}
          </p>
        </section>

        <%!-- With Icons --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">With Icons</h2>
          <.context_menu id="icons-context">
            <:trigger>
              <div class="flex h-[150px] w-[300px] items-center justify-center rounded-md border border-dashed border-border text-sm text-muted-foreground">
                Right-click for file options
              </div>
            </:trigger>
            <:content>
              <.context_menu_item phx-click="demo-action" phx-value-action="cut">
                <.icon name="hero-scissors" /> Cut
                <.context_menu_shortcut>⌘X</.context_menu_shortcut>
              </.context_menu_item>
              <.context_menu_item phx-click="demo-action" phx-value-action="copy">
                <.icon name="hero-document-duplicate" /> Copy
                <.context_menu_shortcut>⌘C</.context_menu_shortcut>
              </.context_menu_item>
              <.context_menu_item phx-click="demo-action" phx-value-action="paste">
                <.icon name="hero-clipboard" /> Paste
                <.context_menu_shortcut>⌘V</.context_menu_shortcut>
              </.context_menu_item>
              <.context_menu_separator />
              <.context_menu_item phx-click="demo-action" phx-value-action="rename">
                <.icon name="hero-pencil" /> Rename
              </.context_menu_item>
              <.context_menu_item phx-click="demo-action" phx-value-action="duplicate">
                <.icon name="hero-document-plus" /> Duplicate
              </.context_menu_item>
              <.context_menu_separator />
              <.context_menu_item variant="destructive" phx-click="demo-action" phx-value-action="delete">
                <.icon name="hero-trash" /> Delete
                <.context_menu_shortcut>⌘⌫</.context_menu_shortcut>
              </.context_menu_item>
            </:content>
          </.context_menu>
        </section>

        <%!-- File Manager Context Menu --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">File Manager Example</h2>
          <.flex class="gap-4">
            <.context_menu id="file-1">
              <:trigger>
                <div class="flex flex-col items-center justify-center gap-2 p-4 rounded-md border border-border hover:bg-accent/50 transition-colors cursor-default">
                  <.icon name="hero-folder" class="size-12 text-yellow-500" />
                  <span class="text-sm text-foreground">Documents</span>
                </div>
              </:trigger>
              <:content>
                <.context_menu_item phx-click="demo-action" phx-value-action="open">
                  <.icon name="hero-folder-open" /> Open
                </.context_menu_item>
                <.context_menu_item phx-click="demo-action" phx-value-action="open-new-tab">
                  <.icon name="hero-arrow-top-right-on-square" /> Open in New Tab
                </.context_menu_item>
                <.context_menu_separator />
                <.context_menu_item phx-click="demo-action" phx-value-action="rename">
                  <.icon name="hero-pencil" /> Rename
                </.context_menu_item>
                <.context_menu_item phx-click="demo-action" phx-value-action="compress">
                  <.icon name="hero-archive-box" /> Compress
                </.context_menu_item>
                <.context_menu_separator />
                <.context_menu_item phx-click="demo-action" phx-value-action="get-info">
                  <.icon name="hero-information-circle" /> Get Info
                </.context_menu_item>
                <.context_menu_separator />
                <.context_menu_item variant="destructive" phx-click="demo-action" phx-value-action="delete">
                  <.icon name="hero-trash" /> Move to Trash
                </.context_menu_item>
              </:content>
            </.context_menu>

            <.context_menu id="file-2">
              <:trigger>
                <div class="flex flex-col items-center justify-center gap-2 p-4 rounded-md border border-border hover:bg-accent/50 transition-colors cursor-default">
                  <.icon name="hero-document-text" class="size-12 text-blue-500" />
                  <span class="text-sm text-foreground">Report.pdf</span>
                </div>
              </:trigger>
              <:content>
                <.context_menu_item phx-click="demo-action" phx-value-action="open">
                  <.icon name="hero-eye" /> Open
                </.context_menu_item>
                <.context_menu_item phx-click="demo-action" phx-value-action="open-with">
                  <.icon name="hero-squares-2x2" /> Open With...
                </.context_menu_item>
                <.context_menu_separator />
                <.context_menu_sub id="share-sub">
                  <:trigger>
                    <.context_menu_sub_trigger>
                      <.icon name="hero-share" /> Share
                    </.context_menu_sub_trigger>
                  </:trigger>
                  <:content>
                    <.context_menu_sub_content>
                      <.context_menu_item phx-click="demo-action" phx-value-action="email">
                        <.icon name="hero-envelope" /> Email
                      </.context_menu_item>
                      <.context_menu_item phx-click="demo-action" phx-value-action="airdrop">
                        <.icon name="hero-signal" /> AirDrop
                      </.context_menu_item>
                      <.context_menu_item phx-click="demo-action" phx-value-action="messages">
                        <.icon name="hero-chat-bubble-left" /> Messages
                      </.context_menu_item>
                    </.context_menu_sub_content>
                  </:content>
                </.context_menu_sub>
                <.context_menu_separator />
                <.context_menu_item phx-click="demo-action" phx-value-action="copy">
                  <.icon name="hero-document-duplicate" /> Copy
                </.context_menu_item>
                <.context_menu_item phx-click="demo-action" phx-value-action="duplicate">
                  <.icon name="hero-document-plus" /> Duplicate
                </.context_menu_item>
                <.context_menu_separator />
                <.context_menu_item variant="destructive" phx-click="demo-action" phx-value-action="delete">
                  <.icon name="hero-trash" /> Move to Trash
                </.context_menu_item>
              </:content>
            </.context_menu>

            <.context_menu id="file-3">
              <:trigger>
                <div class="flex flex-col items-center justify-center gap-2 p-4 rounded-md border border-border hover:bg-accent/50 transition-colors cursor-default">
                  <.icon name="hero-photo" class="size-12 text-green-500" />
                  <span class="text-sm text-foreground">Photo.jpg</span>
                </div>
              </:trigger>
              <:content>
                <.context_menu_item phx-click="demo-action" phx-value-action="preview">
                  <.icon name="hero-eye" /> Quick Look
                </.context_menu_item>
                <.context_menu_item phx-click="demo-action" phx-value-action="edit">
                  <.icon name="hero-pencil-square" /> Edit
                </.context_menu_item>
                <.context_menu_separator />
                <.context_menu_item phx-click="demo-action" phx-value-action="set-wallpaper">
                  <.icon name="hero-computer-desktop" /> Set as Wallpaper
                </.context_menu_item>
                <.context_menu_separator />
                <.context_menu_item variant="destructive" phx-click="demo-action" phx-value-action="delete">
                  <.icon name="hero-trash" /> Move to Trash
                </.context_menu_item>
              </:content>
            </.context_menu>
          </.flex>
        </section>

        <%!-- Disabled Items --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Disabled Items</h2>
          <.context_menu id="disabled-context">
            <:trigger>
              <div class="flex h-[150px] w-[300px] items-center justify-center rounded-md border border-dashed border-border text-sm text-muted-foreground">
                Right-click to see disabled items
              </div>
            </:trigger>
            <:content>
              <.context_menu_item phx-click="demo-action" phx-value-action="undo">
                Undo
                <.context_menu_shortcut>⌘Z</.context_menu_shortcut>
              </.context_menu_item>
              <.context_menu_item disabled>
                Redo
                <.context_menu_shortcut>⇧⌘Z</.context_menu_shortcut>
              </.context_menu_item>
              <.context_menu_separator />
              <.context_menu_item phx-click="demo-action" phx-value-action="cut">
                Cut
                <.context_menu_shortcut>⌘X</.context_menu_shortcut>
              </.context_menu_item>
              <.context_menu_item disabled>
                Copy
                <.context_menu_shortcut>⌘C</.context_menu_shortcut>
              </.context_menu_item>
              <.context_menu_item disabled>
                Paste
                <.context_menu_shortcut>⌘V</.context_menu_shortcut>
              </.context_menu_item>
            </:content>
          </.context_menu>
        </section>

        <%!-- List Item Context Menu --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">List Item Context Menu</h2>
          <p class="text-sm text-muted-foreground mb-4">
            A common pattern is adding context menus to list items for quick actions.
          </p>
          <div class="border border-border rounded-md overflow-hidden divide-y divide-border">
            <.context_menu id="row-1">
              <:trigger>
                <div class="flex items-center justify-between px-4 py-3 hover:bg-accent/50 transition-colors">
                  <div class="flex items-center gap-3">
                    <.avatar class="size-8">
                      <.avatar_fallback>JD</.avatar_fallback>
                    </.avatar>
                    <div>
                      <p class="text-sm font-medium text-foreground">John Doe</p>
                      <p class="text-xs text-muted-foreground">john@example.com</p>
                    </div>
                  </div>
                  <.badge variant="default">Active</.badge>
                </div>
              </:trigger>
              <:content>
                <.context_menu_item phx-click="demo-action" phx-value-action="view">
                  <.icon name="hero-eye" /> View Details
                </.context_menu_item>
                <.context_menu_item phx-click="demo-action" phx-value-action="edit">
                  <.icon name="hero-pencil" /> Edit
                </.context_menu_item>
                <.context_menu_separator />
                <.context_menu_item phx-click="demo-action" phx-value-action="send-email">
                  <.icon name="hero-envelope" /> Send Email
                </.context_menu_item>
                <.context_menu_separator />
                <.context_menu_item variant="destructive" phx-click="demo-action" phx-value-action="delete">
                  <.icon name="hero-trash" /> Delete
                </.context_menu_item>
              </:content>
            </.context_menu>

            <.context_menu id="row-2">
              <:trigger>
                <div class="flex items-center justify-between px-4 py-3 hover:bg-accent/50 transition-colors">
                  <div class="flex items-center gap-3">
                    <.avatar class="size-8">
                      <.avatar_fallback>JS</.avatar_fallback>
                    </.avatar>
                    <div>
                      <p class="text-sm font-medium text-foreground">Jane Smith</p>
                      <p class="text-xs text-muted-foreground">jane@example.com</p>
                    </div>
                  </div>
                  <.badge variant="secondary">Pending</.badge>
                </div>
              </:trigger>
              <:content>
                <.context_menu_item phx-click="demo-action" phx-value-action="view">
                  <.icon name="hero-eye" /> View Details
                </.context_menu_item>
                <.context_menu_item phx-click="demo-action" phx-value-action="edit">
                  <.icon name="hero-pencil" /> Edit
                </.context_menu_item>
                <.context_menu_separator />
                <.context_menu_item phx-click="demo-action" phx-value-action="approve">
                  <.icon name="hero-check" /> Approve
                </.context_menu_item>
                <.context_menu_separator />
                <.context_menu_item variant="destructive" phx-click="demo-action" phx-value-action="reject">
                  <.icon name="hero-x-mark" /> Reject
                </.context_menu_item>
              </:content>
            </.context_menu>

            <.context_menu id="row-3">
              <:trigger>
                <div class="flex items-center justify-between px-4 py-3 hover:bg-accent/50 transition-colors">
                  <div class="flex items-center gap-3">
                    <.avatar class="size-8">
                      <.avatar_fallback>BJ</.avatar_fallback>
                    </.avatar>
                    <div>
                      <p class="text-sm font-medium text-foreground">Bob Johnson</p>
                      <p class="text-xs text-muted-foreground">bob@example.com</p>
                    </div>
                  </div>
                  <.badge variant="outline">Inactive</.badge>
                </div>
              </:trigger>
              <:content>
                <.context_menu_item phx-click="demo-action" phx-value-action="view">
                  <.icon name="hero-eye" /> View Details
                </.context_menu_item>
                <.context_menu_item phx-click="demo-action" phx-value-action="edit">
                  <.icon name="hero-pencil" /> Edit
                </.context_menu_item>
                <.context_menu_separator />
                <.context_menu_item phx-click="demo-action" phx-value-action="reactivate">
                  <.icon name="hero-arrow-path" /> Reactivate
                </.context_menu_item>
                <.context_menu_separator />
                <.context_menu_item variant="destructive" phx-click="demo-action" phx-value-action="delete">
                  <.icon name="hero-trash" /> Delete
                </.context_menu_item>
              </:content>
            </.context_menu>
          </div>
        </section>
      </.stack>
    </.container>
    """
  end
end
