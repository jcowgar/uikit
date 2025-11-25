/**
 * Slider Hook
 *
 * Updates the value display of a basic slider in real-time as the user drags.
 * Looks for value display both inside the slider container and in associated
 * elements using data-slider-value attribute.
 */
export const Slider = {
  mounted() {
    this.updateValue()
    this.el.addEventListener('input', () => this.updateValue())
  },

  updated() {
    this.updateValue()
  },

  updateValue() {
    const value = parseFloat(this.el.value)
    const sliderId = this.el.id

    // Update value display inside the slider container
    const container = this.el.closest('[data-slot="slider"]')
    if (container) {
      const valueDisplay = container.querySelector('.tabular-nums')
      if (valueDisplay) {
        valueDisplay.textContent = Math.round(value)
      }
    }

    // Also update any external value displays linked to this slider
    const externalDisplays = document.querySelectorAll(`[data-slider-value="${sliderId}"]`)
    externalDisplays.forEach(display => {
      const prefix = display.dataset.sliderPrefix || ''
      const suffix = display.dataset.sliderSuffix || ''
      display.textContent = `${prefix}${Math.round(value)}${suffix}`
    })
  }
}

/**
 * SliderFilled Hook
 *
 * Updates the filled track of a slider in real-time as the user drags the thumb.
 * This provides visual feedback without requiring server round-trips.
 */
export const SliderFilled = {
  mounted() {
    this.updateFill()
    this.el.addEventListener('input', () => this.updateFill())
  },

  updated() {
    this.updateFill()
  },

  updateFill() {
    const value = parseFloat(this.el.value)
    const min = parseFloat(this.el.min) || 0
    const max = parseFloat(this.el.max) || 100
    const range = max - min
    const percent = range > 0 ? ((value - min) / range) * 100 : 0

    // Find the fill element (sibling of input within the track container)
    const container = this.el.closest('[data-slot="slider"]')
    if (!container) return

    const fillEl = container.querySelector('.bg-primary')
    if (fillEl) {
      const orientation = this.el.dataset.orientation || 'horizontal'
      if (orientation === 'horizontal') {
        fillEl.style.width = `${percent}%`
      } else {
        fillEl.style.height = `${percent}%`
      }
    }

    // Also update the displayed value if show_value is enabled
    const valueDisplay = container.querySelector('.tabular-nums')
    if (valueDisplay) {
      valueDisplay.textContent = Math.round(value)
    }
  }
}
