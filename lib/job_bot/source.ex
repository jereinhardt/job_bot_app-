defmodule JobBot.Source do
  defstruct name: nil, scraper: nil, applier: nil, credentials: %{}

  def all do
    [
      %__MODULE__{
        applier: JobBot.ElixirJobsApplier,
        name: "Elixir Jobs",
        scraper: JobBot.ElixirJobsScraper,
        credentials: %{}
      },
      %__MODULE__{
        applier: JobBot.StackOverflowApplier,
        name: "Stack Overflow",
        scraper: JobBot.StackOverflowScraper,
        credentials: %{}
      },
      %__MODULE__{
        applier: JobBot.WeWorkRemotelyApplier,
        name: "We Work Remotely",
        scraper: JobBot.WeWorkRemotelyScraper,
        credentials: %{}
      },
      %__MODULE__{
        applier: JobBot.GithubJobsApplier,
        name: "Github Jobs",
        scraper: JobBot.GithubJobsScraper,
        credentials: %{}
      },
      %__MODULE__{
        name: "Zip Recruiter",
        scraper: JobBot.ZipRecruiterScraper,
        credentials: %{}
      },
      %__MODULE__{
        name: "AngelList",
        scraper: JobBot.AngelListScraper,
        credentials: %{}
      }
    ]
  end

  def from_map(map) do
    map
      |> atomize_keys()
      |> constantize_scraper()
      |> constantize_applier()
      |> __MODULE__.__struct__()
  end

  defp atomize_keys(map) do
    for {k, v} <- map, into: %{}, do: {String.to_atom(k), v}
  end

  defp constantize_scraper(map) do
    scraper = String.to_atom(map[:scraper])
    Map.put(map, :scraper, scraper)
  end

  defp constantize_applier(map) do
    if is_nil(map[:applier]) do
      map
    else
      applier = String.to_atom(map[:applier])
      Map.put(map, :applier, applier)
    end
  end
end