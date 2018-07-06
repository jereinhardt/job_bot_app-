defmodule JobBotWeb.SourceControllerTest do
  use JobBotWeb.ConnCase

  test "#index renders a list of all available sources" do
    conn = build_conn()
    sources = JobBot.Source.all() |> Poison.encode!()

    conn = get conn, source_path(conn, :index)

    assert json_response(conn, 200) == sources
  end
end