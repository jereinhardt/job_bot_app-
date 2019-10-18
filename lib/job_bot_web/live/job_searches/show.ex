defmodule JobBotWeb.JobSearchesLive.Show do
  use Phoenix.LiveView

  alias JobBot.JobSearches
  alias JobBot.JobSearches.LiveUpdates

  def mount(session, socket) do
    %{job_search: job_search, current_user: current_user} = session
    listings = JobSearches.get_listings(job_search)

    LiveUpdates.subscribe_live_view(job_search)

    socket =
      socket
      |> assign(job_search: job_search)
      |> assign(current_user: current_user)
      |> assign(page: 1)
      |> assign(listings: listings)
    {:ok, socket}
  end

  def terminate(_reason, socket) do
    LiveUpdates.unsubscribe_live_view(socket.assigns.job_search)
  end

  def render(assigns) do
    JobBotWeb.JobSearchesView.render("show.html", assigns)
  end

  def handle_info({:new_listing, _listing}, socket) do
    listings = JobSearches.get_listings(socket.assigns.job_search)

    {:noreply, assign(socket, listings: listings)}
  end

  def handle_event("mark_as_applied", %{"listing_id" => listing_id}, socket) do
  end

  def handle_event("view_page", %{"page" => page}, socket) do
  end

  def handle_event("view_next_page", _params, socket) do
  end

  def handle_event("view_previous_page", _params, socket) do
  end

  def handle_call({:new_listing, listing}, _from, socket) do
  end
end