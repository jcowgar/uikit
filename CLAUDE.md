# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

UiKit is a reusable Phoenix LiveView UI component library built with Tailwind CSS 4 and semantic design tokens. It provides themed, accessible components for Elixir/Phoenix applications.

## Commands

```bash
# Install dependencies (from ui_kit root)
mix deps.get

# Run tests
mix test

# Run a single test file
mix test test/ui_kit/components/ui/layout_navigation_test.exs

# Format code
mix format

# Compile with warnings as errors
mix compile --warning-as-errors

# Demo app commands (from demo/ directory)
cd demo && mix setup              # Install deps and build assets
cd demo && mix phx.server         # Start dev server at localhost:4000
cd demo && mix precommit          # Run compile, format, test
```

## Architecture

### Library Structure (`lib/ui_kit/`)

- `components/core_components.ex` - Base components (flash, header, table, forms, icon)
- `components/layout_components.ex` - Layout primitives
- `components/ui/` - Feature-specific component modules:
  - `form_input.ex` - Form controls (button, input, select, checkbox, slider, etc.)
  - `layout_navigation.ex` - Navigation (tabs, sidebar, breadcrumb, accordion, etc.)
  - `overlays_dialogs.ex` - Modal, drawer, sheet, context menu, dropdown, tooltip
  - `feedback_status.ex` - Alert, badge, progress, skeleton, toast (sonner)
  - `display_media.ex` - Avatar, card, chart, markdown, calendar
  - `kanban.ex` - Drag-and-drop kanban board
  - `command.ex` - Command palette (Cmd+K)
  - `combobox.ex`, `chip_input.ex` - Advanced form controls

### JavaScript Hooks (`assets/js/`)

Components requiring client-side interactivity use LiveView hooks:
- `hooks/` - Component-specific hooks (sortable, chart, markdown, slider, etc.)
- `sidebar.js`, `tabs.js`, `collapsible.js` - Layout behavior hooks
- `theme.js` - Dark/light theme switching

### Design Tokens (`assets/css/theme/`)

Semantic CSS custom properties for theming:
- `colors.css` - Color tokens (bg-background, text-foreground, bg-primary, etc.)
- `spacing.css` - Gap tokens (gap-space-sm, gap-space-md, etc.)
- `typography.css` - Text utilities (text-body, text-heading-lg, etc.)
- `effects.css` - Shadows and border radius

Theme switching via `data-theme="dark"` attribute on body.

### Demo App (`demo/`)

Phoenix app for component development and visual testing. Uses `{:ui_kit, path: ".."}` dependency.

## Component Patterns

Components use Phoenix.Component with declarative assigns:
```elixir
attr :variant, :string, default: "default", values: ~w(default outline ghost)
attr :size, :string, default: "md", values: ~w(sm md lg)
slot :inner_block, required: true
```

Styling uses semantic design tokens for colors (`bg-primary`, `text-muted-foreground`) but raw Tailwind for layout (`px-4`, `py-2`, `gap-2`).

Icon component wraps Heroicons: `<.icon name="hero-check" class="size-5" />`
