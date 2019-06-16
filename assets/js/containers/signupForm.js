import { connect } from "react-redux";
import { UPDATE_USER, UPDATE_NAME } from "../actionTypes.js";
import SignupForm from "../components/signupForm.js";

const mapStateToProps = (state, props) => {
  return {
    user: state.user,
    name: state.name,
    submitCallback: props.submitCallback
  };
}

const mapDispatchToProps = (dispatch) => {
  return {
    updateUser: (payload) => dispatch({ type: UPDATE_USER, payload }),
    updateName: (payload) => dispatch({ type: UPDATE_NAME, payload })
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(SignupForm);