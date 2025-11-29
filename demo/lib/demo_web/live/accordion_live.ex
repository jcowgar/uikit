defmodule DemoWeb.Ui.AccordionLive do
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
          <h1 class="text-3xl font-bold text-foreground">Accordion</h1>
          <p class="text-muted-foreground mt-2">
            A vertically stacked set of interactive headings that each reveal a section of content.
          </p>
        </div>

        <%!-- Basic Accordion (Single Mode) --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Basic Accordion (Single Mode)</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Only one section can be open at a time. When you open a section, any previously open section automatically closes.
          </p>
          <.card class="max-w-2xl">
            <.card_content class="pt-6">
              <.accordion id="accordion-single" type="single">
                <.accordion_item value="item-1">
                  <.accordion_trigger>Is it accessible?</.accordion_trigger>
                  <.accordion_content>
                    Yes. It adheres to the WAI-ARIA design pattern and provides keyboard navigation support.
                  </.accordion_content>
                </.accordion_item>

                <.accordion_item value="item-2">
                  <.accordion_trigger>Is it styled?</.accordion_trigger>
                  <.accordion_content>
                    Yes. It comes with default styles that match the shadcn/ui design system, but you can customize them with Tailwind CSS classes.
                  </.accordion_content>
                </.accordion_item>

                <.accordion_item value="item-3">
                  <.accordion_trigger>Is it animated?</.accordion_trigger>
                  <.accordion_content>
                    Yes! The accordion features smooth expand/collapse animations and the chevron rotates when sections are opened.
                  </.accordion_content>
                </.accordion_item>
              </.accordion>
            </.card_content>
          </.card>
        </section>

        <%!-- Multiple Mode Accordion --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Multiple Mode</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Multiple sections can be open simultaneously. Each section toggles independently.
          </p>
          <.card class="max-w-2xl">
            <.card_content class="pt-6">
              <.accordion id="accordion-multiple" type="multiple">
                <.accordion_item value="features">
                  <.accordion_trigger>Features</.accordion_trigger>
                  <.accordion_content>
                    <ul class="list-disc list-inside space-y-1">
                      <li>Keyboard navigation support</li>
                      <li>ARIA attributes for accessibility</li>
                      <li>Smooth animations</li>
                      <li>Single and multiple modes</li>
                      <li>Fully customizable with Tailwind</li>
                    </ul>
                  </.accordion_content>
                </.accordion_item>

                <.accordion_item value="installation">
                  <.accordion_trigger>Installation</.accordion_trigger>
                  <.accordion_content>
                    <p class="mb-2">Add the component to your project:</p>
                    <code class="block bg-muted p-2 rounded text-xs">
                      pnpm dlx shadcn@latest add accordion
                    </code>
                  </.accordion_content>
                </.accordion_item>

                <.accordion_item value="customization">
                  <.accordion_trigger>Customization</.accordion_trigger>
                  <.accordion_content>
                    You can customize the accordion using the <code>class</code>
                    attribute on any of the sub-components: accordion, accordion_item, accordion_trigger, or accordion_content.
                  </.accordion_content>
                </.accordion_item>
              </.accordion>
            </.card_content>
          </.card>
        </section>

        <%!-- FAQ Example --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">FAQ Example</h2>
          <.card class="max-w-2xl">
            <.card_header>
              <.card_title>Frequently Asked Questions</.card_title>
              <.card_description>
                Find answers to common questions about our service
              </.card_description>
            </.card_header>
            <.card_content>
              <.accordion id="faq" type="single">
                <.accordion_item value="shipping">
                  <.accordion_trigger>What are your shipping options?</.accordion_trigger>
                  <.accordion_content>
                    We offer standard shipping (5-7 business days) and express shipping (2-3 business days).
                    Free standard shipping is available for orders over $50.
                  </.accordion_content>
                </.accordion_item>

                <.accordion_item value="returns">
                  <.accordion_trigger>What is your return policy?</.accordion_trigger>
                  <.accordion_content>
                    We accept returns within 30 days of purchase. Items must be unused and in their original packaging.
                    Please contact customer service to initiate a return.
                  </.accordion_content>
                </.accordion_item>

                <.accordion_item value="warranty">
                  <.accordion_trigger>Do you offer a warranty?</.accordion_trigger>
                  <.accordion_content>
                    Yes! All our products come with a 1-year manufacturer's warranty covering defects in materials and workmanship.
                    Extended warranty options are available at checkout.
                  </.accordion_content>
                </.accordion_item>

                <.accordion_item value="international">
                  <.accordion_trigger>Do you ship internationally?</.accordion_trigger>
                  <.accordion_content>
                    Yes, we ship to over 50 countries worldwide. International shipping rates and delivery times vary by destination.
                    Customs duties and taxes are the responsibility of the recipient.
                  </.accordion_content>
                </.accordion_item>
              </.accordion>
            </.card_content>
          </.card>
        </section>

        <%!-- Nested Content Example --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Rich Content</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Accordion content can contain any HTML elements, including images, lists, and formatted text.
          </p>
          <.card class="max-w-2xl">
            <.card_content class="pt-6">
              <.accordion id="accordion-rich" type="single">
                <.accordion_item value="getting-started">
                  <.accordion_trigger>Getting Started</.accordion_trigger>
                  <.accordion_content>
                    <div class="space-y-3">
                      <p class="font-medium">Follow these steps to get started:</p>
                      <ol class="list-decimal list-inside space-y-2">
                        <li>Create an account or sign in</li>
                        <li>Complete your profile information</li>
                        <li>Explore the dashboard</li>
                        <li>Start your first project</li>
                      </ol>
                      <.alert variant="info" class="mt-3">
                        <.icon name="hero-information-circle" />
                        <.alert_description>
                          Need help? Check out our comprehensive documentation.
                        </.alert_description>
                      </.alert>
                    </div>
                  </.accordion_content>
                </.accordion_item>

                <.accordion_item value="features-overview">
                  <.accordion_trigger>Features Overview</.accordion_trigger>
                  <.accordion_content>
                    <div class="space-y-3">
                      <p>Our platform offers a comprehensive suite of features:</p>
                      <.grid cols={2}>
                        <.card class="border">
                          <.card_content class="pt-6">
                            <.icon name="hero-shield-check" class="size-8 text-success mb-2" />
                            <h4 class="font-medium mb-1">Security</h4>
                            <p class="text-sm text-muted-foreground">
                              Enterprise-grade security
                            </p>
                          </.card_content>
                        </.card>
                        <.card class="border">
                          <.card_content class="pt-6">
                            <.icon name="hero-bolt" class="size-8 text-warning mb-2" />
                            <h4 class="font-medium mb-1">Performance</h4>
                            <p class="text-sm text-muted-foreground">
                              Lightning-fast speeds
                            </p>
                          </.card_content>
                        </.card>
                      </.grid>
                    </div>
                  </.accordion_content>
                </.accordion_item>

                <.accordion_item value="pricing">
                  <.accordion_trigger>Pricing Plans</.accordion_trigger>
                  <.accordion_content>
                    <div class="space-y-2">
                      <div class="flex items-center justify-between p-3 bg-muted rounded">
                        <div>
                          <p class="font-medium">Starter</p>
                          <p class="text-sm text-muted-foreground">Perfect for individuals</p>
                        </div>
                        <span class="font-bold">$9/mo</span>
                      </div>
                      <div class="flex items-center justify-between p-3 bg-muted rounded">
                        <div>
                          <p class="font-medium">Professional</p>
                          <p class="text-sm text-muted-foreground">For growing teams</p>
                        </div>
                        <span class="font-bold">$29/mo</span>
                      </div>
                      <div class="flex items-center justify-between p-3 bg-muted rounded">
                        <div>
                          <p class="font-medium">Enterprise</p>
                          <p class="text-sm text-muted-foreground">Custom solutions</p>
                        </div>
                        <span class="font-bold">Contact us</span>
                      </div>
                    </div>
                  </.accordion_content>
                </.accordion_item>
              </.accordion>
            </.card_content>
          </.card>
        </section>

        <%!-- Usage Notes --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Usage Notes</h2>
          <.card class="max-w-2xl">
            <.card_content class="pt-6">
              <.stack gap="md">
                <div>
                  <h3 class="font-medium mb-2">Composition</h3>
                  <p class="text-sm text-muted-foreground">
                    The accordion is composed of four components that work together: <code>accordion</code>, <code>accordion_item</code>, <code>accordion_trigger</code>, and <code>accordion_content</code>.
                  </p>
                </div>

                <div>
                  <h3 class="font-medium mb-2">Accessibility</h3>
                  <p class="text-sm text-muted-foreground">
                    The component follows WAI-ARIA accordion pattern with proper keyboard navigation
                    (Tab, Enter, Space) and ARIA attributes for screen readers.
                  </p>
                </div>

                <div>
                  <h3 class="font-medium mb-2">Type Modes</h3>
                  <ul class="text-sm text-muted-foreground space-y-1">
                    <li>• <strong>single</strong> - Only one item can be open (default)</li>
                    <li>• <strong>multiple</strong> - Multiple items can be open simultaneously</li>
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
end
