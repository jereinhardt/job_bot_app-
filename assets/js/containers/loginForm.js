import { connect } from "react-redux";
import {
  ADD_LISTINGS_CHANNEL,
  MOVE_FORWARD,
  UPDATE_USER,
} from "../actionTypes.js";
import LoginForm from "../components/loginForm.js";

const mapStateToProps = (state) => ({ 
  activeStep: state.activeStep,
  csrfToken: state.csrfToken
});

const mapDispatchToProps = (dispatch) => ({
  addListingsChannel: (payload) => dispatch({ type: ADD_LISTINGS_CHANNEL, payload }),
  updateUser: (payload) => dispatch({ type: UPDATE_USER, payload }),
  moveForward: () => dispatch({ type: MOVE_FORWARD })
});

export default connect(mapStateToProps, mapDispatchToProps)(LoginForm)