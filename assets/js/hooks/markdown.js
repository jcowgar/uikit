/**
 * MarkdownRenderer Hook
 *
 * Renders markdown content to HTML using marked.js library.
 * The element should have a data-markdown attribute containing the raw markdown text.
 * The hook will parse and render the markdown into the element's innerHTML.
 *
 * After rendering, it processes:
 * - Syntax highlighting (using highlight.js via marked-highlight)
 * - Mermaid diagrams (finds code.language-mermaid blocks)
 * - MathJax equations (finds $...$ and $$...$$ syntax)
 */
import { marked } from 'marked'
import { markedHighlight } from 'marked-highlight'
import hljs from 'highlight.js'
import mermaid from 'mermaid'

export const MarkdownRenderer = {
  mounted() {
    // Initialize mermaid with a simple theme
    // We'll use the default theme as custom CSS variables don't work directly
    mermaid.initialize({
      startOnLoad: false,
      theme: 'default',
      securityLevel: 'loose'
    })

    this.renderMarkdown()
    this.handleInternalLinks()
  },

  updated() {
    this.renderMarkdown()
    this.handleInternalLinks()
  },

  async renderMarkdown() {
    const markdownContent = this.el.dataset.markdown

    if (!markdownContent) {
      this.el.innerHTML = '<p class="text-muted-foreground">No content</p>'
      return
    }

    // Decode HTML entities that Phoenix/HEEx automatically encodes when passing to data attributes
    // This prevents double-encoding of characters like <, >, &, etc. in the rendered markdown
    const decodedMarkdown = this.decodeHTMLEntities(markdownContent)

    try {
      // Reset marked extensions to avoid conflicts
      marked.setOptions(marked.getDefaults())

      // Configure marked with syntax highlighting extension
      marked.use(
        markedHighlight({
          langPrefix: 'hljs language-',
          highlight(code, lang, info) {
            // Skip mermaid blocks - they'll be processed separately
            if (lang === 'mermaid') {
              return code
            }

            const language = hljs.getLanguage(lang) ? lang : 'plaintext'
            return hljs.highlight(code, { language }).value
          }
        })
      )

      // Configure marked options for better rendering
      marked.setOptions({
        gfm: true,           // GitHub Flavored Markdown
        breaks: true,        // Convert \n to <br>
        headerIds: true,     // Add IDs to headers
        mangle: false,       // Don't escape emails
        pedantic: false      // Don't be too strict
      })

      // Parse and render the markdown
      const html = marked.parse(decodedMarkdown)
      this.el.innerHTML = html

      // Process Mermaid diagrams
      await this.renderMermaidDiagrams()

      // Process MathJax equations
      this.renderMathJax()
    } catch (error) {
      console.error('Error rendering markdown:', error)
      this.el.innerHTML = `<p class="text-destructive">Error rendering markdown: ${error.message}</p>`
    }
  },

  async renderMermaidDiagrams() {
    const mermaidBlocks = this.el.querySelectorAll('code.language-mermaid')

    if (mermaidBlocks.length === 0) {
      return
    }

    const containers = []

    mermaidBlocks.forEach((block, index) => {
      const code = block.textContent

      if (!code || code.trim() === '') {
        return
      }

      const wrapper = document.createElement('div')
      wrapper.className = 'mermaid mermaid-diagram my-4'
      wrapper.id = `mermaid-${Date.now()}-${index}`
      wrapper.textContent = code

      const parentNode = block.closest('pre') || block
      parentNode.replaceWith(wrapper)

      containers.push(wrapper)
    })

    if (containers.length === 0) {
      return
    }

    try {
      await mermaid.run({ nodes: containers, suppressErrors: true })
    } catch (error) {
      console.error('Error rendering mermaid diagram:', error)

      containers.forEach((container) => {
        container.innerHTML = `<div class="text-destructive p-4 border border-destructive rounded">Error rendering diagram: ${error.message}</div>`
      })
    }
  },

  renderMathJax() {
    // Load MathJax if not already loaded
    if (!window.MathJax) {
      window.MathJax = {
        tex: {
          inlineMath: [['$', '$']],
          displayMath: [['$$', '$$']],
          processEscapes: true,
          processEnvironments: true
        },
        options: {
          skipHtmlTags: ['script', 'noscript', 'style', 'textarea', 'pre', 'code']
        },
        startup: {
          pageReady: () => {
            return window.MathJax.startup.defaultPageReady().then(() => {
              console.log('MathJax loaded and ready')
            })
          }
        }
      }

      // Load MathJax script
      const script = document.createElement('script')
      script.src = 'https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js'
      script.async = true
      document.head.appendChild(script)

      script.onload = () => {
        // Typeset the math in this element
        if (window.MathJax.typesetPromise) {
          window.MathJax.typesetPromise([this.el]).catch((err) => {
            console.error('MathJax typeset error:', err)
          })
        }
      }
    } else {
      // MathJax is already loaded, just typeset this element
      if (window.MathJax.typesetPromise) {
        window.MathJax.typesetPromise([this.el]).catch((err) => {
          console.error('MathJax typeset error:', err)
        })
      }
    }
  },

  handleInternalLinks() {
    // Find all links within the markdown content
    const links = this.el.querySelectorAll('a[href^="/org/"]')

    links.forEach((link) => {
      // Add Phoenix LiveView navigation attributes for client-side routing
      link.setAttribute('data-phx-link', 'redirect')
      link.setAttribute('data-phx-link-state', 'push')
    })
  },

  /**
   * Decode HTML entities in a string
   * Phoenix/HEEx automatically encodes HTML when passing to data attributes,
   * so we need to decode it before parsing as markdown
   */
  decodeHTMLEntities(text) {
    const textarea = document.createElement('textarea')
    textarea.innerHTML = text
    return textarea.value
  }
}
