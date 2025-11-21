defmodule DemoWeb.Ui.SidebarLive do
  @moduledoc """
  Showcase page for the Sidebar component.

  Demonstrates various sidebar configurations, states, and use cases
  including collapsible navigation, icon mode, and different layouts.
  """
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
            <h1 class="text-3xl font-bold text-foreground">Sidebar Component</h1>
            <p class="text-muted-foreground mt-2">
              A collapsible navigation sidebar with support for multiple variants, states, and responsive behavior.
            </p>
          </div>

          <%!-- Basic Sidebar Example --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Basic Sidebar</h2>
            <p class="text-sm text-muted-foreground mb-4">
              A simple sidebar with header, content sections, and footer. Click the toggle button to collapse/expand.
            </p>
            <.card>
              <.card_content class="p-0">
                <div class="h-[500px] relative border border-border rounded-lg overflow-hidden isolate [&_[data-slot=sidebar-container]]:absolute [&_[data-slot=sidebar-container]]:h-full">
                  <.sidebar_provider id="sidebar-example-basic">
                    <.sidebar variant="sidebar" collapsible="icon">
                      <.sidebar_header>
                        <.sidebar_menu>
                          <.sidebar_menu_item>
                            <.sidebar_menu_button size="lg" class="cursor-default">
                              <div class="flex aspect-square size-8 items-center justify-center rounded-lg bg-primary text-primary-foreground">
                                <.icon name="hero-command-line" class="size-4" />
                              </div>
                              <div class="grid flex-1 text-left text-sm leading-tight group-data-[collapsible=icon]:hidden">
                                <span class="truncate font-semibold">Acme Inc</span>
                                <span class="truncate text-xs text-muted-foreground">Enterprise</span>
                              </div>
                            </.sidebar_menu_button>
                          </.sidebar_menu_item>
                        </.sidebar_menu>
                      </.sidebar_header>

                      <.sidebar_content>
                        <.sidebar_group label="Platform">
                          <.sidebar_menu>
                            <.sidebar_menu_item icon="hero-home" label="Dashboard" />
                            <.sidebar_menu_item icon="hero-inbox" label="Inbox" badge="12" />
                            <.sidebar_menu_item icon="hero-calendar" label="Calendar" />
                          </.sidebar_menu>
                        </.sidebar_group>

                        <.sidebar_group label="Projects">
                          <.sidebar_menu>
                            <.sidebar_menu_item icon="hero-folder" label="Design System" />
                            <.sidebar_menu_item icon="hero-folder" label="Marketing Site" />
                          </.sidebar_menu>
                        </.sidebar_group>
                      </.sidebar_content>

                      <.sidebar_footer>
                        <.sidebar_menu>
                          <.sidebar_menu_item icon="hero-user-circle" label="John Doe" />
                        </.sidebar_menu>
                      </.sidebar_footer>

                      <.sidebar_rail />
                    </.sidebar>

                    <.sidebar_inset full_page={false}>
                      <div class="p-6">
                        <div class="flex items-center gap-2 mb-4">
                          <.sidebar_trigger id="sidebar-trigger-basic" />
                          <.separator orientation="vertical" class="h-5" />
                          <h3 class="font-semibold">Main Content Area</h3>
                        </div>
                        <p class="text-muted-foreground text-sm">
                          This is the main content area. The sidebar can be toggled using the button above
                          or with the keyboard shortcut Cmd/Ctrl+B.
                        </p>
                      </div>
                    </.sidebar_inset>
                  </.sidebar_provider>
                </div>
              </.card_content>
            </.card>
          </section>

          <%!-- Sidebar with Submenu --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Sidebar with Submenus</h2>
            <p class="text-sm text-muted-foreground mb-4">
              Demonstrating nested navigation with collapsible submenu items. Click on menu items
              with chevron icons to expand/collapse their submenus.
            </p>
            <.card>
              <.card_content class="p-0">
                <div class="h-[500px] relative border border-border rounded-lg overflow-hidden isolate [&_[data-slot=sidebar-container]]:absolute [&_[data-slot=sidebar-container]]:h-full">
                  <.sidebar_provider id="sidebar-example-submenu">
                    <.sidebar variant="sidebar" collapsible="icon">
                      <.sidebar_header>
                        <.sidebar_menu>
                          <.sidebar_menu_item>
                            <.sidebar_menu_button size="lg" class="cursor-default">
                              <div class="flex aspect-square size-8 items-center justify-center rounded-lg bg-primary text-primary-foreground">
                                <.icon name="hero-beaker" class="size-4" />
                              </div>
                              <div class="grid flex-1 text-left text-sm leading-tight group-data-[collapsible=icon]:hidden">
                                <span class="truncate font-semibold">Labs Dashboard</span>
                                <span class="truncate text-xs text-muted-foreground">v2.0.0</span>
                              </div>
                            </.sidebar_menu_button>
                          </.sidebar_menu_item>
                        </.sidebar_menu>
                      </.sidebar_header>

                      <.sidebar_content>
                        <.sidebar_group label="Navigation">
                          <.sidebar_menu>
                            <.sidebar_menu_item icon="hero-home" label="Overview" />

                            <%!-- Settings with submenu (using simplified syntax) --%>
                            <.sidebar_menu_item
                              icon="hero-cog-6-tooth"
                              label="Settings"
                              items={[
                                %{label: "Profile", href: "#profile"},
                                %{label: "Account", href: "#account"},
                                %{label: "Security", href: "#security"}
                              ]}
                            />

                            <%!-- Team with submenu (using simplified syntax) --%>
                            <.sidebar_menu_item
                              icon="hero-user-group"
                              label="Team"
                              items={[
                                %{label: "Members", href: "#members"},
                                %{label: "Invitations", href: "#invitations"},
                                %{label: "Roles", href: "#roles"}
                              ]}
                            />
                          </.sidebar_menu>
                        </.sidebar_group>
                      </.sidebar_content>

                      <.sidebar_footer>
                        <.sidebar_menu>
                          <.sidebar_menu_item icon="hero-arrow-right-on-rectangle" label="Sign Out" />
                        </.sidebar_menu>
                      </.sidebar_footer>

                      <.sidebar_rail />
                    </.sidebar>

                    <.sidebar_inset full_page={false}>
                      <div class="p-6">
                        <div class="flex items-center gap-2 mb-4">
                          <.sidebar_trigger id="sidebar-trigger-submenu" />
                          <.separator orientation="vertical" class="h-5" />
                          <h3 class="font-semibold">Submenu Example</h3>
                        </div>
                        <p class="text-muted-foreground text-sm">
                          Click on "Settings" or "Team" menu items to expand/collapse their nested submenus.
                          The chevron icon rotates to indicate the current state.
                        </p>
                      </div>
                    </.sidebar_inset>
                  </.sidebar_provider>
                </div>
              </.card_content>
            </.card>
          </section>

          <%!-- Sidebar with Actions and Badges --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">
              Sidebar with Actions & Badges
            </h2>
            <p class="text-sm text-muted-foreground mb-4">
              Menu items can include action buttons and notification badges.
            </p>
            <.card>
              <.card_content class="p-0">
                <div class="h-[500px] relative border border-border rounded-lg overflow-hidden isolate [&_[data-slot=sidebar-container]]:absolute [&_[data-slot=sidebar-container]]:h-full">
                  <.sidebar_provider id="sidebar-example-badges">
                    <.sidebar variant="sidebar" collapsible="icon">
                      <.sidebar_header>
                        <.sidebar_menu>
                          <.sidebar_menu_item>
                            <.sidebar_menu_button size="lg" class="cursor-default">
                              <div class="flex aspect-square size-8 items-center justify-center rounded-lg bg-primary text-primary-foreground">
                                <.icon name="hero-bell" class="size-4" />
                              </div>
                              <div class="grid flex-1 text-left text-sm leading-tight group-data-[collapsible=icon]:hidden">
                                <span class="truncate font-semibold">Notifications</span>
                                <span class="truncate text-xs text-muted-foreground">Hub</span>
                              </div>
                            </.sidebar_menu_button>
                          </.sidebar_menu_item>
                        </.sidebar_menu>
                      </.sidebar_header>

                      <.sidebar_content>
                        <.sidebar_group label="Channels">
                          <.sidebar_group_action>
                            <.icon name="hero-plus" class="size-4" />
                            <span class="sr-only">Add Channel</span>
                          </.sidebar_group_action>
                          <.sidebar_menu>
                            <.sidebar_menu_item>
                              <.sidebar_menu_button>
                                <.icon name="hero-inbox" class="size-4" />
                                <span class="group-data-[collapsible=icon]:hidden">Inbox</span>
                                <.sidebar_menu_badge>24</.sidebar_menu_badge>
                              </.sidebar_menu_button>
                            </.sidebar_menu_item>

                            <.sidebar_menu_item>
                              <.sidebar_menu_button>
                                <.icon name="hero-star" class="size-4" />
                                <span class="group-data-[collapsible=icon]:hidden">Starred</span>
                                <.sidebar_menu_badge>5</.sidebar_menu_badge>
                              </.sidebar_menu_button>
                            </.sidebar_menu_item>

                            <.sidebar_menu_item>
                              <.sidebar_menu_button>
                                <.icon name="hero-paper-airplane" class="size-4" />
                                <span class="group-data-[collapsible=icon]:hidden">Sent</span>
                              </.sidebar_menu_button>
                              <.sidebar_menu_action>
                                <.icon name="hero-ellipsis-horizontal" class="size-4" />
                                <span class="sr-only">More actions</span>
                              </.sidebar_menu_action>
                            </.sidebar_menu_item>

                            <.sidebar_menu_item>
                              <.sidebar_menu_button>
                                <.icon name="hero-archive-box" class="size-4" />
                                <span class="group-data-[collapsible=icon]:hidden">Archive</span>
                              </.sidebar_menu_button>
                              <.sidebar_menu_action>
                                <.icon name="hero-ellipsis-horizontal" class="size-4" />
                                <span class="sr-only">More actions</span>
                              </.sidebar_menu_action>
                            </.sidebar_menu_item>
                          </.sidebar_menu>
                        </.sidebar_group>

                        <.sidebar_separator />

                        <.sidebar_group label="Labels">
                          <.sidebar_menu>
                            <.sidebar_menu_item>
                              <.sidebar_menu_button>
                                <div class="size-2 rounded-full bg-red-500" />
                                <span class="group-data-[collapsible=icon]:hidden">Urgent</span>
                                <.sidebar_menu_badge>3</.sidebar_menu_badge>
                              </.sidebar_menu_button>
                            </.sidebar_menu_item>
                            <.sidebar_menu_item>
                              <.sidebar_menu_button>
                                <div class="size-2 rounded-full bg-blue-500" />
                                <span class="group-data-[collapsible=icon]:hidden">Work</span>
                                <.sidebar_menu_badge>12</.sidebar_menu_badge>
                              </.sidebar_menu_button>
                            </.sidebar_menu_item>
                            <.sidebar_menu_item>
                              <.sidebar_menu_button>
                                <div class="size-2 rounded-full bg-green-500" />
                                <span class="group-data-[collapsible=icon]:hidden">Personal</span>
                                <.sidebar_menu_badge>8</.sidebar_menu_badge>
                              </.sidebar_menu_button>
                            </.sidebar_menu_item>
                          </.sidebar_menu>
                        </.sidebar_group>
                      </.sidebar_content>

                      <.sidebar_rail />
                    </.sidebar>

                    <.sidebar_inset full_page={false}>
                      <div class="p-6">
                        <div class="flex items-center gap-2 mb-4">
                          <.sidebar_trigger id="sidebar-trigger-badges" />
                          <.separator orientation="vertical" class="h-5" />
                          <h3 class="font-semibold">Actions & Badges</h3>
                        </div>
                        <p class="text-muted-foreground text-sm">
                          Notice the notification badges on menu items and action buttons that appear
                          on hover.
                        </p>
                      </div>
                    </.sidebar_inset>
                  </.sidebar_provider>
                </div>
              </.card_content>
            </.card>
          </section>

          <%!-- Loading State --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Loading State</h2>
            <p class="text-sm text-muted-foreground mb-4">
              Use skeleton components to show loading states while content is being fetched.
            </p>
            <.card>
              <.card_content class="p-0">
                <div class="h-[400px] relative border border-border rounded-lg overflow-hidden isolate [&_[data-slot=sidebar-container]]:absolute [&_[data-slot=sidebar-container]]:h-full">
                  <.sidebar_provider id="sidebar-example-loading">
                    <.sidebar variant="sidebar" collapsible="icon">
                      <.sidebar_header>
                        <.sidebar_menu>
                          <.sidebar_menu_item>
                            <.sidebar_menu_button size="lg" class="cursor-default">
                              <div class="flex aspect-square size-8 items-center justify-center rounded-lg bg-muted">
                                <div class="size-4 rounded bg-muted-foreground/20" />
                              </div>
                              <div class="grid flex-1 gap-1.5">
                                <div class="h-3 w-24 rounded bg-muted-foreground/20" />
                                <div class="h-2 w-16 rounded bg-muted-foreground/20" />
                              </div>
                            </.sidebar_menu_button>
                          </.sidebar_menu_item>
                        </.sidebar_menu>
                      </.sidebar_header>

                      <.sidebar_content>
                        <.sidebar_group label="Loading...">
                          <.sidebar_menu>
                            <.sidebar_menu_skeleton show_icon={true} />
                            <.sidebar_menu_skeleton show_icon={true} />
                            <.sidebar_menu_skeleton show_icon={true} />
                            <.sidebar_menu_skeleton show_icon={true} />
                          </.sidebar_menu>
                        </.sidebar_group>
                      </.sidebar_content>

                      <.sidebar_rail />
                    </.sidebar>

                    <.sidebar_inset full_page={false}>
                      <div class="p-6">
                        <div class="flex items-center gap-2 mb-4">
                          <.sidebar_trigger id="sidebar-trigger-loading" />
                          <.separator orientation="vertical" class="h-5" />
                          <h3 class="font-semibold">Loading State</h3>
                        </div>
                        <p class="text-muted-foreground text-sm">
                          Skeleton placeholders indicate that menu items are being loaded.
                        </p>
                      </div>
                    </.sidebar_inset>
                  </.sidebar_provider>
                </div>
              </.card_content>
            </.card>
          </section>

          <%!-- Component Features --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Features</h2>
            <.card>
              <.card_content class="pt-6">
                <.stack size="medium">
                  <div class="flex items-start gap-3">
                    <.icon name="hero-check-circle" class="size-5 text-success mt-0.5" />
                    <div>
                      <p class="font-medium text-foreground">Collapsible States</p>
                      <p class="text-sm text-muted-foreground">
                        Supports three collapsible modes: icon-only, off-canvas drawer, or none
                      </p>
                    </div>
                  </div>

                  <div class="flex items-start gap-3">
                    <.icon name="hero-check-circle" class="size-5 text-success mt-0.5" />
                    <div>
                      <p class="font-medium text-foreground">Persistent State</p>
                      <p class="text-sm text-muted-foreground">
                        Sidebar open/closed state is saved to localStorage and persists across sessions
                      </p>
                    </div>
                  </div>

                  <div class="flex items-start gap-3">
                    <.icon name="hero-check-circle" class="size-5 text-success mt-0.5" />
                    <div>
                      <p class="font-medium text-foreground">Keyboard Shortcuts</p>
                      <p class="text-sm text-muted-foreground">
                        Press Cmd+B (Mac) or Ctrl+B (Windows/Linux) to toggle the sidebar
                      </p>
                    </div>
                  </div>

                  <div class="flex items-start gap-3">
                    <.icon name="hero-check-circle" class="size-5 text-success mt-0.5" />
                    <div>
                      <p class="font-medium text-foreground">Responsive Design</p>
                      <p class="text-sm text-muted-foreground">
                        Automatically switches to mobile drawer on small screens
                      </p>
                    </div>
                  </div>

                  <div class="flex items-start gap-3">
                    <.icon name="hero-check-circle" class="size-5 text-success mt-0.5" />
                    <div>
                      <p class="font-medium text-foreground">Flexible Layout</p>
                      <p class="text-sm text-muted-foreground">
                        Supports header, scrollable content area, and footer sections
                      </p>
                    </div>
                  </div>

                  <div class="flex items-start gap-3">
                    <.icon name="hero-check-circle" class="size-5 text-success mt-0.5" />
                    <div>
                      <p class="font-medium text-foreground">Rich Menu Items</p>
                      <p class="text-sm text-muted-foreground">
                        Menu items support icons, badges, actions, and collapsible nested submenus with smooth animations
                      </p>
                    </div>
                  </div>

                  <div class="flex items-start gap-3">
                    <.icon name="hero-check-circle" class="size-5 text-success mt-0.5" />
                    <div>
                      <p class="font-medium text-foreground">Theme Integration</p>
                      <p class="text-sm text-muted-foreground">
                        Uses semantic color tokens for automatic light/dark theme support
                      </p>
                    </div>
                  </div>

                  <div class="flex items-start gap-3">
                    <.icon name="hero-check-circle" class="size-5 text-success mt-0.5" />
                    <div>
                      <p class="font-medium text-foreground">Loading States</p>
                      <p class="text-sm text-muted-foreground">
                        Built-in skeleton components for smooth loading experiences
                      </p>
                    </div>
                  </div>
                </.stack>
              </.card_content>
            </.card>
          </section>

          <%!-- Component Architecture --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Component Architecture</h2>
            <.card>
              <.card_content class="pt-6">
                <.stack size="medium">
                  <div>
                    <p class="text-sm text-muted-foreground mb-3">
                      The sidebar system is composed of multiple layers:
                    </p>
                  </div>

                  <div class="pl-4 border-l-2 border-primary/20">
                    <h3 class="font-semibold text-foreground mb-2">Core Components</h3>
                    <p class="text-sm text-muted-foreground mb-2">
                      Basic building blocks defined in
                      <code class="text-xs bg-muted px-1 py-0.5 rounded">
                        layout_navigation.ex
                      </code>
                    </p>
                    <ul class="text-sm text-muted-foreground space-y-1 list-disc list-inside">
                      <li>
                        <code class="text-xs">&lt;.sidebar_provider&gt;</code>
                        - State management wrapper
                      </li>
                      <li>
                        <code class="text-xs">&lt;.sidebar&gt;</code> - Main container with variants
                      </li>
                      <li>
                        <code class="text-xs">&lt;.sidebar_menu&gt;</code> - Menu list container
                      </li>
                      <li>
                        <code class="text-xs">&lt;.sidebar_menu_button&gt;</code>
                        - Interactive menu items
                      </li>
                      <li>
                        <code class="text-xs">&lt;.sidebar_trigger&gt;</code> - Toggle button
                      </li>
                    </ul>
                  </div>

                  <div class="pl-4 border-l-2 border-secondary/20">
                    <h3 class="font-semibold text-foreground mb-2">Composition Layer</h3>
                    <p class="text-sm text-muted-foreground mb-2">
                      Higher-level components that compose the core building blocks:
                    </p>
                    <ul class="text-sm text-muted-foreground space-y-1 list-disc list-inside">
                      <li>
                        <code class="text-xs">app_sidebar.ex</code> - Complete application sidebar
                      </li>
                      <li><code class="text-xs">nav_main.ex</code> - Main navigation menu</li>
                      <li><code class="text-xs">nav_projects.ex</code> - Project/document list</li>
                      <li><code class="text-xs">nav_user.ex</code> - User account menu</li>
                      <li><code class="text-xs">organization_switcher.ex</code> - Org switcher</li>
                    </ul>
                  </div>

                  <div class="pl-4 border-l-2 border-accent/20">
                    <h3 class="font-semibold text-foreground mb-2">Application Integration</h3>
                    <p class="text-sm text-muted-foreground">
                      The composed sidebar is integrated into the app layout via
                      <code class="text-xs bg-muted px-1 py-0.5 rounded">layouts.ex</code>
                      and used across authenticated pages.
                    </p>
                  </div>
                </.stack>
              </.card_content>
            </.card>
          </section>

          <%!-- Usage Example --%>
          <section>
            <h2 class="text-xl font-semibold text-foreground mb-4">Usage Example</h2>
            <.card>
              <.card_content class="pt-6">
                <p class="text-sm text-muted-foreground mb-4">
                  Basic sidebar implementation with all essential sections:
                </p>
                <pre
                  class="bg-muted p-4 rounded-lg overflow-x-auto text-xs"
                  phx-no-curly-interpolation
                ><code>&lt;.sidebar_provider&gt;
                  &lt;.sidebar variant="sidebar" collapsible="icon"&gt;
                    &lt;.sidebar_header&gt;
                      &lt;!-- Branding / Logo --&gt;
                    &lt;/.sidebar_header&gt;

                    &lt;.sidebar_content&gt;
                      &lt;.sidebar_group&gt;
                        &lt;.sidebar_group_label&gt;Navigation&lt;/.sidebar_group_label&gt;
                        &lt;.sidebar_menu&gt;
                          &lt;.sidebar_menu_item&gt;
                            &lt;.sidebar_menu_button&gt;
                              &lt;.icon name="hero-home" /&gt;
                              &lt;span&gt;Dashboard&lt;/span&gt;
                            &lt;/.sidebar_menu_button&gt;
                          &lt;/.sidebar_menu_item&gt;
                        &lt;/.sidebar_menu&gt;
                      &lt;/.sidebar_group&gt;
                    &lt;/.sidebar_content&gt;

                    &lt;.sidebar_footer&gt;
                      &lt;!-- User menu --&gt;
                    &lt;/.sidebar_footer&gt;

                    &lt;.sidebar_rail /&gt;
                  &lt;/.sidebar&gt;

                  &lt;.sidebar_inset&gt;
                    &lt;.sidebar_trigger /&gt;
                    &lt;!-- Main content --&gt;
                  &lt;/.sidebar_inset&gt;
                &lt;/.sidebar_provider&gt;</code></pre>
              </.card_content>
            </.card>
          </section>
        </.stack>
      </.container>
    
    """
  end
end
