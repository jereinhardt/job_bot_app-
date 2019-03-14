import React from "react";
import UserSocket from "../userSocket.js";
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

    const socketConnectOnSignup = (user) => {
      new UserSocket(user).listenForListings();
    }

    return(

      <div>
        <div className={signupFormClass}>
          <SignupForm submitCallback={socketConnectOnSignup}/>
        </div>
        <div className={confirmationPageClass}>
          <ConfirmationPage />
        </div>
      </div>
    );
  }
}