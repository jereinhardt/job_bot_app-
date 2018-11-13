defmodule JobBotWeb.JobSearchesControllerTest do
  use JobBotWeb.ConnCase

  test "#create returns a status code of 201 on success", %{conn: conn} do
    sources = %{
      "0" => %{
        "applier" => "Elixir.JobBot.WeWorkRemotelyApplier",
        "crawler" => "Elixir.JobBot.WeWorkRemotelyScraper",
        "credentials" => nil,
        "name" => "We Work Remotely"
      }
    }
    response =
      conn
      |> post("api/job_searches", %{user_id: 1, sources: sources})
      |> json_response(201)

    assert response == %{}
  end
end