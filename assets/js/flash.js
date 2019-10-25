const flashCloseButtons = document.querySelectorAll("[data-flash-remove]")
const removeFlashMessage = (event) => {
  event.preventDefault()
  const button = event.target
  const flashName = button.dataset.flashRemove
  const flashMessage = document.querySelector(`[data-flash-message="${flashName}"]`).remove()
}

flashCloseButtons.forEach((elem) => elem.addEventListener("click", removeFlashMessage))