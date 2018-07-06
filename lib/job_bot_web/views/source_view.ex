defmodule JobBotWeb.SourceView do
  use JobBotWeb, :view

  def render("index.json", %{sources: sources}), do: sources
end