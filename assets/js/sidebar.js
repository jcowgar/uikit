/**
 * Sidebar Hook - Manages sidebar state (collapsed/expanded)
 *
 * Features:
 * - Persists state to localStorage
 * - Keyboard shortcut (Cmd/Ctrl+B) to toggle
 * - Syncs state across the DOM via data attributes
 * - Mobile detection and handling
 */

const SIDEBAR_COOKIE_NAME = "sidebar_state"
const SIDEBAR_KEYBOARD_SHORTCUT = "b"

export const SidebarHook = {
  mounted() {
    this.isMobile = this.detectMobile()
    this.state = this.getInitialState()
    this.openMobile = false

    // Store the collapsible mode from app_sidebar component
    const sidebar = this.el.querySelector('[data-slot="sidebar"]')
    if (sidebar) {
      // The collapsible mode is passed via the sidebar component (icon, offcanvas, none)
      // We need to read it from the app_sidebar.ex which sets collapsible="icon"
      this.collapsibleMode = "icon" // This should match app_sidebar.ex line 52
    }

    // Set initial state on the element
    this.updateState()

    // Listen for toggle events from trigger buttons (window event)
    this.handleToggle = () => {
      this.toggle()
    }
    window.addEventListener("sidebar:toggle", this.handleToggle)

    // Keyboard shortcut listener
    this.handleKeyDown = (event) => {
      if (
        event.key === SIDEBAR_KEYBOARD_SHORTCUT &&
        (event.metaKey || event.ctrlKey)
      ) {
        event.preventDefault()
        this.toggle()
      }
    }
    window.addEventListener("keydown", this.handleKeyDown)

    // Mobile detection on resize
    this.handleResize = () => {
      const wasMobile = this.isMobile
      this.isMobile = this.detectMobile()
      if (wasMobile !== this.isMobile) {
        this.updateState()
      }
    }
    window.addEventListener("resize", this.handleResize)
  },

  destroyed() {
    window.removeEventListener("sidebar:toggle", this.handleToggle)
    window.removeEventListener("keydown", this.handleKeyDown)
    window.removeEventListener("resize", this.handleResize)
  },

  /**
   * Get initial state from localStorage or default to expanded
   */
  getInitialState() {
    const stored = localStorage.getItem(SIDEBAR_COOKIE_NAME)
    return stored === "false" ? false : true // default to expanded (true)
  },

  /**
   * Detect if we're on mobile (< 768px)
   */
  detectMobile() {
    return window.innerWidth < 768
  },

  /**
   * Toggle the sidebar state
   */
  toggle() {
    if (this.isMobile) {
      this.openMobile = !this.openMobile
      this.updateState()
    } else {
      this.state = !this.state
      // Persist to localStorage
      localStorage.setItem(SIDEBAR_COOKIE_NAME, this.state.toString())
      this.updateState()
    }
  },

  /**
   * Update DOM to reflect current state
   */
  updateState() {
    const stateStr = this.state ? "expanded" : "collapsed"
    this.el.dataset.state = stateStr
    this.el.dataset.mobile = this.isMobile.toString()
    this.el.dataset.openMobile = this.openMobile.toString()

    // Update the sidebar element (the one with class "group")
    // CRITICAL: Match shadcn reference - only set data-collapsible when collapsed!
    const sidebar = this.el.querySelector('[data-slot="sidebar"]')
    if (sidebar) {
      sidebar.dataset.state = stateStr
      // Only set data-collapsible to the mode when collapsed, empty string when expanded
      sidebar.dataset.collapsible = stateStr === "collapsed" ? this.collapsibleMode : ""
    }

    // Update sidebar gap and container widths for icon mode
    if (this.collapsibleMode === "icon") {
      const gap = this.el.querySelector('[data-slot="sidebar-gap"]')
      const container = this.el.querySelector('[data-slot="sidebar-container"]')

      if (gap && container) {
        if (this.state) {
          // Expanded
          gap.style.width = "var(--sidebar-width)"
          container.style.width = "var(--sidebar-width)"
        } else {
          // Collapsed
          gap.style.width = "var(--sidebar-width-icon)"
          container.style.width = "var(--sidebar-width-icon)"
        }
      }
    }

    // Dispatch custom event for other components that need to react
    window.dispatchEvent(
      new CustomEvent("sidebar:state-changed", {
        detail: {
          state: stateStr,
          open: this.state,
          isMobile: this.isMobile,
          openMobile: this.openMobile,
        },
      })
    )
  },
}

/**
 * Sidebar Trigger Hook - Handles click events on trigger buttons
 */
export const SidebarTriggerHook = {
  mounted() {
    this.el.addEventListener("click", (e) => {
      e.preventDefault()
      // Dispatch event to the sidebar hook (client-side only)
      window.dispatchEvent(new CustomEvent("sidebar:toggle"))
    })

    // Listen for sidebar state changes to update button ARIA
    this.handleStateChange = (event) => {
      const { state } = event.detail
      this.el.setAttribute("aria-expanded", state === "expanded")
    }
    window.addEventListener("sidebar:state-changed", this.handleStateChange)
  },

  destroyed() {
    window.removeEventListener("sidebar:state-changed", this.handleStateChange)
  },
}
