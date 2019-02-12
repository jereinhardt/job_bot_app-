import { connect } from "react-redux";
import {
  MOVE_BACKWARD,
  MOVE_FORWARD,
  UPDATE_RESUME_PATH
} from "../actionTypes.js";
import ResumeForm from "../components/resumeForm.js";

const mapStateToProps = (state) => {
  return { resumePath: state.resumePath };
}

const mapDispatchToProps = (dispatch) => {
  return {
    moveBackward: () => dispatch({ type: MOVE_BACKWARD }),
    moveForward: () => dispatch({ type: MOVE_FORWARD }),
    updateResumePath: (payload) => dispatch({ type: UPDATE_RESUME_PATH, payload })
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(ResumeForm)