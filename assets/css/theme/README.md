# Design Token Reference

This directory contains the semantic design tokens for the application.

## Quick Reference

### Colors

#### Base
- `bg-background` / `text-background`
- `bg-foreground` / `text-foreground`
- `bg-surface` / `text-surface`
- `bg-card` / `text-card`
- `bg-card-foreground` / `text-card-foreground`
- `bg-muted` / `text-muted`
- `bg-muted-foreground` / `text-muted-foreground`

#### Borders
- `border-border`
- `border-input`
- `ring-ring`

#### Brand
- `bg-primary` / `text-primary` / `border-primary`
- `bg-primary-foreground` / `text-primary-foreground`
- `bg-secondary` / `text-secondary`
- `bg-secondary-foreground` / `text-secondary-foreground`
- `bg-accent` / `text-accent`
- `bg-accent-foreground` / `text-accent-foreground`

#### States
- `bg-destructive` / `text-destructive` / `border-destructive`
- `bg-destructive-foreground` / `text-destructive-foreground`
- `bg-success` / `text-success`
- `bg-success-foreground` / `text-success-foreground`
- `bg-warning` / `text-warning`
- `bg-warning-foreground` / `text-warning-foreground`
- `bg-info` / `text-info`
- `bg-info-foreground` / `text-info-foreground`

### Spacing (for component gaps)

Use for spacing BETWEEN components:
- `gap-space-xs` (8px)
- `gap-space-sm` (12px)
- `gap-space-md` (16px)
- `gap-space-lg` (24px)
- `gap-space-xl` (32px)
- `gap-space-2xl` (48px)

Also works with: `space-y-space-md`, `space-x-space-lg`, etc.

### Typography Utilities

Optional semantic classes (or use raw Tailwind):
- `text-body-sm` - Small body text
- `text-body` - Regular body text
- `text-body-lg` - Large body text
- `text-heading-sm` - Small heading
- `text-heading` - Regular heading
- `text-heading-lg` - Large heading
- `text-heading-xl` - Extra large heading
- `text-muted-text` - Muted/secondary text

### Effects

Shadows (theme-aware):
- `shadow-sm`
- `shadow-md`
- `shadow-lg`
- `shadow-xl`

Border radius:
- `rounded-sm`
- `rounded-md`
- `rounded-lg`
- `rounded-xl`
- `rounded-full`

## Opacity Modifiers

All color tokens support Tailwind's opacity syntax:

```heex
<div class="bg-primary/90">90% opacity</div>
<div class="text-muted-foreground/50">50% opacity text</div>
<div class="border-border/20">20% opacity border</div>
```

## Theme Switching

Toggle between light and dark themes by setting the `data-theme` attribute on the `<body>` or any parent element:

```html
<!-- Light mode (default) -->
<body>...</body>

<!-- Dark mode -->
<body data-theme="dark">...</body>
```

All semantic tokens automatically adjust based on the theme.
