import { connect } from "react-redux";
import {
  TOGGLE_SUBMITTED,
  CLEAR_LISTINGS,
  RESET_STEPS
} from "../actionTypes.js";
import Nav from "../components/nav.js";

const mapStateToProps = (state) => {
  return { user: state.user };
}

export default connect(mapStateToProps)(Nav)