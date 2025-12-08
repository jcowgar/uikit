/**
 * ToggleGroup Hook
 *
 * Manages toggle groups with server-side state.
 * Handles single and multiple selection modes.
 * Pushes events to the server when values change.
 * Server controls the selected state - client only sends events.
 */
export const ToggleGroup = {
  mounted() {
    this.type = this.el.dataset.type || 'single'
    this.eventName = this.el.dataset.onValueChange

    // Handle clicks on toggle group items
    this.handleClick = (e) => {
      const item = e.target.closest('[data-slot="toggle-group-item"]')
      if (!item || item.disabled) return

      const value = item.dataset.value
      if (!value) return

      // For single type, don't do anything if already selected
      if (this.type === 'single' && item.dataset.state === 'on') {
        return
      }

      // Push event to server - let server control the state
      if (this.eventName) {
        const payload = this.type === 'single'
          ? { value: value }
          : { value: value, current_state: item.dataset.state }
        this.pushEvent(this.eventName, payload)
      }
    }

    this.el.addEventListener('click', this.handleClick)
  },

  destroyed() {
    if (this.handleClick) {
      this.el.removeEventListener('click', this.handleClick)
    }
  }
}
