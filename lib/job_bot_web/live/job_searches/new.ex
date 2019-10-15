defmodule JobBotWeb.JobSearchesLive.New do
  alias JobBot.Accounts
  alias JobBot.Accounts.{JobSearch, User}
  alias JobBotWeb.Router.Helpers, as: Routes

  use Prospero.LiveForm, schema: JobSearch, steps: 4

  def render(assigns) do
    JobBotWeb.JobSearchesView.render("new.html", assigns)
  end

  def mount(session, socket) do
    user_id = Map.get(session, :user_id)
    final_step = if user_id, do: "confirm", else: "signup"

    prepared_socket =
      socket
      |> prepare_live_form(%{user_id: user_id})
      |> assign(final_step: final_step)
      |> assign(user: User.changeset(%User{}))
    {:ok, prepared_socket}
  end

  def handle_event("toggle_login", _params, socket) do
    {:noreply, assign(socket, final_step: "login")}
  end

  def handle_event("toggle_signup", _params, socket) do
    {:noreply, assign(socket, final_step: "signup")}
  end

  def handle_event("submit_active_step", %{"user" => user_params} = params, %{assigns: %{final_step: "signup"}} = socket) do
    # handle submission of signup
    case Accounts.create_user(user_params) do
      {:ok, user} -> 
        updated_form = update_form(socket.assigns.live_form, %{"user_id" => user.id})
        {:noreply, assign(socket, live_form: updated_form, final_step: "confirm")}
      {:error, changeset} ->
        {:noreply, assign(socket, user: changeset)}
    end
  end

  def handle_event("submit_active_step", %{"user" => user_params}, %{assigns: %{final_step: "login"}} = socket) do
    # handle login
  end

  @impl true
  def submit_form(params, socket) do
    IO.puts("FINAL FORM IS SUBMITTING")
    case Accounts.create_job_search(params) do
      {:ok, _job_search} ->
        # TODO start search processing here
        {
          :stop,
          socket
          |> put_flash(:info, "Searching for jobs...")
          |> redirect(to: Routes.most_recent_search_results_path(socket, :show))
        }
      {:error, _} ->
        {
          :noreply,
          socket
          |> put_flash(:error, "Something went wrong! Please try again later.")
        }
    end
  end
end