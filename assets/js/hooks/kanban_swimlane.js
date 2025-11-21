/**
 * KanbanSwimlane Hook - Client-side collapse/expand for swimlanes
 *
 * Features:
 * - Handles collapse/expand purely on the client (no server roundtrip)
 * - Persists state to localStorage per swimlane ID
 * - Falls back to server event if developer wants server-side state management
 */

const STORAGE_PREFIX = "decree-kanban-swimlane-"

export const KanbanSwimlaneHook = {
  mounted() {
    this.swimlaneId = this.el.id
    if (!this.swimlaneId) {
      console.warn("KanbanSwimlane element missing ID, cannot persist state")
      return
    }

    // Check if developer wants server-side handling
    this.useServerState = this.el.dataset.serverCollapse === "true"

    // Initialize state from localStorage (unless using server state)
    if (!this.useServerState) {
      this.initializeState()
    }

    // Bind handlers
    this.handleToggleClick = this.handleToggleClick.bind(this)

    // Find the toggle button and attach handler
    const toggleBtn = this.el.querySelector('[data-swimlane-toggle]')
    if (toggleBtn) {
      toggleBtn.addEventListener('click', this.handleToggleClick)
      this.toggleBtn = toggleBtn
    }
  },

  updated() {
    // When LiveView updates, restore client state (unless using server state)
    // Use requestAnimationFrame to ensure LiveView's DOM updates are complete
    if (!this.useServerState && this.currentState !== undefined) {
      requestAnimationFrame(() => {
        this.setState(this.currentState, false)
      })
    }
  },

  initializeState() {
    // Check localStorage for saved state
    const storageKey = STORAGE_PREFIX + this.swimlaneId
    const savedState = localStorage.getItem(storageKey)

    // Default to expanded (false = not collapsed)
    const isCollapsed = savedState === "true"

    // Store current state
    this.currentState = isCollapsed

    // Apply the initial state
    this.setState(isCollapsed, false) // Don't save on mount
  },

  handleToggleClick(e) {
    if (this.useServerState) {
      // Let the server handle it via phx-click
      return
    }

    // Handle client-side
    e.preventDefault()
    e.stopPropagation()

    const newState = !this.currentState
    this.setState(newState, true) // Save to localStorage
  },

  setState(isCollapsed, persist = true) {
    const contentEl = this.el.querySelector('[data-swimlane-content]')
    const iconEl = this.el.querySelector('[data-swimlane-icon]')

    if (!contentEl) {
      return
    }

    // Store current state
    this.currentState = isCollapsed

    // Update content visibility
    // Need to remove flex when hiding to prevent CSS specificity conflicts
    if (isCollapsed) {
      contentEl.classList.remove('flex')
      contentEl.classList.add('hidden')
    } else {
      contentEl.classList.remove('hidden')
      contentEl.classList.add('flex')
    }

    // Update icon rotation
    if (iconEl) {
      if (isCollapsed) {
        // Point right when collapsed
        iconEl.style.transform = 'rotate(-90deg)'
      } else {
        // Point down when expanded
        iconEl.style.transform = 'rotate(0deg)'
      }
    }

    // Update aria-expanded
    if (this.toggleBtn) {
      this.toggleBtn.setAttribute('aria-expanded', (!isCollapsed).toString())
    }

    // Persist to localStorage
    if (persist && this.swimlaneId) {
      const storageKey = STORAGE_PREFIX + this.swimlaneId
      localStorage.setItem(storageKey, isCollapsed.toString())
    }
  },

  destroyed() {
    if (this.toggleBtn) {
      this.toggleBtn.removeEventListener('click', this.handleToggleClick)
    }
  }
}
