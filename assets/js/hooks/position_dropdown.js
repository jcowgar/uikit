/**
 * PositionDropdown Hook
 *
 * Positions a dropdown menu using fixed positioning relative to its trigger element.
 * This allows dropdowns to escape overflow containers (like scrollable tables) that
 * would otherwise clip them.
 *
 * The hook:
 * 1. Finds the dropdown's trigger element
 * 2. Calculates the trigger's position relative to the viewport
 * 3. Positions the dropdown menu accordingly using fixed positioning
 * 4. Repositions on scroll events to keep it aligned with the trigger
 */
export const PositionDropdown = {
  mounted() {
    this.positionDropdown()

    // Reposition on scroll events (throttled)
    this.scrollHandler = this.throttle(() => {
      if (!this.el.classList.contains('hidden')) {
        this.positionDropdown()
      }
    }, 16) // ~60fps

    window.addEventListener('scroll', this.scrollHandler, true)
    window.addEventListener('resize', this.scrollHandler)
  },

  updated() {
    // Reposition when the dropdown becomes visible
    // Use setTimeout to wait for LiveView's JS commands to finish updating display style
    setTimeout(() => {
      const computedStyle = window.getComputedStyle(this.el)
      if (computedStyle.display !== 'none') {
        this.positionDropdown()
      }
    }, 0)
  },

  destroyed() {
    window.removeEventListener('scroll', this.scrollHandler, true)
    window.removeEventListener('resize', this.scrollHandler)
  },

  positionDropdown() {
    // Wait a tick for the element to be visible and have dimensions
    // Using a small timeout instead of requestAnimationFrame to ensure content is fully rendered
    setTimeout(() => {
      // Find the trigger element (parent dropdown menu)
      const dropdownMenu = this.el.closest('[data-slot="dropdown-menu"]')
      if (!dropdownMenu) return

      const trigger = dropdownMenu.querySelector('[data-slot="dropdown-menu-trigger"]')
      if (!trigger) return

      // Get positioning preferences from data attributes
      let align = this.el.dataset.align || 'start'
      let side = this.el.dataset.side || 'bottom'
      const offset = parseInt(this.el.dataset.offset || '4', 10)

      // Get trigger's bounding rectangle
      const triggerRect = trigger.getBoundingClientRect()

      // Get viewport dimensions
      const viewportWidth = window.innerWidth
      const viewportHeight = window.innerHeight

      // Get dropdown dimensions (should be available now that it's visible)
      const dropdownWidth = this.el.offsetWidth
      const dropdownHeight = this.el.offsetHeight

      // Bail if dimensions aren't available yet (element still has display: none)
      if (dropdownWidth === 0 || dropdownHeight === 0) {
        // Retry after a short delay
        setTimeout(() => this.positionDropdown(), 50)
        return
      }

      // Smart positioning: check if dropdown would go off-screen and flip if needed

      // Check if dropdown would go off bottom of screen, flip to top
      if (side === 'bottom' && triggerRect.bottom + offset + dropdownHeight > viewportHeight - 8) {
        side = 'top'
      }
      // Check if dropdown would go off top of screen, flip to bottom
      else if (side === 'top' && triggerRect.top - offset - dropdownHeight < 8) {
        side = 'bottom'
      }

      // Calculate position based on side and alignment
      let top = 0
      let left = 0

      // Vertical positioning (side)
      switch (side) {
        case 'top':
          top = triggerRect.top - dropdownHeight - offset
          break
        case 'bottom':
          top = triggerRect.bottom + offset
          break
        case 'left':
        case 'right':
          // For left/right, vertical alignment depends on 'align'
          if (align === 'start') {
            top = triggerRect.top
          } else if (align === 'center') {
            top = triggerRect.top + (triggerRect.height / 2) - (dropdownHeight / 2)
          } else if (align === 'end') {
            top = triggerRect.bottom - dropdownHeight
          }
          break
      }

      // Horizontal positioning
      switch (side) {
        case 'left':
          left = triggerRect.left - dropdownWidth - offset
          break
        case 'right':
          left = triggerRect.right + offset
          break
        case 'top':
        case 'bottom':
          // For top/bottom, horizontal alignment depends on 'align'
          if (align === 'start') {
            left = triggerRect.left
          } else if (align === 'center') {
            left = triggerRect.left + (triggerRect.width / 2) - (dropdownWidth / 2)
          } else if (align === 'end') {
            left = triggerRect.right - dropdownWidth
          }
          break
      }

      // Final bounds check: ensure dropdown stays within viewport
      if (left < 8) {
        left = 8
      } else if (left + dropdownWidth > viewportWidth - 8) {
        left = viewportWidth - dropdownWidth - 8
      }

      if (top < 8) {
        top = 8
      } else if (top + dropdownHeight > viewportHeight - 8) {
        top = viewportHeight - dropdownHeight - 8
      }

      // Apply positioning
      this.el.style.top = `${top}px`
      this.el.style.left = `${left}px`
    }, 10) // Small delay to ensure content is rendered
  },

  /**
   * Throttle function execution
   * @param {Function} func - Function to throttle
   * @param {number} limit - Minimum time between executions in ms
   * @returns {Function} Throttled function
   */
  throttle(func, limit) {
    let inThrottle
    return function() {
      const args = arguments
      const context = this
      if (!inThrottle) {
        func.apply(context, args)
        inThrottle = true
        setTimeout(() => inThrottle = false, limit)
      }
    }
  }
}
