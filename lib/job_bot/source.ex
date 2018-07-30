defmodule JobBot.Source do
  defstruct name: nil,
    crawler: nil,
    applier: nil,
    credentials: %{}

  def all do
    [
      %__MODULE__{
        applier: JobBot.StackOverflowApplier,
        name: "Stack Overflow",
        crawler: JobBot.StackOverflowScraper,
        credentials: %{}
      },
      %__MODULE__{
        applier: JobBot.WeWorkRemotelyApplier,
        name: "We Work Remotely",
        crawler: JobBot.WeWorkRemotelyScraper,
        credentials: nil
      },
      %__MODULE__{
        applier: JobBot.GithubJobsApplier,
        name: "Github Jobs",
        crawler: JobBot.GithubJobsScraper,
        credentials: %{}
      },
      %__MODULE__{
        name: "Zip Recruiter",
        crawler: JobBot.ZipRecruiterScraper,
        credentials: %{}
      },
      %__MODULE__{
        name: "AngelList",
        crawler: JobBot.AngelListScraper,
        credentials: %{}
      }
    ]
  end

  def from_map(map) do
    map
    |> atomize_keys()
    |> constantize_crawler()
    |> constantize_applier()
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

  defp constantize_applier(map) do
    if is_nil(map[:applier]) do
      map
    else
      applier = String.to_atom(map[:applier])
      Map.put(map, :applier, applier)
    end
  end
end