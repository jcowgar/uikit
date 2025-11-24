defmodule UiKit.Components.Ui.MarketingTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  import Phoenix.Component
  import UiKit.Components.Ui.Marketing

  describe "hero" do
    test "renders headline" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.hero>
          <:headline>Welcome</:headline>
          <:description>Subtext</:description>
        </.hero>
        """)

      assert html =~ "Welcome"
      assert html =~ "Subtext"
      # Typography h1 uses text-heading-xl
      assert html =~ "text-heading-xl"
    end

    test "renders actions" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.hero>
          <:headline>H</:headline>
          <:actions>
            <button>Click me</button>
          </:actions>
        </.hero>
        """)

      assert html =~ "Click me"
    end

    test "renders with primary variant" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.hero variant={:primary}>
          <:headline>Primary</:headline>
        </.hero>
        """)

      assert html =~ "bg-primary"
      # Checks if h1 has the text color class applied
      assert html =~ "text-primary-foreground"
    end

    test "renders aligned left" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.hero align={:left}>
          <:headline>Left</:headline>
        </.hero>
        """)

      assert html =~ "text-left"
      assert html =~ "items-start"
    end
  end

  describe "cta" do
    test "renders headline" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.cta>
          <:headline>Join Now</:headline>
        </.cta>
        """)

      assert html =~ "Join Now"
      # Typography h2 uses text-heading-lg
      assert html =~ "text-heading-lg"
    end

    test "renders description" do
      assigns = %{}

      html =
        rendered_to_string(~H"""
        <.cta>
          <:headline>H</:headline>
          <:description>Desc</:description>
        </.cta>
        """)

      assert html =~ "Desc"
    end
  end
end
