defmodule Who.PageController do
  use Who.Web, :controller

  plug :authenticate

  def index(conn, _params) do
    render conn, "index.html"
  end

  defp authenticate(conn, _) do
    case authenticator_find_user(conn) do
      {:ok, user} ->
        assign(conn, :user, user)
      :error ->
        conn |> put_flash(:info, "You must be logged in") |> redirect(to: "/login") |> halt
    end
  end

  defp authenticator_find_user(conn) do
    github_token_size = 40
    access_token = get_session(conn, :access_token) || System.get_env("GITHUB_OAUTH_KEY")
    if access_token !== nil and String.length(access_token) === github_token_size do
      {:ok, Github.user(access_token) }
    else
      :error
    end
  end
end
