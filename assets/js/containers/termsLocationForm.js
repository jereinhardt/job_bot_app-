import { connect } from "react-redux";
import { 
  UPDATE_LOCATION,
  UPDATE_TERMS,
  MOVE_BACKWARD,
  MOVE_FORWARD
} from "../actionTypes.js";
import TermsLocationForm from "../components/termsLocationForm.js";

const mapStateToProps = (state) => {
  return {
    location: state.location,
    terms: state.terms
  };
}

const mapDispatchToProps = (dispatch) => {
  return {
    moveBackward: () => dispatch({ type: MOVE_BACKWARD }),
    moveForward: () => dispatch({ type: MOVE_FORWARD }),
    updateLocation: (payload) => dispatch({ type: UPDATE_LOCATION, payload }),
    updateTerms: (payload) => dispatch({ type: UPDATE_TERMS, payload })
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(TermsLocationForm);