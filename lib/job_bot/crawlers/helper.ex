defmodule JobBot.Crawler.Helper do
  alias HTTPoison.{Error, Response}

  def relative_to_absolute_url(base_url, url) do
    URI.merge(base_url, url) |> URI.to_string()
  end

  def find_final_request_response({:ok, %Response{status_code: status_code} = response}) do
    case status_code do
      code when code in 200..299 -> {:ok, response}
      code when code in 300..399 -> follow_redirect_response(response)
      code when code in 400..499 -> {:error, %Error{reason: "Could not find linked url"}}
      _ -> {:error, %Error{reason: "Internal server error"}}
    end
  end

  def find_final_request_response({:error, _} = response), do: response

  defp follow_redirect_response(%Response{headers: headers} = response) do
    {"Location", url} = 
      headers
      |> Enum.find(fn({k, _}) -> k == "Location" end)

    if url == [] do
      {:error, %Error{reason: "Couldn't follow bad redirect"}}
    else
      url
      |> build_absolute_url(response)
      |> HTTPoison.get()
      |> find_final_request_response()
    end
  end

  defp build_absolute_url(url, response) do
    if String.starts_with?(url, "http") do
      url
    else
      uri = URI.parse(response.request_url)
      uri.scheme <> "://" <> uri.host <> url
    end
  end
end

