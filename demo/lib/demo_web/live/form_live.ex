defmodule DemoWeb.Ui.FormLive do
  @moduledoc false
  use DemoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    # Create a sample changeset for demonstrating form validation
    changeset = sample_changeset(%{})

    {:ok,
     socket
     |> assign(:form, to_form(changeset, as: :user))
     |> assign(:submitted, false)}
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      user_params
      |> sample_changeset()
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset, as: :user))}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    changeset = sample_changeset(user_params)

    case apply_changeset(changeset) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> assign(:submitted, true)
         |> put_flash(:info, "Form submitted successfully!")}

      {:error, changeset} ->
        # Set action to show errors
        changeset = Map.put(changeset, :action, :validate)
        {:noreply, assign(socket, form: to_form(changeset, as: :user))}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.container>
      <.stack gap="xl">
        <%!-- Header --%>
        <div>
          <h1 class="text-3xl font-bold text-foreground">Form Components</h1>
          <p class="text-muted-foreground mt-2">
            Building blocks for creating accessible forms with consistent styling and validation.
          </p>
        </div>

        <%!-- Basic Form Composition --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Basic Composition</h2>
          <.card class="max-w-md">
            <.card_header>
              <.card_title>Manual Field Composition</.card_title>
              <.card_description>
                Build forms using individual components for maximum control
              </.card_description>
            </.card_header>
            <.card_content>
              <.stack gap="lg">
                <.form_item>
                  <.form_label for="basic-email">Email</.form_label>
                  <.input type="email" id="basic-email" name="email" placeholder="john@example.com" />
                  <.form_description>
                    We'll never share your email with anyone.
                  </.form_description>
                </.form_item>

                <.form_item>
                  <.form_label for="basic-password">Password</.form_label>
                  <.input
                    type="password"
                    id="basic-password"
                    name="password"
                    placeholder="••••••••"
                  />
                </.form_item>

                <.button class="w-full">Sign In</.button>
              </.stack>
            </.card_content>
          </.card>
        </section>

        <%!-- Form with Validation --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">
            Form with Validation (Phoenix Forms)
          </h2>
          <.card class="max-w-md">
            <.card_header>
              <.card_title>Create Account</.card_title>
              <.card_description>
                Try submitting without filling fields to see validation
              </.card_description>
            </.card_header>
            <.card_content>
              <.form
                for={@form}
                id="user-form"
                phx-change="validate"
                phx-submit="save"
                class="space-y-4"
              >
                <.form_field
                  field={@form[:name]}
                  type="text"
                  label="Name"
                  description="Your full name"
                  placeholder="John Doe"
                />

                <.form_field
                  field={@form[:email]}
                  type="email"
                  label="Email"
                  description="We'll send you a confirmation email"
                  placeholder="john@example.com"
                />

                <.form_field
                  field={@form[:password]}
                  type="password"
                  label="Password"
                  description="Must be at least 8 characters"
                  placeholder="••••••••"
                />

                <.form_field
                  field={@form[:age]}
                  type="number"
                  label="Age"
                  placeholder="18"
                />

                <div class="flex items-center gap-3 pt-2">
                  <.checkbox
                    id="terms"
                    name="user[terms]"
                    checked={Phoenix.HTML.Form.normalize_value("checkbox", @form[:terms].value)}
                  />
                  <.label for="terms" class="cursor-pointer">
                    I agree to the terms and conditions
                  </.label>
                </div>

                <.button type="submit" class="w-full">Create Account</.button>
              </.form>

              <div
                :if={@submitted}
                class="mt-4 p-3 bg-success/10 border border-success/20 rounded-md"
              >
                <p class="text-sm text-success">Account created successfully!</p>
              </div>
            </.card_content>
          </.card>
        </section>

        <%!-- Error States --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Error States</h2>
          <.card class="max-w-md">
            <.card_header>
              <.card_title>Form with Errors</.card_title>
              <.card_description>
                Examples of how validation errors appear
              </.card_description>
            </.card_header>
            <.card_content>
              <.stack gap="lg">
                <.form_item>
                  <.form_label for="error-email" error>Email</.form_label>
                  <.input
                    type="email"
                    id="error-email"
                    name="email"
                    value="invalid-email"
                    aria-invalid="true"
                    aria-describedby="error-email-message"
                  />
                  <.form_message id="error-email-message">
                    Please enter a valid email address
                  </.form_message>
                </.form_item>

                <.form_item>
                  <.form_label for="error-password" error>Password</.form_label>
                  <.input
                    type="password"
                    id="error-password"
                    name="password"
                    value="123"
                    aria-invalid="true"
                    aria-describedby="error-password-message"
                  />
                  <.form_description>Must be at least 8 characters</.form_description>
                  <.form_message id="error-password-message">
                    Password is too short
                  </.form_message>
                </.form_item>
              </.stack>
            </.card_content>
          </.card>
        </section>

        <%!-- Form Layouts --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Form Layouts</h2>
          <.card>
            <.card_header>
              <.card_title>Contact Form</.card_title>
              <.card_description>
                Example of a more complex form layout
              </.card_description>
            </.card_header>
            <.card_content>
              <form class="space-y-6">
                <.grid cols={2}>
                  <.form_item>
                    <.form_label for="first-name">First Name</.form_label>
                    <.input type="text" id="first-name" name="first_name" placeholder="John" />
                  </.form_item>

                  <.form_item>
                    <.form_label for="last-name">Last Name</.form_label>
                    <.input type="text" id="last-name" name="last_name" placeholder="Doe" />
                  </.form_item>
                </.grid>

                <.form_item>
                  <.form_label for="contact-email">Email</.form_label>
                  <.input
                    type="email"
                    id="contact-email"
                    name="email"
                    placeholder="john@example.com"
                  />
                </.form_item>

                <.form_item>
                  <.form_label for="subject">Subject</.form_label>
                  <.input type="text" id="subject" name="subject" placeholder="How can we help?" />
                </.form_item>

                <.form_item>
                  <.form_label for="message">Message</.form_label>
                  <textarea
                    id="message"
                    name="message"
                    rows="4"
                    placeholder="Tell us more..."
                    class="w-full px-3 py-2 rounded-md border border-input bg-transparent text-foreground placeholder:text-muted-foreground focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] dark:bg-input/30"
                  ></textarea>
                  <.form_description>
                    Provide as much detail as possible
                  </.form_description>
                </.form_item>

                <.flex justify="between" items="center">
                  <div class="flex items-center gap-3">
                    <.checkbox id="subscribe" name="subscribe" />
                    <.label for="subscribe" class="cursor-pointer">
                      Subscribe to newsletter
                    </.label>
                  </div>
                  <.button>Send Message</.button>
                </.flex>
              </form>
            </.card_content>
          </.card>
        </section>

        <%!-- Component Reference --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Component Reference</h2>
          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>Available Components</.card_title>
            </.card_header>
            <.card_content>
              <.stack gap="md">
                <div>
                  <h3 class="font-semibold text-foreground mb-2">Composition Components</h3>
                  <ul class="text-sm text-muted-foreground space-y-1 list-disc list-inside">
                    <li>
                      <code class="text-xs">&lt;.form_item&gt;</code>
                      - Container for form fields with consistent spacing
                    </li>
                    <li>
                      <code class="text-xs">&lt;.form_label&gt;</code>
                      - Label with error state styling
                    </li>
                    <li>
                      <code class="text-xs">&lt;.form_description&gt;</code> - Helper text for fields
                    </li>
                    <li>
                      <code class="text-xs">&lt;.form_message&gt;</code> - Error message display
                    </li>
                  </ul>
                </div>

                <div>
                  <h3 class="font-semibold text-foreground mb-2">High-Level Components</h3>
                  <ul class="text-sm text-muted-foreground space-y-1 list-disc list-inside">
                    <li>
                      <code class="text-xs">&lt;.form_field&gt;</code>
                      - Complete field with label, input, description, and errors
                    </li>
                  </ul>
                </div>

                <div>
                  <h3 class="font-semibold text-foreground mb-2">Usage Patterns</h3>
                  <ul class="text-sm text-muted-foreground space-y-1 list-disc list-inside">
                    <li>
                      Use <code class="text-xs">&lt;.form_field&gt;</code> for quick, standard fields
                    </li>
                    <li>
                      Use composition components for custom layouts or special requirements
                    </li>
                    <li>All components integrate with Phoenix forms and changesets</li>
                    <li>Automatic accessibility with proper ARIA attributes</li>
                  </ul>
                </div>
              </.stack>
            </.card_content>
          </.card>
        </section>
      </.stack>
    </.container>
    """
  end

  # Sample changeset for demonstration
  defp sample_changeset(params) do
    types = %{
      name: :string,
      email: :string,
      password: :string,
      age: :integer,
      terms: :boolean
    }

    {%{}, types}
    |> Ecto.Changeset.cast(params, Map.keys(types))
    |> Ecto.Changeset.validate_required([:name, :email, :password])
    |> Ecto.Changeset.validate_format(:email, ~r/@/)
    |> Ecto.Changeset.validate_length(:password, min: 8)
    |> Ecto.Changeset.validate_number(:age, greater_than_or_equal_to: 18)
    |> Ecto.Changeset.validate_acceptance(:terms)
  end

  defp apply_changeset(changeset) do
    if changeset.valid? do
      {:ok, Ecto.Changeset.apply_changes(changeset)}
    else
      {:error, changeset}
    end
  end
end
