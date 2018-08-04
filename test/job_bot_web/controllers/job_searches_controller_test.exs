defmodule JobBotWeb.JobSearchesControllerTest do
  use JobBotWeb.ConnCase

  test "#create returns a status code of 201 on success", %{conn: conn} do
    response =
      conn
      |> post("api/job_searches", %{user_id: 1, sources: []})
      |> json_response(201)

    assert response == %{}
  end
end