import { connect } from "react-redux";
import Step from "../components/step";

const mapStateToProps = (state, props) => ({
  activeStep: state.activeStep,
  step: props.step
});

export default connect(mapStateToProps)(Step);