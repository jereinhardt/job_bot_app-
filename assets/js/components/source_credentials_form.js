import React from "react";
import Validator from "../containers/validator.js";

export default class SourceCredentialsForm extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      email: undefined,
      password: undefined
    }

    const validations = [
      {id: "email", validate: ["presence"]},
      {id: "password", validate: ["presence"]}
    ];
    this.validator = new Validator(this, validations);
  }

  handleSubmit(event) {
    event.preventDefault();
    if ( !this.validator.hasInvalidFields() ) {
      const attrs = Object.assign({credentials: this.state}, {selected: true});
      this.props.updateSource(this.props.source, attrs);
    }
  }

  updateEmail(event) {
    event.persist();
    this.setState({email: event.target.value});
  }

  updatePassword(event) {
    event.persist();
    this.setState({password: event.target.value});
  }

  render() {
    const className = this.props.toggled ? "toggled" : ""
    const emailErrorClass = this.validator.errorClassFor("email");
    const passwordErrorClass = this.validator.errorClassFor("password");

    return(
      <form className={className} onSubmit={(e) => this.handleSubmit(e)}>
        <label htmlFor="email" className={emailErrorClass}>
          Email or Username
        </label>
        <input
          name="email"
          type="text"
          onChange={(e) => this.updateEmail(e)}
          className={emailErrorClass}
        />
        <span className={`input-error-message ${emailErrorClass}`}>
          {this.validator.errorMessageFor("email")}
        </span>

        <label htmlFor="password" className={passwordErrorClass}>
          Password
        </label>
        <input
          name="password"
          type="password"
          onChange={(e) => this.updatePassword(e)}
          className={passwordErrorClass}
        />
        <span className={`input-error-message ${passwordErrorClass}`}>
          {this.validator.errorMessageFor("password")}
        </span>

        <input type="submit" value="submit" />
      </form>
    );
  }
}