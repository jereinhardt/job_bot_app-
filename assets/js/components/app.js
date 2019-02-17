import React from "react";
import ConfirmationPage from "../containers/confirmationPage.js";
import ListingsList from "../containers/listingsList.js";
import NameLocationForm from "../containers/nameLocationForm.js";
import ResumeForm from "../containers/resumeForm.js";
import SourcesForm from "../containers/sourcesForm.js";
import Step from "../containers/step.js";
import TermsLocationForm from "../containers/termsLocationForm.js";

export default class App extends React.Component {
  render() {
    const modalClass = this.props.submitted ? "modal" : "modal is-active";
    
    return(
      <div className="main-app">
        <div className={modalClass}>
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
              <ResumeForm />
            </Step>
            <Step step={5}>
              <ConfirmationPage />
            </Step>
          </div>
        </div>
        <ListingsList />
      </div>
    );
  }
}