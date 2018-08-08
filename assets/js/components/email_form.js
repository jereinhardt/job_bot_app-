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
        <div className="step__title">
          Mind if I borrow your email?
        </div>
        <p className="step__description">
          Some jobs require me to send an application by email.  In order to do
          this for you, I'll need to be able to log into your Gmail account.
        </p>
        <div className="field">
          <label
            htmlFor="username"
            className={`label ${usernameError}`}
          >
            What is your Gmail username?
          </label>
          <div className="control">
            <input
              type="text"
              name="username"
              placeholder="applicant@gmail.com"
              value={this.state.username}
              onChange={(e) => this.handleUsernameChange(e)}
              className={`input ${usernameError}`}
            />
            <p className={`input-error-message is-danger ${usernameError}`}>
              {this.validator.errorMessageFor("username")}
            </p>
          </div>
        </div>

        <div className="field">
          <label htmlFor="emailPassword" className={`label ${passwordError}`}>
            Password
          </label>
          <div className="control">
            <input
              type="password"
              name="emailPassword"
              value={this.state.password}
              onChange={(e) => this.handlePasswordChange(e)}
              className={`input ${passwordError}`}
            />
            <p className={`input-error-message is-danger ${passwordError}`}>
              {this.validator.errorMessageFor("password")}
            </p>
          </div>
        </div>

        <div className="step__actions">
          <button
            className="step__action step__action--backward"
            onClick={(e) => this.props.moveBackward()}
          >
            Go Back
          </button>
          <input
            type="submit"
            value="Continue"
            className="step__action step__action--forward"
          />
        </div>
      </form>
    );
  }  
}