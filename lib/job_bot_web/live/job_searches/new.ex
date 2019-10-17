defmodule JobBotWeb.JobSearchesLive.New do
  alias JobBot.Accounts
  alias JobBot.Accounts.Guardian
  alias JobBot.Accounts.User
  alias JobBot.JobSearches
  alias JobBot.JobSearches.JobSearch
  alias JobBotWeb.Router.Helpers, as: Routes

  @confirm_step "confirm"
  @signup_step "signup"
  @login_step "login"

  use Prospero.LiveForm, schema: JobSearch, steps: 4

  def render(assigns) do
    JobBotWeb.JobSearchesView.render("new.html", assigns)
  end

  def mount(session, socket) do
    {user, final_step, login_user} = get_initial_state(session)

    prepared_socket =
      socket
      |> prepare_live_form()
      |> assign(final_step: final_step)
      |> assign(user: user)
      |> assign(login_user: login_user)
    {:ok, prepared_socket}
  end

  def handle_event("toggle_login", _params, socket) do
    {:noreply, assign(socket, final_step: "login")}
  end

  def handle_event("toggle_signup", _params, socket) do
    {:noreply, assign(socket, final_step: "signup")}
  end

  def handle_event("submit_active_step", %{"user" => user_params} = params, %{assigns: %{final_step: @signup_step}} = socket) do
    case Accounts.create_user(user_params) do
      {:ok, user} -> 
        socket = 
          socket
          |> assign(final_step: @confirm_step)
          |> assign(user: user)

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, user: changeset)}
    end
  end

  def handle_event("submit_active_step", %{"user" => user_params}, %{assigns: %{final_step: @login_step}} = socket) do
    email = Map.get(user_params, "email")
    password = Map.get(user_params, "password")
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        socket =
          socket
          |> assign(final_step: @confirm_step)
          |> assign(user: user)

        {:noreply, socket}

      {:error, reason} ->
        {:noreply, assign(socket, login_error: reason)}
    end
  end

  @impl true
  def submit_form(params, socket) do
    %{user: user, login_user: login_user} = socket.assigns
    redirect_params = if login_user
        token = Guardian.signed_token(user)
        [user_token: token]
      else
        []
      end

    case JobSearches.create(user, params) do
      {:ok, _job_search} ->
        {
          :stop,
          socket
          |> put_flash(:info, "Searching for jobs...")
          |> redirect(to: submission_redirect_path(socket, user, login_user))
        }
      {:error, _} ->
        {
          :noreply,
          socket
          |> put_flash(:error, "Something went wrong! Please try again later.")
        }
    end
  end

  defp get_initial_state(session) do
    if user = Map.get(session, :user) do
      {user, @confirm_step, false}
    else
      {Accounts.new_user(), @signup_step, true}
    end
  end

  defp submission_redirect_path(socket, user, login_user) do
    if login_user do
      token = Guardian.signed_token(user)
      Route.most_recent_search_results_path(socket, :show, user_token: token)
    else
      Route.most_recent_search_results_path(socket, :show)
    end
  end
end