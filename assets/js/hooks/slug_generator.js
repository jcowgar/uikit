export default {
  mounted() {
    // Find the organization name input field in the same form
    const nameInput = this.el.form.querySelector('input[name="organization[name]"]')
    const slugInput = this.el

    // Track whether user has manually edited the slug
    let userEditedSlug = false

    // Mark as manually edited when user types in slug field
    slugInput.addEventListener('input', () => {
      userEditedSlug = true
    })

    // Auto-generate slug from organization name
    if (nameInput) {
      nameInput.addEventListener('input', (e) => {
        // Only auto-generate if user hasn't manually edited
        if (!userEditedSlug) {
          const slug = e.target.value
            .toLowerCase()
            .replace(/[^a-z0-9]+/g, '-')  // Replace non-alphanumeric with hyphens
            .replace(/^-+|-+$/g, '')       // Remove leading/trailing hyphens

          // Update the slug input value
          slugInput.value = slug

          // Trigger input event so Phoenix LiveView detects the change
          slugInput.dispatchEvent(new Event('input', { bubbles: true }))
        }
      })

      // Reset manual edit flag when form is reset
      this.el.form.addEventListener('reset', () => {
        userEditedSlug = false
      })
    }
  }
}