defmodule HTTP do
  def post(uri) do
    response = HTTPotion.post uri, [headers: ["User-Agent": "Who will review my PR?"]]
    response.body
  end

  def post(access_token, uri, request_body) do
    response = HTTPotion.post uri, [body: request_body ,headers: ["Authorization": "token #{access_token}", "User-Agent": "Who will review my PR?"]]
    response.body
  end

  def get(access_token, uri) do
    response = HTTPotion.get uri, [headers: ["Authorization": "token #{access_token}", "User-Agent": "Who will review my PR?"]]
    response.body
  end
end
