import { connect } from "react-redux";
import { MOVE_BACKWARD, MOVE_FORWARD, UPDATE_EMAIL } from "../actionTypes.js";
import EmailForm from "../components/emailForm.js";

const mapStateToProps = (state) => {
  return { email: state.email };
}

const mapDispatchToProps = (dispatch) => {
  return {
    moveBackward: () => dispatch({ type: MOVE_BACKWARD }),
    moveForward: () => dispatch({ type: MOVE_FORWARD }),
    updateEmail: (payload) => dispatch({ type: UPDATE_EMAIL, payload })
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(EmailForm)