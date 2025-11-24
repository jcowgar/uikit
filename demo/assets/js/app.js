// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//
// If you have dependencies that try to import CSS, esbuild will generate a separate `app.css` file.
// To load it, simply add a second `<link>` to your `root.html.heex` file.

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"
// Theme management - auto-detects system preference
import {toggleTheme, getThemePreference} from "../../../assets/js/theme"
// Sidebar state management
import {SidebarHook, SidebarTriggerHook} from "../../../assets/js/sidebar"
// Tabs state management
import {TabsHook} from "../../../assets/js/tabs"
// Collapsible state management with localStorage persistence
import {CollapsibleHook} from "../../../assets/js/collapsible"
// Select dropdown with keyboard navigation
import {SelectDropdown} from "../../../assets/js/hooks/select_dropdown"
// Sortable drag-and-drop reordering
import {SortableHook} from "../../../assets/js/hooks/sortable"
// Kanban swimlane collapse/expand
import {KanbanSwimlaneHook} from "../../../assets/js/hooks/kanban_swimlane"
// Markdown renderer using marked.js
import {MarkdownRenderer} from "../../../assets/js/hooks/markdown"
// File upload and download hooks
import {FileUpload, Download} from "../../../assets/js/hooks/file_transfer"
// Command menu client-side filtering, keyboard navigation, and auto-focus
import {CommandFilter, CommandKeyboard, CommandInputFocus} from "../../../assets/js/hooks/command"
// Chip input keyboard interactions
import {ChipInput} from "../../../assets/js/hooks/chip_input"
// Combobox chip removal
import {Combobox} from "../../../assets/js/hooks/combobox"
// Slug generator for organization creation
import SlugGenerator from "../../../assets/js/hooks/slug_generator"
// Local time conversion for automatic timezone handling
import {LocalTime} from "../../../assets/js/hooks/local_time"
// Dropdown positioning to escape overflow containers
import {PositionDropdown} from "../../../assets/js/hooks/position_dropdown"
// Chart.js integration for data visualization
import {ChartHook} from "../../../assets/js/hooks/chart"
// Mobile Tab Bar navigation
import {TabBarHook} from "../../../assets/js/hooks/tab_bar_hook"
// Accordion collapsible sections
import AccordionHook from "../../../assets/js/hooks/accordion"
// Context menu for right-click menus
import {ContextMenu} from "../../../assets/js/hooks/context_menu"

// Custom hooks for LiveView components
const Hooks = {
  ThemeToggle: {
    mounted() {
      // Handle clicks on theme buttons
      this.handleClick = (e) => {
        const button = e.target.closest('button')
        if (!button) return

        const action = button.dataset.themeAction
        if (action === 'system') {
          // Clear localStorage to use system preference
          localStorage.removeItem('decree-theme')
          // Re-initialize to apply system theme
          const {initTheme} = require('../../../assets/js/theme')
          initTheme()
        } else if (action === 'light' || action === 'dark') {
          const {setTheme} = require('../../../assets/js/theme')
          setTheme(action)
        }
      }

      this.el.addEventListener('click', this.handleClick)
    },
    destroyed() {
      this.el.removeEventListener('click', this.handleClick)
    }
  },
  Sidebar: SidebarHook,
  SidebarTrigger: SidebarTriggerHook,
  Tabs: TabsHook,
  Collapsible: CollapsibleHook,
  SelectDropdown: SelectDropdown,
  Sortable: SortableHook,
  KanbanSwimlane: KanbanSwimlaneHook,
  MarkdownRenderer: MarkdownRenderer,
  FileUpload: FileUpload,
  Download: Download,
  CommandFilter: CommandFilter,
  CommandKeyboard: CommandKeyboard,
  CommandInputFocus: CommandInputFocus,
  ChipInput: ChipInput,
  Combobox: Combobox,
  SlugGenerator: SlugGenerator,
  LocalTime: LocalTime,
  PositionDropdown: PositionDropdown,
  Chart: ChartHook,
  TabBar: TabBarHook,
  Accordion: AccordionHook,
  ContextMenu: ContextMenu,
  // ... (Other hooks can be copied if needed, but let's start with these)
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: Hooks
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

// The lines below enable quality of life phoenix_live_reload
// development features:
//
//     1. stream server logs to the browser console
//     2. click on elements to jump to their definitions in your code editor
//
if (process.env.NODE_ENV === "development") {
  window.addEventListener("phx:live_reload:attached", ({detail: reloader}) => {
    // Enable server log streaming to client.
    // Disable with reloader.disableServerLogs()
    reloader.enableServerLogs()

    // Open configured PLUG_EDITOR at file:line of the clicked element's HEEx component
    //
    //   * click with "c" key pressed to open at caller location
    //   * click with "d" key pressed to open at function component definition location
    let keyDown
    window.addEventListener("keydown", e => keyDown = e.key)
    window.addEventListener("keyup", e => keyDown = null)
    window.addEventListener("click", e => {
      if(keyDown === "c"){
        e.preventDefault()
        e.stopImmediatePropagation()
        reloader.openEditorAtCaller(e.target)
      } else if(keyDown === "d"){
        e.preventDefault()
        e.stopImmediatePropagation()
        reloader.openEditorAtDef(e.target)
      }
    }, true)

    window.liveReloader = reloader
  })
}

