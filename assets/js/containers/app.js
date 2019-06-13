import { connect } from "react-redux";
import { MOVE_FORWARD } from "../actionTypes.js"; 
import App from "../components/app.js";

const mapStateToProps = (state) => {
  return { submitted: state.submitted }
}

const mapDispatchToProps = (dispatch) => ({
  moveForward: () => dispatch({ type: MOVE_FORWARD }),
});

export default connect(mapStateToProps, mapDispatchToProps)(App);