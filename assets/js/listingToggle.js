const listingToggles = document.querySelectorAll("[data-toggle-listing]")
listingToggles.forEach((toggle) => {
  const toggleListing = (event) => {
    const listingId = event.target.dataset.toggleListing;
    event.preventDefault();
    const description = document.querySelector(`[data-listing-description='${listingId}']`)
    if ( description.classList.contains("expanded") ) {
      toggle.textCotnent = "Show Less"
    } else {
      toggle.textContent = "Show More"
    }
    description.classList.toggle("expanded")
  }
  
  toggle.addEventListener("click", toggleListing)
})