import React from "react";
import LoginForm from "../containers/loginForm.js";
import Nav from "../containers/nav.js";

export default class LoginPage extends React.Component {
  render() {
    return(
      <div>
        <Nav />
        <div className="main-app">
          <LoginForm />
        </div>
      </div>
    );
  }
}