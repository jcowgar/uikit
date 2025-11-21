# UiKit

A reusable Phoenix LiveView UI component library.

## Installation

### 1. Add Dependencies

Add `ui_kit` to your `mix.exs`. You also need `heroicons` (required by the icon components).

```elixir
def deps do
  [
    {:ui_kit, git: "https://github.com/your_username/ui_kit.git"}, # Until published to Hex
    # or if local: {:ui_kit, path: "../ui_kit"},
    
    # Heroicons is required
    {:heroicons,
     github: "tailwindlabs/heroicons",
     tag: "v2.2.0",
     sparse: "optimized",
     app: false,
     compile: false,
     depth: 1}
  ]
end
```

### 2. Configure CSS (Tailwind CSS 4)

This library is designed for **Tailwind CSS 4**. You must import the source files directly into your application's CSS so they are compiled with your theme settings.

In your `assets/css/app.css`:

```css
@import "tailwindcss";

/* 1. Tell Tailwind to scan the library for classes */
@source "../deps/ui_kit";

/* 2. Import the Design System Tokens (Colors, Spacing, Typography) */
@import "../deps/ui_kit/assets/css/theme/colors.css";
@import "../deps/ui_kit/assets/css/theme/spacing.css";
@import "../deps/ui_kit/assets/css/theme/typography.css";
@import "../deps/ui_kit/assets/css/theme/effects.css";

/* 3. (Optional) Import Syntax Highlighting Theme if using Markdown */
@import "../deps/ui_kit/assets/css/highlight-theme.css";

/* ... your other imports ... */
```

> **Note:** If you are using a local path dependency (e.g., `path: "../ui_kit"`), the path would be `@source "../../../ui_kit"` and `@import "../../../ui_kit/..."` depending on your folder structure.

### 3. JavaScript Dependencies

This library uses several JavaScript hooks for interactivity. You need to install the underlying NPM packages and import the hooks.

#### Install NPM Packages

Run this in your `assets` directory:

```bash
cd assets
npm install sortablejs chart.js marked marked-highlight highlight.js mermaid
```

*   `sortablejs`: For drag-and-drop lists.
*   `chart.js`: For chart components.
*   `marked`, `marked-highlight`, `highlight.js`, `mermaid`: For the Markdown renderer.

#### Import Hooks

In your `assets/js/app.js`:

```javascript
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"

// --- UI Kit Hooks Imports ---
// Adjust the path to point to the dependency
// If using Hex/Git deps, it's usually inside ../deps/ui_kit
import { toggleTheme } from "../deps/ui_kit/assets/js/theme"
import { SidebarHook, SidebarTriggerHook } from "../deps/ui_kit/assets/js/sidebar"
import { TabsHook } from "../deps/ui_kit/assets/js/tabs"
import { CollapsibleHook } from "../deps/ui_kit/assets/js/collapsible"
import { SelectDropdown } from "../deps/ui_kit/assets/js/hooks/select_dropdown"
import { SortableHook } from "../deps/ui_kit/assets/js/hooks/sortable"
import { KanbanSwimlaneHook } from "../deps/ui_kit/assets/js/hooks/kanban_swimlane"
import { MarkdownRenderer } from "../deps/ui_kit/assets/js/hooks/markdown"
import { FileUpload, Download } from "../deps/ui_kit/assets/js/hooks/file_transfer"
import { CommandFilter, CommandKeyboard, CommandInputFocus } from "../deps/ui_kit/assets/js/hooks/command"
import { ChipInput } from "../deps/ui_kit/assets/js/hooks/chip_input"
import { Combobox } from "../deps/ui_kit/assets/js/hooks/combobox"
import SlugGenerator from "../deps/ui_kit/assets/js/hooks/slug_generator"
import { LocalTime } from "../deps/ui_kit/assets/js/hooks/local_time"
import { PositionDropdown } from "../deps/ui_kit/assets/js/hooks/position_dropdown"
import { ChartHook } from "../deps/ui_kit/assets/js/hooks/chart"

// Define the Hooks object
const Hooks = {
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
  
  // Theme Toggle Hook
  ThemeToggle: {
    mounted() {
      this.handleClick = (e) => {
        const button = e.target.closest('button')
        if (!button) return
        const action = button.dataset.themeAction
        if (action === 'system') {
          localStorage.removeItem('decree-theme')
          // You might need to re-import initTheme or expose it
          document.documentElement.removeAttribute('data-theme')
        } else if (action === 'light' || action === 'dark') {
           const { setTheme } = require('../deps/ui_kit/assets/js/theme')
           setTheme(action)
        }
      }
      this.el.addEventListener('click', this.handleClick)
    },
    destroyed() {
      this.el.removeEventListener('click', this.handleClick)
    }
  }
}

// Initialize LiveSocket with Hooks
let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: Hooks
})
```

### 4. Heroicons Configuration

Ensure your `assets/vendor/heroicons.js` (standard in Phoenix) is configured and imported in your `assets/css/app.css`:

```css
@plugin "../vendor/heroicons";
```

## Usage

You can now use the components in your HEEx templates.

```heex
<.button>Click Me</.button>
```

(See `lib/ui_kit/components` for available components).