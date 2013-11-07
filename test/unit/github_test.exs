defmodule GithubTest do
  use ExUnit.Case

  test "oauth_uri" do
    assert Github.oauth_uri == "https://github.com/login/oauth/authorize" <>
      "?client_id=the_github_client_id&scope=repo" <>
      "&redirect_uri=localhost%3A4000%2Fauthenticate"
  end

  test "random_reviewer/3 does not return the current user" do
    :meck.new(Github.Api)
    :meck.expect(Github.Api, :contributors,
      fn(_,_) ->
        JSON.decode!(
          "[{\"author\": {\"login\": \"duksis\"}, \"author\": {\"login\": \"paranoid\"}}]"
        )
      end
    )
    :meck.expect(Github.Api, :collaborators,
      fn(_,_) -> JSON.decode! "[ {\"login\": \"duksis\"}, {\"login\": \"paranoid\"} ]" end
    )

    assert Github.random_reviewer(
      "http://github.com/wimdu/who/pulls/1", "duksis", "valid token"
    ) == ["paranoid"]

    :meck.unload(Github.Api)
  end
end
