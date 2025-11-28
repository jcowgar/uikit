/**
 * Tooltip Hook
 *
 * Positions a tooltip using fixed positioning relative to its trigger element.
 * This ensures tooltips don't get clipped by viewport edges or overflow containers.
 *
 * The hook:
 * 1. Finds the tooltip's trigger and content elements
 * 2. Calculates position relative to viewport
 * 3. Flips position if it would overflow viewport
 * 4. Keeps tooltip within viewport bounds
 */
export const Tooltip = {
  mounted() {
    this.trigger = this.el.querySelector('[data-slot="tooltip-trigger"]')
    this.content = this.el.querySelector('[data-slot="tooltip-content"]')

    if (!this.trigger || !this.content) return

    // Get preferred side/align from data attributes
    this.preferredSide = this.content.dataset.side || 'top'
    this.preferredAlign = this.content.dataset.align || 'center'

    // Override CSS positioning - use fixed positioning controlled by JS
    // Use setProperty with 'important' to override Tailwind classes
    // Note: Tailwind v4 uses separate translate/rotate/scale properties, not just transform
    this.content.style.setProperty('position', 'fixed', 'important')
    this.content.style.setProperty('top', 'auto', 'important')
    this.content.style.setProperty('bottom', 'auto', 'important')
    this.content.style.setProperty('left', 'auto', 'important')
    this.content.style.setProperty('right', 'auto', 'important')
    this.content.style.setProperty('transform', 'none', 'important')
    this.content.style.setProperty('translate', 'none', 'important')

    // Position on hover/focus
    this.showHandler = () => {
      // Small delay to ensure element is visible and has dimensions
      requestAnimationFrame(() => this.positionTooltip())
    }
    this.trigger.addEventListener('mouseenter', this.showHandler)
    this.trigger.addEventListener('focus', this.showHandler)

    // Reposition on scroll/resize while visible
    this.scrollHandler = this.throttle(() => {
      if (this.isVisible()) {
        this.positionTooltip()
      }
    }, 16)

    window.addEventListener('scroll', this.scrollHandler, true)
    window.addEventListener('resize', this.scrollHandler)
  },

  destroyed() {
    if (this.trigger) {
      this.trigger.removeEventListener('mouseenter', this.showHandler)
      this.trigger.removeEventListener('focus', this.showHandler)
    }
    window.removeEventListener('scroll', this.scrollHandler, true)
    window.removeEventListener('resize', this.scrollHandler)
  },

  isVisible() {
    if (!this.content) return false
    const style = window.getComputedStyle(this.content)
    return style.visibility !== 'hidden' && style.opacity !== '0'
  },

  positionTooltip() {
    if (!this.trigger || !this.content) return

    const triggerRect = this.trigger.getBoundingClientRect()

    const viewportWidth = window.innerWidth
    const viewportHeight = window.innerHeight
    const offset = 8 // Gap between trigger and tooltip
    const padding = 8 // Minimum distance from viewport edge

    // Get content dimensions - temporarily make visible to measure if needed
    let contentWidth = this.content.offsetWidth
    let contentHeight = this.content.offsetHeight

    if (contentWidth === 0 || contentHeight === 0) {
      // Element might not be visible yet, try again
      setTimeout(() => this.positionTooltip(), 10)
      return
    }

    let side = this.preferredSide
    const align = this.preferredAlign

    // Flip side if tooltip would overflow
    if (side === 'top' && triggerRect.top - offset - contentHeight < padding) {
      side = 'bottom'
    } else if (side === 'bottom' && triggerRect.bottom + offset + contentHeight > viewportHeight - padding) {
      side = 'top'
    } else if (side === 'left' && triggerRect.left - offset - contentWidth < padding) {
      side = 'right'
    } else if (side === 'right' && triggerRect.right + offset + contentWidth > viewportWidth - padding) {
      side = 'left'
    }

    let top = 0
    let left = 0

    // Calculate position based on side
    switch (side) {
      case 'top':
        top = triggerRect.top - contentHeight - offset
        break
      case 'bottom':
        top = triggerRect.bottom + offset
        break
      case 'left':
        left = triggerRect.left - contentWidth - offset
        top = triggerRect.top + (triggerRect.height / 2) - (contentHeight / 2)
        break
      case 'right':
        left = triggerRect.right + offset
        top = triggerRect.top + (triggerRect.height / 2) - (contentHeight / 2)
        break
    }

    // Calculate horizontal alignment for top/bottom
    if (side === 'top' || side === 'bottom') {
      switch (align) {
        case 'start':
          left = triggerRect.left
          break
        case 'center':
          left = triggerRect.left + (triggerRect.width / 2) - (contentWidth / 2)
          break
        case 'end':
          left = triggerRect.right - contentWidth
          break
      }
    }

    // Keep within viewport bounds (horizontal)
    if (left < padding) {
      left = padding
    } else if (left + contentWidth > viewportWidth - padding) {
      left = viewportWidth - contentWidth - padding
    }

    // Keep within viewport bounds (vertical)
    if (top < padding) {
      top = padding
    } else if (top + contentHeight > viewportHeight - padding) {
      top = viewportHeight - contentHeight - padding
    }

    // Apply position with !important to override Tailwind classes
    this.content.style.setProperty('top', `${top}px`, 'important')
    this.content.style.setProperty('left', `${left}px`, 'important')
  },

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
