defmodule JobBot.Scraper do
  @callback scrape(list) :: list

  defmacro __using__(opts) do
    use_hound = Keyword.get(opts, :use_hound, false)

    quote do
      if unquote(use_hound) do
        # use Hound.Helpers
      end

      @behaviour JobBot.Scraper

      if unquote(use_hound) do
        defp start_hound_session do
          if Enum.any?(Hound.Session.active_sessions()) do
            Hound.end_session()
          end

          Hound.start_session(
            browser: "chrome",
            user_agent: :chrome,
            driver: %{
              chromeOptions: %{
                args: ["--headless"]
              }
            }
          )
        end
      end
    end
  end
end