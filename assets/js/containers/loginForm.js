import { connect } from "react-redux";
import { MOVE_FORWARD, UPDATE_USER, TOGGLE_SUBMITTED } from "../actionTypes.js";
import LoginForm from "../components/loginForm.js";

const mapStateToProps = (state) => {
  return { activeStep: state.activeStep };
}

const mapDispatchToProps = (dispatch) => {
  return {
    updateUser: (payload) => dispatch({ type: UPDATE_USER, payload }),
    moveForward: () => dispatch({ type: MOVE_FORWARD })
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(LoginForm)