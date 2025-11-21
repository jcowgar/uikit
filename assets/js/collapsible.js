/**
 * Collapsible Hook - Manages collapsible state with localStorage persistence
 *
 * Features:
 * - Persists state to localStorage per collapsible ID
 * - Restores state on mount
 * - Syncs state via DOM data attributes and CSS classes
 */

const STORAGE_PREFIX = "decree-collapsible-"

export const CollapsibleHook = {
  mounted() {
    // Get the collapsible ID from the element
    this.collapsibleId = this.el.id
    if (!this.collapsibleId) {
      console.warn("Collapsible element missing ID, cannot persist state")
      return
    }

    // Initialize state from storage or default
    this.initializeState()

    // Bind the handlers to this instance
    this.handleClickTrigger = this.handleClickTrigger.bind(this)
    this.handleKeyDown = this.handleKeyDown.bind(this)

    // Use event delegation to catch clicks on triggers within this collapsible
    this.el.addEventListener("click", this.handleClickTrigger)

    // Add keyboard support for trigger button
    this.el.addEventListener("keydown", this.handleKeyDown)
  },

  updated() {
    // When LiveView updates the DOM, restore the state from our current runtime state
    // This prevents the collapsible from resetting when LiveView re-renders
    if (this.currentState !== undefined) {
      this.setState(this.currentState, false)
    }
  },

  initializeState() {
    // Get the initial open state from the element's data attribute
    const defaultOpen = this.el.dataset.defaultOpen === "true"

    // Check localStorage for saved state
    const storageKey = STORAGE_PREFIX + this.collapsibleId
    const savedState = localStorage.getItem(storageKey)

    // Determine the initial state: saved state > default open
    const isOpen = savedState !== null ? savedState === "true" : defaultOpen

    // Store current state for restoration after LiveView updates
    this.currentState = isOpen

    // Apply the initial state
    this.setState(isOpen, false) // false = don't save to localStorage on mount
  },

  handleClickTrigger(e) {
    // Only toggle if the click is on the trigger itself
    // First check if we clicked on the trigger
    const trigger = e.target.closest('[data-slot="collapsible-trigger"]')
    const content = e.target.closest('[data-slot="collapsible-content"]')

    console.log('[Collapsible] Click detected:', {
      targetElement: e.target,
      clickedOnTrigger: !!trigger,
      clickedInContent: !!content,
      collapsibleId: this.collapsibleId
    })

    // If we clicked on the trigger, toggle
    if (trigger && this.el.contains(trigger)) {
      console.log('[Collapsible] Toggling because trigger was clicked')
      e.preventDefault()
      this.toggle()
      return
    }

    // If we clicked inside the content area, don't toggle
    // (this prevents clicks on edit buttons, inputs, etc from toggling)
    if (content && this.el.contains(content)) {
      console.log('[Collapsible] Ignoring click inside content area')
      // Click is inside content, do nothing
      return
    }
  },

  handleKeyDown(e) {
    const trigger = e.target.closest('[data-slot="collapsible-trigger"]')

    // Only handle keyboard events on the trigger button
    if (!trigger || !this.el.contains(trigger)) {
      return
    }

    // Toggle on Enter or Space key
    if (e.key === 'Enter' || e.key === ' ') {
      e.preventDefault()
      this.toggle()
    }
  },

  toggle() {
    const contentEl = this.el.querySelector('[data-slot="collapsible-content"]')
    if (!contentEl) return

    // Determine current state by checking if content is open
    const isCurrentlyOpen = contentEl.classList.contains("grid-rows-[1fr]")
    const newState = !isCurrentlyOpen

    this.setState(newState, true) // true = save to localStorage
  },

  setState(isOpen, persist = true) {
    const contentEl = this.el.querySelector('[data-slot="collapsible-content"]')
    const triggerEl = this.el.querySelector('[data-slot="collapsible-trigger"]')
    const iconEl = this.el.querySelector('[data-collapsible-icon]')

    if (!contentEl) return

    // Store the current state for restoration after LiveView updates
    this.currentState = isOpen

    // Update ARIA attributes for accessibility
    if (triggerEl) {
      triggerEl.setAttribute('aria-expanded', isOpen.toString())
      // Also set data-state for CSS styling
      triggerEl.setAttribute('data-state', isOpen ? 'open' : 'closed')
    }

    if (isOpen) {
      // Open state
      contentEl.classList.remove("grid-rows-[0fr]", "opacity-0")
      contentEl.classList.add("grid-rows-[1fr]", "opacity-100")
      if (iconEl) {
        iconEl.classList.add("rotate-180")
      }
    } else {
      // Closed state
      contentEl.classList.remove("grid-rows-[1fr]", "opacity-100")
      contentEl.classList.add("grid-rows-[0fr]", "opacity-0")
      if (iconEl) {
        iconEl.classList.remove("rotate-180")
      }
    }

    // Persist to localStorage if requested
    if (persist && this.collapsibleId) {
      const storageKey = STORAGE_PREFIX + this.collapsibleId
      localStorage.setItem(storageKey, isOpen.toString())
    }
  },

  destroyed() {
    if (this.el) {
      this.el.removeEventListener("click", this.handleClickTrigger)
      this.el.removeEventListener("keydown", this.handleKeyDown)
    }
  }
}
