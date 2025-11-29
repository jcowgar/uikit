/**
 * Dialog JavaScript Utilities
 *
 * Provides the global event handler for server-side dialog closing.
 * This must be initialized in your app.js for push_event("close-dialog", ...) to work.
 *
 * Usage in app.js:
 *   import { initDialogEvents } from "../deps/ui_kit/assets/js/hooks/dialog"
 *   initDialogEvents()
 */

/**
 * Initialize global dialog event handlers.
 *
 * Call this function once in your app.js after the DOM is ready.
 * It sets up the listener for server-triggered dialog closes.
 *
 * Example:
 *   // In app.js
 *   import { initDialogEvents } from "../deps/ui_kit/assets/js/hooks/dialog"
 *   initDialogEvents()
 *
 *   // In LiveView - close dialog after handling event
 *   def handle_event("save-settings", _params, socket) do
 *     {:noreply,
 *      socket
 *      |> put_flash(:info, "Settings saved")
 *      |> push_event("close-dialog", %{id: "user-settings"})}
 *   end
 */
export function initDialogEvents() {
  // Listen for server-triggered dialog close events
  window.addEventListener("phx:close-dialog", (event) => {
    const { id } = event.detail;
    if (!id) {
      console.warn("close-dialog event received without id");
      return;
    }

    // Find and click the hidden close button to trigger the close animation
    const closeButton = document.getElementById(`${id}-server-close`);
    if (closeButton) {
      closeButton.click();
    } else {
      console.warn(`Dialog close button not found: ${id}-server-close`);
    }
  });
}
