defmodule FakeHTTP do
  defexception UnexpectedRequestError, params: [] do
    def message(exception) do
      "received an unexpected request #{inspect(exception.params)}"
    end
  end

  def post(uri) do
    find_response_for("POST", [uri])
  end

  def post(_, uri, request_body) do
    find_response_for("POST", [uri, request_body])
  end

  def get(_, uri) do
    find_response_for("GET", [uri])
  end

  defp find_response_for(action, params) do
    [uri | _] = params
    case File.read(file_path_for(action, uri)) do
      {:ok, content} -> content
      {_,_} -> raise UnexpectedRequestError, params: List.insert_at(params, 0, action)
    end
  end

  defp file_path_for(action, uri) do
    case URI.parse(uri).path do
      "/" <> path -> "test/factories/#{String.downcase(action)}_#{path}.json"
      _ -> ""
    end
  end
end
