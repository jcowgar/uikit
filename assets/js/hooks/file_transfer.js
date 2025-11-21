/**
 * FileUpload Hook
 *
 * Handles file upload from file input, reads the file content,
 * and sends it to the server via Phoenix LiveView.
 */
export const FileUpload = {
  mounted() {
    this.el.addEventListener('change', (e) => {
      const file = e.target.files[0]

      if (!file) return

      const reader = new FileReader()

      reader.onload = (event) => {
        const fileContent = event.target.result

        // Push the file content to the server
        this.pushEvent('import', {
          file_content: fileContent,
          file_name: file.name,
          file_type: file.type
        })

        // Reset the input so the same file can be selected again
        e.target.value = ''
      }

      reader.onerror = () => {
        console.error('Failed to read file')
        e.target.value = ''
      }

      // Read file as text (for JSON files)
      reader.readAsText(file)
    })
  }
}

/**
 * Download Hook
 *
 * Listens for download events from the server and triggers
 * a browser download with the provided content.
 */
export const Download = {
  mounted() {
    this.handleEvent('download', ({content, filename, content_type}) => {
      // Create a blob from the content
      const blob = new Blob([content], {type: content_type || 'application/octet-stream'})

      // Create a temporary download link
      const url = window.URL.createObjectURL(blob)
      const a = document.createElement('a')
      a.href = url
      a.download = filename
      a.style.display = 'none'

      // Trigger the download
      document.body.appendChild(a)
      a.click()

      // Clean up
      setTimeout(() => {
        document.body.removeChild(a)
        window.URL.revokeObjectURL(url)
      }, 100)
    })
  }
}
