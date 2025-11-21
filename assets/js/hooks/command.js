/**
 * Auto-focus command input when mounted
 *
 * Used for command dialogs to automatically focus the search input when opened.
 * Waits for the dialog animation to complete before focusing.
 */
export const CommandInputFocus = {
  mounted() {
    // Find the dialog content element (parent of the command component)
    const dialogContent = this.el.closest('[data-slot="dialog-content"]')

    if (dialogContent) {
      // Watch for when the dialog opens (data-state changes to "open")
      const observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
          if (mutation.type === 'attributes' && mutation.attributeName === 'data-state') {
            const state = dialogContent.dataset.state

            if (state === 'open') {
              // Wait for the dialog animation to complete (200ms + small buffer)
              setTimeout(() => {
                this.el.focus()
              }, 250)

              // Stop observing after focusing
              observer.disconnect()
            }
          }
        })
      })

      // Check if dialog is already open
      if (dialogContent.dataset.state === 'open') {
        // Dialog is already open, focus immediately with small delay
        setTimeout(() => {
          this.el.focus()
        }, 50)
      } else {
        // Start observing for state changes
        observer.observe(dialogContent, {
          attributes: true,
          attributeFilter: ['data-state']
        })

        // Store observer for cleanup
        this.observer = observer
      }
    } else {
      // Fallback: If not in a dialog, focus immediately
      requestAnimationFrame(() => {
        this.el.focus()
      })
    }
  },

  destroyed() {
    // Clean up the observer if it exists
    if (this.observer) {
      this.observer.disconnect()
    }
  }
}

/**
 * Keyboard navigation for command components
 *
 * Provides keyboard navigation with arrow keys and Enter to select.
 * Works with both client and server-side filtering.
 */
export const CommandKeyboard = {
  mounted() {
    this.input = this.el.querySelector('[data-command-input]')
    this.list = this.el.querySelector('[data-command-list]')

    if (!this.input || !this.list) {
      console.warn('CommandKeyboard: Missing required elements (input or list)')
      return
    }

    // Track currently focused item
    this.focusedIndex = -1

    // Handle keyboard navigation
    this.handleKeyDown = (e) => {
      const visibleItems = this.getVisibleItems()

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
          // Clear search and reset
          if (this.input.value) {
            this.input.value = ''
            // Trigger input event for client-side filtering
            this.input.dispatchEvent(new Event('input', { bubbles: true }))
            // Trigger change event for server-side filtering
            const form = this.input.closest('form')
            if (form) {
              form.dispatchEvent(new Event('change', { bubbles: true }))
            }
          }
          this.focusedIndex = -1
          this.updateFocusedItem([])
          break
      }
    }

    // Handle input changes to reset focus
    this.handleInput = () => {
      this.focusedIndex = -1
      this.updateFocusedItem([])
    }

    this.input.addEventListener('keydown', this.handleKeyDown)
    this.input.addEventListener('input', this.handleInput)
  },

  getVisibleItems() {
    const allItems = Array.from(this.list.querySelectorAll('[data-command-item]'))
    return allItems.filter(item => {
      // Check if item is visible (not hidden by style.display or parent group)
      if (item.style.display === 'none') return false

      // Check if parent group is hidden
      const group = item.closest('[data-command-group]')
      if (group && group.style.display === 'none') return false

      // Check if disabled
      if (item.hasAttribute('disabled')) return false

      // Check if actually visible in DOM
      return item.offsetParent !== null
    })
  },

  updateFocusedItem(visibleItems) {
    // Remove focus from all items
    const allItems = this.list.querySelectorAll('[data-command-item]')
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
    // Check if item has a phx-click handler
    const clickEvent = item.getAttribute('phx-click')

    if (clickEvent) {
      // Trigger the click event
      item.click()
    } else {
      // Fallback: dispatch a custom event that the parent can handle
      const event = new CustomEvent('command-item-selected', {
        detail: {
          label: item.dataset.commandLabel || item.textContent.trim(),
          value: item.getAttribute('phx-value-command')
        },
        bubbles: true
      })
      item.dispatchEvent(event)
    }
  },

  destroyed() {
    if (this.input) {
      if (this.handleKeyDown) {
        this.input.removeEventListener('keydown', this.handleKeyDown)
      }
      if (this.handleInput) {
        this.input.removeEventListener('input', this.handleInput)
      }
    }
  }
}

/**
 * Client-side command filtering hook
 *
 * Provides instant, client-side filtering of command items without server round trips.
 * Note: Keyboard navigation is now handled by CommandKeyboard hook.
 */
export const CommandFilter = {
  mounted() {
    this.input = this.el.querySelector('[data-command-input]')
    this.list = this.el.querySelector('[data-command-list]')
    this.emptyState = this.el.querySelector('[data-command-empty]')

    if (!this.input || !this.list) {
      console.warn('CommandFilter: Missing required elements (input or list)')
      return
    }

    // Store all command items for filtering
    this.allItems = Array.from(this.list.querySelectorAll('[data-command-item]'))
    this.allGroups = Array.from(this.list.querySelectorAll('[data-command-group]'))

    // Handle input changes
    this.handleInput = () => {
      const query = this.input.value.toLowerCase().trim()
      this.filterCommands(query)
    }

    this.input.addEventListener('input', this.handleInput)

    // Initial filter (in case there's a preset value)
    if (this.input.value) {
      this.filterCommands(this.input.value.toLowerCase().trim())
    }
  },

  filterCommands(query) {
    if (!query) {
      // Show all items and groups
      this.allItems.forEach(item => {
        item.style.display = ''
      })
      this.allGroups.forEach(group => {
        group.style.display = ''
      })
      this.toggleEmptyState(false)
      return
    }

    let visibleCount = 0

    // Filter items and track which groups have visible items
    const groupVisibility = new Map()

    this.allItems.forEach(item => {
      const label = (item.dataset.commandLabel || item.textContent).toLowerCase()
      const matches = label.includes(query)

      if (matches) {
        item.style.display = ''
        visibleCount++

        // Mark this item's group as having visible items
        const group = item.closest('[data-command-group]')
        if (group) {
          groupVisibility.set(group, true)
        }
      } else {
        item.style.display = 'none'
      }
    })

    // Show/hide groups based on whether they have visible items
    this.allGroups.forEach(group => {
      if (groupVisibility.get(group)) {
        group.style.display = ''
      } else {
        group.style.display = 'none'
      }
    })

    // Show/hide empty state
    this.toggleEmptyState(visibleCount === 0)
  },

  toggleEmptyState(show) {
    if (this.emptyState) {
      this.emptyState.style.display = show ? '' : 'none'
    }
  },

  destroyed() {
    if (this.input && this.handleInput) {
      this.input.removeEventListener('input', this.handleInput)
    }
  }
}
