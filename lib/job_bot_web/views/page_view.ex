defmodule JobBotWeb.PageView do
  use JobBotWeb, :view

  def main_app(state) do
    ~E[<div id="app" data-react-state="<%= state %>"></div>]
  end
end
