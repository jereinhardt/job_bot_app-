defmodule JobBot.CrawlerCase do
  use ExUnit.CaseTemplate
  alias HTTPoison.Response

  using do
    quote do

      defp listing_matches_response(_, {:error, _}, _), do: false
      defp listing_matches_response?(listing, {:ok, response_listing}, fields) do
        Enum.all?(fields, fn (field) ->
          Map.get(response_listing, field) == Map.get(listing, field)
        end)
      end

      defp get_fixture_response(path) do
        dirname =
          __MODULE__.__info__(:module)
          |> Atom.to_string()
          |> String.split(".")
          |> Enum.at(-1)
          |> Macro.underscore()
          |> String.replace("_test", "")
        dir_path = "test/support/fixtures/#{dirname}/"
        body = Path.expand(dir_path <> path) |> File.read!()
        {:ok, %Response{status_code: 200, body: body}}
      end
    end
  end
end