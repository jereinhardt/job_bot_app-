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
      |> assign(toggled_listings: [])
      |> assign(listings: listings)
    {:ok, socket}
  end

  def terminate(_reason, socket) do
    LiveUpdates.unsubscribe_live_view(socket.assigns.job_search)
  end

  def render(assigns) do
    JobBotWeb.JobSearchesView.render("show.html", assigns)
  end

  def handle_event("mark_as_applied", %{"listing-id" => listing_id}, socket) do
    now = NaiveDateTime.utc_now()
    with listing <- JobSearches.get_listing(listing_id),
      {:ok, _} <- JobSearches.update_listing(listing, %{applied_to_at: now})
    do
      refresh_listings(socket)
    else
      {:error, _} -> {:noreply, socket}
    end
  end

  def handle_event("unmark_as_applied", %{"listing-id" => listing_id}, socket) do
    with listing <- JobSearches.get_listing(listing_id),
      {:ok, _} <- JobSearches.update_listing(listing, %{applied_to_at: nil})
    do
      refresh_listings(socket)
    else
      {:error, _} -> {:noreply, socket}
    end
  end

  def handle_event("toggle_listing", %{"listing-id" => listing_id}, socket) when is_binary(listing_id) do
    handle_event("toggle_listing", %{"listing-id" => String.to_integer(listing_id)}, socket)
  end

  def handle_event("toggle_listing", %{"listing-id" => listing_id}, socket) do
    toggled_listings =
      if listing_id in socket.assigns.toggled_listings do
        socket.assigns.toggled_listings
        |> Enum.reject(&(&1 == listing_id))
      else
        socket.assigns.toggled_listings
        |> Enum.concat([listing_id])
      end

    {:noreply, assign(socket, toggled_listings: toggled_listings)}
  end

  def handle_event("view_page", %{"page" => page}, socket) do
    listings = JobSearches.get_listings(socket.assigns.job_search, page: page)

    {:noreply, assign(socket, listings: listings)}
  end

  def handle_event("view_next_page", _params, socket) do
    if socket.assigns.listings.page_number < socket.assigns.listings.total_pages  do
      page = socket.assigns.listings.page_number + 1
      listings = JobSearches.get_listings(socket.assigns.job_search, page: page)

      {:noreply, assign(socket, listings: listings)}
    else
      {:noreply, socket}
    end
  end

  def handle_event("view_previous_page", _params, socket) do
    if socket.assigns.listings.page_number > 1 do
      page = socket.assigns.listings.page_number - 1
      listings = JobSearches.get_listings(socket.assigns.job_search, page: page)

      {:noreply, assign(socket, listings: listings)}
    else
      {:noreply, socket}
    end
  end

  def handle_info({:new_listing, _listing}, socket) do
    refresh_listings(socket)
  end

  defp refresh_listings(socket) do
    %{job_search: job_search, listings: listings} = socket.assigns
    listings = JobSearches.get_listings(job_search, page: listings.page_number)

    {:noreply, assign(socket, listings: listings)}    
  end
end