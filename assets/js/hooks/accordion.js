/**
 * Accordion Hook
 *
 * Handles accordion expand/collapse behavior with single/multiple modes.
 * Supports keyboard navigation and ARIA attributes for accessibility.
 */
export default {
  mounted() {
    this.type = this.el.dataset.type || 'single'
    this.setupAccordion()
  },

  setupAccordion() {
    // Find all accordion items
    const items = this.el.querySelectorAll('[data-slot="accordion-item"]')

    items.forEach(item => {
      const trigger = item.querySelector('[data-slot="accordion-trigger"]')
      const content = item.querySelector('[data-slot="accordion-content"]')

      if (!trigger || !content) return

      // Set up click handler
      trigger.addEventListener('click', (e) => {
        e.preventDefault()
        this.toggleItem(item, trigger, content)
      })

      // Set up keyboard navigation
      trigger.addEventListener('keydown', (e) => {
        if (e.key === 'Enter' || e.key === ' ') {
          e.preventDefault()
          this.toggleItem(item, trigger, content)
        }
      })

      // Initialize ARIA attributes
      const triggerId = `trigger-${item.dataset.value}`
      const contentId = `content-${item.dataset.value}`

      trigger.id = triggerId
      trigger.setAttribute('aria-controls', contentId)
      trigger.setAttribute('aria-expanded', 'false')

      content.id = contentId
      content.setAttribute('role', 'region')
      content.setAttribute('aria-labelledby', triggerId)
    })
  },

  toggleItem(item, trigger, content) {
    const isOpen = trigger.dataset.state === 'open'

    if (this.type === 'single' && !isOpen) {
      // Close all other items
      this.el.querySelectorAll('[data-slot="accordion-item"]').forEach(otherItem => {
        if (otherItem !== item) {
          const otherTrigger = otherItem.querySelector('[data-slot="accordion-trigger"]')
          const otherContent = otherItem.querySelector('[data-slot="accordion-content"]')
          if (otherTrigger && otherContent) {
            this.closeItem(otherTrigger, otherContent)
          }
        }
      })
    }

    // Toggle current item
    if (isOpen) {
      this.closeItem(trigger, content)
    } else {
      this.openItem(trigger, content)
    }
  },

  openItem(trigger, content) {
    trigger.dataset.state = 'open'
    trigger.setAttribute('aria-expanded', 'true')
    content.dataset.state = 'open'

    // Force reflow to ensure animation runs
    content.offsetHeight

    // Trigger animation
    requestAnimationFrame(() => {
      content.style.maxHeight = content.scrollHeight + 'px'
      content.style.opacity = '1'
    })
  },

  closeItem(trigger, content) {
    trigger.dataset.state = 'closed'
    trigger.setAttribute('aria-expanded', 'false')
    content.dataset.state = 'closed'

    // Animate out
    content.style.maxHeight = '0'
    content.style.opacity = '0'
  }
}
