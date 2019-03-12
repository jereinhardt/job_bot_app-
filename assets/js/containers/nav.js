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

const mapDispatchToProps = (dispatch) => {
  return {
    createNewSearch: () => {
      dispatch({ type: RESET_STEPS });
      dispatch({ type: TOGGLE_SUBMITTED });
      dispatch({ type: CLEAR_LISTINGS });
    }
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(Nav)