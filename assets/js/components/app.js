import React from "react";
import ConfirmationPage from "../containers/confirmationPage.js";
import NameLocationForm from "../containers/nameLocationForm.js";
import SignupForm from "../containers/signupForm.js";
import SourcesForm from "../containers/sourcesForm.js";
import Step from "../containers/step.js";
import TermsLocationForm from "../containers/termsLocationForm.js";
import Nav from "../containers/nav.js";

export default class App extends React.Component {
  render() {    
    return(
      <div>
        <Nav />
        <div className="main-app">
          <div className="modal is-active">
            <div className="modal-background"></div>
            <div className="modal-content">
              <Step step={1}>
                <NameLocationForm />
              </Step>
              <Step step={2}>
                <SourcesForm />
              </Step>
              <Step step={3}>
                <TermsLocationForm />
              </Step>
              <Step step={4}>
                <SignupForm submitCallback={this.props.moveForward}/>
              </Step>
              <Step step={5}>
                <ConfirmationPage />
              </Step>
            </div>
          </div>
        </div>
      </div>
    );
  }
}