/**
 * Chip Input hook for keyboard interactions
 *
 * Handles:
 * - Enter, Space, Comma: Add new chip from input value
 * - Backspace on empty input: Remove last chip
 * - Escape: Clear input
 * - Show/filter suggestions dropdown as user types
 */
export const ChipInput = {
  mounted() {
    this.input = this.el.querySelector('[data-chip-input]')
    this.allowDuplicates = this.el.dataset.allowDuplicates === 'true'
    this.serverMode = this.el.dataset.serverMode === 'true'
    this.suggestionsContainer = this.el.querySelector('[data-suggestions-trigger]')
    this.suggestionsList = this.el.querySelector('[role="listbox"]')

    if (!this.input) {
      console.warn('ChipInput: Missing input element')
      return
    }

    // Attach remove handlers to existing chips (client-side mode only)
    if (!this.serverMode) {
      this.attachRemoveHandlers()
    }

    // Handle input events for suggestions
    this.handleInput = (e) => {
      if (this.suggestionsList) {
        this.filterSuggestions(e.target.value)
      }
    }

    // Handle focus events to show suggestions
    this.handleFocus = () => {
      if (this.suggestionsContainer && this.suggestionsList) {
        this.showSuggestions()
        this.filterSuggestions(this.input.value)
      }
    }

    // Handle keydown events
    this.handleKeydown = (e) => {
      // Backspace on empty input: Remove last chip
      if (e.key === 'Backspace' && this.input.value === '') {
        e.preventDefault()
        this.removeLastChip()
        return
      }

      const value = this.input.value.trim()

      // Enter, Space, or Comma: Add chip
      if (e.key === 'Enter' || e.key === ' ' || e.key === ',') {
        e.preventDefault()

        if (value) {
          this.addChip(value)
        }
      }
      // Escape: Clear input and hide suggestions
      else if (e.key === 'Escape') {
        e.preventDefault()
        this.input.value = ''
        this.hideSuggestions()
        this.input.blur()
      }
    }

    this.input.addEventListener('keydown', this.handleKeydown)
    this.input.addEventListener('input', this.handleInput)
    this.input.addEventListener('focus', this.handleFocus)

    // Hide suggestions when clicking outside
    this.handleClickOutside = (e) => {
      if (!this.el.contains(e.target)) {
        this.hideSuggestions()
      }
    }
    document.addEventListener('click', this.handleClickOutside)
  },

  showSuggestions() {
    if (this.suggestionsContainer) {
      const popover = this.suggestionsContainer.closest('[data-popover]')
      const content = popover?.querySelector('[data-popover-content]')
      if (popover && content) {
        popover.setAttribute('data-state', 'open')
        content.setAttribute('data-state', 'open')
      }
    }
  },

  hideSuggestions() {
    if (this.suggestionsContainer) {
      const popover = this.suggestionsContainer.closest('[data-popover]')
      const content = popover?.querySelector('[data-popover-content]')
      if (popover && content) {
        popover.setAttribute('data-state', 'closed')
        content.setAttribute('data-state', 'closed')
      }
    }
  },

  filterSuggestions(searchTerm) {
    if (!this.suggestionsList) return

    const options = this.suggestionsList.querySelectorAll('[data-suggestion]')
    const term = searchTerm.toLowerCase()
    let hasVisibleOptions = false

    options.forEach(option => {
      const suggestionText = option.getAttribute('data-suggestion').toLowerCase()
      const matches = suggestionText.includes(term)

      option.style.display = matches ? '' : 'none'
      if (matches) hasVisibleOptions = true
    })

    // Hide suggestions if no matches
    if (!hasVisibleOptions && term) {
      this.hideSuggestions()
    } else if (hasVisibleOptions) {
      this.showSuggestions()
    }
  },

  addChip(value) {
    // Get current chips
    const currentChips = this.getCurrentChips()

    // Check for duplicates if not allowed
    if (!this.allowDuplicates && currentChips.includes(value)) {
      // Clear input and return early
      this.input.value = ''
      return
    }

    if (this.serverMode) {
      // Server-side mode: Push event to LiveView
      this.pushEvent('chip-input:add', {
        id: this.el.id,
        value: value
      })
    } else {
      // Client-side mode: Add chip to DOM directly
      this.addChipToDOM(value)
    }

    // Clear input and hide suggestions
    this.input.value = ''
    this.hideSuggestions()
  },

  removeLastChip() {
    const badges = this.el.querySelectorAll('[data-chip-value]')

    if (badges.length > 0) {
      const lastBadge = badges[badges.length - 1]
      const removeButton = lastBadge.querySelector('[data-chip-remove]')

      if (removeButton) {
        // Trigger the remove event
        removeButton.click()
      }
    }
  },

  getCurrentChips() {
    const badges = this.el.querySelectorAll('[data-chip-value]')
    return Array.from(badges).map(badge => {
      return badge.getAttribute('data-chip-value')
    }).filter(Boolean)
  },

  attachRemoveHandlers() {
    // Find all remove buttons in existing chips and attach click handlers
    const removeButtons = this.el.querySelectorAll('[data-chip-remove]')
    removeButtons.forEach(button => {
      // Skip if already has handler attached
      if (button.dataset.handlerAttached) return

      const badge = button.closest('[data-chip-value]')
      if (badge) {
        const value = badge.getAttribute('data-chip-value')
        button.addEventListener('click', (e) => {
          e.preventDefault()
          this.removeChipFromDOM(value)
        })
        button.dataset.handlerAttached = 'true'
      }
    })
  },

  addChipToDOM(value) {
    // Create badge element matching <.badge variant="secondary" class="gap-1 pl-2 pr-1">
    // Classes must exactly match the server-rendered badge component
    const badge = document.createElement('span')
    badge.className = [
      // Badge base styles (from feedback_status.ex lines 63-67)
      'inline-flex items-center justify-center rounded-md border px-2 py-0.5',
      'text-xs font-medium w-fit whitespace-nowrap shrink-0',
      '[&>svg]:size-3 gap-1 [&>svg]:pointer-events-none',
      'focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]',
      'transition-[color,box-shadow] overflow-hidden',
      // Badge variant="secondary" styles (from feedback_status.ex lines 85-87)
      'border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/90 [a_&]:hover:bg-secondary/90',
      // Custom class passed to badge in chip_input.ex
      'gap-1 pl-2 pr-1'
    ].join(' ')
    badge.setAttribute('data-chip-value', value)
    badge.textContent = value

    // Create remove button matching <.close_button variant="chip" size="sm">
    // Classes must exactly match the close_button component (from form_input.ex)
    const button = document.createElement('button')
    button.type = 'button'
    button.className = [
      // close_button_classes("chip") (from form_input.ex lines 237-242)
      'ml-1 rounded-sm',
      'hover:bg-secondary-foreground/20',
      'focus-visible:outline-hidden focus-visible:ring-1 focus-visible:ring-ring',
      // close_button_size("sm") (from form_input.ex line 245)
      'p-0.5'
    ].join(' ')
    button.setAttribute('aria-label', `Remove ${value}`)
    button.setAttribute('data-chip-remove', '')
    button.dataset.handlerAttached = 'true' // Mark as having handler

    // Create X icon matching <.icon name="hero-x-mark" class="size-3" />
    // The icon component renders as: <span class="hero-x-mark size-3" />
    const icon = document.createElement('span')
    icon.className = 'hero-x-mark size-3'
    button.appendChild(icon)

    // Add sr-only span for accessibility (matching close_button component)
    const srSpan = document.createElement('span')
    srSpan.className = 'sr-only'
    srSpan.textContent = `Remove ${value}`
    button.appendChild(srSpan)

    // Handle remove click
    button.addEventListener('click', (e) => {
      e.preventDefault()
      this.removeChipFromDOM(value)
    })

    badge.appendChild(button)

    // Insert badge before the input field
    const container = this.input.parentElement
    container.insertBefore(badge, this.input)

    // Add hidden input for form submission
    if (!this.serverMode) {
      this.addHiddenInput(value)
    }
  },

  removeChipFromDOM(value) {
    // Find and remove the badge
    const badges = this.el.querySelectorAll('[data-chip-value]')
    badges.forEach(badge => {
      if (badge.getAttribute('data-chip-value') === value) {
        badge.remove()
      }
    })

    // Remove corresponding hidden input
    if (!this.serverMode) {
      this.removeHiddenInput(value)
    }
  },

  addHiddenInput(value) {
    const container = this.el
    const inputField = container.querySelector('[data-chip-input-field]')

    if (inputField) {
      const hiddenInput = document.createElement('input')
      hiddenInput.type = 'hidden'
      hiddenInput.name = inputField.name.replace(/\[\]$/, '') + '[]'
      hiddenInput.value = value
      hiddenInput.setAttribute('data-chip-hidden-value', '')

      container.insertBefore(hiddenInput, container.firstChild)
    }
  },

  removeHiddenInput(value) {
    const hiddenInputs = this.el.querySelectorAll('[data-chip-hidden-value]')
    hiddenInputs.forEach(input => {
      if (input.value === value) {
        input.remove()
        return
      }
    })
  },

  destroyed() {
    if (this.input) {
      if (this.handleKeydown) {
        this.input.removeEventListener('keydown', this.handleKeydown)
      }
      if (this.handleInput) {
        this.input.removeEventListener('input', this.handleInput)
      }
      if (this.handleFocus) {
        this.input.removeEventListener('focus', this.handleFocus)
      }
    }
    if (this.handleClickOutside) {
      document.removeEventListener('click', this.handleClickOutside)
    }
  }
}
