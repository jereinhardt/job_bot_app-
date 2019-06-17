import { connect } from "react-redux";
import { MOVE_BACKWARD, MOVE_FORWARD } from "../actionTypes.js";
import SourcesForm from "../components/sourcesForm.js";

const mapStateToProps = (state) => ({ sources: state.sources });

const mapDispatchToProps = (dispatch) => ({
  moveBackward: () => dispatch({ type: MOVE_BACKWARD }),
  moveForward: () => dispatch({ type: MOVE_FORWARD })
});

export default connect(mapStateToProps, mapDispatchToProps)(SourcesForm);