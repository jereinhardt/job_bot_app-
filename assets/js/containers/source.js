import { connect } from "react-redux";
import { TOGGLE_SOURCE, UPDATE_SOURCE } from "../actionTypes.js";
import Source from "../components/source.js";

const mapStateToProps = (state, props) => {
  return { source: props.source };
}

const mapDispatchToProps = (dispatch) => {
  return {
    toggleSource: (payload) => dispatch({ type: TOGGLE_SOURCE, payload }),
    updateSource: (payload) => dispatch({ type: UPDATE_SOURCE, payload })
  };
}

export default connect(mapStateToProps, mapDispatchToProps)(Source);