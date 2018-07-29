import React from "react";
import Validator from "../containers/validator.js";

export default class EmailForm extends React.Component {
  constructor(props) {
    super(props);

    this.state = this.props.email;

    const validations = [
      {id: "username", validate: ["presence", "email"]},
      {id: "password", validate: ["presence"]}
    ]
    this.validator = new Validator(this, validations);
  }

  handleUsernameChange(event) {
    event.persist();
    this.setState({username: event.target.value});
  }

  handlePasswordChange(event) {
    event.persist();
    this.setState({password: event.target.value});
  }

  handleSubmit(event) {
    event.preventDefault();
    if ( !this.validator.hasInvalidFields() ) {
      this.props.updateData({email: this.state});
      this.props.moveForward();
    }
  }

  render() {
    const usernameError = this.validator.errorClassFor("username");
    const passwordError = this.validator.errorClassFor("password");
    return(
      <form onSubmit={(e) => this.handleSubmit(e)}>
        <label
          htmlFor="username"
          className={usernameError}
        >
          Email
        </label>
        <input
          type="text"
          name="username"
          placeholder="enter your email"
          value={this.state.username}
          onChange={(e) => this.handleUsernameChange(e)}
          className={usernameError}
        />
        <span
          className={`input-error-message ${usernameError}`}
        >
          {this.validator.errorMessageFor("username")}
        </span>

        <label
          htmlFor="emailPassword"
          className={passwordError}
        >
          Password
        </label>
        <input
          type="password"
          name="emailPassword"
          value={this.state.password}
          onChange={(e) => this.handlePasswordChange(e)}
          className={passwordError}
        />
        <span 
          className={`input-error-message ${passwordError}`}
        >
          {this.validator.errorMessageFor("password")}
        </span>

        <input type="submit" value="continue" />
      </form>
    );
  }  
}