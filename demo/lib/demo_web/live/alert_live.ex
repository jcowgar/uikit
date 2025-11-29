defmodule DemoWeb.Ui.AlertLive do
  @moduledoc false
  use DemoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.container>
      <.stack gap="xl">
        <%!-- Header --%>
        <div>
          <h1 class="text-3xl font-bold text-foreground">Alert Component</h1>
          <p class="text-muted-foreground mt-2">
            Display important messages to users with appropriate visual emphasis.
          </p>
        </div>

        <%!-- All Variants --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">All Variants</h2>
          <.stack gap="lg">
            <.alert>
              <.alert_title>Default Alert</.alert_title>
              <.alert_description>
                This is a standard alert with neutral styling.
              </.alert_description>
            </.alert>

            <.alert variant="info">
              <.icon name="hero-information-circle" />
              <.alert_title>Information</.alert_title>
              <.alert_description>
                This is an informational alert to provide helpful context.
              </.alert_description>
            </.alert>

            <.alert variant="warning">
              <.icon name="hero-exclamation-triangle" />
              <.alert_title>Warning</.alert_title>
              <.alert_description>
                This is a warning alert to notify users of potential issues.
              </.alert_description>
            </.alert>

            <.alert variant="destructive">
              <.icon name="hero-exclamation-circle" />
              <.alert_title>Error</.alert_title>
              <.alert_description>
                This is an error alert for critical issues requiring attention.
              </.alert_description>
            </.alert>

            <.alert variant="success">
              <.icon name="hero-check-circle" />
              <.alert_title>Success</.alert_title>
              <.alert_description>
                This is a success alert to confirm completed actions.
              </.alert_description>
            </.alert>
          </.stack>
        </section>

        <%!-- With Icons --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">With Icons</h2>
          <.stack gap="lg">
            <.alert variant="info">
              <.icon name="hero-information-circle" />
              <.alert_title>Did you know?</.alert_title>
              <.alert_description>
                You can add icons to alerts for better visual communication.
              </.alert_description>
            </.alert>

            <.alert variant="success">
              <.icon name="hero-check-circle" />
              <.alert_title>Changes Saved</.alert_title>
              <.alert_description>
                Your profile has been updated successfully.
              </.alert_description>
            </.alert>
          </.stack>
        </section>

        <%!-- Title Only (No Description) --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Title Only</h2>
          <.stack gap="lg">
            <.alert variant="info">
              <.icon name="hero-information-circle" />
              <.alert_title>Maintenance scheduled for tonight at 11 PM EST</.alert_title>
            </.alert>

            <.alert variant="warning">
              <.icon name="hero-exclamation-triangle" />
              <.alert_title>Your session will expire in 5 minutes</.alert_title>
            </.alert>

            <.alert variant="destructive">
              <.icon name="hero-x-circle" />
              <.alert_title>Connection lost</.alert_title>
            </.alert>
          </.stack>
        </section>

        <%!-- Description Only (No Title) --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Description Only</h2>
          <.stack gap="lg">
            <.alert variant="info">
              <.icon name="hero-information-circle" />
              <.alert_description>
                This alert has only a description without a title.
              </.alert_description>
            </.alert>

            <.alert>
              <.alert_description>
                Simple alert message without icon or title.
              </.alert_description>
            </.alert>
          </.stack>
        </section>

        <%!-- Rich Content --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Rich Content</h2>
          <.stack gap="lg">
            <.alert variant="info">
              <.icon name="hero-information-circle" />
              <.alert_title>Getting Started</.alert_title>
              <.alert_description>
                <p>Follow these steps to complete your setup:</p>
                <ul class="list-disc list-inside mt-2 space-y-1">
                  <li>Create your account</li>
                  <li>Verify your email address</li>
                  <li>Complete your profile</li>
                  <li>Start using the app</li>
                </ul>
              </.alert_description>
            </.alert>

            <.alert variant="warning">
              <.icon name="hero-exclamation-triangle" />
              <.alert_title>Update Required</.alert_title>
              <.alert_description>
                <p>Your app version is outdated.</p>
                <p class="mt-2">
                  Please update to continue using all features. Visit
                  <.link navigate={~p"/"} class="underline font-medium">the download page</.link>
                  to get the latest version.
                </p>
              </.alert_description>
            </.alert>
          </.stack>
        </section>

        <%!-- Real-World Examples --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Real-World Examples</h2>
          <.stack gap="lg">
            <%!-- Login screen dev mode notice --%>
            <.alert variant="info">
              <.icon name="hero-information-circle" />
              <.alert_title>Development Mode</.alert_title>
              <.alert_description>
                You can sign in with any email for testing. Check your terminal for the login link.
              </.alert_description>
            </.alert>

            <%!-- Email confirmation reminder --%>
            <.alert variant="warning">
              <.icon name="hero-exclamation-triangle" />
              <.alert_title>Email Confirmation Required</.alert_title>
              <.alert_description>
                Please confirm your email address within 3 days to continue using all features.
              </.alert_description>
            </.alert>

            <%!-- Password change success --%>
            <.alert variant="success">
              <.icon name="hero-check-circle" />
              <.alert_title>Password Updated</.alert_title>
              <.alert_description>
                Your password has been changed successfully. You can now use it to log in.
              </.alert_description>
            </.alert>

            <%!-- Login error --%>
            <.alert variant="destructive">
              <.icon name="hero-exclamation-circle" />
              <.alert_title>Login Failed</.alert_title>
              <.alert_description>
                Invalid email or password. Please try again or reset your password.
              </.alert_description>
            </.alert>

            <%!-- Session expired --%>
            <.alert variant="destructive">
              <.icon name="hero-clock" />
              <.alert_title>Session Expired</.alert_title>
              <.alert_description>
                Your session has expired for security reasons. Please log in again.
              </.alert_description>
            </.alert>
          </.stack>
        </section>

        <%!-- Accessibility Features --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Accessibility</h2>
          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>Accessibility Features</.card_title>
            </.card_header>
            <.card_content>
              <.stack gap="md">
                <p class="text-sm text-muted-foreground">
                  The alert component includes several accessibility features:
                </p>
                <ul class="text-sm text-muted-foreground space-y-2 list-disc list-inside">
                  <li>
                    Proper <code class="text-xs">role="alert"</code> attribute for screen readers
                  </li>
                  <li>Semantic HTML structure with title and description separation</li>
                  <li>Color is not the only indicator - icons and text provide context</li>
                  <li>Sufficient color contrast for all variants in light and dark modes</li>
                  <li>Icons use current color for proper theme integration</li>
                  <li>Grid layout ensures proper alignment with and without icons</li>
                </ul>
              </.stack>
            </.card_content>
          </.card>
        </section>

        <%!-- Usage Guidelines --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Usage Guidelines</h2>
          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>When to Use Each Variant</.card_title>
            </.card_header>
            <.card_content>
              <.stack gap="md">
                <div>
                  <h3 class="font-semibold text-foreground mb-2">Default</h3>
                  <p class="text-sm text-muted-foreground">
                    Neutral messages that don't fit other categories.
                  </p>
                </div>

                <div>
                  <h3 class="font-semibold text-foreground mb-2">Info</h3>
                  <p class="text-sm text-muted-foreground">
                    Helpful information, tips, or context that enhances the user experience.
                  </p>
                </div>

                <div>
                  <h3 class="font-semibold text-foreground mb-2">Warning</h3>
                  <p class="text-sm text-muted-foreground">
                    Cautionary messages about potential issues or actions that need attention.
                  </p>
                </div>

                <div>
                  <h3 class="font-semibold text-foreground mb-2">Destructive</h3>
                  <p class="text-sm text-muted-foreground">
                    Critical errors, failed operations, or urgent issues requiring immediate action.
                  </p>
                </div>

                <div>
                  <h3 class="font-semibold text-foreground mb-2">Success</h3>
                  <p class="text-sm text-muted-foreground">
                    Confirmation of successful actions or completed operations.
                  </p>
                </div>
              </.stack>
            </.card_content>
          </.card>
        </section>
      </.stack>
    </.container>
    """
  end
end
