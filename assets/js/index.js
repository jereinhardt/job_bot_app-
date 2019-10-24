import { Socket } from "phoenix"
import LiveSocket from "phoenix_live_view"
import "../../deps/phoenix_html/priv/static/phoenix_html"

let liveSocket = new LiveSocket("/live", Socket)
liveSocket.connect()

const navToggle = document.querySelector("[data-navigation-toggle]")

const toggleNavigation = (event) => {
  console.log(event)
  event.preventDefault()
  const itemsContainer = document.querySelector("[data-navigation-items-container]")
  itemsContainer.classList.toggle("expanded")
  if (navToggle.getAttribute("aria-expanded") === "true") {
    navToggle.setAttribute("aria-expanded", false)
  } else {
    navToggle.setAttribute("aria-expanded", true)
  }
}

navToggle.addEventListener("click", toggleNavigation);



const flashCloseButtons = document.querySelectorAll("[data-flash-remove]")
const removeFlashMessage = (event) => {
  event.preventDefault()
  const button = event.target
  const flashName = button.dataset.flashRemove
  const flashMessage = document.querySelector(`[data-flash-message="${flashName}"]`).remove()
}

flashCloseButtons.forEach((elem) => elem.addEventListener("click", removeFlashMessage))