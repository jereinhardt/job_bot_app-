import { connect } from "react-redux";
import { CLEAR_LISTINGS, MOVE_BACKWARD, RESET_STEPS } from "../actionTypes.js";
import ConfirmationPage from "../components/confirmationPage.js";

const mapStateToProps = (state) => {
  return { data: state };
}

const mapDispatchToProps = (dispatch) => {
  return {
    moveBackward: (payload) => dispatch({ type: MOVE_BACKWARD, payload }),
    resetSteps: () => dispatch({ type: RESET_STEPS }),
    clearListings: () => dispatch({ type: CLEAR_LISTINGS })
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(ConfirmationPage)