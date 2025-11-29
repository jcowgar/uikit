/**
 * DestructiveConfirmationInput Hook
 *
 * Enables a confirmation button only when the input value matches
 * the required confirmation text. Used for destructive actions
 * like delete confirmations.
 */
export const DestructiveConfirmationInput = {
  mounted() {
    this.confirmationText = this.el.dataset.confirmationText
    this.buttonId = this.el.dataset.buttonId
    this.button = document.getElementById(this.buttonId)

    if (!this.button) {
      console.warn('DestructiveConfirmationInput: Button not found:', this.buttonId)
      return
    }

    this.handleInput = () => {
      const matches = this.el.value === this.confirmationText
      this.button.disabled = !matches
    }

    this.el.addEventListener('input', this.handleInput)

    // Check initial state
    this.handleInput()
  },

  destroyed() {
    if (this.handleInput) {
      this.el.removeEventListener('input', this.handleInput)
    }
  }
}
