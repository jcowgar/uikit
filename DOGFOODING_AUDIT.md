# UI Kit Dogfooding Audit

This document tracks instances where UI Kit components are using raw HTML elements instead of existing components from the library. The goal is to have components "eat their own dog food" by using the library's own primitives.

## Summary

| Category | Count | Status |
|----------|-------|--------|
| Raw `<button>` that should use `<.button>` | 22 | **RESOLVED** |
| Raw `<div class="flex...">` that could use `<.flex>` | 40+ | **RESOLVED** |
| Raw `<div class="space-y-*">` that could use `<.stack>` | 10 | **RESOLVED** |
| Raw `<span class="hero-*">` that should use `<.icon>` | 1 | **RESOLVED** |
| Raw `<label>` that could use `<.label>` | 2 | **RESOLVED** |

---

## Category 1: Raw `<button>` Elements - RESOLVED

### High Priority (Close Buttons - Pattern Duplication) - DONE

Created `<.close_button>` component and updated all close buttons:

| File | Line | Component | Status |
|------|------|-----------|--------|
| `core_components.ex` | 83 | Flash close button | [x] Uses `<.close_button>` |
| `feedback_status.ex` | 485 | Sonner toast close button | [x] Uses `<.close_button>` |
| `overlays_dialogs.ex` | 1715-1718 | Sheet close button | [x] Uses `<.close_button>` |
| `overlays_dialogs.ex` | 2625-2629 | Dialog close button | [x] Uses `<.close_button>` |

### High Priority (Action Buttons - Style Duplication) - DONE

Updated to use `<.button>` with appropriate variants:

| File | Component | Status |
|------|-----------|--------|
| `overlays_dialogs.ex` | `alert_dialog_action` | [x] Uses `<.button>` |
| `overlays_dialogs.ex` | `alert_dialog_cancel` | [x] Uses `<.button variant="outline">` |
| `overlays_dialogs.ex` | `dialog_footer` auto_cancel | [x] Uses `<.button variant="outline">` |
| `overlays_dialogs.ex` | `destructive_confirmation_dialog` cancel | [x] Uses `<.button variant="outline">` |
| `overlays_dialogs.ex` | `destructive_confirmation_dialog` confirm | [x] Uses `<.button variant="destructive">` |

### Medium Priority (Specialized Trigger Buttons) - DONE

All trigger components now use `<.button variant="unstyled">`:

| File | Component | Status |
|------|-----------|--------|
| `layout_navigation.ex` | `sidebar_trigger` | [x] Uses `<.button variant="unstyled">` |
| `layout_navigation.ex` | `sidebar_rail` | [x] Uses `<.button variant="unstyled">` |
| `layout_navigation.ex` | `sidebar_group_action` | [x] Uses `<.button variant="unstyled">` |
| `layout_navigation.ex` | `sidebar_menu_button` (non-link) | [x] Uses `<.button variant="unstyled">` |
| `layout_navigation.ex` | `sidebar_menu_action` | [x] Uses `<.button variant="unstyled">` |
| `layout_navigation.ex` | `sidebar_menu_sub_button` (non-link) | [x] Uses `<.button variant="unstyled">` |
| `layout_navigation.ex` | `tabs_trigger` | [x] Uses `<.button variant="unstyled">` |
| `layout_navigation.ex` | `accordion_trigger` | [x] Uses `<.button variant="unstyled">` |
| `miscellaneous.ex` | `collapsible_trigger` | [x] Uses `<.button variant="unstyled">` |
| `miscellaneous.ex` | `toggle_group_item` | [x] Uses `<.button variant="unstyled">` |

### Low Priority (Hidden/Utility Buttons) - Acceptable

These are hidden utility buttons for programmatic control - acceptable as raw elements:

| File | Component | Notes |
|------|-----------|-------|
| `overlays_dialogs.ex` | Alert dialog server-close | Hidden, programmatic - OK |
| `overlays_dialogs.ex` | Dialog server-close | Hidden, programmatic - OK |
| `overlays_dialogs.ex` | Drawer close | Hidden, programmatic - OK |

### Low Priority (Form Components - Semantic Elements) - Acceptable

These use `<button>` because they ARE buttons with special form semantics:

| File | Component | Notes |
|------|-----------|-------|
| `form_input.ex` | `button` component | This IS the button component - N/A |
| `form_input.ex` | `switch` | Uses button for toggle semantics - OK |
| `form_input.ex` | `radio_group_item` | Radio button semantics - OK |
| `form_input.ex` | `range_slider` | Slider semantics - OK |
| `form_input.ex` | `stepper` | +/- stepper buttons - OK |
| `combobox.ex` | Chip remove button | [x] Uses `<.close_button variant="chip">` |
| `chip_input.ex` | Chip remove button | [x] Uses `<.close_button variant="chip">` |
| `kanban.ex` | Column collapse button | Kanban-specific - OK |

---

## Category 2: Raw `<div class="flex...">` Elements - RESOLVED

Enhanced `<.flex>` component with granular control (`justify`, `items`, `gap`, `wrap`, `direction`) and updated all component code and docstring examples to use it.

---

## Category 3: Raw `<div class="space-y-*">` Elements - RESOLVED

Updated all raw space-y divs to use `<.stack>` component with appropriate gap values.

---

## Category 4: Raw `<span class="hero-*">` Instead of `<.icon>` - RESOLVED

| File | Line | Status |
|------|------|--------|
| `form_input.ex` | 542 | [x] Fixed - now uses `<.icon name="hero-question-mark-circle" class="size-5" />` |

---

## Category 5: Raw `<label>` Elements - RESOLVED

Updated 2 raw label elements in docstring examples to use `<.label>` component.

---

## Completed Actions

### Phase 1: Quick Wins - COMPLETE
1. [x] Fix raw `<span class="hero-*">` → `<.icon>` (1 instance)
2. [x] Create `<.close_button>` component for modal/dialog/sheet close buttons
3. [x] Update `alert_dialog_action` and `alert_dialog_cancel` to use `<.button>`
4. [x] Update `dialog_footer` auto_cancel to use `<.button>`
5. [x] Update `destructive_confirmation_dialog` buttons to use `<.button>`

### Phase 2: Component Enhancement - COMPLETE
1. [x] `size="icon"` variant already exists (`icon`, `icon-sm`, `icon-lg`)
2. [x] Added `variant="unstyled"` to `<.button>` for trigger use cases
3. [x] Expanded button's ARIA include list (`role`, `aria-expanded`, `aria-controls`, `aria-pressed`, `aria-haspopup`, `aria-describedby`)
4. [x] All trigger components now compose `<.button variant="unstyled">`

### Phase 3: Documentation - COMPLETE
1. [x] Updated all docstring examples to use proper components (`<.flex>`, `<.stack>`, `<.label>`)

### Phase 4: Layout Components - COMPLETE
1. [x] Enhanced `<.flex>` with separate `justify` and `items` attributes for granular control
2. [x] Enhanced `<.flex>` with consistent gap naming (`none`, `xs`, `sm`, `default`, `md`, `lg`, `xl`)
3. [x] Enhanced `<.stack>` with `gap` attribute (replacing `size`) using same naming for consistency
4. [x] Enhanced `<.grid>` with consistent gap naming (`none`, `xs`, `sm`, `default`, `md`, `lg`, `xl`)
5. [x] Updated all raw flex and stack divs across all component files
6. [x] Updated all demo app files to use new layout component APIs

---

## Notes

### New Components Created
- `<.close_button>` - Reusable close button with variants (`default`, `ghost`, `chip`) and sizes (`sm`, `default`, `lg`)

### Button Component Enhancements
- Added `variant="unstyled"` - Renders a button with no default styling, allowing full customization
- Expanded ARIA attribute documentation in the `include` list
- Changed `class` attribute type from `:string` to `:any` to support class lists

### Legitimate Raw Element Usage

Some raw elements remain acceptable:
- The `button` component itself uses `<button>` (it IS the primitive)
- The `close_button` component uses raw `<button>` (to avoid circular dependency)
- Hidden utility buttons for programmatic control
- Form elements with specific ARIA/semantic requirements (switch, radio, slider)
- Elements inside slots where the user provides content

---

## Progress Tracking

- **Last Updated**: 2025-11-28
- **Audit Completed By**: Claude
- **All Categories**: RESOLVED
- **Overall Progress**: Complete - all identified dogfooding issues have been addressed

### Changelog

- **2025-11-28**:
  - Added `variant="unstyled"` to button component
  - Expanded button ARIA include list
  - Created `<.close_button>` component
  - Fixed raw span hero icon
  - Updated all close buttons to use `<.close_button>`
  - Updated all action/cancel buttons to use `<.button>`
  - Updated all trigger components to use `<.button variant="unstyled">`
  - Added `variant="chip"` to `<.close_button>` for chip/badge remove buttons
  - Updated `combobox.ex` and `chip_input.ex` chip remove buttons to use `<.close_button variant="chip">`
  - Enhanced `<.flex>` component with separate `justify` and `items` attributes
  - Enhanced `<.flex>`, `<.stack>`, and `<.grid>` with consistent gap naming (`none`, `xs`, `sm`, `default`, `md`, `lg`, `xl`)
  - Replaced `<.stack size="...">` with `<.stack gap="...">` for API consistency
  - Updated all raw `<div class="flex...">` to use `<.flex>` across all component files
  - Updated all raw `<div class="space-y-*">` to use `<.stack>`
  - Updated all raw `<label>` in docstrings to use `<.label>`
  - Fixed JS chip_input hook to match server-rendered component output exactly
  - Updated all 47 demo app files to use new layout component APIs
