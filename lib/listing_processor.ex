defmodule JobBot.ListingProcessor do
  use GenServer

  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_), do: {:ok, []}

  def process({:ok, listing}) do
  end

  def process({:error, message}) do
    Logger.info IO.ANSI.red <> message <> IO.ANSI.reset
  end
end