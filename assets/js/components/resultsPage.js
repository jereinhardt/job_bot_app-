import React from "react";
import ListingsList from "../containers/listingsList.js";
import Nav from "../containers/nav.js";

export default class ResultsPage extends React.Component {
  render() {
    return(
      <div>
        <Nav />
        <ListingsList />
      </div>
    );
  }
}