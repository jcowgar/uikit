defmodule DemoWeb.PageControllerTest do
  use DemoWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "UI Component Library"
  end
end
