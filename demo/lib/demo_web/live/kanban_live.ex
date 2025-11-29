defmodule DemoWeb.Ui.KanbanLive do
  @moduledoc false
  use DemoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:tasks, initial_tasks())
     |> assign(:projects, initial_projects())}
  end

  @impl true
  def handle_event("reorder", _params, socket) do
    # In a real app, you would handle the reorder event:
    # %{
    #   "from" => from_column,
    #   "to" => to_column,
    #   "item" => card_id,
    #   "newIndex" => new_index
    # } = params
    #
    # Then update your database accordingly

    # For demo purposes, we just silently acknowledge the move
    # The drag-and-drop visual feedback is sufficient
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.container max_width="full" padding="small">
      <.stack gap="xl">
        <%!-- Header --%>
        <div>
          <h1 class="text-3xl font-bold text-foreground">Kanban Component</h1>
          <p class="text-muted-foreground mt-2">
            A drag-and-drop kanban board for task management and workflow visualization.
          </p>
        </div>

        <%!-- Basic Kanban --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Basic Kanban</h2>
          <p class="text-muted-foreground text-sm mb-4">
            A simple kanban board with three columns. Try dragging cards between columns!
          </p>

          <.kanban id="basic-board">
            <.kanban_column title="To Do" id="todo" count={3}>
              <.kanban_card id="task-1" title="Design new landing page">
                <:content>
                  <p class="text-sm text-muted-foreground">
                    Create mockups and wireframes for the new landing page redesign.
                  </p>
                </:content>
                <:footer>
                  <.badge variant="default">Design</.badge>
                  <.badge variant="outline">High</.badge>
                </:footer>
              </.kanban_card>

              <.kanban_card id="task-2" title="Write API documentation" />

              <.kanban_card id="task-3" title="Set up CI/CD pipeline">
                <:footer>
                  <.badge variant="secondary">DevOps</.badge>
                </:footer>
              </.kanban_card>
            </.kanban_column>

            <.kanban_column title="In Progress" id="in-progress" count={2}>
              <.kanban_card id="task-4" title="Implement user authentication">
                <:content>
                  <p class="text-sm text-muted-foreground">
                    Add OAuth and JWT authentication to the application.
                  </p>
                </:content>
                <:footer>
                  <.badge variant="info">Backend</.badge>
                  <.badge variant="warning">In Progress</.badge>
                </:footer>
              </.kanban_card>

              <.kanban_card id="task-5" title="Fix mobile responsiveness">
                <:footer>
                  <.badge variant="destructive">Bug</.badge>
                </:footer>
              </.kanban_card>
            </.kanban_column>

            <.kanban_column title="Done" id="done" count={1}>
              <.kanban_card id="task-6" title="Setup project repository">
                <:content>
                  <p class="text-sm text-muted-foreground">
                    Initialize Git repository and setup initial project structure.
                  </p>
                </:content>
                <:footer>
                  <.badge variant="success">Completed</.badge>
                </:footer>
              </.kanban_card>
            </.kanban_column>
          </.kanban>
        </section>

        <%!-- Custom Column Width --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Custom Column Width</h2>
          <p class="text-muted-foreground text-sm mb-4">
            Columns can have custom widths using the width attribute.
          </p>

          <.kanban id="custom-width-board">
            <.kanban_column title="Backlog" id="backlog-custom" width="w-64" count={2}>
              <.kanban_card id="custom-1" title="Small column card" />
              <.kanban_card id="custom-2" title="Another task" />
            </.kanban_column>

            <.kanban_column title="Active" id="active-custom" width="w-96" count={1}>
              <.kanban_card id="custom-3" title="Wide column card">
                <:content>
                  <p class="text-sm text-muted-foreground">
                    This column is wider (w-96) to accommodate more content.
                  </p>
                </:content>
              </.kanban_card>
            </.kanban_column>
          </.kanban>
        </section>

        <%!-- Custom Headers --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Custom Column Headers</h2>
          <p class="text-muted-foreground text-sm mb-4">
            Columns support custom headers with actions and additional information.
          </p>

          <.kanban id="custom-header-board">
            <.kanban_column title="Projects" id="projects-custom">
              <:header>
                <.flex justify="between" items="center" class="mb-0">
                  <.flex justify="center" items="center" class="gap-2">
                    <h3 class="font-semibold text-foreground">Projects</h3>
                    <.badge variant="secondary">{length(@projects)}</.badge>
                  </.flex>
                  <.button size="icon-sm" variant="ghost" aria-label="Add project">
                    <.icon name="hero-plus" class="h-4 w-4" />
                  </.button>
                </.flex>
              </:header>

              <.kanban_card :for={project <- @projects} id={project.id} title={project.name}>
                <:content>
                  <p class="text-sm text-muted-foreground">{project.description}</p>
                </:content>
                <:footer>
                  <.badge variant={project.priority}>{project.status}</.badge>
                </:footer>
              </.kanban_card>
            </.kanban_column>

            <.kanban_column title="Archived" id="archived-custom">
              <:header>
                <.flex justify="between" items="center" class="mb-0">
                  <.flex justify="center" items="center" class="gap-2">
                    <.icon name="hero-archive-box" class="h-5 w-5 text-muted-foreground" />
                    <h3 class="font-semibold text-foreground">Archived</h3>
                  </.flex>
                </.flex>
              </:header>

              <.kanban_card id="archived-1" title="Old project">
                <:footer>
                  <.badge variant="outline">Archived</.badge>
                </:footer>
              </.kanban_card>
            </.kanban_column>
          </.kanban>
        </section>

        <%!-- Custom Card Content --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Custom Card Content</h2>
          <p class="text-muted-foreground text-sm mb-4">
            Cards can contain custom content using the inner_block slot for complete flexibility.
          </p>

          <.kanban id="custom-content-board">
            <.kanban_column title="Team Members" id="team-members">
              <.kanban_card id="member-1">
                <.flex justify="start" items="start" class="gap-3">
                  <div class="flex h-10 w-10 items-center justify-center rounded-full bg-primary text-primary-foreground font-semibold">
                    JD
                  </div>
                  <div class="flex-1">
                    <p class="font-semibold text-foreground">John Doe</p>
                    <p class="text-sm text-muted-foreground">john@example.com</p>
                    <.flex justify="start" items="start" class="gap-2 mt-2">
                      <.badge variant="success">Active</.badge>
                      <.badge variant="outline">Admin</.badge>
                    </.flex>
                  </div>
                </.flex>
              </.kanban_card>

              <.kanban_card id="member-2">
                <.flex justify="start" items="start" class="gap-3">
                  <div class="flex h-10 w-10 items-center justify-center rounded-full bg-secondary text-secondary-foreground font-semibold">
                    SK
                  </div>
                  <div class="flex-1">
                    <p class="font-semibold text-foreground">Sarah Kim</p>
                    <p class="text-sm text-muted-foreground">sarah@example.com</p>
                    <.flex justify="start" items="start" class="gap-2 mt-2">
                      <.badge variant="success">Active</.badge>
                      <.badge variant="outline">Developer</.badge>
                    </.flex>
                  </div>
                </.flex>
              </.kanban_card>
            </.kanban_column>

            <.kanban_column title="Pending Invites" id="pending-invites" count={1}>
              <.kanban_card id="invite-1">
                <.flex justify="start" items="start" class="gap-3">
                  <div class="flex h-10 w-10 items-center justify-center rounded-full bg-muted text-muted-foreground font-semibold">
                    ?
                  </div>
                  <div class="flex-1">
                    <p class="font-semibold text-foreground">alex@example.com</p>
                    <p class="text-sm text-muted-foreground">Invited 2 days ago</p>
                    <.badge variant="warning" class="mt-2">Pending</.badge>
                  </div>
                </.flex>
              </.kanban_card>
            </.kanban_column>
          </.kanban>
        </section>

        <%!-- Non-draggable Cards --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Non-draggable Cards</h2>
          <p class="text-muted-foreground text-sm mb-4">
            Cards can be made non-draggable using the draggable={false} attribute.
          </p>

          <.kanban id="mixed-draggable-board">
            <.kanban_column title="Locked Items" id="locked-items">
              <.kanban_card id="locked-1" title="System Configuration" draggable={false}>
                <:content>
                  <p class="text-sm text-muted-foreground">
                    This card cannot be moved (no drag handle visible on hover).
                  </p>
                </:content>
                <:footer>
                  <.badge variant="outline">
                    <.icon name="hero-lock-closed" class="h-3 w-3" /> Locked
                  </.badge>
                </:footer>
              </.kanban_card>

              <.kanban_card id="movable-1" title="Regular Task">
                <:content>
                  <p class="text-sm text-muted-foreground">
                    This card can be moved (drag handle appears on hover).
                  </p>
                </:content>
              </.kanban_card>
            </.kanban_column>

            <.kanban_column title="Available" id="available-items">
              <.kanban_card id="movable-2" title="Another movable card" />
            </.kanban_column>
          </.kanban>
        </section>

        <%!-- Swimlanes --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Swimlanes</h2>
          <p class="text-muted-foreground text-sm mb-4">
            Swimlanes allow you to organize your kanban board by teams, priorities, or any other category.
            Column headers appear once at the top, with lightweight dividers separating each swimlane.
            Click the chevron icon to collapse or expand individual swimlanes. Collapse state is persisted
            to localStorage automatically (no server roundtrip needed).
          </p>

          <.kanban id="swimlane-board" class="max-h-[600px]">
            <:headers>
              <.kanban_column_header title="To Do" count={4} />
              <.kanban_column_header title="In Progress" count={4} />
              <.kanban_column_header title="Done" count={2} />
            </:headers>

            <.kanban_swimlane title="Team Alpha" id="team-alpha">
              <.kanban_column title="To Do" id="alpha-todo" show_header={false}>
                <.kanban_card id="alpha-task-1" title="Design user interface">
                  <:content>
                    <p class="text-sm text-muted-foreground">Create mockups for new dashboard</p>
                  </:content>
                  <:footer>
                    <.badge variant="default">Design</.badge>
                  </:footer>
                </.kanban_card>

                <.kanban_card id="alpha-task-2" title="Implement API endpoints">
                  <:footer>
                    <.badge variant="info">Backend</.badge>
                  </:footer>
                </.kanban_card>
              </.kanban_column>

              <.kanban_column title="In Progress" id="alpha-progress" show_header={false}>
                <.kanban_card id="alpha-task-3" title="User authentication">
                  <:content>
                    <p class="text-sm text-muted-foreground">
                      Implementing OAuth2 flow with JWT tokens
                    </p>
                  </:content>
                  <:footer>
                    <.badge variant="warning">In Progress</.badge>
                  </:footer>
                </.kanban_card>
              </.kanban_column>

              <.kanban_column title="Done" id="alpha-done" show_header={false}>
                <.kanban_card id="alpha-task-4" title="Setup repository">
                  <:footer>
                    <.badge variant="success">Completed</.badge>
                  </:footer>
                </.kanban_card>
              </.kanban_column>
            </.kanban_swimlane>

            <.kanban_swimlane title="Team Beta" id="team-beta">
              <.kanban_column title="To Do" id="beta-todo" show_header={false}>
                <.kanban_card id="beta-task-1" title="Write unit tests">
                  <:footer>
                    <.badge variant="secondary">Testing</.badge>
                  </:footer>
                </.kanban_card>
              </.kanban_column>

              <.kanban_column title="In Progress" id="beta-progress" show_header={false}>
                <.kanban_card id="beta-task-2" title="Database migration">
                  <:content>
                    <p class="text-sm text-muted-foreground">Adding new tables for reporting</p>
                  </:content>
                  <:footer>
                    <.badge variant="warning">In Progress</.badge>
                  </:footer>
                </.kanban_card>

                <.kanban_card id="beta-task-3" title="Performance optimization">
                  <:footer>
                    <.badge variant="info">Backend</.badge>
                  </:footer>
                </.kanban_card>
              </.kanban_column>

              <.kanban_column title="Done" id="beta-done" show_header={false}></.kanban_column>
            </.kanban_swimlane>

            <.kanban_swimlane title="Team Gamma" id="team-gamma">
              <.kanban_column title="To Do" id="gamma-todo" show_header={false}>
                <.kanban_card id="gamma-task-1" title="Security audit">
                  <:content>
                    <p class="text-sm text-muted-foreground">
                      Review codebase for security vulnerabilities
                    </p>
                  </:content>
                  <:footer>
                    <.badge variant="destructive">High Priority</.badge>
                  </:footer>
                </.kanban_card>
              </.kanban_column>

              <.kanban_column title="In Progress" id="gamma-progress" show_header={false}>
              </.kanban_column>

              <.kanban_column title="Done" id="gamma-done" show_header={false}>
                <.kanban_card id="gamma-task-2" title="Code review">
                  <:footer>
                    <.badge variant="success">Completed</.badge>
                  </:footer>
                </.kanban_card>
              </.kanban_column>
            </.kanban_swimlane>
          </.kanban>
        </section>

        <%!-- Swimlanes with Custom Headers --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">
            Swimlanes with Icons
          </h2>
          <p class="text-muted-foreground text-sm mb-4">
            You can customize swimlane headers with icons and badges for additional context.
          </p>

          <.kanban id="advanced-swimlane-board" class="max-h-[600px]">
            <:headers>
              <.kanban_column_header title="To Do" width="w-72" count={1} />
              <.kanban_column_header title="In Progress" width="w-72" count={2} />
              <.kanban_column_header title="Done" width="w-72" count={2} />
            </:headers>

            <.kanban_swimlane title="High Priority" id="priority-high">
              <:header>
                <.flex justify="center" items="center" class="gap-2">
                  <.icon name="hero-exclamation-triangle" class="h-3.5 w-3.5 text-destructive" />
                  <span class="text-xs font-medium text-muted-foreground uppercase tracking-wider">
                    High Priority
                  </span>
                  <.badge variant="destructive" class="text-xs px-1.5 py-0">3</.badge>
                </.flex>
              </:header>

              <.kanban_column title="To Do" id="high-todo" width="w-72" show_header={false}>
                <.kanban_card id="high-1" title="Critical bug fix">
                  <:content>
                    <p class="text-sm text-muted-foreground">
                      Production issue affecting users
                    </p>
                  </:content>
                  <:footer>
                    <.badge variant="destructive">Critical</.badge>
                  </:footer>
                </.kanban_card>
              </.kanban_column>

              <.kanban_column title="In Progress" id="high-progress" width="w-72" show_header={false}>
                <.kanban_card id="high-2" title="Security patch">
                  <:footer>
                    <.badge variant="warning">In Progress</.badge>
                  </:footer>
                </.kanban_card>
              </.kanban_column>

              <.kanban_column title="Done" id="high-done" width="w-72" show_header={false}>
                <.kanban_card id="high-3" title="Hotfix deployment">
                  <:footer>
                    <.badge variant="success">Deployed</.badge>
                  </:footer>
                </.kanban_card>
              </.kanban_column>
            </.kanban_swimlane>

            <.kanban_swimlane title="Normal Priority" id="priority-normal">
              <:header>
                <.flex justify="center" items="center" class="gap-2">
                  <.icon name="hero-minus-circle" class="h-3.5 w-3.5 text-muted-foreground" />
                  <span class="text-xs font-medium text-muted-foreground uppercase tracking-wider">
                    Normal Priority
                  </span>
                  <.badge variant="outline" class="text-xs px-1.5 py-0">2</.badge>
                </.flex>
              </:header>

              <.kanban_column title="To Do" id="normal-todo" width="w-72" show_header={false}>
                <.kanban_card id="normal-1" title="Feature enhancement">
                  <:footer>
                    <.badge variant="default">Feature</.badge>
                  </:footer>
                </.kanban_card>
              </.kanban_column>

              <.kanban_column
                title="In Progress"
                id="normal-progress"
                width="w-72"
                show_header={false}
              >
                <.kanban_card id="normal-2" title="Documentation update">
                  <:footer>
                    <.badge variant="secondary">Docs</.badge>
                  </:footer>
                </.kanban_card>
              </.kanban_column>

              <.kanban_column title="Done" id="normal-done" width="w-72" show_header={false}>
              </.kanban_column>
            </.kanban_swimlane>
          </.kanban>
        </section>
      </.stack>
    </.container>
    """
  end

  # Demo data
  defp initial_tasks do
    [
      %{id: "task-1", title: "Design new landing page", status: "todo"},
      %{id: "task-2", title: "Write API documentation", status: "todo"},
      %{id: "task-3", title: "Set up CI/CD pipeline", status: "todo"},
      %{id: "task-4", title: "Implement user authentication", status: "in_progress"},
      %{id: "task-5", title: "Fix mobile responsiveness", status: "in_progress"},
      %{id: "task-6", title: "Setup project repository", status: "done"}
    ]
  end

  defp initial_projects do
    [
      %{
        id: "proj-1",
        name: "Website Redesign",
        description: "Complete overhaul of company website",
        status: "Active",
        priority: "default"
      },
      %{
        id: "proj-2",
        name: "Mobile App",
        description: "New iOS and Android applications",
        status: "Planning",
        priority: "info"
      },
      %{
        id: "proj-3",
        name: "API Integration",
        description: "Third-party service integration",
        status: "On Hold",
        priority: "warning"
      }
    ]
  end
end
