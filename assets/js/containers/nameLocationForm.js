import { connect } from "react-redux";
import {
  MOVE_FORWARD,
  UPDATE_APPLICANT_LOCATION,
  UPDATE_NAME
} from "../actionTypes.js";
import NameLocationForm from "../components/nameLocationForm.js";

const mapStateToProps = (state) => {
  return {
    applicantLocation: state.applicantLocation,
    name: state.name
  };
}

const mapDispatchToProps = (dispatch) => {
  return {
    moveForward: () => dispatch({ type: MOVE_FORWARD }),
    updateApplicantLocation: (payload) => {
      return dispatch({ type: UPDATE_APPLICANT_LOCATION, payload })
    },
    updateName: (payload) => dispatch({ type: UPDATE_NAME, payload })
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(NameLocationForm)