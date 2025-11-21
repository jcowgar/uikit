/**
 * SelectDropdown Hook
 *
 * Provides keyboard navigation and accessibility features for the custom Select component.
 * Handles arrow key navigation, Enter to select, Escape to close, and type-to-search.
 */
export const SelectDropdown = {
  mounted() {
    this.selectId = this.el.dataset.selectId
    this.trigger = document.getElementById(`${this.selectId}-trigger`)
    this.content = document.getElementById(`${this.selectId}-content`)
    this.input = document.getElementById(`${this.selectId}-input`)
    this.options = []
    this.focusedIndex = -1
    this.searchQuery = ""
    this.searchTimeout = null

    // Update options list whenever content changes
    this.updateOptions()

    // Keyboard event handler
    this.handleKeyDown = (e) => {
      // Only handle if dropdown is open
      const isOpen = !this.content.classList.contains("hidden")

      if (!isOpen && (e.key === "ArrowDown" || e.key === "ArrowUp" || e.key === " ")) {
        // Open dropdown
        e.preventDefault()
        this.trigger.click()
        return
      }

      if (!isOpen) return

      switch (e.key) {
        case "ArrowDown":
          e.preventDefault()
          this.focusNextOption()
          break
        case "ArrowUp":
          e.preventDefault()
          this.focusPreviousOption()
          break
        case "Enter":
          e.preventDefault()
          this.selectFocusedOption()
          break
        case "Escape":
          e.preventDefault()
          this.closeDropdown()
          break
        case " ":
          e.preventDefault()
          this.selectFocusedOption()
          break
        default:
          // Type to search
          if (e.key.length === 1) {
            this.handleTypeToSearch(e.key)
          }
          break
      }
    }

    // Add keyboard listener to trigger button
    this.trigger.addEventListener("keydown", this.handleKeyDown)

    // Observer to detect when dropdown opens/closes
    this.observer = new MutationObserver((mutations) => {
      mutations.forEach((mutation) => {
        if (mutation.attributeName === "class") {
          const isOpen = !this.content.classList.contains("hidden")
          if (isOpen) {
            this.updateOptions()
            // Focus first selected option or first option
            const selectedIndex = this.options.findIndex(
              (opt) => opt.getAttribute("aria-selected") === "true"
            )
            this.focusedIndex = selectedIndex >= 0 ? selectedIndex : 0
            this.updateFocus()
          }
        }
      })
    })

    this.observer.observe(this.content, { attributes: true })

    // Update the trigger text and selected state when input value changes
    this.handleInputChange = () => {
      const value = this.input.value
      this.updateOptions()

      // Update trigger text
      const selectedOption = Array.from(this.options).find(
        (opt) => opt.dataset.value === value
      )
      if (selectedOption) {
        const label = selectedOption.querySelector("span").textContent.trim()
        this.trigger.querySelector("span").textContent = label
        this.trigger.classList.remove("text-muted-foreground")
        this.trigger.classList.add("text-foreground")
      }

      // Update which option shows the check mark
      this.updateSelectedState(value)
    }

    this.input.addEventListener("change", this.handleInputChange)

    // Observer to watch for DOM updates (when LiveView re-renders)
    this.contentObserver = new MutationObserver(() => {
      this.updateOptions()
      // Re-apply selected state after DOM updates
      this.updateSelectedState(this.input.value)
    })

    this.contentObserver.observe(this.content, {
      childList: true,
      subtree: true,
    })

    // Initialize selected state on mount
    this.updateSelectedState(this.input.value)
  },

  updateOptions() {
    this.options = Array.from(
      this.content.querySelectorAll('[role="option"]')
    )
  },

  updateSelectedState(value) {
    // Update aria-selected and check marks for all options
    this.options.forEach((option) => {
      const isSelected = option.dataset.value === value
      option.setAttribute("aria-selected", isSelected.toString())

      // Show/hide check mark
      const checkMark = option.querySelector('span[class*="absolute"]')
      if (checkMark) {
        if (isSelected) {
          checkMark.classList.remove("hidden")
        } else {
          checkMark.classList.add("hidden")
        }
      }
    })
  },

  focusNextOption() {
    if (this.options.length === 0) return
    this.focusedIndex = (this.focusedIndex + 1) % this.options.length
    this.updateFocus()
  },

  focusPreviousOption() {
    if (this.options.length === 0) return
    this.focusedIndex =
      this.focusedIndex <= 0 ? this.options.length - 1 : this.focusedIndex - 1
    this.updateFocus()
  },

  updateFocus() {
    this.options.forEach((option, index) => {
      if (index === this.focusedIndex) {
        option.classList.add("bg-accent", "text-accent-foreground")
        option.scrollIntoView({ block: "nearest" })
      } else {
        option.classList.remove("bg-accent", "text-accent-foreground")
      }
    })
  },

  selectFocusedOption() {
    if (this.focusedIndex >= 0 && this.options[this.focusedIndex]) {
      this.options[this.focusedIndex].click()
    }
  },

  closeDropdown() {
    this.trigger.click() // Toggle to close
    this.trigger.focus()
  },

  handleTypeToSearch(key) {
    clearTimeout(this.searchTimeout)

    this.searchQuery += key.toLowerCase()

    // Find first option that starts with search query
    const matchIndex = this.options.findIndex((option) => {
      const label = option.querySelector("span").textContent.trim().toLowerCase()
      return label.startsWith(this.searchQuery)
    })

    if (matchIndex >= 0) {
      this.focusedIndex = matchIndex
      this.updateFocus()
    }

    // Clear search query after 500ms
    this.searchTimeout = setTimeout(() => {
      this.searchQuery = ""
    }, 500)
  },

  destroyed() {
    if (this.trigger) {
      this.trigger.removeEventListener("keydown", this.handleKeyDown)
    }
    if (this.input) {
      this.input.removeEventListener("change", this.handleInputChange)
    }
    if (this.observer) {
      this.observer.disconnect()
    }
    if (this.contentObserver) {
      this.contentObserver.disconnect()
    }
    clearTimeout(this.searchTimeout)
  },
}
