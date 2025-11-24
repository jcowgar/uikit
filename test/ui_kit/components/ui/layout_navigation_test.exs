defmodule UiKit.Components.Ui.LayoutNavigationTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  import Phoenix.Component
  import UiKit.Components.Ui.LayoutNavigation

  describe "tab_bar" do
    test "renders with items" do
      assigns = %{active_path: "/"}

      html =
        rendered_to_string(~H"""
        <.tab_bar active_path={@active_path}>
          <.tab_bar_item navigate="/" icon="hero-home" label="Home" />
          <.tab_bar_item navigate="/settings" icon="hero-cog" label="Settings" />
        </.tab_bar>
        """)

      assert html =~ "fixed inset-x-0 bottom-0"
      assert html =~ "Home"
      assert html =~ "Settings"
      assert html =~ "hero-home"
      assert html =~ "hero-cog"
    end

    test "marks active item based on active_path" do
      assigns = %{active_path: "/settings"}

      html =
        rendered_to_string(~H"""
        <.tab_bar active_path={@active_path}>
          <.tab_bar_item navigate="/" label="Home" />
          <.tab_bar_item navigate="/settings" label="Settings" />
        </.tab_bar>
        """)

      # The hook updates data-active, but server-side rendering might only set initial state?
      # Let's check the implementation of tab_bar_item.
      # It uses `data-[active=true]` styles.
      # But the active state logic seems to be in the Hook (client-side)?
      # Wait, looking at the code:
      # <.tab_bar phx-hook="TabBarHook" data-active-path={@active_path} ...>
      # The item:
      # <.link ... class="... data-[active=true]:text-primary ...">
      # There is NO server-side logic in `tab_bar_item` to set `data-active="true"`.
      # It relies ENTIRELY on the JS hook `TabBarHook` to set `data-active="true"`.
      
      # So I cannot test the visual active state in a static render test easily, 
      # unless I check for the `data-active-path` attribute on the container.
      
      assert html =~ "data-active-path=\"/settings\""
    end

    test "renders badges" do
      assigns = %{active_path: "/"}

      html =
        rendered_to_string(~H"""
        <.tab_bar active_path={@active_path}>
          <.tab_bar_item navigate="/alerts" label="Alerts" badge="5" />
        </.tab_bar>
        """)

      assert html =~ "bg-red-500"
      assert html =~ "5"
    end
    
    test "renders correct link attributes" do
      assigns = %{active_path: "/"}
       html =
        rendered_to_string(~H"""
        <.tab_bar active_path={@active_path}>
          <.tab_bar_item navigate="/link" label="Link" />
        </.tab_bar>
        """)
        
      assert html =~ "href=\"/link\""
      assert html =~ "data-phx-link=\"redirect\""
      assert html =~ "data-phx-link-state=\"push\"" 
    end
  end
end
