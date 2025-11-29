/**
 * ToggleGroup Hook
 *
 * Manages client-side state for toggle groups when on_value_change is used.
 * Handles single and multiple selection modes.
 */
export const ToggleGroup = {
  mounted() {
    this.type = this.el.dataset.type || 'single'

    // Handle clicks on toggle group items
    this.handleClick = (e) => {
      const item = e.target.closest('[data-slot="toggle-group-item"]')
      if (!item || item.disabled) return

      const value = item.dataset.value
      if (!value) return

      // Get currently selected values
      const selectedItems = this.el.querySelectorAll('[data-slot="toggle-group-item"][data-state="on"]')
      let selectedValues = Array.from(selectedItems).map(el => el.dataset.value)

      if (this.type === 'single') {
        // Single selection: toggle between this value and empty
        selectedValues = selectedValues.includes(value) ? [] : [value]
      } else {
        // Multiple selection: toggle this value in/out of the list
        if (selectedValues.includes(value)) {
          selectedValues = selectedValues.filter(v => v !== value)
        } else {
          selectedValues.push(value)
        }
      }

      // Update visual state
      this.updateState(selectedValues)
    }

    this.el.addEventListener('click', this.handleClick)
  },

  updateState(selectedValues) {
    const items = this.el.querySelectorAll('[data-slot="toggle-group-item"]')
    items.forEach(item => {
      const isSelected = selectedValues.includes(item.dataset.value)
      item.dataset.state = isSelected ? 'on' : 'off'
      item.setAttribute('aria-pressed', isSelected)
    })
  },

  destroyed() {
    if (this.handleClick) {
      this.el.removeEventListener('click', this.handleClick)
    }
  }
}
