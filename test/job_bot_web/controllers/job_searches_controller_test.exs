defmodule JobBotWeb.JobSearchesControllerTest do
  use JobBotWeb.ConnCase
  use JobBotWeb.AuthCase

  describe "create search when user is not logged in" do
    test "returns 401 when there is no logged in user", %{conn: conn} do
      response = conn
        |> post("data/job_searches", %{user_id: 1, sources: sources()})
        |> response(401)
        |> Poison.decode!()

      assert response == %{"message" => "unauthenticated"}
    end
  end

  describe "create search when user is logged in" do
    setup [:log_in_user]

    test "returns a status code of 201 on success", %{conn: conn} do
      response =
        conn
        |> post("data/job_searches", %{user_id: 1, sources: sources()})
        |> json_response(201)

      assert response == %{}
    end
  end

  defp sources do
    %{
      "0" => %{
        "applier" => "Elixir.JobBot.WeWorkRemotelyApplier",
        "crawler" => "Elixir.JobBot.WeWorkRemotelyScraper",
        "name" => "We Work Remotely"
      }
    }
  end
end