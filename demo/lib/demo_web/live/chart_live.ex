defmodule DemoWeb.Ui.ChartLive do
  @moduledoc false
  use DemoWeb, :live_view

  alias Phoenix.LiveView.Socket

  @impl true
  @spec mount(map(), map(), Socket.t()) :: {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    socket = assign_chart_configs(socket)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    
      <.container>
        <.stack size="large">
          <div>
            <h1 class="text-3xl font-bold text-foreground">Chart</h1>
            <p class="text-muted-foreground mt-2">
              Interactive charts powered by Chart.js with automatic theme support.
            </p>
          </div>

          <%!-- Bar Chart --%>
          <section class="space-y-4">
            <div>
              <h2 class="text-2xl font-semibold text-foreground">Bar Chart</h2>
              <p class="text-muted-foreground">
                Display data using vertical bars. Great for comparing values across categories.
              </p>
            </div>

            <.card>
              <.card_header>
                <.card_title>Monthly Sales</.card_title>
                <.card_description>Sales data for the first half of 2024</.card_description>
              </.card_header>
              <.card_content>
                <.chart id="bar-chart" class="h-[350px]" config={@bar_chart_config} />
              </.card_content>
            </.card>
          </section>

          <%!-- Line Chart --%>
          <section class="space-y-4">
            <div>
              <h2 class="text-2xl font-semibold text-foreground">Line Chart</h2>
              <p class="text-muted-foreground">
                Show trends over time with smooth lines connecting data points.
              </p>
            </div>

            <.card>
              <.card_header>
                <.card_title>Revenue vs Expenses</.card_title>
                <.card_description>Financial overview for Q1 2024</.card_description>
              </.card_header>
              <.card_content>
                <.chart id="line-chart" class="h-[350px]" config={@line_chart_config} />
              </.card_content>
            </.card>
          </section>

          <%!-- Pie Chart --%>
          <section class="space-y-4">
            <div>
              <h2 class="text-2xl font-semibold text-foreground">Pie Chart</h2>
              <p class="text-muted-foreground">
                Visualize proportions and percentages as segments of a circle.
              </p>
            </div>

            <.card>
              <.card_header>
                <.card_title>Market Share</.card_title>
                <.card_description>Product distribution by category</.card_description>
              </.card_header>
              <.card_content>
                <.chart id="pie-chart" class="h-[350px]" config={@pie_chart_config} />
              </.card_content>
            </.card>
          </section>

          <%!-- Doughnut Chart --%>
          <section class="space-y-4">
            <div>
              <h2 class="text-2xl font-semibold text-foreground">Doughnut Chart</h2>
              <p class="text-muted-foreground">
                Similar to pie charts but with a hollow center, offering more visual appeal.
              </p>
            </div>

            <.card>
              <.card_header>
                <.card_title>Browser Usage</.card_title>
                <.card_description>Visitor browser statistics</.card_description>
              </.card_header>
              <.card_content>
                <.chart id="doughnut-chart" class="h-[350px]" config={@doughnut_chart_config} />
              </.card_content>
            </.card>
          </section>

          <%!-- Interactive Example --%>
          <section class="space-y-4">
            <div>
              <h2 class="text-2xl font-semibold text-foreground">Interactive Chart</h2>
              <p class="text-muted-foreground">
                Charts can be updated dynamically from your LiveView.
              </p>
            </div>

            <.card>
              <.card_header>
                <.card_title>Real-time Data</.card_title>
                <.card_description>
                  Click the button to refresh the chart with new data
                </.card_description>
              </.card_header>
              <.card_content>
                <.chart id="interactive-chart" class="h-[350px]" config={@interactive_chart_config} />
                <div class="mt-4">
                  <.button phx-click="refresh_chart">
                    <.icon name="hero-arrow-path" class="w-4 h-4 mr-2" /> Refresh Data
                  </.button>
                </div>
              </.card_content>
            </.card>
          </section>

          <%!-- Code Example --%>
          <section class="space-y-4">
            <div>
              <h2 class="text-2xl font-semibold text-foreground">Usage</h2>
              <p class="text-muted-foreground">
                How to use the chart component in your LiveView.
              </p>
            </div>

            <.card>
              <.card_content>
                <pre class="text-sm p-4 bg-muted rounded-lg overflow-x-auto" phx-no-format><code phx-no-curly-interpolation># In your LiveView module
    def mount(_params, _session, socket) do
    chart_config = %{
    type: "bar",
    data: %{
      labels: ["Jan", "Feb", "Mar", "Apr", "May"],
      datasets: [%{
        label: "Sales",
        data: [12, 19, 3, 5, 2],
        backgroundColor: "rgb(59, 130, 246)"
      }]
    },
    options: %{
      responsive: true,
      maintainAspectRatio: false
    }
    }

    {:ok, assign(socket, chart_config: chart_config)}
    end

    # In your template
    &lt;.chart id="my-chart" class="h-[400px]" config={@chart_config} />

    # To update the chart
    def handle_event("refresh", _params, socket) do
    new_config = %{...}
    {:noreply, assign(socket, chart_config: new_config)}
    end</code></pre>
              </.card_content>
            </.card>
          </section>
        </.stack>
      </.container>
    
    """
  end

  @impl true
  @spec handle_event(String.t(), map(), Socket.t()) :: {:noreply, Socket.t()}
  def handle_event("refresh_chart", _params, socket) do
    # Generate random data
    data = Enum.map(1..6, fn _index -> :rand.uniform(50) end)

    new_config = %{
      type: "bar",
      data: %{
        labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
        datasets: [
          %{
            label: "Updated Sales",
            data: data,
            backgroundColor: "rgb(34, 197, 94)"
          }
        ]
      },
      options: %{
        responsive: true,
        maintainAspectRatio: false,
        plugins: %{
          legend: %{
            display: true
          }
        },
        scales: %{
          y: %{
            beginAtZero: true
          }
        }
      }
    }

    {:noreply, assign(socket, :interactive_chart_config, new_config)}
  end

  @spec assign_chart_configs(Socket.t()) :: Socket.t()
  defp assign_chart_configs(socket) do
    socket
    |> assign(:bar_chart_config, bar_chart_config())
    |> assign(:line_chart_config, line_chart_config())
    |> assign(:pie_chart_config, pie_chart_config())
    |> assign(:doughnut_chart_config, doughnut_chart_config())
    |> assign(:interactive_chart_config, interactive_chart_config())
  end

  @spec bar_chart_config() :: map()
  defp bar_chart_config do
    %{
      type: "bar",
      data: %{
        labels: ["January", "February", "March", "April", "May", "June"],
        datasets: [
          %{
            label: "Sales",
            data: [12, 19, 3, 5, 2, 3],
            backgroundColor: "rgb(59, 130, 246)"
          }
        ]
      },
      options: %{
        responsive: true,
        maintainAspectRatio: false,
        plugins: %{
          legend: %{
            display: true
          }
        },
        scales: %{
          y: %{
            beginAtZero: true
          }
        }
      }
    }
  end

  @spec line_chart_config() :: map()
  defp line_chart_config do
    %{
      type: "line",
      data: %{
        labels: ["January", "February", "March", "April", "May", "June"],
        datasets: [
          %{
            label: "Revenue",
            data: [30, 45, 38, 50, 48, 60],
            borderColor: "rgb(34, 197, 94)",
            backgroundColor: "rgba(34, 197, 94, 0.1)",
            tension: 0.4,
            fill: true
          },
          %{
            label: "Expenses",
            data: [20, 25, 22, 30, 28, 35],
            borderColor: "rgb(239, 68, 68)",
            backgroundColor: "rgba(239, 68, 68, 0.1)",
            tension: 0.4,
            fill: true
          }
        ]
      },
      options: %{
        responsive: true,
        maintainAspectRatio: false,
        plugins: %{
          legend: %{
            display: true
          }
        },
        scales: %{
          y: %{
            beginAtZero: true
          }
        }
      }
    }
  end

  @spec pie_chart_config() :: map()
  defp pie_chart_config do
    %{
      type: "pie",
      data: %{
        labels: ["Electronics", "Clothing", "Food", "Books", "Other"],
        datasets: [
          %{
            data: [300, 150, 200, 100, 50],
            backgroundColor: [
              "rgb(59, 130, 246)",
              "rgb(34, 197, 94)",
              "rgb(234, 179, 8)",
              "rgb(168, 85, 247)",
              "rgb(239, 68, 68)"
            ]
          }
        ]
      },
      options: %{
        responsive: true,
        maintainAspectRatio: false,
        plugins: %{
          legend: %{
            display: true,
            position: "bottom"
          }
        }
      }
    }
  end

  @spec doughnut_chart_config() :: map()
  defp doughnut_chart_config do
    %{
      type: "doughnut",
      data: %{
        labels: ["Chrome", "Firefox", "Safari", "Edge", "Other"],
        datasets: [
          %{
            data: [45, 25, 15, 10, 5],
            backgroundColor: [
              "rgb(59, 130, 246)",
              "rgb(239, 68, 68)",
              "rgb(34, 197, 94)",
              "rgb(168, 85, 247)",
              "rgb(156, 163, 175)"
            ]
          }
        ]
      },
      options: %{
        responsive: true,
        maintainAspectRatio: false,
        plugins: %{
          legend: %{
            display: true,
            position: "bottom"
          }
        }
      }
    }
  end

  @spec interactive_chart_config() :: map()
  defp interactive_chart_config do
    %{
      type: "bar",
      data: %{
        labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
        datasets: [
          %{
            label: "Initial Sales",
            data: [10, 20, 15, 25, 22, 30],
            backgroundColor: "rgb(59, 130, 246)"
          }
        ]
      },
      options: %{
        responsive: true,
        maintainAspectRatio: false,
        plugins: %{
          legend: %{
            display: true
          }
        },
        scales: %{
          y: %{
            beginAtZero: true
          }
        }
      }
    }
  end
end
