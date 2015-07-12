defmodule Github.ApiTest do
  use ExUnit.Case

  defp api do
    Github.Api
  end

  test "user/1 returned data contains key 'login'" do
    assert Dict.has_key?(api.user("valid_access_token"), "login")
  end

  test "collaborators/2 returns a list of repo collaborators" do
    assert is_list(api.collaborators("valid_access_token", "/wimdu/who/pull/1"))
  end

  test "contributors/2 returns a list of repo contributors" do
    assert Enum.all?(
      api.contributors("valid_access_token", "/wimdu/who/pull/1"),
      fn(contributor) -> Map.has_key?(contributor, "author") end
    )
  end

  test "issue/2 returns the issue details" do
    assert Map.has_key?(
      api.issue("valid access token", "/wimdu/who/pull/1"), "pull_request"
    )
  end

  test "post_assignee/3 assigns user to pull request" do
    assert {:ok, _} =
      JSON.decode(api.post_assignee("valid access token", "/wimdu/who/pull/1", "duksis"))
  end
end
