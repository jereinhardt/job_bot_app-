import React from "react";
import Listing from "./listing.js";

export default class ListingsList extends React.Component {
  render() {
    const listingNodes = this.props.listings.
      map((listing) => {
        <Listing
          {...listing}
          key={`${listing.listing_url}|${listing.title}`}
        />
      });

    return(
      <ul className="listings--list">
        {listingNodes}
      </ul>
    );
  }
}