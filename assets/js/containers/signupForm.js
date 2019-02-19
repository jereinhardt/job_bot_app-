import { connect } from "react-redux";
import { UPDATE_USER } from "../actionTypes.js";
import SignupForm from "../components/signupForm.js";

const mapStateToProps = (state) => {
  return { user: state.user, name: state.name };
}

const mapDispatchToProps = (dispatch) => {
  return {
    updateUser: (payload) => dispatch({ type: UPDATE_USER, payload })
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(SignupForm);