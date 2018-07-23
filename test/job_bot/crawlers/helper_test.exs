defmodule JobBot.Crawler.HelperTest do
  use ExUnit.Case

  alias JobBot.Crawler.Helper

  test "relative_to_absolute_url/2" do
    base_url = "http://testsite.com"
    relative_path = "/path"
    expected_path = base_url <> relative_path

    return_path = Helper.relative_to_absolute_url(base_url, relative_path)

    assert return_path == expected_path
  end
end