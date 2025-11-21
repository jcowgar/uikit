/**
 * Tabs Hook
 *
 * Manages tab state and interactions for the Tabs component.
 * Handles both client-side tab switching and LiveView controlled tabs.
 *
 * Features:
 * - Client-side state management with default value
 * - Keyboard navigation (Arrow keys)
 * - Active state synchronization
 * - LiveView integration via phx-change events
 */

export const TabsHook = {
  mounted() {
    this.activeTab = this.el.dataset.value || this.el.dataset.defaultValue

    // Initialize tabs on mount
    this.updateTabStates()

    // Listen for clicks on tab triggers
    this.handleClick = (e) => {
      const trigger = e.target.closest('[data-slot="tabs-trigger"]')
      if (!trigger) return

      const newValue = trigger.dataset.value
      if (newValue && newValue !== this.activeTab && !trigger.disabled) {
        this.activeTab = newValue
        this.updateTabStates()

        // If there's a phx-change handler, push event to LiveView
        const phxChange = this.el.getAttribute('phx-change')
        if (phxChange) {
          this.pushEvent(phxChange, { value: newValue })
        }
      }
    }

    // Listen for keyboard navigation
    this.handleKeyDown = (e) => {
      // Only handle keyboard navigation when focus is on a tab trigger
      // This prevents interference with form inputs (textarea, input, etc.)
      const isOnTrigger = e.target.closest('[data-slot="tabs-trigger"]')
      if (!isOnTrigger) return

      const triggers = this.getTriggers()
      const currentIndex = triggers.findIndex(t => t.dataset.value === this.activeTab)

      let newIndex = currentIndex

      if (e.key === 'ArrowRight' || e.key === 'ArrowDown') {
        e.preventDefault()
        newIndex = (currentIndex + 1) % triggers.length
      } else if (e.key === 'ArrowLeft' || e.key === 'ArrowUp') {
        e.preventDefault()
        newIndex = currentIndex - 1
        if (newIndex < 0) newIndex = triggers.length - 1
      } else if (e.key === 'Home') {
        e.preventDefault()
        newIndex = 0
      } else if (e.key === 'End') {
        e.preventDefault()
        newIndex = triggers.length - 1
      }

      if (newIndex !== currentIndex && triggers[newIndex]) {
        const newValue = triggers[newIndex].dataset.value
        this.activeTab = newValue
        this.updateTabStates()
        triggers[newIndex].focus()

        // Notify LiveView if applicable
        const phxChange = this.el.getAttribute('phx-change')
        if (phxChange) {
          this.pushEvent(phxChange, { value: newValue })
        }
      }
    }

    this.el.addEventListener('click', this.handleClick)
    this.el.addEventListener('keydown', this.handleKeyDown)
  },

  updated() {
    // Sync state if LiveView updates the value
    const newValue = this.el.dataset.value
    if (newValue && newValue !== this.activeTab) {
      this.activeTab = newValue
      this.updateTabStates()
    }
  },

  destroyed() {
    this.el.removeEventListener('click', this.handleClick)
    this.el.removeEventListener('keydown', this.handleKeyDown)
  },

  getTriggers() {
    return Array.from(this.el.querySelectorAll('[data-slot="tabs-trigger"]'))
  },

  getContents() {
    return Array.from(this.el.querySelectorAll('[data-slot="tabs-content"]'))
  },

  updateTabStates() {
    const triggers = this.getTriggers()
    const contents = this.getContents()

    // Update trigger states
    triggers.forEach(trigger => {
      const value = trigger.dataset.value
      const isActive = value === this.activeTab

      trigger.dataset.state = isActive ? 'active' : 'inactive'
      trigger.setAttribute('aria-selected', isActive)
      trigger.setAttribute('tabindex', isActive ? '0' : '-1')
    })

    // Update content visibility
    contents.forEach(content => {
      const value = content.dataset.value
      const isActive = value === this.activeTab

      content.dataset.state = isActive ? 'active' : 'inactive'

      if (isActive) {
        content.classList.remove('hidden')
      } else {
        content.classList.add('hidden')
      }
    })
  }
}
