defmodule UiKit.Components.Ui.Marketing do
  @moduledoc """
  Marketing components for landing pages and promotional content.
  """
  use Phoenix.Component

  import UiKit.Components.LayoutComponents
  import UiKit.Components.Ui.Typography

  @doc """
  Renders a Hero section.

  ## Examples

      <.hero>
        <:headline>Welcome to OPL</:headline>
        <:description>The best pool league.</:description>
        <:actions>
          <.button>Join Now</.button>
        </:actions>
      </.hero>
  """
  attr(:align, :atom, default: :center, values: [:left, :center])
  attr(:size, :atom, default: :default, values: [:default, :large])
  attr(:variant, :atom, default: :default, values: [:default, :primary, :muted])
  attr(:class, :string, default: nil)
  slot(:headline, required: true)
  slot(:subheadline)
  slot(:description)
  slot(:actions)

  def hero(assigns) do
    hero_class =
      [
        hero_variant_class(assigns.variant),
        hero_size_class(assigns.size),
        assigns.class
      ]
      |> Enum.filter(& &1)
      |> Enum.join(" ")

    hero_text_class_h1 = hero_text_class(assigns.variant, :h1)

    hero_text_class_lead =
      [
        "max-w-2xl",
        hero_text_class(assigns.variant, :lead)
      ]
      |> Enum.filter(& &1)
      |> Enum.join(" ")

    assigns =
      assigns
      |> assign(:hero_class, hero_class)
      |> assign(:hero_text_class_h1, hero_text_class_h1)
      |> assign(:hero_text_class_lead, hero_text_class_lead)

    ~H"""
    <.section class={@hero_class}>
      <.container>
        <div class={[
          "flex flex-col gap-6",
          hero_align_class(@align)
        ]}>
          <%= if @subheadline do %>
            <.typography variant={:h3} class="text-primary font-medium">
              {render_slot(@subheadline)}
            </.typography>
          <% end %>

          <.typography variant={:h1} class={@hero_text_class_h1}>
            {render_slot(@headline)}
          </.typography>

          <%= if @description do %>
            <.typography variant={:lead} class={@hero_text_class_lead}>
              {render_slot(@description)}
            </.typography>
          <% end %>

          <%= if @actions do %>
            <div class={[
              "flex flex-wrap gap-4 mt-4",
              hero_actions_align_class(@align)
            ]}>
              {render_slot(@actions)}
            </div>
          <% end %>
        </div>
      </.container>
    </.section>
    """
  end

  @doc """
  Renders a Call-to-Action section.

  ## Examples

      <.cta>
        <:headline>Ready to play?</:headline>
        <:description>Join a team today.</:description>
        <:actions>
          <.button>Sign Up</.button>
        </:actions>
      </.cta>
  """
  attr(:align, :atom, default: :center, values: [:left, :center])
  attr(:variant, :atom, default: :default, values: [:default, :primary, :muted])
  attr(:class, :string, default: nil)
  slot(:headline, required: true)
  slot(:description)
  slot(:actions)

  def cta(assigns) do
    cta_class =
      [
        "py-16 md:py-24",
        cta_variant_class(assigns.variant),
        assigns.class
      ]
      |> Enum.filter(& &1)
      |> Enum.join(" ")

    cta_text_class_h2 = hero_text_class(assigns.variant, :h2)

    cta_text_class_lead =
      [
        "max-w-2xl",
        hero_text_class(assigns.variant, :lead)
      ]
      |> Enum.filter(& &1)
      |> Enum.join(" ")

    assigns =
      assigns
      |> assign(:cta_class, cta_class)
      |> assign(:cta_text_class_h2, cta_text_class_h2)
      |> assign(:cta_text_class_lead, cta_text_class_lead)

    ~H"""
    <.section class={@cta_class}>
      <.container>
        <div class={[
          "flex flex-col gap-6",
          hero_align_class(@align)
        ]}>
          <.typography variant={:h2} class={@cta_text_class_h2}>
            {render_slot(@headline)}
          </.typography>

          <%= if @description do %>
            <.typography variant={:lead} class={@cta_text_class_lead}>
              {render_slot(@description)}
            </.typography>
          <% end %>

          <%= if @actions do %>
            <div class={[
              "flex flex-wrap gap-4 mt-4",
              hero_actions_align_class(@align)
            ]}>
              {render_slot(@actions)}
            </div>
          <% end %>
        </div>
      </.container>
    </.section>
    """
  end

  # Helpers

  defp hero_align_class(:center), do: "items-center text-center mx-auto"
  defp hero_align_class(:left), do: "items-start text-left"

  defp hero_actions_align_class(:center), do: "justify-center"
  defp hero_actions_align_class(:left), do: "justify-start"

  defp hero_size_class(:default), do: "py-16 md:py-24"
  defp hero_size_class(:large), do: "py-24 md:py-32"

  defp hero_variant_class(:default), do: "bg-background"
  defp hero_variant_class(:muted), do: "bg-muted"
  defp hero_variant_class(:primary), do: "bg-primary"

  defp cta_variant_class(:default), do: "bg-background"
  defp cta_variant_class(:muted), do: "bg-muted"
  defp cta_variant_class(:primary), do: "bg-primary"

  # Text color adjustments based on background variant
  defp hero_text_class(:primary, _), do: "text-primary-foreground"
  defp hero_text_class(:muted, :lead), do: "text-muted-foreground"
  defp hero_text_class(:default, :lead), do: "text-muted-foreground"
  # Default text color
  defp hero_text_class(_, _), do: ""
end
