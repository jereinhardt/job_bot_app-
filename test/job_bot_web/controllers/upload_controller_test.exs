defmodule JobBotWeb.UploadControllerTest do
  use JobBotWeb.ConnCase

  import Mock

  test "#create returns the path the upload is saved at", %{conn: conn} do
    with_mock(JobBotWeb.Upload, [store: fn(_) -> {:ok, "path/to_file.pdf"} end]) do
      response =
        conn
        |> post("uploads", %{"file" => %Plug.Upload{}})
        |> json_response(200)

      assert response == %{path: "uploads/tmp/resumes/rand/path/to_file.pdf"}
    end
  end
end