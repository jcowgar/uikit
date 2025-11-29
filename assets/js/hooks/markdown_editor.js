/**
 * MarkdownEditor Hook
 *
 * A WYSIWYG markdown editor using TipTap.
 * Converts markdown to HTML for editing, and back to markdown for form submission.
 *
 * Data attributes:
 * - data-placeholder: Placeholder text for the editor
 * - data-autofocus: Whether to autofocus the editor on mount
 */
import { Editor } from '@tiptap/core'
import { StarterKit } from '@tiptap/starter-kit'
import { Placeholder } from '@tiptap/extension-placeholder'
import { Table } from '@tiptap/extension-table'
import { TableRow } from '@tiptap/extension-table-row'
import { TableCell } from '@tiptap/extension-table-cell'
import { TableHeader } from '@tiptap/extension-table-header'
import { marked } from 'marked'
import TurndownService from 'turndown'
import { gfm } from 'turndown-plugin-gfm'

export const MarkdownEditor = {
  mounted() {
    this.initEditor()
  },

  destroyed() {
    if (this.editor) {
      this.editor.destroy()
      this.editor = null
    }
  },

  initEditor() {
    const container = this.el
    const textarea = container.querySelector('textarea')
    if (!textarea) {
      console.error('MarkdownEditor: No textarea found')
      return
    }

    // Hide the textarea (we'll sync to it for form submission)
    textarea.style.display = 'none'

    // Create editor container
    const editorEl = document.createElement('div')
    editorEl.className = 'tiptap-editor'
    container.appendChild(editorEl)

    // Create toolbar
    const toolbar = this.createToolbar()
    container.insertBefore(toolbar, editorEl)

    // Parse config
    const placeholder = container.dataset.placeholder || 'Start writing...'
    const autofocus = container.dataset.autofocus === 'true'

    // Convert initial markdown to HTML
    const initialMarkdown = textarea.value || ''
    const initialHtml = initialMarkdown ? this.markdownToHtml(initialMarkdown) : ''

    // Initialize TipTap editor
    this.editor = new Editor({
      element: editorEl,
      extensions: [
        StarterKit.configure({
          heading: { levels: [1, 2, 3, 4, 5, 6] }
        }),
        Placeholder.configure({
          placeholder: placeholder
        }),
        Table.configure({
          resizable: true
        }),
        TableRow,
        TableHeader,
        TableCell
      ],
      content: initialHtml,
      autofocus: autofocus,
      editorProps: {
        attributes: {
          class: 'tiptap-content focus:outline-none'
        }
      },
      onUpdate: ({ editor }) => {
        // Just sync to textarea without triggering LiveView events
        const html = editor.getHTML()
        const markdown = this.htmlToMarkdown(html)
        textarea.value = markdown
      }
    })

    // Store references
    this.textarea = textarea
    this.toolbar = toolbar

    // Create table controls (hidden by default) - insert after main toolbar
    this.tableControls = this.createTableControls()
    toolbar.insertAdjacentElement('afterend', this.tableControls)

    // Update toolbar state on selection change
    this.editor.on('selectionUpdate', () => {
      this.updateToolbarState()
      this.updateTableControls()
    })
    this.editor.on('transaction', () => {
      this.updateToolbarState()
      this.updateTableControls()
    })

    // Only trigger LiveView validation on blur (not during typing)
    this.editor.on('blur', () => {
      const event = new Event('input', { bubbles: true })
      textarea.dispatchEvent(event)
    })
  },

  createToolbar() {
    const toolbar = document.createElement('div')
    toolbar.className = 'tiptap-toolbar'

    // Check for custom action buttons from the server-rendered slot
    const actionsContainer = this.el.querySelector('[data-slot="toolbar-actions"]')
    if (actionsContainer) {
      // Create a wrapper for the actions
      const actionsWrapper = document.createElement('div')
      actionsWrapper.className = 'tiptap-toolbar-actions'

      // Move all children from the hidden container to the wrapper
      while (actionsContainer.firstChild) {
        actionsWrapper.appendChild(actionsContainer.firstChild)
      }

      toolbar.appendChild(actionsWrapper)

      // Add separator after actions
      const sep = document.createElement('span')
      sep.className = 'tiptap-toolbar-separator'
      toolbar.appendChild(sep)

      // Remove the now-empty container
      actionsContainer.remove()
    }

    const buttons = [
      { command: 'bold', icon: 'bold', title: 'Bold' },
      { command: 'italic', icon: 'italic', title: 'Italic' },
      { command: 'strike', icon: 'strikethrough', title: 'Strikethrough' },
      { type: 'separator' },
      { command: 'heading1', icon: 'h1', title: 'Heading 1' },
      { command: 'heading2', icon: 'h2', title: 'Heading 2' },
      { command: 'heading3', icon: 'h3', title: 'Heading 3' },
      { type: 'separator' },
      { command: 'bulletList', icon: 'list-bullet', title: 'Bullet List' },
      { command: 'orderedList', icon: 'list-ordered', title: 'Numbered List' },
      { type: 'separator' },
      { command: 'blockquote', icon: 'quote', title: 'Quote' },
      { command: 'codeBlock', icon: 'code', title: 'Code Block' },
      { command: 'table', icon: 'table', title: 'Insert Table' },
      { command: 'horizontalRule', icon: 'minus', title: 'Horizontal Rule' },
      { type: 'separator' },
      { command: 'undo', icon: 'undo', title: 'Undo' },
      { command: 'redo', icon: 'redo', title: 'Redo' }
    ]

    // SVG icons for toolbar
    const icons = {
      bold: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M6 4h8a4 4 0 0 1 4 4 4 4 0 0 1-4 4H6z"></path><path d="M6 12h9a4 4 0 0 1 4 4 4 4 0 0 1-4 4H6z"></path></svg>',
      italic: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="4" x2="10" y2="4"></line><line x1="14" y1="20" x2="5" y2="20"></line><line x1="15" y1="4" x2="9" y2="20"></line></svg>',
      strikethrough: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 4H9a3 3 0 0 0-2.83 4"></path><path d="M14 12a4 4 0 0 1 0 8H6"></path><line x1="4" y1="12" x2="20" y2="12"></line></svg>',
      h1: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 12h8"></path><path d="M4 18V6"></path><path d="M12 18V6"></path><path d="m17 12 3-2v8"></path></svg>',
      h2: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 12h8"></path><path d="M4 18V6"></path><path d="M12 18V6"></path><path d="M21 18h-4c0-4 4-3 4-6 0-1.5-2-2.5-4-1"></path></svg>',
      h3: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 12h8"></path><path d="M4 18V6"></path><path d="M12 18V6"></path><path d="M17.5 10.5c1.7-1 3.5 0 3.5 1.5a2 2 0 0 1-2 2"></path><path d="M17 17.5c2 1.5 4 .3 4-1.5a2 2 0 0 0-2-2"></path></svg>',
      'list-bullet': '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="8" y1="6" x2="21" y2="6"></line><line x1="8" y1="12" x2="21" y2="12"></line><line x1="8" y1="18" x2="21" y2="18"></line><line x1="3" y1="6" x2="3.01" y2="6"></line><line x1="3" y1="12" x2="3.01" y2="12"></line><line x1="3" y1="18" x2="3.01" y2="18"></line></svg>',
      'list-ordered': '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="10" y1="6" x2="21" y2="6"></line><line x1="10" y1="12" x2="21" y2="12"></line><line x1="10" y1="18" x2="21" y2="18"></line><path d="M4 6h1v4"></path><path d="M4 10h2"></path><path d="M6 18H4c0-1 2-2 2-3s-1-1.5-2-1"></path></svg>',
      quote: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 21c3 0 7-1 7-8V5c0-1.25-.756-2.017-2-2H4c-1.25 0-2 .75-2 1.972V11c0 1.25.75 2 2 2 1 0 1 0 1 1v1c0 1-1 2-2 2s-1 .008-1 1.031V21z"></path><path d="M15 21c3 0 7-1 7-8V5c0-1.25-.757-2.017-2-2h-4c-1.25 0-2 .75-2 1.972V11c0 1.25.75 2 2 2h.75c0 2.25.25 4-2.75 4v3z"></path></svg>',
      code: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="16 18 22 12 16 6"></polyline><polyline points="8 6 2 12 8 18"></polyline></svg>',
      minus: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"></line></svg>',
      table: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3v18"></path><rect width="18" height="18" x="3" y="3" rx="2"></rect><path d="M3 9h18"></path><path d="M3 15h18"></path></svg>',
      undo: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 7v6h6"></path><path d="M21 17a9 9 0 0 0-9-9 9 9 0 0 0-6 2.3L3 13"></path></svg>',
      redo: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 7v6h-6"></path><path d="M3 17a9 9 0 0 1 9-9 9 9 0 0 1 6 2.3l3 2.7"></path></svg>'
    }

    buttons.forEach((btn) => {
      if (btn.type === 'separator') {
        const sep = document.createElement('span')
        sep.className = 'tiptap-toolbar-separator'
        toolbar.appendChild(sep)
      } else {
        const button = document.createElement('button')
        button.type = 'button'
        button.className = 'tiptap-toolbar-button'
        button.dataset.command = btn.command
        button.title = btn.title
        button.innerHTML = icons[btn.icon] || btn.icon
        button.addEventListener('click', (e) => {
          e.preventDefault()
          this.executeCommand(btn.command)
        })
        toolbar.appendChild(button)
      }
    })

    return toolbar
  },

  executeCommand(command) {
    if (!this.editor) return

    const commands = {
      bold: () => this.editor.chain().focus().toggleBold().run(),
      italic: () => this.editor.chain().focus().toggleItalic().run(),
      strike: () => this.editor.chain().focus().toggleStrike().run(),
      heading1: () => this.editor.chain().focus().toggleHeading({ level: 1 }).run(),
      heading2: () => this.editor.chain().focus().toggleHeading({ level: 2 }).run(),
      heading3: () => this.editor.chain().focus().toggleHeading({ level: 3 }).run(),
      bulletList: () => this.editor.chain().focus().toggleBulletList().run(),
      orderedList: () => this.editor.chain().focus().toggleOrderedList().run(),
      blockquote: () => this.editor.chain().focus().toggleBlockquote().run(),
      codeBlock: () => this.editor.chain().focus().toggleCodeBlock().run(),
      table: () =>
        this.editor.chain().focus().insertTable({ rows: 3, cols: 3, withHeaderRow: true }).run(),
      horizontalRule: () => this.editor.chain().focus().setHorizontalRule().run(),
      undo: () => this.editor.chain().focus().undo().run(),
      redo: () => this.editor.chain().focus().redo().run()
    }

    if (commands[command]) {
      commands[command]()
    }
  },

  updateToolbarState() {
    if (!this.editor || !this.toolbar) return

    const activeStates = {
      bold: this.editor.isActive('bold'),
      italic: this.editor.isActive('italic'),
      strike: this.editor.isActive('strike'),
      heading1: this.editor.isActive('heading', { level: 1 }),
      heading2: this.editor.isActive('heading', { level: 2 }),
      heading3: this.editor.isActive('heading', { level: 3 }),
      bulletList: this.editor.isActive('bulletList'),
      orderedList: this.editor.isActive('orderedList'),
      blockquote: this.editor.isActive('blockquote'),
      codeBlock: this.editor.isActive('codeBlock')
    }

    this.toolbar.querySelectorAll('.tiptap-toolbar-button').forEach((button) => {
      const command = button.dataset.command
      if (activeStates[command]) {
        button.classList.add('is-active')
      } else {
        button.classList.remove('is-active')
      }
    })
  },

  createTableControls() {
    const controls = document.createElement('div')
    controls.className = 'tiptap-table-controls'
    // Always visible - buttons are disabled when not in a table

    const buttons = [
      { command: 'addColumnBefore', icon: 'col-before', title: 'Add column before' },
      { command: 'addColumnAfter', icon: 'col-after', title: 'Add column after' },
      { command: 'deleteColumn', icon: 'col-delete', title: 'Delete column' },
      { type: 'separator' },
      { command: 'addRowBefore', icon: 'row-before', title: 'Add row before' },
      { command: 'addRowAfter', icon: 'row-after', title: 'Add row after' },
      { command: 'deleteRow', icon: 'row-delete', title: 'Delete row' },
      { type: 'separator' },
      { command: 'deleteTable', icon: 'table-delete', title: 'Delete table' }
    ]

    const icons = {
      'col-before': '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 3v18"/><rect x="10" y="3" width="10" height="18" rx="1"/><path d="M4 12h4"/><path d="M6 10v4"/></svg>',
      'col-after': '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M8 3v18"/><rect x="4" y="3" width="10" height="18" rx="1"/><path d="M16 12h4"/><path d="M18 10v4"/></svg>',
      'col-delete': '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3v18"/><rect x="6" y="3" width="12" height="18" rx="1"/><path d="m2 6 4 4"/><path d="m2 10 4-4"/></svg>',
      'row-before': '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 16h18"/><rect x="3" y="10" width="18" height="10" rx="1"/><path d="M12 4v4"/><path d="M10 6h4"/></svg>',
      'row-after': '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 8h18"/><rect x="3" y="4" width="18" height="10" rx="1"/><path d="M12 16v4"/><path d="M10 18h4"/></svg>',
      'row-delete': '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12h18"/><rect x="3" y="6" width="18" height="12" rx="1"/><path d="m6 2 4 4"/><path d="m6 6 4-4"/></svg>',
      'table-delete': '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 3h18v18H3z"/><path d="M3 9h18"/><path d="M3 15h18"/><path d="M9 3v18"/><path d="m15 15 6 6"/><path d="m15 21 6-6"/></svg>'
    }

    buttons.forEach((btn) => {
      if (btn.type === 'separator') {
        const sep = document.createElement('span')
        sep.className = 'tiptap-toolbar-separator'
        controls.appendChild(sep)
      } else {
        const button = document.createElement('button')
        button.type = 'button'
        button.className = 'tiptap-toolbar-button'
        button.dataset.command = btn.command
        button.title = btn.title
        button.innerHTML = icons[btn.icon] || btn.icon
        button.addEventListener('click', (e) => {
          e.preventDefault()
          this.executeTableCommand(btn.command)
        })
        controls.appendChild(button)
      }
    })

    return controls
  },

  executeTableCommand(command) {
    if (!this.editor) return

    const commands = {
      addColumnBefore: () => this.editor.chain().focus().addColumnBefore().run(),
      addColumnAfter: () => this.editor.chain().focus().addColumnAfter().run(),
      deleteColumn: () => this.editor.chain().focus().deleteColumn().run(),
      addRowBefore: () => this.editor.chain().focus().addRowBefore().run(),
      addRowAfter: () => this.editor.chain().focus().addRowAfter().run(),
      deleteRow: () => this.editor.chain().focus().deleteRow().run(),
      deleteTable: () => this.editor.chain().focus().deleteTable().run()
    }

    if (commands[command]) {
      commands[command]()
    }
  },

  updateTableControls() {
    if (!this.editor || !this.tableControls) return

    const isInTable = this.editor.isActive('table')

    // Enable/disable buttons instead of showing/hiding to prevent content jump
    this.tableControls.querySelectorAll('.tiptap-toolbar-button').forEach((button) => {
      button.disabled = !isInTable
      if (isInTable) {
        button.classList.remove('is-disabled')
      } else {
        button.classList.add('is-disabled')
      }
    })

    // Update the container class for styling
    if (isInTable) {
      this.tableControls.classList.add('is-active')
    } else {
      this.tableControls.classList.remove('is-active')
    }
  },

  markdownToHtml(markdown) {
    if (!markdown) return ''

    // Configure marked for GFM
    marked.setOptions({
      gfm: true,
      breaks: true
    })

    return marked.parse(markdown)
  },

  htmlToMarkdown(html) {
    if (!html || html === '<p></p>') return ''

    const turndownService = new TurndownService({
      headingStyle: 'atx',
      codeBlockStyle: 'fenced',
      emDelimiter: '*'
    })

    // Use GFM plugin for tables and strikethrough
    turndownService.use(gfm)

    // Configure for better markdown output
    turndownService.addRule('strikethrough', {
      filter: ['del', 's', 'strike'],
      replacement: (content) => `~~${content}~~`
    })

    return turndownService.turndown(html)
  }
}
