import { connect } from "react-redux";
import { TOGGLE_SUBMITTED, CLEAR_LISTINGS } from "../actionTypes.js";
import BlankSlate from "../components/blankSlate.js";

const mapStateToProps = (state) => {
  return {};
}

const mapDispatchToProps = (dispatch) => {
  return {
    createNewSearch: () => {
      dispatch({ type: TOGGLE_SUBMITTED });
      dispatch({ type: CLEAR_LISTINGS });
    }
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(BlankSlate)