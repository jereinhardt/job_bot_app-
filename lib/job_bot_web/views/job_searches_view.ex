defmodule JobBotWeb.JobSearchesView do
  use JobBotWeb, :view

  import Prospero.View
  
  alias JobBotWeb.LivePaginationView, as: Pagination
  alias JobBot.JobSearches.JobSearch
  alias Phoenix.HTML.Form
  alias Phoenix.HTML.FormData
  
  def render("create.json", _params), do: %{}

  def step_navigation(do: content) do
    content_tag(:div, content, class: "step__actions")
  end

  def previous_step_button do
    back_button("back", class: "step__action step__action--backward")
  end

  def next_step_button do
    submit("continue", class: "step__action step__action--forward")
  end

  def next_step_button(text) do
    submit(text, class: "step__action step__action--forward")
  end

  def decorated_text_input(%Form{} = form, name, opts \\ []) do
    class = decorated_input_class(form, name)
    merged_opts = Keyword.merge(opts, [class: class])
    text_input(form, name, merged_opts)
  end

  def decorated_text_input(%Ecto.Changeset{} = changeset, name, opts) do
    class = decorated_input_class(changeset, name)
    form = FormData.to_form(changeset, [])
    merged_opts = Keyword.merge(opts, [class: class])
    text_input(form, name, merged_opts)
  end

  def decorated_password_input(%Ecto.Changeset{} = changeset, name, opts \\ []) do
    class = decorated_input_class(changeset, name)
    form = FormData.to_form(changeset, [])
    merged_opts = Keyword.merge(opts, [class: class])
    password_input(form, name, merged_opts)
  end

  def login_email_input(changeset, opts \\ []) do
    merged_opts = Keyword.merge(opts, [class: "input"])
    form = FormData.to_form(changeset, [])
    text_input(form, :email, merged_opts)
  end

  def login_password_input(changeset, opts \\ []) do
    merged_opts = Keyword.merge(opts, [class: "input", value: ""])
    form = FormData.to_form(changeset, [])
    password_input(form, :password, merged_opts)
  end

  def input_error(%Form{source: %Prospero.FormData{action: :revise}, errors: errors}, name) do
    case Keyword.get(errors, name) do
      {message, _} -> content_tag(:p, message, class: "help is-danger")
      _ -> nil
    end
  end
  
  def input_error(%Ecto.Changeset{action: nil}, _name), do: nil
  def input_error(%Ecto.Changeset{errors: errors} = changeset, name) do
    case Keyword.get(errors, name) do
      {message, _} -> content_tag(:p, message, class: "help is-danger")
      _ -> nil
    end
  end

  def input_error(_form, _name), do: nil

  def source_checkbox(%Form{source: %{changeset: changeset}} = form, source) do
    checked =
      changeset.changes
      |> Map.get(:sources, [])
      |> Enum.any?(&(&1 == source))

    content_tag :label, class: "checkbox" do
      [
        checkbox(
          form,
          nil,
          name: "job_search[sources][]",
          checked_value: source,
          unchecked_value: nil,
          checked: checked,
          class: "checkbox"
        ),
        source
      ]
    end 
  end

  def render_final_step(form, %{final_step: final_step} = assigns) do
    job_search_attrs =
      form.source.store
      |> Enum.map(fn ({k, v}) -> {String.to_atom(k), v} end)
      |> Enum.into(%{})
    job_search = JobSearch.__struct__(job_search_attrs)
    merged_assigns = Map.merge(assigns, %{f: form, job_search: job_search})
    case final_step do
      "confirm" -> render("_confirm.html", merged_assigns)
      "signup" -> render("_signup.html", merged_assigns)
      "login" -> render("_login.html", merged_assigns)
    end
  end

  defp decorated_input_class(%Ecto.Changeset{action: action, errors: errors}, name) do
    if !is_nil(action) && Keyword.get(errors, name) do
      "input has-error"
    else
      "input"
    end    
  end

  defp decorated_input_class(%Form{source: %Prospero.FormData{action: action}, errors: errors}, name) do
    if action == :revise && Keyword.get(errors, name) do
      "input has-error"
    else
      "input"
    end
  end
end