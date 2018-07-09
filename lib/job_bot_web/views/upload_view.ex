defmodule JobBotWeb.UploadView do
  use JobBotWeb, :view

  def render("create.json", %{file: file}), do: file
end