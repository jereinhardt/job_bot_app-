defmodule JobBot.Source do
  defstruct name: nil, crawler: nil, applier: nil

  def all do
    [
      %__MODULE__{
        name: "Stack Overflow",
        crawler: JobBot.Crawler.StackOverflow
      },
      %__MODULE__{
        name: "We Work Remotely",
        crawler: JobBot.Crawler.WeWorkRemotely
      },
      %__MODULE__{
        name: "Github Jobs",
        crawler: JobBot.Crawler.GithubJobs
      },
      %__MODULE__{
        name: "Zip Recruiter",
        crawler: JobBot.Crawler.ZipRecruiter
      },
      %__MODULE__{
        name: "AngelList",
        crawler: JobBot.Crawler.AngelList
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