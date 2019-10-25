const toggleListing = (event) => {
  const toggle = event.target
  const listingId = toggle.dataset.toggleListing
  event.preventDefault();
  const description = document.querySelector(`[data-listing-description='${listingId}']`)
  if ( description.classList.contains("expanded") ) {
    toggle.textCotnent = "Show Less"
  } else {
    toggle.textContent = "Show More"
  }
  description.classList.toggle("expanded")
}

window.toggleListing = toggleListing;