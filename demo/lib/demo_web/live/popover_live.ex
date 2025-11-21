defmodule DemoWeb.Ui.PopoverLive do
  @moduledoc false
  use DemoWeb, :live_view

  alias Phoenix.LiveView.Socket

  @impl true
  @spec mount(map(), map(), Socket.t()) ::
          {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  @spec handle_event(String.t(), map(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("demo-action", %{"action" => action}, socket) do
    {:noreply, put_flash(socket, :info, "Action triggered: #{action}")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    
      <.container>
        <.stack size="large">
          <%!-- Header --%>
          <div>
            <h1 class="text-3xl font-bold text-foreground">Popover Component</h1>
            <p class="text-muted-foreground mt-2">
              Displays rich content in a floating panel, triggered by a button.
            </p>
          </div>

          <%!-- Basic Example --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Basic Popover</h2>
            <.popover id="basic-popover">
              <:trigger>
                <.button variant="outline">Open Popover</.button>
              </:trigger>
              <:content>
                <.stack size="small">
                  <h4 class="font-medium leading-none">Popover Content</h4>
                  <p class="text-sm text-muted-foreground">
                    This is a basic popover with some simple content.
                  </p>
                </.stack>
              </:content>
            </.popover>
          </section>

          <%!-- Dimensions Example (from shadcn docs) --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Dimensions Settings</h2>
            <.popover id="dimensions-popover">
              <:trigger>
                <.button variant="outline">Open Settings</.button>
              </:trigger>
              <:content>
                <.stack size="medium">
                  <.stack size="small">
                    <h4 class="font-medium leading-none">Dimensions</h4>
                    <p class="text-sm text-muted-foreground">
                      Set the dimensions for the layer.
                    </p>
                  </.stack>
                  <.stack size="small">
                    <.grid cols={3} class="items-center">
                      <label for="width" class="text-sm">Width</label>
                      <input
                        id="width"
                        class="col-span-2 h-8 rounded-md border border-input bg-background px-3 text-sm"
                        value="100%"
                      />
                    </.grid>
                    <.grid cols={3} class="items-center">
                      <label for="max-width" class="text-sm">Max Width</label>
                      <input
                        id="max-width"
                        class="col-span-2 h-8 rounded-md border border-input bg-background px-3 text-sm"
                        value="300px"
                      />
                    </.grid>
                    <.grid cols={3} class="items-center">
                      <label for="height" class="text-sm">Height</label>
                      <input
                        id="height"
                        class="col-span-2 h-8 rounded-md border border-input bg-background px-3 text-sm"
                        value="25px"
                      />
                    </.grid>
                    <.grid cols={3} class="items-center">
                      <label for="max-height" class="text-sm">Max Height</label>
                      <input
                        id="max-height"
                        class="col-span-2 h-8 rounded-md border border-input bg-background px-3 text-sm"
                        value="none"
                      />
                    </.grid>
                  </.stack>
                </.stack>
              </:content>
            </.popover>
          </section>

          <%!-- With Icon Button --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">With Icon Button</h2>
            <.popover id="info-popover">
              <:trigger>
                <.button variant="ghost" size="sm">
                  <.icon name="hero-information-circle" class="size-5" />
                </.button>
              </:trigger>
              <:content>
                <.stack size="small">
                  <h4 class="font-medium leading-none">Information</h4>
                  <p class="text-sm text-muted-foreground">
                    This is additional contextual information that appears when you click the info icon.
                  </p>
                </.stack>
              </:content>
            </.popover>
          </section>

          <%!-- Alignment Options --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Alignment Options</h2>
            <.flex align="start" class="gap-4">
              <.popover id="align-start-popover">
                <:trigger>
                  <.button variant="outline">Align Start</.button>
                </:trigger>
                <:content align="start">
                  <p class="text-sm">Aligned to the start (left)</p>
                </:content>
              </.popover>

              <.popover id="align-center-popover">
                <:trigger>
                  <.button variant="outline">Align Center</.button>
                </:trigger>
                <:content align="center">
                  <p class="text-sm">Aligned to center</p>
                </:content>
              </.popover>

              <.popover id="align-end-popover">
                <:trigger>
                  <.button variant="outline">Align End</.button>
                </:trigger>
                <:content align="end">
                  <p class="text-sm">Aligned to the end (right)</p>
                </:content>
              </.popover>
            </.flex>
          </section>

          <%!-- Side Options --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Position Options</h2>
            <.flex align="center" class="gap-4">
              <.popover id="side-top-popover">
                <:trigger>
                  <.button variant="outline">Top</.button>
                </:trigger>
                <:content side="top">
                  <p class="text-sm">Appears above the button</p>
                </:content>
              </.popover>

              <.popover id="side-right-popover">
                <:trigger>
                  <.button variant="outline">Right</.button>
                </:trigger>
                <:content side="right">
                  <p class="text-sm">Appears to the right</p>
                </:content>
              </.popover>

              <.popover id="side-bottom-popover">
                <:trigger>
                  <.button variant="outline">Bottom</.button>
                </:trigger>
                <:content side="bottom">
                  <p class="text-sm">Appears below (default)</p>
                </:content>
              </.popover>

              <.popover id="side-left-popover">
                <:trigger>
                  <.button variant="outline">Left</.button>
                </:trigger>
                <:content side="left">
                  <p class="text-sm">Appears to the left</p>
                </:content>
              </.popover>
            </.flex>
          </section>

          <%!-- With Actions --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">With Action Buttons</h2>
            <.popover id="actions-popover">
              <:trigger>
                <.button variant="outline">Quick Actions</.button>
              </:trigger>
              <:content>
                <.stack size="small">
                  <h4 class="font-medium leading-none">Actions</h4>
                  <.button
                    variant="ghost"
                    size="sm"
                    phx-click="demo-action"
                    phx-value-action="edit"
                    class="justify-start"
                  >
                    <.icon name="hero-pencil" /> Edit
                  </.button>
                  <.button
                    variant="ghost"
                    size="sm"
                    phx-click="demo-action"
                    phx-value-action="duplicate"
                    class="justify-start"
                  >
                    <.icon name="hero-document-duplicate" /> Duplicate
                  </.button>
                  <.button
                    variant="ghost"
                    size="sm"
                    phx-click="demo-action"
                    phx-value-action="archive"
                    class="justify-start"
                  >
                    <.icon name="hero-archive-box" /> Archive
                  </.button>
                  <.separator />
                  <.button
                    variant="ghost"
                    size="sm"
                    phx-click="demo-action"
                    phx-value-action="delete"
                    class="justify-start text-destructive hover:text-destructive"
                  >
                    <.icon name="hero-trash" /> Delete
                  </.button>
                </.stack>
              </:content>
            </.popover>
          </section>

          <%!-- Rich Content Example --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Rich Content</h2>
            <.popover id="rich-popover">
              <:trigger>
                <.button variant="outline">
                  View Details <.icon name="hero-chevron-down" />
                </.button>
              </:trigger>
              <:content>
                <.stack size="medium">
                  <.stack size="small">
                    <h4 class="font-medium leading-none">User Profile</h4>
                    <p class="text-sm text-muted-foreground">
                      Detailed information about the user
                    </p>
                  </.stack>
                  <.flex align="center" class="gap-3">
                    <div class="size-10 rounded-full bg-accent flex items-center justify-center">
                      <.icon name="hero-user" class="size-5 text-accent-foreground" />
                    </div>
                    <.stack size="xs">
                      <p class="text-sm font-medium">John Doe</p>
                      <p class="text-xs text-muted-foreground">john@example.com</p>
                    </.stack>
                  </.flex>
                  <.flex class="gap-2">
                    <.button
                      size="sm"
                      class="flex-1"
                      phx-click="demo-action"
                      phx-value-action="profile"
                    >
                      View Profile
                    </.button>
                    <.button
                      variant="outline"
                      size="sm"
                      class="flex-1"
                      phx-click="demo-action"
                      phx-value-action="message"
                    >
                      Message
                    </.button>
                  </.flex>
                </.stack>
              </:content>
            </.popover>
          </section>

          <%!-- Custom Width --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Custom Width</h2>
            <.flex align="start" class="gap-4">
              <.popover id="narrow-popover">
                <:trigger>
                  <.button variant="outline">Narrow</.button>
                </:trigger>
                <:content class="w-48">
                  <p class="text-sm">This popover has a custom narrow width (w-48)</p>
                </:content>
              </.popover>

              <.popover id="wide-popover">
                <:trigger>
                  <.button variant="outline">Wide</.button>
                </:trigger>
                <:content class="w-96">
                  <.stack size="small">
                    <h4 class="font-medium">Wide Popover</h4>
                    <p class="text-sm text-muted-foreground">
                      This popover has a custom wide width (w-96) to accommodate more content.
                      You can override the default width with the class attribute.
                    </p>
                  </.stack>
                </:content>
              </.popover>
            </.flex>
          </section>

          <%!-- Help Text Example --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Inline Help</h2>
            <p class="text-sm text-muted-foreground mb-4">
              Click the question mark icon next to the label to see help text in a popover.
              The label component automatically handles the popover when help attributes are provided.
            </p>
            <.card>
              <.card_content class="pt-6">
                <.stack size="small">
                  <.label
                    for="email"
                    help_title="Email Format"
                    help_text="Enter a valid email address in the format: username@domain.com"
                  >
                    Email Address
                  </.label>
                  <input
                    id="email"
                    type="email"
                    placeholder="john@example.com"
                    class="w-full rounded-md border border-input bg-background px-3 py-2 text-sm"
                  />
                </.stack>
              </.card_content>
            </.card>
          </section>
        </.stack>
      </.container>
    
    """
  end
end
