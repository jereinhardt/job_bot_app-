import { connect } from "react-redux";
import { Socket } from "phoenix";
import { ADD_LISTINGS_CHANNEL, UPDATE_USER, UPDATE_NAME } from "../actionTypes.js";
import SignupForm from "../components/signupForm.js";

const mapStateToProps = (state, props) => ({
  user: state.user,
  name: state.name,
  csrfToken: state.csrfToken,
  submitCallback: props.submitCallback
});

const mapDispatchToProps = (dispatch) => ({
  addListingsChannel: (payload) => dispatch({ type: ADD_LISTINGS_CHANNEL, payload }),
  updateUser: (payload) => dispatch({ type: UPDATE_USER, payload }),
  updateName: (payload) => dispatch({ type: UPDATE_NAME, payload })
});

export default connect(mapStateToProps, mapDispatchToProps)(SignupForm);