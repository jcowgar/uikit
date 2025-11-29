/**
 * DialogAutoFocus Hook
 *
 * Automatically focuses the first focusable input when a dialog opens.
 * Priority:
 * 1. Input with `autofocus` attribute
 * 2. First focusable input (input, textarea, select)
 * 3. Nothing if no inputs exist
 */
export const DialogAutoFocus = {
  mounted() {
    // Set up a MutationObserver to watch for data-state changes
    this.observer = new MutationObserver((mutations) => {
      mutations.forEach((mutation) => {
        if (mutation.attributeName === "data-state") {
          const state = this.el.getAttribute("data-state");
          if (state === "open") {
            this.focusFirstInput();
          }
        }
      });
    });

    this.observer.observe(this.el, { attributes: true });

    // Also check initial state (in case dialog opens immediately)
    if (this.el.getAttribute("data-state") === "open") {
      this.focusFirstInput();
    }
  },

  focusFirstInput() {
    // Wait for dialog animation to complete (200ms transition + buffer)
    setTimeout(() => {
      // First, try to find an element with autofocus attribute
      const autofocusEl = this.el.querySelector("[autofocus]");
      if (autofocusEl) {
        autofocusEl.focus();
        return;
      }

      // Otherwise, find the first focusable input
      const focusableSelector = "input:not([type=hidden]):not([disabled]), textarea:not([disabled]), select:not([disabled])";
      const firstInput = this.el.querySelector(focusableSelector);
      if (firstInput) {
        firstInput.focus();
      }
    }, 250);
  },

  destroyed() {
    if (this.observer) {
      this.observer.disconnect();
    }
  }
};
