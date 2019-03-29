import React from "react";
import { Link } from "react-router-dom";
import { mainAppPath } from "../routes.js";
import Nav from "../containers/nav.js";
import avatar from "../../static/images/avatar.png";

export default class LandingPage extends React.Component {
  render() {
    return(
      <div>
        <Nav />
        <div className="hero is-fullheight">
          <div className="hero-body">
            <div className="container">
              <div className="columns is-tablet">
                <figure className="landing-page__hero-image-container column is-one-third-tablet">
                  <img src={avatar} />
                </figure>
                <div className="column">
                  <div className="landing-page__hero-text-container">
                    <div>
                      <h1 className="title">Hi! I'm Job-Bot</h1>
                      <h3 className="subtitle">And I can check the most popular job boards on the internet to find the job that's right for you!</h3>
                      <Link to={mainAppPath} className="button is-primary is-medium">Get Started Now</Link>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
}