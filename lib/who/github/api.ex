
defmodule Github.Api do
  def authorize_uri do
    uri.authorize(client_id, redirect_uri)
  end

  def access_token(code) do
    http.post(
      uri.access_token(client_id, client_secret, code, redirect_uri)
    )
  end

  def user(access_token) do
    {:ok, resp } = JSON.decode(
      http.get(access_token, uri.user)
    )
    resp
  end

  def collaborators(access_token, pull_request) do
    [owner, repo, _] = decompose_pr(pull_request)

    {:ok, resp} = JSON.decode(
      http.get(access_token, uri.collaborators(owner, repo))
    )
    resp
  end

  def contributors(access_token, pull_request) do
    [owner, repo, _] = decompose_pr(pull_request)

    {:ok, resp } = JSON.decode(
      http.get(access_token, uri.contributors(owner, repo))
    )
    resp
  end

  def issue(access_token, pull_request) do
    [owner, repo, number] = decompose_pr(pull_request)

    {:ok, resp } = JSON.decode(
      http.get(access_token, uri.issue(owner, repo, number))
    )
    resp
  end

  def post_comment(access_token, pull_request, comment) do
    [owner, repo, number] = decompose_pr(pull_request)
    request_body = "{ \"body\": \"#{comment}\" }"
    http.post(access_token, uri.comments(owner, repo, number), request_body)
  end

  def post_assignee(access_token, pull_request, assignee) do
    [owner, repo, number] = decompose_pr(pull_request)
    request_body = "{ \"assignee\": \"#{assignee}\" }"
    http.post(access_token, uri.issue(owner, repo, number), request_body)
  end

  defp decompose_pr(path) do
    case String.split(URI.parse(path).path, "/") do
      [_, owner, repo, _, number] -> [owner, repo, number]
      [_, owner, repo, _, number, _] -> [owner, repo, number]
    end
  end

  defp client_id do
    Config.client_id
  end

  defp client_secret do
    Config.client_secret
  end

  defp redirect_uri do
    Config.root_url <> "/authenticate"
  end

  defp uri do
    Github.Uri
  end

  defp http do
    if Mix.env == :prod do
      HTTP
    else
      FakeHTTP
    end
  end
end

