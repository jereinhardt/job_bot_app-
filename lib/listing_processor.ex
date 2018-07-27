defmodule JobBot.ListingProcessor do
  require Logger

  def process(user_id, {:ok, listing}) do
    JobBotWeb.Endpoint.broadcast(
      "users:#{user_id}",
      "new_listing",
      %{"listing" => listing}
    )
  end

  def process(_user_id, {:error, message}) do
    Logger.info IO.ANSI.red <> message <> IO.ANSI.reset
  end
end