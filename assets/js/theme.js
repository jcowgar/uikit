/**
 * Theme Management
 *
 * Handles automatic theme detection and switching between light/dark modes.
 * Respects system preferences and persists user choice to localStorage.
 */

const THEME_STORAGE_KEY = 'decree-theme'
const THEME_ATTRIBUTE = 'data-theme'

/**
 * Get the current theme preference
 * Priority: localStorage > system preference > 'light' (default)
 */
function getThemePreference() {
  // Check if user has explicitly set a preference
  const stored = localStorage.getItem(THEME_STORAGE_KEY)
  if (stored === 'light' || stored === 'dark') {
    return stored
  }

  // Check system preference
  if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
    return 'dark'
  }

  return 'light'
}

/**
 * Apply theme to the document
 */
function applyTheme(theme) {
  if (theme === 'dark') {
    document.documentElement.setAttribute(THEME_ATTRIBUTE, 'dark')
  } else {
    document.documentElement.removeAttribute(THEME_ATTRIBUTE)
  }
}

/**
 * Set theme and persist to localStorage
 */
function setTheme(theme) {
  localStorage.setItem(THEME_STORAGE_KEY, theme)
  applyTheme(theme)

  // Dispatch event for components that need to react to theme changes
  window.dispatchEvent(new CustomEvent('theme-changed', { detail: { theme } }))
}

/**
 * Toggle between light and dark themes
 */
function toggleTheme() {
  const current = getThemePreference()
  const next = current === 'light' ? 'dark' : 'light'
  setTheme(next)
  return next
}

/**
 * Initialize theme on page load
 * This runs immediately to prevent flash of wrong theme
 */
function initTheme() {
  const theme = getThemePreference()
  applyTheme(theme)

  // Listen for system theme changes (if no explicit user preference is set)
  if (window.matchMedia) {
    const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)')
    mediaQuery.addEventListener('change', (e) => {
      // Only auto-switch if user hasn't explicitly set a preference
      const storedPreference = localStorage.getItem(THEME_STORAGE_KEY)
      if (!storedPreference) {
        const systemTheme = e.matches ? 'dark' : 'light'
        applyTheme(systemTheme)
        window.dispatchEvent(new CustomEvent('theme-changed', { detail: { theme: systemTheme } }))
      }
    })
  }
}

// Initialize theme immediately (before DOM loads to prevent flash)
initTheme()

// Export functions for use in LiveView hooks or other JS modules
export { getThemePreference, setTheme, toggleTheme, initTheme }
