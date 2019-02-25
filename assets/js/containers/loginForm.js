import { connect } from "react-redux";
import { UPDATE_USER } from "../actionTypes.js";
import LoginForm from "../components/loginForm.js";

const mapStateToProps = (state) => { return {}; }
const mapDispatchToProps = (dispatch) => {
  return {
    updateUser: (payload) => dispatch({ type: UPDATE_USER, payload })
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(LoginForm)