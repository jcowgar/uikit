defmodule DemoWeb.Ui.ComboboxLive do
  @moduledoc false
  use DemoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:selected_framework, nil)
      |> assign(:selected_language, "elixir")
      |> assign(:selected_tags, [])
      |> assign(:selected_team_members, ["alice"])
      |> assign(:task_assignees, [])
      |> assign(:task_priority, nil)

    {:ok, socket}
  end

  @impl true
  def handle_event("select_framework", %{"value" => value}, socket) do
    {:noreply, assign(socket, :selected_framework, value)}
  end

  @impl true
  def handle_event("select_language", %{"value" => value}, socket) do
    {:noreply, assign(socket, :selected_language, value)}
  end

  @impl true
  def handle_event("select_tags", %{"value" => value}, socket) do
    selected_tags = String.split(value, ",", trim: true)
    {:noreply, assign(socket, :selected_tags, selected_tags)}
  end

  @impl true
  def handle_event("select_team", %{"value" => value}, socket) do
    selected_members = String.split(value, ",", trim: true)
    {:noreply, assign(socket, :selected_team_members, selected_members)}
  end

  @impl true
  def handle_event("select_task_assignees", %{"value" => value}, socket) do
    assignees = String.split(value, ",", trim: true)
    {:noreply, assign(socket, :task_assignees, assignees)}
  end

  @impl true
  def handle_event("select_task_priority", %{"value" => value}, socket) do
    {:noreply, assign(socket, :task_priority, value)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    
      <.container>
        <.stack size="large">
          <%!-- Header --%>
          <div>
            <h1 class="text-3xl font-bold text-foreground">Combobox Component</h1>
            <p class="text-muted-foreground mt-2">
              Searchable single and multi-select dropdown with keyboard navigation.
            </p>
          </div>

          <%!-- Single Selection --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Single Selection</h2>
            <.stack size="medium">
              <div>
                <.label for="framework-select" class="mb-1.5">Select Framework</.label>
                <.combobox
                  id="framework-select"
                  value={@selected_framework}
                  options={[
                    %{value: "react", label: "React"},
                    %{value: "vue", label: "Vue"},
                    %{value: "svelte", label: "Svelte"},
                    %{value: "angular", label: "Angular"},
                    %{value: "solid", label: "Solid"},
                    %{value: "qwik", label: "Qwik"},
                    %{value: "phoenix", label: "Phoenix LiveView"}
                  ]}
                  placeholder="Select a framework..."
                  mode={:single}
                  phx-change="select_framework"
                />
                <p class="text-sm text-muted-foreground mt-1.5">
                  Selected: {if @selected_framework, do: @selected_framework, else: "(none)"}
                </p>
              </div>

              <div>
                <.label for="language-select" class="mb-1.5">Programming Language</.label>
                <.combobox
                  id="language-select"
                  value={@selected_language}
                  options={[
                    %{value: "elixir", label: "Elixir"},
                    %{value: "ruby", label: "Ruby"},
                    %{value: "python", label: "Python"},
                    %{value: "javascript", label: "JavaScript"},
                    %{value: "go", label: "Go"},
                    %{value: "rust", label: "Rust"}
                  ]}
                  placeholder="Select language..."
                  mode={:single}
                  phx-change="select_language"
                />
                <p class="text-sm text-muted-foreground mt-1.5">
                  Selected: {@selected_language}
                </p>
              </div>
            </.stack>
          </section>

          <%!-- Multiple Selection --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Multiple Selection</h2>
            <.stack size="medium">
              <div>
                <.label for="tags-select" class="mb-1.5">Select Tags</.label>
                <.combobox
                  id="tags-select"
                  value={@selected_tags}
                  options={[
                    %{value: "bug", label: "Bug"},
                    %{value: "feature", label: "Feature"},
                    %{value: "enhancement", label: "Enhancement"},
                    %{value: "documentation", label: "Documentation"},
                    %{value: "performance", label: "Performance"},
                    %{value: "security", label: "Security"}
                  ]}
                  placeholder="Select tags..."
                  mode={:multiple}
                  phx-change="select_tags"
                />
                <p class="text-sm text-muted-foreground mt-1.5">
                  Selected ({length(@selected_tags)}): {if Enum.empty?(@selected_tags),
                    do: "(none)",
                    else: Enum.join(@selected_tags, ", ")}
                </p>
              </div>

              <div>
                <.label for="team-select" class="mb-1.5">Team Members</.label>
                <.combobox
                  id="team-select"
                  value={@selected_team_members}
                  options={[
                    %{value: "alice", label: "Alice Johnson"},
                    %{value: "bob", label: "Bob Smith"},
                    %{value: "charlie", label: "Charlie Davis"},
                    %{value: "diana", label: "Diana Martinez"},
                    %{value: "evan", label: "Evan Wilson"}
                  ]}
                  placeholder="Select team members..."
                  search_placeholder="Search members..."
                  mode={:multiple}
                  phx-change="select_team"
                />
                <p class="text-sm text-muted-foreground mt-1.5">
                  Selected: {Enum.join(@selected_team_members, ", ")}
                </p>
              </div>
            </.stack>
          </section>

          <%!-- Form Example --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Form Example</h2>
            <.card class="max-w-md">
              <.card_header>
                <.card_title>Create Task</.card_title>
                <.card_description>Assign task to team members</.card_description>
              </.card_header>
              <.card_content>
                <.stack size="medium">
                  <div>
                    <.label for="task-name" class="mb-1.5">Task Name</.label>
                    <.input id="task-name" name="name" placeholder="Enter task name" />
                  </div>

                  <div>
                    <.label for="task-assignees" class="mb-1.5">Assignees</.label>
                    <.combobox
                      id="task-assignees"
                      value={@task_assignees}
                      options={[
                        %{value: "alice", label: "Alice Johnson"},
                        %{value: "bob", label: "Bob Smith"},
                        %{value: "charlie", label: "Charlie Davis"}
                      ]}
                      placeholder="Select assignees..."
                      mode={:multiple}
                      phx-change="select_task_assignees"
                    />
                  </div>

                  <div>
                    <.label for="task-priority" class="mb-1.5">Priority</.label>
                    <.combobox
                      id="task-priority"
                      value={@task_priority}
                      options={[
                        %{value: "low", label: "Low"},
                        %{value: "medium", label: "Medium"},
                        %{value: "high", label: "High"},
                        %{value: "urgent", label: "Urgent"}
                      ]}
                      placeholder="Select priority..."
                      mode={:single}
                      phx-change="select_task_priority"
                    />
                  </div>

                  <.button class="w-full">Create Task</.button>
                </.stack>
              </.card_content>
            </.card>
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
                    <h3 class="text-sm font-semibold text-foreground mb-2">Single Selection</h3>
                    <ul class="text-sm text-muted-foreground space-y-1 list-disc list-inside">
                      <li>Search/filter via Command input</li>
                      <li>Checkmark indicates selected item</li>
                      <li>Popover closes on selection</li>
                      <li>Display selected label in trigger</li>
                      <li>Empty state when no results</li>
                    </ul>
                  </div>

                  <div>
                    <h3 class="text-sm font-semibold text-foreground mb-2">Multiple Selection</h3>
                    <ul class="text-sm text-muted-foreground space-y-1 list-disc list-inside">
                      <li>Select multiple items</li>
                      <li>Checkmarks for all selected</li>
                      <li>Popover stays open for selection</li>
                      <li>Count badge shows "N selected"</li>
                      <li>Toggle items on/off</li>
                    </ul>
                  </div>

                  <div>
                    <h3 class="text-sm font-semibold text-foreground mb-2">Keyboard Navigation</h3>
                    <ul class="text-sm text-muted-foreground space-y-1 list-disc list-inside">
                      <li>
                        <code class="text-xs">Arrow Up/Down</code> - Navigate options
                      </li>
                      <li>
                        <code class="text-xs">Enter</code> - Select focused item
                      </li>
                      <li>
                        <code class="text-xs">Escape</code> - Close popover
                      </li>
                      <li>Type to filter results instantly</li>
                      <li>Full ARIA support</li>
                    </ul>
                  </div>

                  <div>
                    <h3 class="text-sm font-semibold text-foreground mb-2">Implementation</h3>
                    <ul class="text-sm text-muted-foreground space-y-1 list-disc list-inside">
                      <li>Composes Command + Popover</li>
                      <li>Client-side filtering via CommandFilter hook</li>
                      <li>Semantic color tokens for theming</li>
                      <li>Automatic dark mode support</li>
                      <li>Hidden input for form submission</li>
                    </ul>
                  </div>
                </.grid>
              </.card_content>
            </.card>
          </section>
        </.stack>
      </.container>
    
    """
  end
end
