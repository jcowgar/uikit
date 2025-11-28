---
description: Convert a shadcn/ui component to Phoenix LiveView
args:
  component_name:
    description: Name of the shadcn component to convert (e.g., button, input, card)
    required: true
  category:
    description: Category file to place it in (form_input, layout_navigation, overlays_dialogs, feedback_status, display_media, miscellaneous)
    required: false
---

# Convert shadcn/ui Component to Phoenix LiveView

You are converting a shadcn/ui component to a Phoenix LiveView function component.

## Component to Convert: {{component_name}}

{{#if category}}
Target category: {{category}}
{{else}}
Auto-detect the appropriate category based on component type.
{{/if}}

## Step 1: Review Documentation

**First, read the component documentation** to understand all variants, use cases, and composition patterns:

Visit: `https://ui.shadcn.com/docs/components/{{component_name}}`

This shows:
- All available variants (visual examples)
- Size options
- Composition patterns (e.g., Card = Card + CardHeader + CardTitle + CardContent)
- Accessibility considerations
- Common usage patterns

## Step 2: Fetch the Source

Run this command to fetch the shadcn component source:
```bash
pnpm dlx shadcn@latest view {{component_name}}
```

This will output JSON with the component source in the `content` field.

## Step 3: Determine Category

{{#if category}}
Using specified category: **{{category}}**
{{else}}
**If no category specified**, fetch the official categorization:

Visit: `https://ui.shadcn.com/llms.txt` to see the official component organization.

Based on shadcn's organization from llms.txt, place the component in the appropriate category file:
{{/if}}

- **form_input.ex** - Form & Input components (Button, Input, Checkbox, Label, Textarea, Select, Switch, Radio Group, Slider, Form, Date Picker, Combobox, etc.)
- **layout_navigation.ex** - Layout & Navigation components (Accordion, Breadcrumb, Sidebar, Tabs, Navigation Menu, Separator, Scroll Area, Resizable)
- **overlays_dialogs.ex** - Overlays & Dialogs components (Dialog, Drawer, Popover, Tooltip, Dropdown Menu, Context Menu, Menubar, Command, Alert Dialog, Sheet)
- **feedback_status.ex** - Feedback & Status components (Alert, Badge, Progress, Toast/Sonner, Skeleton, Spinner)
- **display_media.ex** - Display & Media components (Avatar, Card, Table, Data Table, Chart, Carousel, Typography, Aspect Ratio, Calendar, Pagination)
- **miscellaneous.ex** - Misc components (Toggle, Toggle Group, Collapsible, Hover Card, Pagination)

Create the category file at: `lib/decree_web/components/ui/{{category}}.ex`

## Step 4: Translation Guidelines

### Module Structure
```elixir
defmodule DecreeWeb.UI.{{CategoryName}} do
  @moduledoc """
  {{Category description}}

  Components ported from shadcn/ui.
  """
  use Phoenix.Component
  use Gettext, backend: DecreeWeb.Gettext

  alias Phoenix.LiveView.JS

  # Component functions here...
end
```

### Converting React/TypeScript to Phoenix/Elixir

1. **Props → Attributes**
   ```typescript
   // React
   interface ButtonProps {
     variant?: "default" | "destructive" | "outline"
     size?: "default" | "sm" | "lg"
     className?: string
     disabled?: boolean
   }
   ```

   ```elixir
   # Phoenix
   attr :variant, :string, default: "default", values: ~w(default destructive outline)
   attr :size, :string, default: "default", values: ~w(default sm lg)
   attr :class, :string, default: nil
   attr :rest, :global, include: ~w(disabled)
   slot :inner_block, required: true
   ```

2. **Variants using Maps (not CVA)**
   ```typescript
   // React with class-variance-authority
   const buttonVariants = cva("base-classes", {
     variants: { ... }
   })
   ```

   ```elixir
   # Phoenix with maps
   def component(assigns) do
     variants = %{
       "default" => "bg-primary text-primary-foreground",
       "destructive" => "bg-destructive text-white"
     }

     assigns = assign_new(assigns, :class, fn ->
       ["base-classes", Map.fetch!(variants, assigns[:variant])]
     end)

     ~H"""
     <button class={@class} {@rest}>
       {render_slot(@inner_block)}
     </button>
     """
   end
   ```

3. **Conditional Classes**
   ```typescript
   // React
   className={cn("base", variant === "default" && "extra")}
   ```

   ```elixir
   # Phoenix
   class={[
     "base",
     @variant == "default" && "extra"
   ]}
   ```

4. **Children → Slots**
   ```typescript
   // React
   {children}
   ```

   ```elixir
   # Phoenix
   {render_slot(@inner_block)}
   ```

5. **Ignore React/Radix Dependencies**
   - Skip `@radix-ui/*` imports (we'll handle behavior differently)
   - Skip `React.forwardRef`, hooks, etc.
   - Focus on extracting Tailwind classes and variant logic

### Tailwind Class Conversion

Most Tailwind classes transfer 1:1, but watch for:
- Classes work the same in HEEx
- Use list syntax for conditional classes: `class={["base", @condition && "extra"]}`
- Phoenix doesn't need `cn()` utility - just use lists

**IMPORTANT: Always use semantic color tokens from the design system:**
- ✅ Use: `bg-primary`, `text-foreground`, `border-border`, `bg-destructive`
- ❌ Avoid: `bg-blue-600`, `text-gray-900`, `border-gray-200`, `bg-red-500`

See `CLAUDE.md` for the complete list of semantic tokens (bg-background, bg-surface, text-muted-foreground, etc.)

### Component Composition

If the shadcn component has sub-components (e.g., Card, CardHeader, CardContent):
```elixir
def card(assigns) do
  ~H"""
  <div class={["card-classes", @class]} {@rest}>
    {render_slot(@inner_block)}
  </div>
  """
end

def card_header(assigns) do
  ~H"""
  <div class="card-header-classes">
    {render_slot(@inner_block)}
  </div>
  """
end
```

## Step 5: File Location

Place the component in: `lib/decree_web/components/ui/{{category}}.ex`

If the file doesn't exist, create it with the module structure from Step 4.

## Step 6: Import Setup

After creating/updating the component file, ensure it's imported in `lib/decree_web.ex`:

```elixir
defp html_helpers do
  quote do
    # ... existing imports
    import DecreeWeb.UI.{{CategoryName}}
    # ...
  end
end
```

## Step 7: Testing

After conversion:
1. Start the Phoenix server: `mix phx.server`
2. Create or update a test page under `lib/decree_web/live/ui/{category}.ex`
3. Ensure proper route is setup in `lib/decree_web/router.ex`
4. Add examples of all variants and sizes shown in the documentation
5. Ensure that `ui/live_index.ex` file has a link
6. **Add component to sidebar navigation** in `lib/decree_web/shared/components/layouts/ui.html.heex` under the appropriate category section
7. Give URL to user to verify appearance and functionality

## Notes

- Keep the spirit of shadcn: components you own and can customize
- Don't try to be a perfect 1:1 port - adapt to Phoenix idioms
- Focus on Tailwind classes and visual appearance
- Behavior/interactions may need Phoenix-specific solutions (LiveView events, JS commands)
- Document any deviations from the original shadcn component

### Interactive Components

For components with interactions (dropdowns, modals, tooltips, etc.):
- Use `Phoenix.LiveView.JS` for client-side interactions without server round-trips
- Common JS commands: `JS.show()`, `JS.hide()`, `JS.toggle()`, `JS.add_class()`, `JS.remove_class()`
- For more complex state, consider LiveView events with `phx-click`, `phx-change`, etc.
- Example: A dropdown can use `JS.toggle()` to show/hide without hitting the server

```elixir
def dropdown_toggle(assigns) do
  ~H"""
  <button phx-click={JS.toggle(to: "#dropdown-menu")}>
    Toggle
  </button>
  <div id="dropdown-menu" class="hidden">
    Menu content
  </div>
  """
end
```
