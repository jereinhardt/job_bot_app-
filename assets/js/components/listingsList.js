import React from "react";
import { Socket } from "phoenix";
import { joinUserListingsChannel } from "../utils/userListingsChannel.js";
import BlankSlate from "../containers/blankSlate.js";
import Listing from "../containers/listing.js";

export default class ListingsList extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};
    
    if ( this.props.user.id && this.props.user.token && !this.props.listingsChannel ) {
      joinUserListingsChannel(this.props.user, this.props.addListingsChannel);
    }
  }

  static getDerivedStateFromProps(nextProps, _prevState) {
    if ( nextProps.listingsChannel && nextProps.listingsChannel.state == "closed" ) {
      nextProps.listingsChannel.join().receive("ok", (res) => {
        if ( nextProps.listings.length == 0 ) {
          nextProps.updateListings(res.listings);       
        }
      });
      nextProps.listingsChannel.on("new_listing", (payload) => {
        nextProps.addListing(payload.listing);
      })
    }
    return null;
  }

  render() {
    if ( this.props.listings.length < 1 ) {
      return <BlankSlate />
    } else {
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
}