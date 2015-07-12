defmodule Who.PageController do
  use Who.Web, :controller

  plug :authenticate

  def index(conn, _params) do
    render conn, "index.html"
  end

  def create(conn, %{"pull_request" => pull_request}) do
    case Github.random_reviewer(pull_request, conn |> access_token)do
      [] ->
        conn |> put_flash(:info, "Reviewer not found!") |> redirect(to: "/") |> halt
      reviewer ->
        Github.ask_to_review(pull_request, reviewer, conn |> access_token)
        conn |> render("review.html", pull_request: pull_request, reviewer_name: reviewer)
    end
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
    access_token = conn |> access_token
    if access_token !== nil and String.length(access_token) === github_token_size do
      {:ok, Github.user(access_token) }
    else
      :error
    end
  end

  defp access_token(conn) do
    get_session(conn, :access_token) || System.get_env("GITHUB_OAUTH_KEY")
  end
end
