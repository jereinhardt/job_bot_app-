defmodule JobBotWeb.UploadController do
  use JobBotWeb, :controller

  @tmp_folder "uploads/tmp/resumes"

  def create(conn, %{"file" => file}) do
    string = :crypto.strong_rand_bytes(10)
      |> Base.url_encode64
      |> binary_part(0, 10)
    {:ok, path} = JobBotWeb.Upload.store({file, %{id: string}})
    render(
      conn,
      "create.json",
      file: %{path: "#{@tmp_folder}/#{string}/#{path}"}
    )
  end
end