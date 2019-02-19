import React from "react";
import SignupForm from "../containers/signupForm.js";
import ConfirmationPage from "../containers/confirmationPage.js";

export default class FinalStep extends React.Component {
  render() {
    let confirmationPageClass = "", signupFormClass = "";
    if ( this.props.user.id ) {
      signupFormClass = "hidden";
    } else {
      confirmationPageClass = "hidden";
    }

    return(
      <div>
        <div className={signupFormClass}>
          <SignupForm />
        </div>
        <div className={confirmationPageClass}>
          <ConfirmationPage />
        </div>
      </div>
    );
  }
}