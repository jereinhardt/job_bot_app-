import { connect } from "react-redux";
import { ADD_LISTING } from "../actionTypes.js";
import ListingsList from "../components/listingsList.js";

const mapStateToProps = (state) => {
  return { listings: state.listings };
}

const mapDispatchToProps = (dispatch) => {
  return {
    addListing: (payload) => dispatch({ type: ADD_LISTING, payload })
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(ListingsList)