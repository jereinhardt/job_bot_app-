defmodule JobBot.Source do
  defstruct name: nil, crawler: nil, applier: nil

  def all do
    [
      %__MODULE__{
        name: "CareerBuilder",
        crawler: JobBot.Crawler.CareerBuilder
      },
      %__MODULE__{
        name: "Indeed",
        crawler: JobBot.Crawler.Indeed
      },
      %__MODULE__{
        name: "Linkedin",
        crawler: JobBot.Crawler.Linkedin
      },
      %__MODULE__{
        name: "We Work Remotely",
        crawler: JobBot.Crawler.WeWorkRemotely
      }
    ]
  end

  def from_map(map) do
    map
    |> atomize_keys()
    |> constantize_crawler()
    |> __struct__()
  end

  def find_by_name(name) do
    all() |> Enum.find(& &1.name == name)
  end

  defp atomize_keys(map) do
    for {k, v} <- map, into: %{}, do: {String.to_atom(k), v}
  end

  defp constantize_crawler(map) do
    crawler = String.to_atom(map[:crawler])
    Map.put(map, :crawler, crawler)
  end
end