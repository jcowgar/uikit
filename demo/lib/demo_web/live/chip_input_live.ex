defmodule DemoWeb.Ui.ChipInputLive do
  @moduledoc false
  use DemoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:project_tags, ["phoenix", "liveview"])
      |> assign(:skills, [])
      |> assign(:email_recipients, ["user@example.com"])
      |> assign(:keywords, ["elixir", "functional"])

    {:ok, socket}
  end

  @impl true
  def handle_event("chip-input:add", %{"id" => "tags-chip", "value" => tag}, socket) do
    {:noreply, update(socket, :project_tags, fn tags -> Enum.uniq(tags ++ [tag]) end)}
  end

  @impl true
  def handle_event("remove_tag", %{"value" => tag}, socket) do
    {:noreply, update(socket, :project_tags, &List.delete(&1, tag))}
  end

  @impl true
  def handle_event("chip-input:add", %{"id" => "skills-chip", "value" => skill}, socket) do
    {:noreply, update(socket, :skills, fn skills -> Enum.uniq(skills ++ [skill]) end)}
  end

  @impl true
  def handle_event("remove_skill", %{"value" => skill}, socket) do
    {:noreply, update(socket, :skills, &List.delete(&1, skill))}
  end

  @impl true
  def handle_event("chip-input:add", %{"id" => "email-chip", "value" => email}, socket) do
    {:noreply, update(socket, :email_recipients, fn emails -> Enum.uniq(emails ++ [email]) end)}
  end

  @impl true
  def handle_event("remove_email", %{"value" => email}, socket) do
    {:noreply, update(socket, :email_recipients, &List.delete(&1, email))}
  end

  @impl true
  def handle_event("chip-input:add", %{"id" => "keywords-chip", "value" => keyword}, socket) do
    {:noreply, update(socket, :keywords, fn keywords -> keywords ++ [keyword] end)}
  end

  @impl true
  def handle_event("remove_keyword", %{"value" => keyword}, socket) do
    {:noreply, update(socket, :keywords, &List.delete(&1, keyword))}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.container>
      <.stack gap="xl">
        <%!-- Header --%>
        <div>
          <h1 class="text-3xl font-bold text-foreground">Chip Input Component</h1>
          <p class="text-muted-foreground mt-2">
            Tag management with removable chips and keyboard shortcuts.
          </p>
        </div>

        <%!-- Client-Side Mode (No Server Events) --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Client-Side Mode</h2>
          <.stack gap="lg">
            <div>
              <.label for="client-tags" class="mb-1.5">Blog Post Tags</.label>
              <.chip_input
                id="client-tags"
                name="post[tags]"
                value={["elixir", "phoenix", "liveview"]}
                placeholder="Add tag..."
              />
              <p class="text-sm text-muted-foreground mt-1.5">
                This operates entirely client-side with no server events. Perfect for standard forms!
              </p>
              <p class="text-sm text-muted-foreground mt-1">
                Values are stored in hidden inputs and will be submitted with the form as <code class="text-xs">post[tags][]</code>.
              </p>
            </div>
          </.stack>
        </section>

        <%!-- Server-Side Mode (LiveView Events) --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Server-Side Mode</h2>
          <.stack gap="lg">
            <div>
              <.label for="tags-chip" class="mb-1.5">Project Tags</.label>
              <.chip_input
                id="tags-chip"
                values={@project_tags}
                placeholder="Add tag..."
                on_add="chip-input:add"
                on_remove="remove_tag"
              />
              <p class="text-sm text-muted-foreground mt-1.5">
                This sends LiveView events for every add/remove. Use when you need server validation!
              </p>
              <p class="text-sm text-muted-foreground mt-1">
                Current tags ({length(@project_tags)}): {if Enum.empty?(@project_tags),
                  do: "(none)",
                  else: Enum.join(@project_tags, ", ")}
              </p>
            </div>
          </.stack>
        </section>

        <%!-- With Suggestions --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">With Suggestions</h2>
          <.stack gap="lg">
            <div>
              <.label for="skills-chip" class="mb-1.5">Skills</.label>
              <.chip_input
                id="skills-chip"
                values={@skills}
                placeholder="Add skill..."
                suggestions={[
                  "Elixir",
                  "Phoenix",
                  "LiveView",
                  "JavaScript",
                  "React",
                  "TypeScript",
                  "Python",
                  "Go",
                  "Rust",
                  "PostgreSQL",
                  "Docker",
                  "Kubernetes"
                ]}
                on_add="chip-input:add"
                on_remove="remove_skill"
              />
              <p class="text-sm text-muted-foreground mt-1.5">
                Click a suggestion or type your own. Suggestions appear as you type.
              </p>
              <p class="text-sm text-muted-foreground mt-1">
                Current skills: {if Enum.empty?(@skills),
                  do: "(none)",
                  else: Enum.join(@skills, ", ")}
              </p>
            </div>
          </.stack>
        </section>

        <%!-- Email Composer Example --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Email Composer</h2>
          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>Compose Email</.card_title>
              <.card_description>Send a message to multiple recipients</.card_description>
            </.card_header>
            <.card_content>
              <.stack gap="lg">
                <div>
                  <.label for="email-chip" class="mb-1.5">To:</.label>
                  <.chip_input
                    id="email-chip"
                    values={@email_recipients}
                    placeholder="Add recipient..."
                    on_add="chip-input:add"
                    on_remove="remove_email"
                    allow_duplicates={false}
                  />
                  <p class="text-sm text-muted-foreground mt-1.5">
                    Recipients: {Enum.join(@email_recipients, ", ")}
                  </p>
                </div>

                <div>
                  <.label for="subject" class="mb-1.5">Subject:</.label>
                  <.input id="subject" name="subject" placeholder="Enter email subject" />
                </div>

                <div>
                  <.label for="message" class="mb-1.5">Message:</.label>
                  <.textarea
                    id="message"
                    name="message"
                    rows="5"
                    placeholder="Write your message..."
                  />
                </div>

                <.flex justify="end" items="end">
                  <.button>Send Email</.button>
                </.flex>
              </.stack>
            </.card_content>
          </.card>
        </section>

        <%!-- Customization --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Customization</h2>
          <.stack gap="lg">
            <div>
              <.label for="keywords-chip" class="mb-1.5">
                Custom Placeholder & Allow Duplicates
              </.label>
              <.chip_input
                id="keywords-chip"
                values={@keywords}
                placeholder="Type a keyword and press Enter..."
                on_add="chip-input:add"
                on_remove="remove_keyword"
                allow_duplicates={true}
              />
              <p class="text-sm text-muted-foreground mt-1.5">
                This example allows duplicate values and has a custom placeholder.
              </p>
            </div>
          </.stack>
        </section>

        <%!-- Features & Accessibility --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Features & Accessibility</h2>
          <.card>
            <.card_header>
              <.card_title>Component Features</.card_title>
            </.card_header>
            <.card_content>
              <.grid cols={2}>
                <div>
                  <h3 class="text-sm font-semibold text-foreground mb-2">Adding Chips</h3>
                  <ul class="text-sm text-muted-foreground space-y-1 list-disc list-inside">
                    <li>
                      <code class="text-xs">Enter</code> key adds chip from input
                    </li>
                    <li>
                      <code class="text-xs">Space</code> key adds chip from input
                    </li>
                    <li>
                      <code class="text-xs">Comma</code> key adds chip from input
                    </li>
                    <li>Click suggestion to add instantly</li>
                    <li>Input clears automatically after adding</li>
                  </ul>
                </div>

                <div>
                  <h3 class="text-sm font-semibold text-foreground mb-2">Removing Chips</h3>
                  <ul class="text-sm text-muted-foreground space-y-1 list-disc list-inside">
                    <li>Click X button on any chip to remove</li>
                    <li>
                      <code class="text-xs">Backspace</code> on empty input removes last chip
                    </li>
                    <li>
                      <code class="text-xs">Escape</code> clears input field
                    </li>
                    <li>Visual hover states on remove buttons</li>
                    <li>Accessible aria-labels on remove buttons</li>
                  </ul>
                </div>

                <div>
                  <h3 class="text-sm font-semibold text-foreground mb-2">Configuration</h3>
                  <ul class="text-sm text-muted-foreground space-y-1 list-disc list-inside">
                    <li>Optional suggestions dropdown</li>
                    <li>Allow/prevent duplicate values</li>
                    <li>Custom placeholders</li>
                    <li>Custom input/container classes</li>
                    <li>Uses Badge component for chip display</li>
                  </ul>
                </div>

                <div>
                  <h3 class="text-sm font-semibold text-foreground mb-2">Implementation</h3>
                  <ul class="text-sm text-muted-foreground space-y-1 list-disc list-inside">
                    <li>Client-side keyboard via ChipInput hook</li>
                    <li>Uses Badge (secondary variant) for chips</li>
                    <li>Optional Popover for suggestions</li>
                    <li>Semantic color tokens for theming</li>
                    <li>Automatic dark mode support</li>
                  </ul>
                </div>
              </.grid>
            </.card_content>
          </.card>
        </section>

        <%!-- Keyboard Reference --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Keyboard Reference</h2>
          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>Keyboard Shortcuts</.card_title>
              <.card_description>All available keyboard interactions</.card_description>
            </.card_header>
            <.card_content>
              <.stack gap="md">
                <div class="flex items-center justify-between py-2 border-b border-border">
                  <span class="text-sm text-foreground font-medium">Add chip</span>
                  <div class="flex gap-2">
                    <code class="text-xs bg-muted px-2 py-1 rounded">Enter</code>
                    <code class="text-xs bg-muted px-2 py-1 rounded">Space</code>
                    <code class="text-xs bg-muted px-2 py-1 rounded">Comma</code>
                  </div>
                </div>

                <div class="flex items-center justify-between py-2 border-b border-border">
                  <span class="text-sm text-foreground font-medium">Remove last chip</span>
                  <code class="text-xs bg-muted px-2 py-1 rounded">Backspace (empty input)</code>
                </div>

                <div class="flex items-center justify-between py-2 border-b border-border">
                  <span class="text-sm text-foreground font-medium">Clear input</span>
                  <code class="text-xs bg-muted px-2 py-1 rounded">Escape</code>
                </div>

                <div class="flex items-center justify-between py-2">
                  <span class="text-sm text-foreground font-medium">Navigate to next field</span>
                  <code class="text-xs bg-muted px-2 py-1 rounded">Tab</code>
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
