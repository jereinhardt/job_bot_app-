defmodule JobBot.Crawler.Helper do
  def relative_to_absolute_url(base_url, url) do
    URI.merge(base_url, url) |> URI.to_string()
  end
end