import {
  Chart,
  CategoryScale,
  LinearScale,
  BarController,
  LineController,
  PieController,
  DoughnutController,
  RadarController,
  PolarAreaController,
  BarElement,
  LineElement,
  PointElement,
  ArcElement,
  RadialLinearScale,
  Tooltip,
  Legend,
  Title,
  Filler
} from 'chart.js'

// Register Chart.js components
Chart.register(
  CategoryScale,
  LinearScale,
  BarController,
  LineController,
  PieController,
  DoughnutController,
  RadarController,
  PolarAreaController,
  BarElement,
  LineElement,
  PointElement,
  ArcElement,
  RadialLinearScale,
  Tooltip,
  Legend,
  Title,
  Filler
)

/**
 * Chart.js hook for Phoenix LiveView
 *
 * Usage:
 * <canvas id="my-chart" phx-hook="Chart" phx-update="ignore" data-chart-config={@chart_config}></canvas>
 *
 * The chart_config should be a JSON-encoded Chart.js configuration object.
 * Example configuration in LiveView:
 *
 * config = %{
 *   type: "bar",
 *   data: %{
 *     labels: ["Jan", "Feb", "Mar"],
 *     datasets: [%{
 *       label: "Sales",
 *       data: [12, 19, 3],
 *       backgroundColor: "rgb(59, 130, 246)"
 *     }]
 *   },
 *   options: %{
 *     responsive: true,
 *     maintainAspectRatio: false
 *   }
 * }
 *
 * assign(socket, chart_config: Jason.encode!(config))
 */
export const ChartHook = {
  mounted() {
    this.initChart()

    // Listen for chart update events from the server
    this.handleEvent('chart-update', (payload) => {
      this.updateChart(payload)
    })
  },

  updated() {
    // When the component updates, check if config has changed
    const newConfig = this.getConfig()
    if (newConfig && JSON.stringify(newConfig) !== JSON.stringify(this.currentConfig)) {
      this.updateChart(newConfig)
    }
  },

  destroyed() {
    // Clean up chart instance
    if (this.chart) {
      this.chart.destroy()
      this.chart = null
    }
  },

  initChart() {
    const config = this.getConfig()
    if (!config) {
      console.error('Chart hook: No chart configuration found')
      return
    }

    this.currentConfig = config

    // Get the canvas context
    const ctx = this.el.getContext('2d')

    // Apply theme colors if not explicitly set
    const themedConfig = this.applyThemeColors(config)

    // Create the chart
    this.chart = new Chart(ctx, themedConfig)
  },

  updateChart(newConfig) {
    if (!this.chart) {
      this.initChart()
      return
    }

    this.currentConfig = newConfig

    // Apply theme colors
    const themedConfig = this.applyThemeColors(newConfig)

    // Update chart data and options
    this.chart.data = themedConfig.data
    this.chart.options = themedConfig.options || {}
    this.chart.update()
  },

  getConfig() {
    const configAttr = this.el.dataset.chartConfig
    if (!configAttr) return null

    try {
      return JSON.parse(configAttr)
    } catch (e) {
      console.error('Chart hook: Failed to parse chart configuration', e)
      return null
    }
  },

  applyThemeColors(config) {
    // Clone the config to avoid mutating the original
    const themedConfig = JSON.parse(JSON.stringify(config))

    // Detect current theme
    const isDark = document.documentElement.getAttribute('data-theme') === 'dark'

    // Get CSS custom properties for theme colors
    const root = getComputedStyle(document.documentElement)

    // Helper to convert HSL to RGB for Chart.js
    const hslToRgb = (h, s, l) => {
      s /= 100
      l /= 100
      const k = n => (n + h / 30) % 12
      const a = s * Math.min(l, 1 - l)
      const f = n => l - a * Math.max(-1, Math.min(k(n) - 3, Math.min(9 - k(n), 1)))
      return [255 * f(0), 255 * f(8), 255 * f(4)].map(Math.round)
    }

    // Get theme colors
    const getThemeColor = (varName, alpha = 1) => {
      const hslValue = root.getPropertyValue(varName).trim()
      const matches = hslValue.match(/(\d+\.?\d*)\s+(\d+\.?\d*)%\s+(\d+\.?\d*)%/)
      if (matches) {
        const [_, h, s, l] = matches
        const [r, g, b] = hslToRgb(parseFloat(h), parseFloat(s), parseFloat(l))
        return alpha < 1 ? `rgba(${r}, ${g}, ${b}, ${alpha})` : `rgb(${r}, ${g}, ${b})`
      }
      return isDark ? 'rgba(255, 255, 255, 0.8)' : 'rgba(0, 0, 0, 0.8)'
    }

    // Apply default theme colors if not set
    if (!themedConfig.options) {
      themedConfig.options = {}
    }

    // Set default font color based on theme
    if (!themedConfig.options.plugins) {
      themedConfig.options.plugins = {}
    }

    // Apply legend colors
    if (!themedConfig.options.plugins.legend) {
      themedConfig.options.plugins.legend = {}
    }
    if (!themedConfig.options.plugins.legend.labels) {
      themedConfig.options.plugins.legend.labels = {}
    }
    if (!themedConfig.options.plugins.legend.labels.color) {
      themedConfig.options.plugins.legend.labels.color = getThemeColor('--foreground')
    }

    // Apply tooltip colors
    if (!themedConfig.options.plugins.tooltip) {
      themedConfig.options.plugins.tooltip = {}
    }
    if (!themedConfig.options.plugins.tooltip.backgroundColor) {
      // Use high-contrast tooltip backgrounds
      themedConfig.options.plugins.tooltip.backgroundColor = isDark
        ? 'rgba(255, 255, 255, 0.95)'
        : 'rgba(0, 0, 0, 0.9)'
    }
    if (!themedConfig.options.plugins.tooltip.titleColor) {
      // Invert text color for contrast
      themedConfig.options.plugins.tooltip.titleColor = isDark
        ? 'rgb(0, 0, 0)'
        : 'rgb(255, 255, 255)'
    }
    if (!themedConfig.options.plugins.tooltip.bodyColor) {
      themedConfig.options.plugins.tooltip.bodyColor = isDark
        ? 'rgba(0, 0, 0, 0.8)'
        : 'rgba(255, 255, 255, 0.9)'
    }
    if (!themedConfig.options.plugins.tooltip.borderColor) {
      themedConfig.options.plugins.tooltip.borderColor = isDark
        ? 'rgba(0, 0, 0, 0.2)'
        : 'rgba(255, 255, 255, 0.2)'
    }
    if (!themedConfig.options.plugins.tooltip.borderWidth) {
      themedConfig.options.plugins.tooltip.borderWidth = 1
    }

    // Apply scale colors
    if (themedConfig.options.scales) {
      Object.keys(themedConfig.options.scales).forEach(scaleKey => {
        const scale = themedConfig.options.scales[scaleKey]

        if (!scale.ticks) scale.ticks = {}
        if (!scale.ticks.color) {
          scale.ticks.color = getThemeColor('--muted-foreground')
        }

        if (!scale.grid) scale.grid = {}
        if (!scale.grid.color) {
          scale.grid.color = getThemeColor('--border', 0.2)
        }

        if (!scale.title) scale.title = {}
        if (!scale.title.color) {
          scale.title.color = getThemeColor('--foreground')
        }
      })
    }

    return themedConfig
  }
}
