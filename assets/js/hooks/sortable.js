/**
 * Sortable Hook
 *
 * Provides drag-and-drop reordering functionality using Sortable.js.
 * Enables users to reorder lists of items with smooth animations and
 * communicates the new order back to the LiveView server.
 *
 * Usage:
 *   <div id="my-list" phx-hook="Sortable" data-group="items">
 *     <div data-id="item-1">Item 1</div>
 *     <div data-id="item-2">Item 2</div>
 *   </div>
 *
 * The hook will push a "reorder" event to the server with detailed information:
 *   %{
 *     "order" => ["item-1", "item-2", ...],  # New order of all items in target container
 *     "item" => "item-1",                     # ID of the item that was moved
 *     "from" => "source-container-id",        # ID of source container
 *     "to" => "target-container-id",          # ID of target container
 *     "oldIndex" => 0,                        # Old position in source
 *     "newIndex" => 1                         # New position in target
 *   }
 *
 * Attributes:
 *   - data-group: Optional group name for linked lists (default: "default")
 *   - data-handle: Optional CSS selector for drag handle (default: ".drag-handle")
 *   - data-animation: Optional animation duration in ms (default: 150)
 */
import Sortable from "sortablejs"

export const SortableHook = {
  mounted() {
    const hook = this
    const group = this.el.dataset.group || "default"
    const handle = this.el.dataset.handle || ".drag-handle"
    const animation = parseInt(this.el.dataset.animation || "150", 10)

    // Track whether a drag operation occurred to prevent click events
    let isDragging = false
    let dragOccurred = false

    this.sortable = Sortable.create(this.el, {
      animation: animation,
      handle: handle,
      ghostClass: "sortable-ghost",
      dragClass: "sortable-drag",
      chosenClass: "sortable-chosen",
      group: group,
      forceFallback: true, // Better cross-browser compatibility
      fallbackTolerance: 3,
      onStart(evt) {
        isDragging = true
        dragOccurred = false
      },
      onMove(evt) {
        // If the item actually moved, mark that a drag occurred
        dragOccurred = true
      },
      onEnd(evt) {
        // Get the new order of item IDs from data-id attributes
        const order = Array.from(evt.to.children).map(
          (el) => el.dataset.id
        )

        // Build detailed event information
        const eventData = {
          order: order,
          item: evt.item.dataset.id,
          from: evt.from.id,
          to: evt.to.id,
          oldIndex: evt.oldIndex,
          newIndex: evt.newIndex,
        }

        // Send the new order to the LiveView server
        hook.pushEvent("reorder", eventData)

        // Prevent click events for a short time after drag completes
        // This prevents navigation when releasing after a drag
        if (dragOccurred || evt.oldIndex !== evt.newIndex) {
          evt.item.classList.add("sortable-no-click")
          setTimeout(() => {
            evt.item.classList.remove("sortable-no-click")
            isDragging = false
            dragOccurred = false
          }, 100)
        } else {
          isDragging = false
          dragOccurred = false
        }
      },
    })

    // Capture click events on the sortable container
    // If a drag just occurred, prevent the event from reaching Phoenix
    this.el.addEventListener(
      "click",
      (e) => {
        const target = e.target.closest("[data-id]")
        if (target && target.classList.contains("sortable-no-click")) {
          e.stopPropagation()
          e.preventDefault()
        }
      },
      true
    ) // Use capture phase to intercept before Phoenix handlers
  },

  destroyed() {
    if (this.sortable) {
      this.sortable.destroy()
    }
  },
}
