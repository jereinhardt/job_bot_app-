import { connect } from "react-redux";
import FinalStep from "../components/finalStep";

const mapStateToProps = (state) => {
  return { user: state.user };
}

export default connect(mapStateToProps)(FinalStep)