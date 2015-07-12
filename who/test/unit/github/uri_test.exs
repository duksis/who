defmodule Github.UriTest do
  use ExUnit.Case

  test "issue/3 returns the uri for issue" do
    assert Github.Uri.issue("wimdu", "who", "1") ==
      "https://api.github.com/repos/wimdu/who/issues/1"
  end

  test "comments/3 returns the uri for issue comments" do
    assert Github.Uri.comments("wimdu", "who", "1") ==
      "https://api.github.com/repos/wimdu/who/issues/1/comments"
  end

  test "contributors/2 returns the uri for reposritory contributors" do
    assert Github.Uri.contributors("wimdu", "who") ==
      "https://api.github.com/repos/wimdu/who/stats/contributors"
  end

  test "collaborators/2 returns the uri for reposritory collaborators" do
    assert Github.Uri.collaborators("wimdu", "who") ==
      "https://api.github.com/repos/wimdu/who/collaborators"
  end

  test "user/0 returns the uri for current user" do
    assert Github.Uri.user == "https://api.github.com/user"
  end
end
