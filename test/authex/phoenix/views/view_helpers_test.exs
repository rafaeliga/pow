defmodule AuthexTest.Phoenix.TestView do
  def render(_template, _opts), do: :ok
end
defmodule Authex.Test.Phoenix.AuthexTest.TestView do
  def render(_template, _opts), do: :ok
end
defmodule Authex.Phoenix.ViewHelpersTest do
  use Authex.Test.Phoenix.ConnCase
  doctest Authex.Phoenix.ViewHelpers

  alias Authex.Phoenix.ViewHelpers
  alias Authex.Test.Ecto.Users.User
  alias Plug.Conn

  setup %{conn: conn} do
    changeset   = User.changeset(%User{}, %{})
    action      = "/"
    conn =
      conn
      |> Map.put(:params, %{"_format" => "html"})
      |> Conn.put_private(:authex_config, [])
      |> Conn.put_private(:phoenix_endpoint, Authex.Test.Phoenix.Endpoint)
      |> Conn.put_private(:phoenix_view, Authex.Phoenix.SessionView)
      |> Conn.put_private(:phoenix_layout, {Authex.Phoenix.LayoutView, :app})
      |> Conn.put_private(:phoenix_router, Authex.Test.Phoenix.Router)
      |> Conn.assign(:changeset, changeset)
      |> Conn.assign(:action, action)

    {:ok, %{conn: conn}}
  end

  test "render/3", %{conn: conn} do
    conn = ViewHelpers.render(conn, :new)

    assert conn.private[:phoenix_endpoint] == Authex.Test.Phoenix.Endpoint
    assert conn.private[:phoenix_view] == Authex.Phoenix.SessionView
    assert conn.private[:phoenix_layout] == {Authex.Test.Phoenix.LayoutView, :app}
  end

  test "render/3 with :web_module", %{conn: conn} do
    conn =
      conn
      |> Conn.put_private(:authex_config, [web_module: Authex.Test.Phoenix])
      |> ViewHelpers.render(:new)

    assert conn.private[:phoenix_endpoint] == Authex.Test.Phoenix.Endpoint
    assert conn.private[:phoenix_view] == Authex.Test.Phoenix.Authex.SessionView
    assert conn.private[:phoenix_layout] == {Authex.Test.Phoenix.LayoutView, :app}
  end

  test "render/3 in extension", %{conn: conn} do
    conn =
      conn
      |> Conn.put_private(:phoenix_view, AuthexTest.Phoenix.TestView)
      |> ViewHelpers.render(:new)

    assert conn.private[:phoenix_endpoint] == Authex.Test.Phoenix.Endpoint
    assert conn.private[:phoenix_view] == AuthexTest.Phoenix.TestView
    assert conn.private[:phoenix_layout] == {Authex.Test.Phoenix.LayoutView, :app}
  end

  test "render/3 in extension with :web_module", %{conn: conn} do
    conn =
      conn
      |> Conn.put_private(:phoenix_view, AuthexTest.Phoenix.TestView)
      |> Conn.put_private(:authex_config, [web_module: Authex.Test.Phoenix])
      |> ViewHelpers.render(:new)

    assert conn.private[:phoenix_endpoint] == Authex.Test.Phoenix.Endpoint
    assert conn.private[:phoenix_view] == Authex.Test.Phoenix.AuthexTest.TestView
    assert conn.private[:phoenix_layout] == {Authex.Test.Phoenix.LayoutView, :app}
  end
end