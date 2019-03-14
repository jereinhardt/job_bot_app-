import { connect } from "react-redux";
import { UPDATE_USER, TOGGLE_SUBMITTED } from "../actionTypes.js";
import LoginForm from "../components/loginForm.js";

const mapStateToProps = (state) => {
  return { activeStep: state.activeStep };
}

const mapDispatchToProps = (dispatch) => {
  return {
    updateUser: (payload) => dispatch({ type: UPDATE_USER, payload }),
    toggleSubmitted: () => dispatch({ type: TOGGLE_SUBMITTED })
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(LoginForm)