/**
 * SonnerToast Hook
 *
 * Handles auto-dismiss functionality for Sonner toast notifications.
 * Listens for the `sonner:auto-dismiss` event dispatched by the server
 * and sets up a timeout to automatically hide the toast.
 */
export const SonnerToast = {
  mounted() {
    this.timeoutId = null

    // Listen for the auto-dismiss event from the server
    this.handleAutoDismiss = (e) => {
      const duration = e.detail?.duration || 5000

      // Clear any existing timeout
      if (this.timeoutId) {
        clearTimeout(this.timeoutId)
      }

      // Set up auto-dismiss
      this.timeoutId = setTimeout(() => {
        this.dismiss()
      }, duration)
    }

    this.el.addEventListener("sonner:auto-dismiss", this.handleAutoDismiss)
  },

  dismiss() {
    // Set the closed state to trigger animation
    this.el.setAttribute("data-state", "closed")

    // Wait for animation to complete, then push the clear-flash event
    setTimeout(() => {
      // Extract the flash key from the element ID (e.g., "sonner-info" -> "info")
      const id = this.el.id
      const key = id.replace("sonner-", "")

      // Push the clear-flash event to the server
      this.pushEvent("lv:clear-flash", { key: key })

      // Hide the element
      this.el.style.display = "none"
    }, 300)
  },

  destroyed() {
    if (this.timeoutId) {
      clearTimeout(this.timeoutId)
    }
    this.el.removeEventListener("sonner:auto-dismiss", this.handleAutoDismiss)
  }
}
