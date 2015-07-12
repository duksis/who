defmodule Who.SessionController do
  use Who.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", github_oauth_uri: Github.oauth_uri
  end

  def create(conn, %{"code" => code}) do
    auth_code = Github.authenticate(code)
    put_session(conn, :access_token, auth_code) |> redirect(to: "/") |> halt
  end

  def destroy(conn, _params) do
    put_session(conn, :access_token, nil) |> redirect(to: "/login") |> halt
  end
end
