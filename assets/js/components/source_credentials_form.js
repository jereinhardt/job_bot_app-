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
      <form className={`source__form ${className}`} onSubmit={(e) => this.handleSubmit(e)}>
        <div className="field">
          <label htmlFor="email" className={`label ${emailErrorClass}`}>
            Email or Username
          </label>
          <div className="control">
            <input
              name="email"
              type="text"
              onChange={(e) => this.updateEmail(e)}
              className={`input ${emailErrorClass}`}
            />
            <p className={`input-error-message is-danger ${emailErrorClass}`}>
              {this.validator.errorMessageFor("email")}
            </p>
          </div>
        </div>

        <div className="field">
          <label htmlFor="password" className={`label ${passwordErrorClass}`}>
            Password
          </label>
          <div className="control">
            <input
              name="password"
              type="password"
              onChange={(e) => this.updatePassword(e)}
              className={`input ${passwordErrorClass}`}
            />
            <p className={`input-error-message ${passwordErrorClass}`}>
              {this.validator.errorMessageFor("password")}
            </p>
          </div>
        </div>
        <div className="field">
          <div className="control">
            <input type="submit" value="submit" className="button is-link"/>
          </div>
        </div>
      </form>
    );
  }
}