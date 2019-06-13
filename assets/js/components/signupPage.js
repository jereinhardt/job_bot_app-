import React from "react";
import { history } from "../store.js";
import { mainAppPath } from "../routes.js";
import SignupForm from "../containers/signupForm.js";
import Nav from "../containers/nav.js";

export default class LoginPage extends React.Component {
  render() {
    const submitCallback = () => history.push(mainAppPath);
    return(
      <div>
        <Nav />
        <div className="main-app">
          <div className="modal is-active">
            <div className="modal-background"></div>
            <div className="modal-content">
              <SignupForm submitCallback={submitCallback} />
            </div>
          </div>
        </div>
      </div>
    );
  }
}