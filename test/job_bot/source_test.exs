defmodule JobBot.SourceTest do
  use ExUnit.Case

  alias JobBot.Source

  describe "from_map/1" do
    test "it creates a struct from a map with string keys and constants" do
      source = %Source{crawler: JobBot.TestScraper}

      source_map = %{"crawler" => "Elixir.JobBot.TestScraper"}

      assert Source.from_map(source_map) == source
    end
  end
end