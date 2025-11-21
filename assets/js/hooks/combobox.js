/**
 * Combobox hook for handling chip removal in multiple selection mode,
 * auto-focusing search input when popover opens, and keyboard navigation.
 *
 * Features:
 * - Intercepts clicks on remove buttons before they bubble to the popover trigger
 * - Auto-focuses search input when popover opens for immediate typing
 * - Keyboard navigation with arrow keys and Enter to select
 */
export const Combobox = {
  mounted() {
    // Get the combobox ID from data attribute
    const comboboxId = this.el.dataset.combobox

    // Find the popover content element
    this.popoverContent = document.getElementById(`${comboboxId}-content`)

    // Track focused item index
    this.focusedIndex = -1

    // Set up MutationObserver to watch for popover state changes
    if (this.popoverContent) {
      this.observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
          if (mutation.type === 'attributes' && mutation.attributeName === 'data-state') {
            const state = this.popoverContent.dataset.state

            // When popover opens, focus the search input and setup keyboard navigation
            if (state === 'open') {
              // Small delay to ensure the popover is fully rendered
              setTimeout(() => {
                const searchInput = this.popoverContent.querySelector('[data-command-input]')
                if (searchInput) {
                  searchInput.focus()
                  this.setupKeyboardNavigation(searchInput)
                }
              }, 50)
            } else if (state === 'closed') {
              // Clean up keyboard navigation when closed
              this.cleanupKeyboardNavigation()
              this.focusedIndex = -1
            }
          }
        })
      })

      // Start observing the popover content for attribute changes
      this.observer.observe(this.popoverContent, {
        attributes: true,
        attributeFilter: ['data-state']
      })
    }

    // Handle clicks on remove buttons
    this.handleClick = (e) => {
      const removeButton = e.target.closest('[data-combobox-remove]')

      if (removeButton) {
        // Stop the event from reaching the popover trigger
        e.stopPropagation()
        e.preventDefault()

        // Get the data we need
        const value = removeButton.dataset.removeValue
        const comboboxId = removeButton.dataset.comboboxId
        const eventName = removeButton.dataset.eventName

        if (eventName) {
          // Get current values from all chips
          const chips = this.el.querySelectorAll('[data-chip-value]')
          const currentValues = Array.from(chips).map(chip => chip.dataset.chipValue)

          // Remove this value
          const newValues = currentValues.filter(v => v !== value)

          // Push event to server
          this.pushEvent(eventName, {
            id: comboboxId,
            value: newValues.join(',')
          })
        }
      }
    }

    // Attach at capture phase to intercept before popover trigger
    this.el.addEventListener('click', this.handleClick, true)
  },

  setupKeyboardNavigation(searchInput) {
    // Store the input element for cleanup later
    this.searchInput = searchInput

    // Handle keyboard navigation
    this.handleKeyDown = (e) => {
      const list = this.popoverContent.querySelector('[data-command-list]')
      if (!list) return

      const allItems = Array.from(list.querySelectorAll('[data-command-item]'))
      const visibleItems = allItems.filter(item =>
        item.offsetParent !== null && !item.hasAttribute('disabled')
      )

      if (visibleItems.length === 0) return

      switch(e.key) {
        case 'ArrowDown':
          e.preventDefault()
          this.focusedIndex = Math.min(this.focusedIndex + 1, visibleItems.length - 1)
          this.updateFocusedItem(visibleItems)
          break

        case 'ArrowUp':
          e.preventDefault()
          this.focusedIndex = Math.max(this.focusedIndex - 1, -1)
          this.updateFocusedItem(visibleItems)
          break

        case 'Enter':
          e.preventDefault()

          // If only one item is visible, select it regardless of focus
          if (visibleItems.length === 1) {
            this.selectItem(visibleItems[0])
          }
          // Otherwise select the focused item if there is one
          else if (this.focusedIndex >= 0 && this.focusedIndex < visibleItems.length) {
            this.selectItem(visibleItems[this.focusedIndex])
          }
          break

        case 'Escape':
          // Close the popover
          const closeButton = document.querySelector(`#${this.el.dataset.combobox}-trigger`)
          if (closeButton) {
            closeButton.click()
          }
          break
      }
    }

    // Handle input changes to reset focus
    this.handleInput = () => {
      this.focusedIndex = -1
      this.updateFocusedItem([])
    }

    searchInput.addEventListener('keydown', this.handleKeyDown)
    searchInput.addEventListener('input', this.handleInput)
  },

  cleanupKeyboardNavigation() {
    if (this.searchInput) {
      if (this.handleKeyDown) {
        this.searchInput.removeEventListener('keydown', this.handleKeyDown)
      }
      if (this.handleInput) {
        this.searchInput.removeEventListener('input', this.handleInput)
      }
      this.searchInput = null
    }
  },

  updateFocusedItem(visibleItems) {
    // Remove focus from all items in the popover
    const list = this.popoverContent.querySelector('[data-command-list]')
    if (!list) return

    const allItems = list.querySelectorAll('[data-command-item]')
    allItems.forEach(item => {
      item.setAttribute('data-selected', 'false')
      item.classList.remove('bg-accent', 'text-accent-foreground')
    })

    // Add focus to current item
    if (this.focusedIndex >= 0 && this.focusedIndex < visibleItems.length) {
      const focusedItem = visibleItems[this.focusedIndex]
      focusedItem.setAttribute('data-selected', 'true')
      focusedItem.classList.add('bg-accent', 'text-accent-foreground')

      // Scroll into view if needed
      focusedItem.scrollIntoView({ block: 'nearest', behavior: 'smooth' })
    }
  },

  selectItem(item) {
    // Trigger the click event on the item
    item.click()
  },

  destroyed() {
    if (this.handleClick) {
      this.el.removeEventListener('click', this.handleClick, true)
    }

    // Clean up keyboard navigation
    this.cleanupKeyboardNavigation()

    // Clean up the observer
    if (this.observer) {
      this.observer.disconnect()
    }
  }
}
