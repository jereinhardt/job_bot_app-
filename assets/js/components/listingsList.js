import React from "react";
import { Socket } from "phoenix";
import Listing from "./listing.js";

export default class ListingsList extends React.Component {
  constructor(props) {
    super(props);
    
    const $app = $("#app");
    const userId = $app.data("js-user-id");
    const userToken = $app.data("js-user-token");

    let socket = new Socket("/socket", {params: {token: userToken}});
    socket.connect();
    let channel = socket.channel(`users:${userId}`, {});
    channel.join().
      receive("error", resp => { 
        console.error("failed to connect to channel", resp)
      });

    channel.on("new_listing", payload => {
      this.props.addListing(payload.listing);
    });
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
      <ul className="listings--list">
        {listingNodes}
      </ul>
    );
  }
}