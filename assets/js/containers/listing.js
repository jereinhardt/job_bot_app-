import { connect } from "react-redux";
import { UPDATE_LISTING } from "../actionTypes.js";
import Listing from "../components/listing.js";

const mapStateToProps = (state, props) => {
  return props;
}

const mapDispatchToProps = (dispatch) => {
  return {
    updateListing: (payload) => dispatch({ type: UPDATE_LISTING, payload })
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(Listing)