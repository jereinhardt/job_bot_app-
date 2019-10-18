defmodule JobBot.JobSearches.LiveUpdates do
  alias JobBot.PubSub, as: Server
  alias Phoenix.PubSub

  @topic "job_searches"

  def subscribe_live_view(job_search) do
    PubSub.subscribe(Server, topic(job_search), link: true)
  end

  def unsubscribe_live_view(job_search) do
    PubSub.unsubscribe(Server, topic(job_search))
  end

  def broadcast_new_listing(job_search, listing) do
    PubSub.broadcast(Server, topic(job_search), {:new_listing, listing})
  end

  defp topic(job_search) do
    "#{@topic}:#{job_search.id}"
  end
end