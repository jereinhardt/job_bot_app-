import React from "react";
import Listing from "./listing.js";

export default class ListingsList extends React.Component {
  render() {
    const listingNodes = this.props.listings.
      map((listing) => <Listing {...listing} key={listing.updated_at} />);

    return(
      <ul className="listings--list">
        {listingNodes}
      </ul>
    );
  }
}