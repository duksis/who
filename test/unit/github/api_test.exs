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
      HashDict.has_key?(&1, "author")
    )
  end
end
