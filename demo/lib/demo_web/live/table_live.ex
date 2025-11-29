defmodule DemoWeb.Ui.TableLive do
  @moduledoc false
  use DemoWeb, :live_view

  alias UiKit.Components.Ui.DisplayMedia
  alias Phoenix.LiveView.Socket

  @impl true
  @spec mount(map(), map(), Socket.t()) ::
          {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  @spec render(map()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <.container>
      <.stack gap="xl">
        <%!-- Header --%>
        <div>
          <h1 class="text-3xl font-bold text-foreground">Table Component</h1>
          <p class="text-muted-foreground mt-2">
            A responsive table component for displaying tabular data.
          </p>
        </div>

        <%!-- Basic Usage --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Basic Usage</h2>
          <DisplayMedia.table>
            <DisplayMedia.table_header>
              <DisplayMedia.table_row>
                <DisplayMedia.table_head>Invoice</DisplayMedia.table_head>
                <DisplayMedia.table_head>Status</DisplayMedia.table_head>
                <DisplayMedia.table_head>Method</DisplayMedia.table_head>
                <DisplayMedia.table_head class="text-right">Amount</DisplayMedia.table_head>
              </DisplayMedia.table_row>
            </DisplayMedia.table_header>
            <DisplayMedia.table_body>
              <DisplayMedia.table_row>
                <DisplayMedia.table_cell class="font-medium">INV001</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Paid</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Credit Card</DisplayMedia.table_cell>
                <DisplayMedia.table_cell class="text-right">$250.00</DisplayMedia.table_cell>
              </DisplayMedia.table_row>
              <DisplayMedia.table_row>
                <DisplayMedia.table_cell class="font-medium">INV002</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Pending</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>PayPal</DisplayMedia.table_cell>
                <DisplayMedia.table_cell class="text-right">$150.00</DisplayMedia.table_cell>
              </DisplayMedia.table_row>
              <DisplayMedia.table_row>
                <DisplayMedia.table_cell class="font-medium">INV003</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Unpaid</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Bank Transfer</DisplayMedia.table_cell>
                <DisplayMedia.table_cell class="text-right">$350.00</DisplayMedia.table_cell>
              </DisplayMedia.table_row>
              <DisplayMedia.table_row>
                <DisplayMedia.table_cell class="font-medium">INV004</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Paid</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Credit Card</DisplayMedia.table_cell>
                <DisplayMedia.table_cell class="text-right">$450.00</DisplayMedia.table_cell>
              </DisplayMedia.table_row>
              <DisplayMedia.table_row>
                <DisplayMedia.table_cell class="font-medium">INV005</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Paid</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>PayPal</DisplayMedia.table_cell>
                <DisplayMedia.table_cell class="text-right">$550.00</DisplayMedia.table_cell>
              </DisplayMedia.table_row>
            </DisplayMedia.table_body>
          </DisplayMedia.table>
        </section>

        <%!-- With Caption --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">With Caption</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Use <code class="bg-muted px-1.5 py-0.5 rounded text-xs">&lt;.table_caption&gt;</code>
            to add a descriptive caption to your table.
          </p>
          <DisplayMedia.table>
            <DisplayMedia.table_caption>A list of your recent invoices.</DisplayMedia.table_caption>
            <DisplayMedia.table_header>
              <DisplayMedia.table_row>
                <DisplayMedia.table_head>Invoice</DisplayMedia.table_head>
                <DisplayMedia.table_head>Status</DisplayMedia.table_head>
                <DisplayMedia.table_head>Amount</DisplayMedia.table_head>
              </DisplayMedia.table_row>
            </DisplayMedia.table_header>
            <DisplayMedia.table_body>
              <DisplayMedia.table_row>
                <DisplayMedia.table_cell class="font-medium">INV001</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Paid</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>$250.00</DisplayMedia.table_cell>
              </DisplayMedia.table_row>
              <DisplayMedia.table_row>
                <DisplayMedia.table_cell class="font-medium">INV002</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Pending</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>$150.00</DisplayMedia.table_cell>
              </DisplayMedia.table_row>
            </DisplayMedia.table_body>
          </DisplayMedia.table>
        </section>

        <%!-- Striped Table --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Striped Rows</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Add <code class="bg-muted px-1.5 py-0.5 rounded text-xs">striped</code>
            attribute for alternating row colors to improve readability of large tables.
          </p>
          <DisplayMedia.table striped>
            <DisplayMedia.table_header>
              <DisplayMedia.table_row>
                <DisplayMedia.table_head>Product ID</DisplayMedia.table_head>
                <DisplayMedia.table_head>Product Name</DisplayMedia.table_head>
                <DisplayMedia.table_head>Category</DisplayMedia.table_head>
                <DisplayMedia.table_head>Stock</DisplayMedia.table_head>
                <DisplayMedia.table_head class="text-right">Price</DisplayMedia.table_head>
              </DisplayMedia.table_row>
            </DisplayMedia.table_header>
            <DisplayMedia.table_body>
              <DisplayMedia.table_row>
                <DisplayMedia.table_cell class="font-medium">PROD-001</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Wireless Mouse</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Electronics</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>45</DisplayMedia.table_cell>
                <DisplayMedia.table_cell class="text-right">$29.99</DisplayMedia.table_cell>
              </DisplayMedia.table_row>
              <DisplayMedia.table_row>
                <DisplayMedia.table_cell class="font-medium">PROD-002</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>USB-C Cable</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Accessories</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>120</DisplayMedia.table_cell>
                <DisplayMedia.table_cell class="text-right">$12.99</DisplayMedia.table_cell>
              </DisplayMedia.table_row>
              <DisplayMedia.table_row>
                <DisplayMedia.table_cell class="font-medium">PROD-003</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Mechanical Keyboard</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Electronics</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>28</DisplayMedia.table_cell>
                <DisplayMedia.table_cell class="text-right">$89.99</DisplayMedia.table_cell>
              </DisplayMedia.table_row>
              <DisplayMedia.table_row>
                <DisplayMedia.table_cell class="font-medium">PROD-004</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Laptop Stand</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Accessories</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>62</DisplayMedia.table_cell>
                <DisplayMedia.table_cell class="text-right">$39.99</DisplayMedia.table_cell>
              </DisplayMedia.table_row>
              <DisplayMedia.table_row>
                <DisplayMedia.table_cell class="font-medium">PROD-005</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Webcam HD</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Electronics</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>18</DisplayMedia.table_cell>
                <DisplayMedia.table_cell class="text-right">$69.99</DisplayMedia.table_cell>
              </DisplayMedia.table_row>
              <DisplayMedia.table_row>
                <DisplayMedia.table_cell class="font-medium">PROD-006</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Monitor Arm</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Accessories</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>34</DisplayMedia.table_cell>
                <DisplayMedia.table_cell class="text-right">$129.99</DisplayMedia.table_cell>
              </DisplayMedia.table_row>
              <DisplayMedia.table_row>
                <DisplayMedia.table_cell class="font-medium">PROD-007</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Desk Lamp</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Office</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>55</DisplayMedia.table_cell>
                <DisplayMedia.table_cell class="text-right">$45.99</DisplayMedia.table_cell>
              </DisplayMedia.table_row>
            </DisplayMedia.table_body>
          </DisplayMedia.table>
        </section>

        <%!-- With Footer --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">With Footer</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Use <code class="bg-muted px-1.5 py-0.5 rounded text-xs">&lt;.table_footer&gt;</code>
            for summary rows or totals.
          </p>
          <DisplayMedia.table>
            <DisplayMedia.table_header>
              <DisplayMedia.table_row>
                <DisplayMedia.table_head>Product</DisplayMedia.table_head>
                <DisplayMedia.table_head>Quantity</DisplayMedia.table_head>
                <DisplayMedia.table_head class="text-right">Price</DisplayMedia.table_head>
              </DisplayMedia.table_row>
            </DisplayMedia.table_header>
            <DisplayMedia.table_body>
              <DisplayMedia.table_row>
                <DisplayMedia.table_cell>Widget A</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>10</DisplayMedia.table_cell>
                <DisplayMedia.table_cell class="text-right">$100.00</DisplayMedia.table_cell>
              </DisplayMedia.table_row>
              <DisplayMedia.table_row>
                <DisplayMedia.table_cell>Widget B</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>5</DisplayMedia.table_cell>
                <DisplayMedia.table_cell class="text-right">$75.00</DisplayMedia.table_cell>
              </DisplayMedia.table_row>
              <DisplayMedia.table_row>
                <DisplayMedia.table_cell>Widget C</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>3</DisplayMedia.table_cell>
                <DisplayMedia.table_cell class="text-right">$45.00</DisplayMedia.table_cell>
              </DisplayMedia.table_row>
            </DisplayMedia.table_body>
            <DisplayMedia.table_footer>
              <DisplayMedia.table_row>
                <DisplayMedia.table_cell colspan="2">Total</DisplayMedia.table_cell>
                <DisplayMedia.table_cell class="text-right">$220.00</DisplayMedia.table_cell>
              </DisplayMedia.table_row>
            </DisplayMedia.table_footer>
          </DisplayMedia.table>
        </section>

        <%!-- User Management Table --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">User Management Example</h2>
          <.card>
            <.card_header>
              <.flex justify="between" items="center">
                <div>
                  <.card_title>Team Members</.card_title>
                  <.card_description>
                    Manage your team members and their account roles.
                  </.card_description>
                </div>
                <.button>Add Member</.button>
              </.flex>
            </.card_header>
            <.card_content>
              <DisplayMedia.table>
                <DisplayMedia.table_header>
                  <DisplayMedia.table_row>
                    <DisplayMedia.table_head>Name</DisplayMedia.table_head>
                    <DisplayMedia.table_head>Email</DisplayMedia.table_head>
                    <DisplayMedia.table_head>Role</DisplayMedia.table_head>
                    <DisplayMedia.table_head>Status</DisplayMedia.table_head>
                    <DisplayMedia.table_head class="text-right">Actions</DisplayMedia.table_head>
                  </DisplayMedia.table_row>
                </DisplayMedia.table_header>
                <DisplayMedia.table_body>
                  <DisplayMedia.table_row>
                    <DisplayMedia.table_cell class="font-medium">
                      Sofia Davis
                    </DisplayMedia.table_cell>
                    <DisplayMedia.table_cell>sofia@example.com</DisplayMedia.table_cell>
                    <DisplayMedia.table_cell>
                      <.badge>Owner</.badge>
                    </DisplayMedia.table_cell>
                    <DisplayMedia.table_cell>
                      <.flex justify="center" items="center" class="gap-2">
                        <span class="size-2 rounded-full bg-success"></span>
                        <span class="text-sm">Active</span>
                      </.flex>
                    </DisplayMedia.table_cell>
                    <DisplayMedia.table_cell class="text-right">
                      <.button variant="ghost" size="sm">Edit</.button>
                    </DisplayMedia.table_cell>
                  </DisplayMedia.table_row>
                  <DisplayMedia.table_row>
                    <DisplayMedia.table_cell class="font-medium">
                      Jackson Lee
                    </DisplayMedia.table_cell>
                    <DisplayMedia.table_cell>jackson@example.com</DisplayMedia.table_cell>
                    <DisplayMedia.table_cell>
                      <.badge variant="secondary">Admin</.badge>
                    </DisplayMedia.table_cell>
                    <DisplayMedia.table_cell>
                      <.flex justify="center" items="center" class="gap-2">
                        <span class="size-2 rounded-full bg-success"></span>
                        <span class="text-sm">Active</span>
                      </.flex>
                    </DisplayMedia.table_cell>
                    <DisplayMedia.table_cell class="text-right">
                      <.button variant="ghost" size="sm">Edit</.button>
                    </DisplayMedia.table_cell>
                  </DisplayMedia.table_row>
                  <DisplayMedia.table_row>
                    <DisplayMedia.table_cell class="font-medium">
                      Isabella Nguyen
                    </DisplayMedia.table_cell>
                    <DisplayMedia.table_cell>isabella@example.com</DisplayMedia.table_cell>
                    <DisplayMedia.table_cell>
                      <.badge variant="outline">Member</.badge>
                    </DisplayMedia.table_cell>
                    <DisplayMedia.table_cell>
                      <.flex justify="center" items="center" class="gap-2">
                        <span class="size-2 rounded-full bg-warning"></span>
                        <span class="text-sm">Away</span>
                      </.flex>
                    </DisplayMedia.table_cell>
                    <DisplayMedia.table_cell class="text-right">
                      <.button variant="ghost" size="sm">Edit</.button>
                    </DisplayMedia.table_cell>
                  </DisplayMedia.table_row>
                  <DisplayMedia.table_row>
                    <DisplayMedia.table_cell class="font-medium">
                      William Kim
                    </DisplayMedia.table_cell>
                    <DisplayMedia.table_cell>william@example.com</DisplayMedia.table_cell>
                    <DisplayMedia.table_cell>
                      <.badge variant="outline">Member</.badge>
                    </DisplayMedia.table_cell>
                    <DisplayMedia.table_cell>
                      <.flex justify="center" items="center" class="gap-2">
                        <span class="size-2 rounded-full bg-muted-foreground"></span>
                        <span class="text-sm">Offline</span>
                      </.flex>
                    </DisplayMedia.table_cell>
                    <DisplayMedia.table_cell class="text-right">
                      <.button variant="ghost" size="sm">Edit</.button>
                    </DisplayMedia.table_cell>
                  </DisplayMedia.table_row>
                </DisplayMedia.table_body>
              </DisplayMedia.table>
            </.card_content>
          </.card>
        </section>

        <%!-- Transaction History --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Transaction History Example</h2>
          <.card>
            <.card_header>
              <.card_title>Recent Transactions</.card_title>
              <.card_description>Your latest account activity.</.card_description>
            </.card_header>
            <.card_content>
              <DisplayMedia.table>
                <DisplayMedia.table_header>
                  <DisplayMedia.table_row>
                    <DisplayMedia.table_head>Date</DisplayMedia.table_head>
                    <DisplayMedia.table_head>Description</DisplayMedia.table_head>
                    <DisplayMedia.table_head>Type</DisplayMedia.table_head>
                    <DisplayMedia.table_head class="text-right">Amount</DisplayMedia.table_head>
                  </DisplayMedia.table_row>
                </DisplayMedia.table_header>
                <DisplayMedia.table_body>
                  <DisplayMedia.table_row>
                    <DisplayMedia.table_cell>2025-01-15</DisplayMedia.table_cell>
                    <DisplayMedia.table_cell>Payment received from client</DisplayMedia.table_cell>
                    <DisplayMedia.table_cell>
                      <.badge variant="outline" class="bg-success/10 text-success border-success/20">
                        Income
                      </.badge>
                    </DisplayMedia.table_cell>
                    <DisplayMedia.table_cell class="text-right text-success">
                      +$1,200.00
                    </DisplayMedia.table_cell>
                  </DisplayMedia.table_row>
                  <DisplayMedia.table_row>
                    <DisplayMedia.table_cell>2025-01-14</DisplayMedia.table_cell>
                    <DisplayMedia.table_cell>Office supplies purchase</DisplayMedia.table_cell>
                    <DisplayMedia.table_cell>
                      <.badge
                        variant="outline"
                        class="bg-destructive/10 text-destructive border-destructive/20"
                      >
                        Expense
                      </.badge>
                    </DisplayMedia.table_cell>
                    <DisplayMedia.table_cell class="text-right text-destructive">
                      -$85.00
                    </DisplayMedia.table_cell>
                  </DisplayMedia.table_row>
                  <DisplayMedia.table_row>
                    <DisplayMedia.table_cell>2025-01-12</DisplayMedia.table_cell>
                    <DisplayMedia.table_cell>Subscription renewal</DisplayMedia.table_cell>
                    <DisplayMedia.table_cell>
                      <.badge
                        variant="outline"
                        class="bg-destructive/10 text-destructive border-destructive/20"
                      >
                        Expense
                      </.badge>
                    </DisplayMedia.table_cell>
                    <DisplayMedia.table_cell class="text-right text-destructive">
                      -$29.99
                    </DisplayMedia.table_cell>
                  </DisplayMedia.table_row>
                  <DisplayMedia.table_row>
                    <DisplayMedia.table_cell>2025-01-10</DisplayMedia.table_cell>
                    <DisplayMedia.table_cell>Consulting services payment</DisplayMedia.table_cell>
                    <DisplayMedia.table_cell>
                      <.badge variant="outline" class="bg-success/10 text-success border-success/20">
                        Income
                      </.badge>
                    </DisplayMedia.table_cell>
                    <DisplayMedia.table_cell class="text-right text-success">
                      +$850.00
                    </DisplayMedia.table_cell>
                  </DisplayMedia.table_row>
                </DisplayMedia.table_body>
                <DisplayMedia.table_footer>
                  <DisplayMedia.table_row>
                    <DisplayMedia.table_cell colspan="3" class="font-medium">
                      Net Change
                    </DisplayMedia.table_cell>
                    <DisplayMedia.table_cell class="text-right font-medium text-success">
                      +$1,935.01
                    </DisplayMedia.table_cell>
                  </DisplayMedia.table_row>
                </DisplayMedia.table_footer>
              </DisplayMedia.table>
            </.card_content>
          </.card>
        </section>

        <%!-- Compact Table --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Compact Table</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Reduce padding for more compact tables in tight spaces.
          </p>
          <DisplayMedia.table class="text-xs">
            <DisplayMedia.table_header>
              <DisplayMedia.table_row>
                <DisplayMedia.table_head class="px-1 h-8">ID</DisplayMedia.table_head>
                <DisplayMedia.table_head class="px-1 h-8">Name</DisplayMedia.table_head>
                <DisplayMedia.table_head class="px-1 h-8">Status</DisplayMedia.table_head>
                <DisplayMedia.table_head class="px-1 h-8 text-right">Value</DisplayMedia.table_head>
              </DisplayMedia.table_row>
            </DisplayMedia.table_header>
            <DisplayMedia.table_body>
              <DisplayMedia.table_row>
                <DisplayMedia.table_cell class="p-1">001</DisplayMedia.table_cell>
                <DisplayMedia.table_cell class="p-1">Item A</DisplayMedia.table_cell>
                <DisplayMedia.table_cell class="p-1">
                  <.badge variant="outline" class="text-xs px-1 py-0">Active</.badge>
                </DisplayMedia.table_cell>
                <DisplayMedia.table_cell class="p-1 text-right">$50</DisplayMedia.table_cell>
              </DisplayMedia.table_row>
              <DisplayMedia.table_row>
                <DisplayMedia.table_cell class="p-1">002</DisplayMedia.table_cell>
                <DisplayMedia.table_cell class="p-1">Item B</DisplayMedia.table_cell>
                <DisplayMedia.table_cell class="p-1">
                  <.badge variant="outline" class="text-xs px-1 py-0">Active</.badge>
                </DisplayMedia.table_cell>
                <DisplayMedia.table_cell class="p-1 text-right">$75</DisplayMedia.table_cell>
              </DisplayMedia.table_row>
              <DisplayMedia.table_row>
                <DisplayMedia.table_cell class="p-1">003</DisplayMedia.table_cell>
                <DisplayMedia.table_cell class="p-1">Item C</DisplayMedia.table_cell>
                <DisplayMedia.table_cell class="p-1">
                  <.badge variant="outline" class="text-xs px-1 py-0">Inactive</.badge>
                </DisplayMedia.table_cell>
                <DisplayMedia.table_cell class="p-1 text-right">$25</DisplayMedia.table_cell>
              </DisplayMedia.table_row>
            </DisplayMedia.table_body>
          </DisplayMedia.table>
        </section>

        <%!-- Responsive Table --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Responsive Behavior</h2>
          <p class="text-sm text-muted-foreground mb-4">
            The table automatically scrolls horizontally on smaller screens. Try resizing your browser window.
          </p>
          <DisplayMedia.table>
            <DisplayMedia.table_header>
              <DisplayMedia.table_row>
                <DisplayMedia.table_head>Column 1</DisplayMedia.table_head>
                <DisplayMedia.table_head>Column 2</DisplayMedia.table_head>
                <DisplayMedia.table_head>Column 3</DisplayMedia.table_head>
                <DisplayMedia.table_head>Column 4</DisplayMedia.table_head>
                <DisplayMedia.table_head>Column 5</DisplayMedia.table_head>
                <DisplayMedia.table_head>Column 6</DisplayMedia.table_head>
                <DisplayMedia.table_head>Column 7</DisplayMedia.table_head>
                <DisplayMedia.table_head>Column 8</DisplayMedia.table_head>
              </DisplayMedia.table_row>
            </DisplayMedia.table_header>
            <DisplayMedia.table_body>
              <DisplayMedia.table_row>
                <DisplayMedia.table_cell>Data 1</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Data 2</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Data 3</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Data 4</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Data 5</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Data 6</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Data 7</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Data 8</DisplayMedia.table_cell>
              </DisplayMedia.table_row>
              <DisplayMedia.table_row>
                <DisplayMedia.table_cell>Data 1</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Data 2</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Data 3</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Data 4</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Data 5</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Data 6</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Data 7</DisplayMedia.table_cell>
                <DisplayMedia.table_cell>Data 8</DisplayMedia.table_cell>
              </DisplayMedia.table_row>
            </DisplayMedia.table_body>
          </DisplayMedia.table>
        </section>
      </.stack>
    </.container>
    """
  end
end
