import { connect } from "react-redux";
import Nav from "../components/nav.js";

const mapStateToProps = (state) => {
  return { user: state.user };
}

const mapDispatchToProps = (dispatch) => {
  return {};
}

export default connect(mapStateToProps, mapDispatchToProps)(Nav)