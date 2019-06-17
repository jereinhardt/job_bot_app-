import { connect } from "react-redux";
import { 
  UPDATE_LOCATION,
  UPDATE_TERMS,
  MOVE_BACKWARD,
  MOVE_FORWARD
} from "../actionTypes.js";
import TermsLocationForm from "../components/termsLocationForm.js";

const mapStateToProps = (state) => ({
  location: state.location,
  terms: state.terms,
  user: state.user
});

const mapDispatchToProps = (dispatch) => ({
  moveBackward: () => dispatch({ type: MOVE_BACKWARD }),
  moveForward: (payload) => dispatch({ type: MOVE_FORWARD, payload }),
  updateLocation: (payload) => dispatch({ type: UPDATE_LOCATION, payload }),
  updateTerms: (payload) => dispatch({ type: UPDATE_TERMS, payload })
});

export default connect(mapStateToProps, mapDispatchToProps)(TermsLocationForm);