/**
 * LocalTime Hook - Client-side timezone conversion for datetime elements
 *
 * This hook automatically converts UTC datetime values to the user's local timezone.
 * It finds all elements with the `data-local-time` attribute and formats them based
 * on the `data-format` attribute.
 *
 * Formats:
 * - relative: "2 hours ago", "in 3 days"
 * - short: "Nov 16, 2:00 PM"
 * - long: "November 16, 2025 at 2:00 PM"
 * - date: "November 16, 2025"
 * - time: "2:00 PM"
 */

export const LocalTime = {
  mounted() {
    this.formatTime()
  },

  updated() {
    this.formatTime()
  },

  formatTime() {
    const isoString = this.el.getAttribute('datetime')
    const format = this.el.getAttribute('data-format') || 'relative'

    if (!isoString) return

    try {
      const date = new Date(isoString)

      // Check if date is valid
      if (isNaN(date.getTime())) {
        console.warn('Invalid datetime:', isoString)
        return
      }

      const formatted = this.formatDate(date, format)
      this.el.textContent = formatted

      // Add title attribute with full datetime for hover tooltip
      if (format === 'relative') {
        this.el.title = this.formatDate(date, 'long')
      }
    } catch (error) {
      console.error('Error formatting datetime:', error)
    }
  },

  formatDate(date, format) {
    const now = new Date()
    const diffMs = now - date
    const diffSecs = Math.floor(diffMs / 1000)
    const diffMins = Math.floor(diffSecs / 60)
    const diffHours = Math.floor(diffMins / 60)
    const diffDays = Math.floor(diffHours / 24)

    switch (format) {
      case 'relative':
        return this.formatRelative(diffSecs, diffMins, diffHours, diffDays, date)

      case 'short':
        return new Intl.DateTimeFormat(undefined, {
          month: 'short',
          day: 'numeric',
          year: 'numeric',
          hour: 'numeric',
          minute: '2-digit',
        }).format(date)

      case 'long':
        return new Intl.DateTimeFormat(undefined, {
          month: 'long',
          day: 'numeric',
          year: 'numeric',
          hour: 'numeric',
          minute: '2-digit',
        }).format(date)

      case 'date':
        return new Intl.DateTimeFormat(undefined, {
          month: 'long',
          day: 'numeric',
          year: 'numeric',
        }).format(date)

      case 'time':
        return new Intl.DateTimeFormat(undefined, {
          hour: 'numeric',
          minute: '2-digit',
        }).format(date)

      default:
        return date.toLocaleString()
    }
  },

  formatRelative(diffSecs, diffMins, diffHours, diffDays, date) {
    const absSeconds = Math.abs(diffSecs)
    const absMinutes = Math.abs(diffMins)
    const absHours = Math.abs(diffHours)
    const absDays = Math.abs(diffDays)

    // Future dates
    if (diffSecs < 0) {
      if (absSeconds < 60) return 'in a moment'
      if (absMinutes < 60) return `in ${absMinutes} ${absMinutes === 1 ? 'minute' : 'minutes'}`
      if (absHours < 24) return `in ${absHours} ${absHours === 1 ? 'hour' : 'hours'}`
      if (absDays < 30) return `in ${absDays} ${absDays === 1 ? 'day' : 'days'}`
      // For dates more than 30 days in the future, show absolute date
      return new Intl.DateTimeFormat(undefined, {
        month: 'short',
        day: 'numeric',
        year: 'numeric',
      }).format(date)
    }

    // Past dates
    if (diffSecs < 60) return 'just now'
    if (diffMins < 60) return `${diffMins} ${diffMins === 1 ? 'minute' : 'minutes'} ago`
    if (diffHours < 24) return `${diffHours} ${diffHours === 1 ? 'hour' : 'hours'} ago`
    if (diffDays < 30) return `${diffDays} ${diffDays === 1 ? 'day' : 'days'} ago`

    // For dates more than 30 days ago, show absolute date
    return new Intl.DateTimeFormat(undefined, {
      month: 'short',
      day: 'numeric',
      year: 'numeric',
    }).format(date)
  },
}
