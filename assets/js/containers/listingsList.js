import { connect } from "react-redux";
import { Socket } from "phoenix";
import { ADD_LISTING, ADD_LISTINGS_CHANNEL, UPDATE_LISTINGS } from "../actionTypes.js";
import ListingsList from "../components/listingsList.js";

const mapStateToProps = (state) => ({
  listings: state.listings,
  listingsChannel: state.listingsChannel,
  user: state.user
});

const mapDispatchToProps = (dispatch) => ({
  addListingsChannel: (payload) => dispatch({ type: ADD_LISTINGS_CHANNEL, payload }),
  addListing: (payload) => dispatch({ type: ADD_LISTING, payload }),
  updateListings: (payload) => dispatch({ type: UPDATE_LISTINGS, payload })
});

export default connect(mapStateToProps, mapDispatchToProps)(ListingsList)