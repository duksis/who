defmodule Github do
  def oauth_uri do
    api.authorize_uri
  end

  def authenticate(code) do
    response = api.access_token(code)
    String.slice(response, 13, 40)
  end

  def user(access_token) do
    resp = api.user(access_token)
    Map.get(resp, "login")
  end

  def random_reviewer(pull_request, access_token) do
    current_user = user(access_token)
    col = collaborators(pull_request, access_token)
    con = contributors(pull_request, access_token)
    if Dict.size(con) == 0, do: con = contributors(pull_request, access_token)
    in_both = Common.members_of_both(con, col)
    shuffled = Common.shuffle(in_both -- [current_user])
    Enum.take(shuffled,1)
  end

  def ask_to_review(pull_request, reviewer, access_token) do
    assing_to_pr(pull_request, reviewer, access_token)
    comment = "Hey @#{reviewer} would you have time to review this? [/®](http://who-will-review-my-pr.herokuapp.com)"
    resp = api.post_comment(access_token, pull_request, comment)
    resp
  end

  defp assing_to_pr(pull_request, reviewer, access_token) do
    issue = api.issue(access_token, pull_request)
    if Dict.size(reviewer) != 0 && Map.get(issue, "assignee") == nil do
      api.post_assignee(access_token, pull_request, reviewer)
    end
  end

  defp collaborators(pull_request, access_token) do
    resp = api.collaborators(access_token, pull_request)
    Enum.map(resp, &get_user_login/1)
  end

  defp contributors(pull_request, access_token) do
    resp = api.contributors(access_token, pull_request)
    Enum.map(resp, &get_contribution_author/1)
  end

  defp get_user_login(user) do
    Map.get(user, "login")
  end

  defp get_contribution_author(contribution) do
    get_user_login(
      Map.get(contribution, "author")
    )
  end

  defp api do
    Github.Api
  end
end

