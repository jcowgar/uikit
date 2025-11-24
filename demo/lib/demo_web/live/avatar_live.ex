defmodule DemoWeb.Ui.AvatarLive do
  @moduledoc false
  use DemoWeb, :live_view

  alias Phoenix.LiveView.Socket

  @impl true
  @spec mount(map(), map(), Socket.t()) ::
          {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  @spec render(map()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <.container>
      <.stack size="large">
        <%!-- Header --%>
        <div>
          <h1 class="text-3xl font-bold text-foreground">Avatar Component</h1>
          <p class="text-muted-foreground mt-2">
            An image element with a fallback for representing the user.
          </p>
        </div>

        <%!-- Basic Usage --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Basic Usage</h2>
          <.flex align="center" class="gap-4 flex-wrap">
            <.avatar>
              <.avatar_image
                src="https://github.com/shadcn.png"
                alt="@shadcn"
              />
              <.avatar_fallback>CN</.avatar_fallback>
            </.avatar>

            <.avatar>
              <.avatar_image
                src="https://github.com/vercel.png"
                alt="@vercel"
              />
              <.avatar_fallback>VC</.avatar_fallback>
            </.avatar>

            <.avatar>
              <.avatar_image
                src="https://github.com/nextjs.png"
                alt="@nextjs"
              />
              <.avatar_fallback>NX</.avatar_fallback>
            </.avatar>
          </.flex>
        </section>

        <%!-- Fallback Only --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Fallback Only</h2>
          <p class="text-sm text-muted-foreground mb-4">
            When no image is provided or the image fails to load, the fallback is displayed.
          </p>
          <.flex align="center" class="gap-4 flex-wrap">
            <.avatar>
              <.avatar_fallback>JD</.avatar_fallback>
            </.avatar>

            <.avatar>
              <.avatar_fallback>AB</.avatar_fallback>
            </.avatar>

            <.avatar>
              <.avatar_fallback>MK</.avatar_fallback>
            </.avatar>

            <.avatar>
              <.avatar_fallback>
                <.icon name="hero-user" />
              </.avatar_fallback>
            </.avatar>
          </.flex>
        </section>

        <%!-- Sizes --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Sizes</h2>
          <.flex align="center" class="gap-4 flex-wrap items-end">
            <div class="text-center">
              <.avatar class="size-6">
                <.avatar_image
                  src="https://github.com/shadcn.png"
                  alt="@shadcn"
                />
                <.avatar_fallback>CN</.avatar_fallback>
              </.avatar>
              <p class="text-xs text-muted-foreground mt-2">Small (24px)</p>
            </div>

            <div class="text-center">
              <.avatar>
                <.avatar_image
                  src="https://github.com/shadcn.png"
                  alt="@shadcn"
                />
                <.avatar_fallback>CN</.avatar_fallback>
              </.avatar>
              <p class="text-xs text-muted-foreground mt-2">Default (32px)</p>
            </div>

            <div class="text-center">
              <.avatar class="size-12">
                <.avatar_image
                  src="https://github.com/shadcn.png"
                  alt="@shadcn"
                />
                <.avatar_fallback>CN</.avatar_fallback>
              </.avatar>
              <p class="text-xs text-muted-foreground mt-2">Medium (48px)</p>
            </div>

            <div class="text-center">
              <.avatar class="size-16">
                <.avatar_image
                  src="https://github.com/shadcn.png"
                  alt="@shadcn"
                />
                <.avatar_fallback>CN</.avatar_fallback>
              </.avatar>
              <p class="text-xs text-muted-foreground mt-2">Large (64px)</p>
            </div>

            <div class="text-center">
              <.avatar class="size-24">
                <.avatar_image
                  src="https://github.com/shadcn.png"
                  alt="@shadcn"
                />
                <.avatar_fallback>CN</.avatar_fallback>
              </.avatar>
              <p class="text-xs text-muted-foreground mt-2">Extra Large (96px)</p>
            </div>
          </.flex>
        </section>

        <%!-- Square Avatars --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Square Avatars</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Use rounded corners instead of circular for company logos or similar use cases.
          </p>
          <.flex align="center" class="gap-4 flex-wrap">
            <.avatar class="rounded-lg">
              <.avatar_image
                src="https://github.com/vercel.png"
                alt="@vercel"
              />
              <.avatar_fallback>VC</.avatar_fallback>
            </.avatar>

            <.avatar class="rounded-lg size-12">
              <.avatar_image
                src="https://github.com/nextjs.png"
                alt="@nextjs"
              />
              <.avatar_fallback>NX</.avatar_fallback>
            </.avatar>

            <.avatar class="rounded-lg size-16">
              <.avatar_fallback>CO</.avatar_fallback>
            </.avatar>
          </.flex>
        </section>

        <%!-- Grouped Avatars --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Grouped Avatars</h2>
          <p class="text-sm text-muted-foreground mb-4">
            Display multiple avatars overlapping to show group membership or participants.
          </p>
          <.flex align="start" class="gap-8 flex-wrap">
            <div>
              <p class="text-sm font-medium text-foreground mb-3">Team Members (4)</p>
              <div class="flex -space-x-2">
                <.avatar class="ring-2 ring-background">
                  <.avatar_image
                    src="https://github.com/shadcn.png"
                    alt="@shadcn"
                  />
                  <.avatar_fallback>CN</.avatar_fallback>
                </.avatar>
                <.avatar class="ring-2 ring-background">
                  <.avatar_image
                    src="https://github.com/vercel.png"
                    alt="@vercel"
                  />
                  <.avatar_fallback>VC</.avatar_fallback>
                </.avatar>
                <.avatar class="ring-2 ring-background">
                  <.avatar_fallback>JD</.avatar_fallback>
                </.avatar>
                <.avatar class="ring-2 ring-background">
                  <.avatar_fallback>AB</.avatar_fallback>
                </.avatar>
              </div>
            </div>

            <div>
              <p class="text-sm font-medium text-foreground mb-3">More Than 5</p>
              <div class="flex -space-x-2">
                <.avatar class="ring-2 ring-background">
                  <.avatar_fallback>A</.avatar_fallback>
                </.avatar>
                <.avatar class="ring-2 ring-background">
                  <.avatar_fallback>B</.avatar_fallback>
                </.avatar>
                <.avatar class="ring-2 ring-background">
                  <.avatar_fallback>C</.avatar_fallback>
                </.avatar>
                <.avatar class="ring-2 ring-background">
                  <.avatar_fallback>D</.avatar_fallback>
                </.avatar>
                <.avatar class="ring-2 ring-background">
                  <.avatar_fallback class="text-xs">+5</.avatar_fallback>
                </.avatar>
              </div>
            </div>

            <div>
              <p class="text-sm font-medium text-foreground mb-3">Large Group</p>
              <div class="flex -space-x-3">
                <.avatar class="ring-2 ring-background size-12">
                  <.avatar_image
                    src="https://github.com/shadcn.png"
                    alt="@shadcn"
                  />
                  <.avatar_fallback>CN</.avatar_fallback>
                </.avatar>
                <.avatar class="ring-2 ring-background size-12">
                  <.avatar_fallback>JD</.avatar_fallback>
                </.avatar>
                <.avatar class="ring-2 ring-background size-12">
                  <.avatar_fallback>AB</.avatar_fallback>
                </.avatar>
                <.avatar class="ring-2 ring-background size-12">
                  <.avatar_fallback>MK</.avatar_fallback>
                </.avatar>
                <.avatar class="ring-2 ring-background size-12">
                  <.avatar_fallback class="text-sm">+12</.avatar_fallback>
                </.avatar>
              </div>
            </div>
          </.flex>
        </section>

        <%!-- With Status Indicators --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">With Status Indicators</h2>
          <.flex align="center" class="gap-6 flex-wrap">
            <div class="relative">
              <.avatar class="size-12">
                <.avatar_image
                  src="https://github.com/shadcn.png"
                  alt="@shadcn"
                />
                <.avatar_fallback>CN</.avatar_fallback>
              </.avatar>
              <span class="absolute bottom-0 right-0 block size-3 rounded-full bg-success ring-2 ring-background">
              </span>
            </div>

            <div class="relative">
              <.avatar class="size-12">
                <.avatar_fallback>JD</.avatar_fallback>
              </.avatar>
              <span class="absolute bottom-0 right-0 block size-3 rounded-full bg-warning ring-2 ring-background">
              </span>
            </div>

            <div class="relative">
              <.avatar class="size-12">
                <.avatar_fallback>AB</.avatar_fallback>
              </.avatar>
              <span class="absolute bottom-0 right-0 block size-3 rounded-full bg-muted-foreground ring-2 ring-background">
              </span>
            </div>
          </.flex>
        </section>

        <%!-- In Cards --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">In Cards</h2>
          <.grid cols={2}>
            <.card>
              <.card_header>
                <.flex align="center" class="gap-4">
                  <.avatar class="size-12">
                    <.avatar_image
                      src="https://github.com/shadcn.png"
                      alt="@shadcn"
                    />
                    <.avatar_fallback>CN</.avatar_fallback>
                  </.avatar>
                  <div>
                    <.card_title>shadcn</.card_title>
                    <.card_description>@shadcn</.card_description>
                  </div>
                </.flex>
              </.card_header>
              <.card_content>
                <p class="text-sm text-foreground">
                  Creator of shadcn/ui, a collection of beautifully designed components.
                </p>
              </.card_content>
            </.card>

            <.card>
              <.card_header>
                <.flex align="center" class="gap-4">
                  <.avatar class="size-12 rounded-lg">
                    <.avatar_image
                      src="https://github.com/vercel.png"
                      alt="Vercel"
                    />
                    <.avatar_fallback>VC</.avatar_fallback>
                  </.avatar>
                  <div>
                    <.card_title>Vercel</.card_title>
                    <.card_description>vercel.com</.card_description>
                  </div>
                </.flex>
              </.card_header>
              <.card_content>
                <p class="text-sm text-foreground">
                  Develop. Preview. Ship. For the best frontend teams.
                </p>
              </.card_content>
            </.card>
          </.grid>
        </section>

        <%!-- User Lists --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">User Lists</h2>
          <.card class="max-w-md">
            <.card_header>
              <.card_title>Team Members</.card_title>
              <.card_description>Manage your team members and their roles.</.card_description>
            </.card_header>
            <.card_content>
              <.stack size="small">
                <.flex align="center" class="justify-between">
                  <.flex align="center" class="gap-3">
                    <.avatar>
                      <.avatar_image
                        src="https://github.com/shadcn.png"
                        alt="Sofia Davis"
                      />
                      <.avatar_fallback>SD</.avatar_fallback>
                    </.avatar>
                    <div>
                      <p class="text-sm font-medium text-foreground">Sofia Davis</p>
                      <p class="text-xs text-muted-foreground">sofia@example.com</p>
                    </div>
                  </.flex>
                  <.badge>Owner</.badge>
                </.flex>

                <.flex align="center" class="justify-between">
                  <.flex align="center" class="gap-3">
                    <.avatar>
                      <.avatar_fallback>JL</.avatar_fallback>
                    </.avatar>
                    <div>
                      <p class="text-sm font-medium text-foreground">Jackson Lee</p>
                      <p class="text-xs text-muted-foreground">jackson@example.com</p>
                    </div>
                  </.flex>
                  <.badge variant="secondary">Member</.badge>
                </.flex>

                <.flex align="center" class="justify-between">
                  <.flex align="center" class="gap-3">
                    <.avatar>
                      <.avatar_fallback>IM</.avatar_fallback>
                    </.avatar>
                    <div>
                      <p class="text-sm font-medium text-foreground">Isabella Nguyen</p>
                      <p class="text-xs text-muted-foreground">isabella@example.com</p>
                    </div>
                  </.flex>
                  <.badge variant="secondary">Member</.badge>
                </.flex>
              </.stack>
            </.card_content>
          </.card>
        </section>

        <%!-- Custom Fallback Colors --%>
        <section>
          <h2 class="text-xl font-semibold text-foreground mb-4">Custom Fallback Colors</h2>
          <.flex align="center" class="gap-4 flex-wrap">
            <.avatar>
              <.avatar_fallback class="bg-primary text-primary-foreground">
                AP
              </.avatar_fallback>
            </.avatar>

            <.avatar>
              <.avatar_fallback class="bg-secondary text-secondary-foreground">
                BQ
              </.avatar_fallback>
            </.avatar>

            <.avatar>
              <.avatar_fallback class="bg-destructive text-destructive-foreground">
                CR
              </.avatar_fallback>
            </.avatar>

            <.avatar>
              <.avatar_fallback class="bg-success text-white">
                DS
              </.avatar_fallback>
            </.avatar>

            <.avatar>
              <.avatar_fallback class="bg-warning text-foreground">
                ET
              </.avatar_fallback>
            </.avatar>

            <.avatar>
              <.avatar_fallback class="bg-info text-white">
                FU
              </.avatar_fallback>
            </.avatar>
          </.flex>
        </section>
      </.stack>
    </.container>
    """
  end
end
