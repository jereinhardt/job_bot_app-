defmodule JobBotWeb.FormView do
  use JobBotWeb, :view

  def text_field(form, field, opts \\ []) do
    input_class = text_input_class(form, field)
    text_opts = 
      opts
      |> Keyword.take([:type, :value, :autofocus])
      |> Keyword.merge([class: input_class])

    content_tag(:div, class: "field") do
      [
        field_label(form, field, opts),
        content_tag(:div, class: "control") do
          [
            text_input(form, field, text_opts),
            field_error(form, field)
          ]
        end
      ]
    end
  end

  def password_field(form, field, opts \\ []) do
    input_class = text_input_class(form, field)
    input_opts = 
      opts
      |> Keyword.take([:value, :rows])
      |> Keyword.merge([class: input_class])

    content_tag(:div, class: "field") do
      [
        field_label(form, field, opts),
        content_tag(:div, class: "cotnrol") do
          [
            password_input(form, field, input_opts),
            field_error(form, field)
          ]
        end
      ]
    end
  end 

  def field_label(form, field, opts) do
    case Keyword.get(opts, :label) do
      nil  -> label(form, field, class: "label")
      text -> label(form, field, text, class: "label")
    end
  end

  def field_error(form, field) do
    case Keyword.get(form.errors, field) do
      {message, _} -> content_tag(:p, message, class: "help is-danger")
      _            -> ""
    end
  end

  defp text_input_class(form, field) do
    if Keyword.has_key?(form.errors, field) do
      "input is-danger"
    else
      "input"      
    end
  end
end