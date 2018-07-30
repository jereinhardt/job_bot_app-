defmodule JobBot.SourceTest do
  use ExUnit.Case

  alias JobBot.Source

  describe "from_map/1" do
    test "it creates a struct from a map with string keys and constants" do
      source_with_applier = %Source{
        applier: JobBot.TestApplier,
        crawler: JobBot.TestScraper
      }
      source_without_applier = %Source{crawler: JobBot.TestScraper}

      map_with_applier = %{
        "applier" => "Elixir.JobBot.TestApplier",
        "crawler" => "Elixir.JobBot.TestScraper"
      }
      map_without_applier = %{"crawler" => "Elixir.JobBot.TestScraper"}

      assert Source.from_map(map_with_applier) == source_with_applier
      assert Source.from_map(map_without_applier) == source_without_applier
    end
  end
end