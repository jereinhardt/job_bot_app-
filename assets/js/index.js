import { Socket } from "phoenix"
import LiveSocket from "phoenix_live_view"
import "../../deps/phoenix_html/priv/static/phoenix_html"
import "./flash"
import "./listingToggle"
import "./navToggle"

let liveSocket = new LiveSocket("/live", Socket)
liveSocket.connect()