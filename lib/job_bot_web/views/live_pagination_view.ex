defmodule JobBotWeb.LivePaginationView do
  import Phoenix.HTML.Tag
  import Phoenix.HTML.Link
  alias JobBotWeb.Router.Helpers, as: Routes

  def pagination_links(%{total_pages: 1}), do: nil
  def pagination_links(params) do
    content =
      if params.total_pages <= 5 do
        unified_pagination(params)
      else
        split_pagination(params)
      end

    content_tag(
      :nav,
      content,
      class: "pagination is-centered",
      role: "navigation",
      aria_label: "pagination"
    )
  end

  # defp unified_pagination(%{total_pages: total_pages}) when total_pages == 1 do
  #   [content_tag(:ul, [current_page_list_item(1)], class: "pagination-list")]
  # end

  defp unified_pagination(%{page_number: page_number} = params) when page_number == 1 do
    list_items =
      1..params.total_pages
      |> Enum.map(&(build_list_item(&1, page_number)))
    
    pages_list = content_tag(:ul, list_items, class: "pagination-list")
    
    [
      next_link(),
      pages_list
    ]
  end

  defp unified_pagination(%{page_number: page_number, total_pages: total_pages}) when page_number == total_pages do
    list_items =
      1..total_pages
      |> Enum.map(&(build_list_item(&1, page_number)))

    pages_list = content_tag(:ul, list_items, class: "pagination-list")

    [
      previous_link(),
      pages_list
    ]
  end

  defp unified_pagination(params) do
    list_items = 
      1..params.total_pages
      |> Enum.map(&(build_list_item(&1, params.page_number)))

    pages_list = content_tag(:ul, list_items, class: "pagination-list")

    [
      previous_link(),
      next_link(),
      pages_list
    ]
  end



  defp split_pagination(%{page_number: page_number} = params) when page_number == 1 do
    list_items =
      1..4
      |> Enum.map(&(build_list_item(&1, page_number)))
      |> Enum.concat([seperator_item()])
      |> Enum.concat([page_list_item(params.total_pages)])

    pages_list = content_tag(:ul, list_items, class: "pagination-list")

    [
      next_link(),
      pages_list      
    ]
  end

  defp split_pagination(%{page_number: page_number} = params) when page_number <= 3 do
    list_items =
      1..4
      |> Enum.map(&(build_list_item(&1, page_number)))
      |> Enum.concat([seperator_item()])
      |> Enum.concat([page_list_item(params.total_pages)])

    pages_list = content_tag(:ul, list_items, class: "pagination-list")

    [
      previous_link(),
      next_link(),
      pages_list
    ]
  end

  defp split_pagination(%{page_number: page_number, total_pages: total_pages}) when page_number == total_pages do
    concurrent_items =
      (total_pages - 3)..total_pages
      |> Enum.map(&(build_list_item(&1, page_number)))
    list_items =
      [page_list_item(1)]
      |> Enum.concat([seperator_item()])
      |> Enum.concat(concurrent_items)

    pages_list = content_tag(:ul, list_items, class: "pagination-list")

    [
      previous_link(),
      pages_list
    ]
  end

  defp split_pagination(%{page_number: page_number, total_pages: total_pages}) when page_number >= total_pages - 3 do
    concurrent_items =
      (total_pages - 3)..total_pages
      |> Enum.map(&(build_list_item(&1, page_number)))
    list_items =
      [page_list_item(1)]
      |> Enum.concat([seperator_item()])
      |> Enum.concat(concurrent_items)

    pages_list = content_tag(:ul, list_items, class: "pagination-list")

    [
      previous_link(),
      next_link(),
      pages_list
    ]
  end

  defp split_pagination(params) do
    concurrent_items =
      (params.page_number - 1)..(params.page_number + 1)
      |> Enum.map(&(build_list_item(&1, params.page_number)))

    list_items =
      [page_list_item(1)]
      |> Enum.concat([seperator_item()])
      |> Enum.concat(concurrent_items)
      |> Enum.concat([seperator_item()])
      |> Enum.concat([page_list_item(params.total_pages)])


    pages_list = content_tag(:ul, list_items, class: "pagination-list")

    [
      previous_link(),
      next_link(),
      pages_list
    ]
  end

  defp build_list_item(item_number, current_page_number) do
    if item_number == current_page_number do
      current_page_list_item(item_number)
    else
      page_list_item(item_number)
    end
  end

  defp current_page_list_item(number) do
    span =
      content_tag(
        :span,
        number,
        class: "pagination-link is-current",
        aria_label: "Page #{number}",
        aria_current: "page"
      )

    content_tag(:li, [span])
  end

  defp page_list_item(number) do
    anchor =
      link(
        number,
        to: "#",
        class: "pagination-link",
        phx_click: "view_page",
        phx_value_page: number
      )
    content_tag(:li, anchor)
  end

  defp seperator_item do
    content_tag(
      :li,
      [content_tag(:span, "...", class: "pagination-ellipsis")]
    )
  end

  defp next_link do
    link(
      ">",
      to: "#",
      phx_click: "view_next_page",
      class: "pagination-next"
    )
  end

  defp previous_link() do
    link(
      "<",
      to: "#",
      phx_click: "view_previous_page",
      class: "pagination-previous"
    )
  end
end