import { connect } from "react-redux";
import { UPDATE_LISTING } from "../actionTypes.js";
import Listing from "../components/listing.js";

const mapStateToProps = (state, props) => (
  Object.assign({}, props, { csrfToken: state.csrfToken })
);

const mapDispatchToProps = (dispatch) => ({
  updateListing: (payload) => dispatch({ type: UPDATE_LISTING, payload })
});

export default connect(mapStateToProps, mapDispatchToProps)(Listing)