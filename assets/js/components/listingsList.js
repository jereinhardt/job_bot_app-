import React from "react";
import { Socket } from "phoenix";
import UserSocket from "../userSocket.js"
import Listing from "./listing.js";

export default class ListingsList extends React.Component {
  constructor(props) {
    super(props);
    
    if ( this.props.user.id && this.props.user.token ) {
      new UserSocket(this.props.user).listenForListings();
    }
  }

  render() {
    const listingNodes = this.props.listings.
      map((listing) => {
        return(
          <Listing
            {...listing}
            key={`${listing.listing_url}|${listing.title}`}
          />
        );
      });

    return(
      <section className="section">
        <div className="container">
          <ul className="listings--list">
            {listingNodes}
          </ul>
        </div>
      </section>
    );
  }
}