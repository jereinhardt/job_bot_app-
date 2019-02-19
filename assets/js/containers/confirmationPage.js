import { connect } from "react-redux";
import { MOVE_BACKWARD, TOGGLE_SUBMITTED } from "../actionTypes.js";
import ConfirmationPage from "../components/confirmationPage.js";

const mapStateToProps = (state) => {
  return { data: state };
}

const mapDispatchToProps = (dispatch) => {
  return {
    moveBackward: () => dispatch({ type: MOVE_BACKWARD }),
    toggleSubmitted: () => dispatch({ type: TOGGLE_SUBMITTED })
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(ConfirmationPage)