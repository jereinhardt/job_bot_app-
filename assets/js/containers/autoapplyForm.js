import { connect } from "react-redux";
import {
  MOVE_BACKWARD,
  MOVE_FORWARD,
  UPDATE_AUTOAPPLY
} from "../actionTypes.js";
import AutoapplyForm from "../components/autoapplyForm.js";

const mapStateToProps = (state) => {
  return { autoapply: state.autoapply };
}

const mapDispatchToProps = (dispatch) => {
  return {
    moveBackward: () => dispatch({ type: MOVE_BACKWARD }),
    moveForward: (payload) => dispatch({ type: MOVE_FORWARD, payload }),
    updateAutoapply: (payload) => dispatch({ type: UPDATE_AUTOAPPLY, payload })
  }
};

export default connect(mapStateToProps, mapDispatchToProps)(AutoapplyForm);