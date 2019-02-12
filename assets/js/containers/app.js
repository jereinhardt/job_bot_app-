import { connect } from "react-redux";
import App from "../components/app.js";

const mapStateToProps = (state) => {
  return { submitted: state.submitted }
}

export default connect(mapStateToProps)(App);