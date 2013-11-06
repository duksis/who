defmodule FakeHTTPTest do
  use ExUnit.Case

  test "post/1 raises error when response for argument not defined" do
    assert_raise FakeHTTP.UnexpectedRequestError,
      "received an unexpected request [\"POST\", \"unexpected argument\"]", fn ->
        FakeHTTP.post("unexpected argument")
    end
  end

  test "post/3 raises error when response for argument not defined" do
    assert_raise FakeHTTP.UnexpectedRequestError,
      "received an unexpected request [\"POST\", \"unexpected argument\", \"request body\"]", fn ->
        FakeHTTP.post("access token", "unexpected argument", "request body")
    end
  end

  test "get/2 raises error when response for argument not defined" do
    assert_raise FakeHTTP.UnexpectedRequestError,
      "received an unexpected request [\"GET\", \"unexpected argument\"]", fn ->
        FakeHTTP.get("access token", "unexpected argument")
    end
  end

  test "get/2 returns the content from coresponding file in test/factories" do
    {:ok, content} = File.read("test/factories/get_repos/wimdu/who/collaborators.json")
    assert content, FakeHTTP.get("valid token","https://api.github.com/repos/wimdu/who/collaborators")
  end
end
