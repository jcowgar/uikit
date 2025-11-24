/**
 * ContextMenu Hook
 *
 * Handles right-click context menu behavior for Phoenix LiveView.
 * Shows a menu at the cursor position when the trigger element is right-clicked.
 */

// Track all open context menus globally
const openContextMenus = new Set()

function closeAllContextMenus() {
  openContextMenus.forEach((menu) => {
    menu.style.display = "none"
    menu.setAttribute("data-state", "closed")
    // Close any open submenus
    const submenus = menu.querySelectorAll(
      "[data-slot='context-menu-sub'] > div[id$='-content']"
    )
    submenus.forEach((submenu) => {
      submenu.classList.add("hidden")
      submenu.setAttribute("data-state", "closed")
    })
  })
  openContextMenus.clear()
}

export const ContextMenu = {
  mounted() {
    const menuId = this.el.dataset.menuId
    this.menu = document.getElementById(menuId)

    if (!this.menu) {
      console.warn(`ContextMenu: No menu found with id "${menuId}"`)
      return
    }

    // Handle right-click (context menu)
    this.handleContextMenu = (e) => {
      e.preventDefault()

      // Close any other open context menus first
      closeAllContextMenus()

      // Position the menu at cursor
      this.menu.style.left = `${e.clientX}px`
      this.menu.style.top = `${e.clientY}px`

      // Show the menu and track it
      this.menu.style.display = "block"
      this.menu.setAttribute("data-state", "open")
      openContextMenus.add(this.menu)

      // Ensure menu stays within viewport
      requestAnimationFrame(() => {
        const rect = this.menu.getBoundingClientRect()
        const viewportWidth = window.innerWidth
        const viewportHeight = window.innerHeight

        // Adjust horizontal position if menu would overflow right
        if (rect.right > viewportWidth) {
          this.menu.style.left = `${viewportWidth - rect.width - 8}px`
        }

        // Adjust vertical position if menu would overflow bottom
        if (rect.bottom > viewportHeight) {
          this.menu.style.top = `${viewportHeight - rect.height - 8}px`
        }
      })
    }

    // Handle clicks on menu items to close menu
    this.handleMenuClick = (e) => {
      const item = e.target.closest("[data-context-close-on-click]")
      if (item && !item.hasAttribute("data-disabled")) {
        // Close the menu after a brief delay to allow the click handler to fire
        setTimeout(() => {
          this.hideMenu()
        }, 50)
      }
    }

    // Handle escape key to close menu
    this.handleKeyDown = (e) => {
      if (e.key === "Escape" && this.menu.style.display !== "none") {
        this.hideMenu()
      }
    }

    this.el.addEventListener("contextmenu", this.handleContextMenu)
    this.menu.addEventListener("click", this.handleMenuClick)
    document.addEventListener("keydown", this.handleKeyDown)
  },

  hideMenu() {
    if (this.menu) {
      this.menu.style.display = "none"
      this.menu.setAttribute("data-state", "closed")
      openContextMenus.delete(this.menu)

      // Close any open submenus
      const submenus = this.menu.querySelectorAll(
        "[data-slot='context-menu-sub'] > div[id$='-content']"
      )
      submenus.forEach((submenu) => {
        submenu.classList.add("hidden")
        submenu.setAttribute("data-state", "closed")
      })
    }
  },

  destroyed() {
    if (this.el) {
      this.el.removeEventListener("contextmenu", this.handleContextMenu)
    }
    if (this.menu) {
      this.menu.removeEventListener("click", this.handleMenuClick)
    }
    document.removeEventListener("keydown", this.handleKeyDown)
  },
}
