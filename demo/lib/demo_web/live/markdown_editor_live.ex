defmodule DemoWeb.Ui.MarkdownEditorLive do
  @moduledoc false
  use DemoWeb, :live_view

  alias Phoenix.LiveView.Socket

  @impl true
  @spec mount(map(), map(), Socket.t()) :: {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:form, to_form(%{"content" => sample_markdown(), "notes" => ""}))

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", params, socket) do
    # Merge with existing form data to handle partial updates
    current = socket.assigns.form.params
    updated = Map.merge(current, Map.take(params, ["content", "notes"]))
    form = to_form(updated)
    {:noreply, assign(socket, :form, form)}
  end

  @impl true
  def handle_event("save", params, socket) do
    IO.inspect(params, label: "Saved content")
    {:noreply, put_flash(socket, :info, "Content saved!")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.container>
      <.stack gap="xl">
        <div>
          <h1 class="text-3xl font-bold text-foreground">Markdown Editor</h1>
          <p class="text-muted-foreground mt-2">
            A WYSIWYG markdown editor powered by TipTap.
          </p>
        </div>

        <%!-- Basic Editor --%>
        <section class="space-y-4">
          <div>
            <h2 class="text-2xl font-semibold text-foreground">Basic Editor</h2>
            <p class="text-muted-foreground">
              Edit content visually - it outputs clean markdown.
            </p>
          </div>

          <.card>
            <.card_header>
              <.card_title>Document Editor</.card_title>
              <.card_description>What you see is what you get</.card_description>
            </.card_header>
            <.card_content>
              <.form for={@form} phx-change="validate" phx-submit="save" class="space-y-4">
                <.markdown_editor
                  id="basic-editor"
                  name="content"
                  value={@form[:content].value}
                  placeholder="Start writing..."
                />
                <.button type="submit">Save Content</.button>
              </.form>
            </.card_content>
          </.card>
        </section>

        <%!-- Empty Editor with Placeholder --%>
        <section class="space-y-4">
          <div>
            <h2 class="text-2xl font-semibold text-foreground">With Placeholder</h2>
            <p class="text-muted-foreground">
              Shows placeholder text when the editor is empty.
            </p>
          </div>

          <.card>
            <.card_header>
              <.card_title>Quick Notes</.card_title>
            </.card_header>
            <.card_content>
              <.markdown_editor
                id="notes-editor"
                name="notes"
                value={@form[:notes].value}
                placeholder="Write your notes here..."
              />
            </.card_content>
          </.card>
        </section>

        <%!-- Usage --%>
        <section class="space-y-4">
          <div>
            <h2 class="text-2xl font-semibold text-foreground">Usage</h2>
            <p class="text-muted-foreground">
              How to use the markdown editor in your LiveView.
            </p>
          </div>

          <.card>
            <.card_content>
              <pre class="text-sm p-4 bg-muted rounded-lg overflow-x-auto" phx-no-format><code phx-no-curly-interpolation># Basic usage
              &lt;.markdown_editor id="readme" name="content" /&gt;

              # With initial content
              &lt;.markdown_editor id="notes" name="notes" value={@notes_content} /&gt;

              # With placeholder
              &lt;.markdown_editor id="comment" name="comment" placeholder="Write a comment..." /&gt;

              # In a form
              &lt;.form for={@form} phx-change="validate" phx-submit="save"&gt;
                &lt;.markdown_editor
                  id="editor"
                  name="content"
                  value={@form[:content].value}
                /&gt;
                &lt;.button type="submit"&gt;Save&lt;/.button&gt;
              &lt;/.form&gt;</code></pre>
            </.card_content>
          </.card>
        </section>
      </.stack>
    </.container>
    """
  end

  @spec sample_markdown() :: String.t()
  defp sample_markdown do
    """
    # Welcome to the Markdown Editor

    This is a **WYSIWYG** markdown editor built with TipTap.

    ## Features

    - **Bold** and *italic* text
    - Headings (H1-H6)
    - Lists (ordered and unordered)
    - Code blocks
    - Blockquotes
    - And more!

    ### Code Example

    ```elixir
    defmodule Hello do
      def world do
        IO.puts("Hello, World!")
      end
    end
    ```

    > This is a blockquote. Try selecting text and using the toolbar buttons!
    """
  end
end
