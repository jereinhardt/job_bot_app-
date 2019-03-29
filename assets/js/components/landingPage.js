import React from "react";
import { Link } from "react-router-dom";
import { mainAppPath } from "../routes.js";
import Nav from "../containers/nav.js";

export default class LandingPage extends React.Component {
  render() {
    return(
      <div>
        <Nav />
        <h1>Hi!  I'm Job-Bot!</h1>
        <Link to={mainAppPath} className="button is-primary">Get Started Now</Link>
      </div>
    );
  }
}