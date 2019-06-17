import { connect } from "react-redux";
import { Socket } from "phoenix";
import { ADD_LISTING, ADD_LISTINGS_CHANNEL, UPDATE_LISTINGS } from "../actionTypes.js";
import ListingsList from "../components/listingsList.js";

const mapStateToProps = (state) => ({
  listings: state.listings,
  listingsChannel: state.listingsChannel,
  user: state.user
});

const mapDispatchToProps = (dispatch) => {
  const connectToListingsChannel = (user) => {
    let socket = new Socket("/socket", { params: { token: user.token } });
    const channel = socket.channel(`users:${user.id}`, {});
    channel.join();
    channel.on("new_listing", payload => {
      store.dispatch({ type: ADD_LISTING, payload: payload.listing });
    })
  };

  return {
    connectToListingsChannel: connectToListingsChannel,
    addListingsChannel: (payload) => dispatch({ type: ADD_LISTINGS_CHANNEL, payload }),
    addListing: (payload) => dispatch({ type: ADD_LISTING, payload }),
    updateListings: (payload) => dispatch({ type: UPDATE_LISTINGS, payload })
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(ListingsList)