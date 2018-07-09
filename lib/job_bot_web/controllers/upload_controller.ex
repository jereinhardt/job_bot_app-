defmodule JobBotWeb.UploadController do
  use JobBotWeb, :controller

  @tmp_folder "uploads/tmp/resumes"

  def create(conn, %{"file" => file}) do
    string = :crypto.strong_rand_bytes(10)
      |> Base.url_encode64
      |> binary_part(0, 10)
    with {:ok, path} <- JobBotWeb.Upload.store({file, %{id: string}}),
      {:ok, data} <- Poison.encode(%{path: "#{@tmp_folder}/#{string}/#{path}"})
    do
      render conn, "create.json", file: data
    end
  end
end