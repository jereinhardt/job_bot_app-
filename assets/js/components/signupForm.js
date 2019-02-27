import $ from "jquery";
import React from "react";
import { Link } from "react-router-dom";
import UserSocket from "../userSocket.js";
import Validator from "../containers/validator.js";

export default class SignupForm extends React.Component {
  constructor(props) {
    super(props);

    const name = this.props.user.name ? this.props.user.name : this.props.name;
    this.state = { name: name, email: "", password: "", errors: {} };
  }

  handleSubmit(event) {
    event.preventDefault();
    const url = "/data/users";
    const token = $("#app").data("js-csrf-token")
    const params = {
      user: {
        name: this.state.name,
        email: this.state.email,
        password: this.state.password 
      },
      "_csrf_token": token
    };
    $.post("/data/users", params, (res) => {
      this.props.updateUser(res.data.user);
      new UserSocket(res.data.user).listenForListings();
    }).fail((res) => {
      this.setState({errors: res.responseJSON.data.errors});
    })
  }

  handleNameChange(event) {
    event.persist();
    this.setState({name: event.target.value});
  }

  handleEmailChange(event) {
    event.persist();
    this.setState({email: event.target.value});
  }

  handlePasswordChange(event) {
    event.persist();
    this.setState({password: event.target.value});
  }

  render() {
    const nameError = {
      class: this.state.errors.name ? " has-error" : "",
      message: this.state.errors.name
    };
    const emailError = {
      class: this.state.errors.email ? " has-error" : "",
      message: this.state.errors.email
    };
    const passwordError = {
      class: this.state.errors.password ? " has-error" : "",
      message: this.state.errors.password
    };

    return(
      <form onSubmit={(e) => this.handleSubmit(e)}>
        <h2 className="step__title">
          Sign Up For JobBot
        </h2>
        <h4 className="step__description">
          Find and apply to dozens of jobs from around the internet
        </h4>

        <p>
          Already have an account? <Link to="/login">Sign in here</Link>.
        </p>

        <div className="field">
          <label
            htmlFor="name"
            className={`label${nameError.class}`}
          >
            Name
          </label>
          <div className="control">
            <input
              type="text"
              name="name"
              value={this.state.name}
              placeholder="John Botson"
              className={`input${nameError.class}`}
              onChange={(e) => this.handleNameChange(e)}
            />
            <p className={`input-error-message is-danger ${nameError.class}`}>
              {nameError.message}
            </p>
          </div>
        </div>

        <div className="field">
          <label
            htmlFor="email"
            className={`label${emailError.class}`}
          >
            Email
          </label>
          <div className="control">
            <input
              type="email"
              name="email"
              value={this.state.email}
              placeholder="john@botson.com"
              className={`input${emailError.class}`}
              onChange={(e) => this.handleEmailChange(e)}
            />
            <p className={`input-error-message is-danger ${emailError.class}`}>
              {emailError.message}
            </p>
          </div>
        </div>


        <div className="field">
          <label
            htmlFor="password"
            className={`label${passwordError.class}`}
          >
            Password
          </label>
          <div className="control">
            <input
              type="password"
              name="password"
              value={this.state.password}
              className={`input${passwordError.class}`}
              onChange={(e) => this.handlePasswordChange(e)}
            />
            <p className={`input-error-message is-danger ${passwordError.class}`}>
              {passwordError.message}
            </p>
          </div>
        </div>

        <div className="step__actions">
          <input
            type="submit"
            value="Sign Up"
            className="step__action step__action--forward"
          />
        </div>

      </form>
    );
  }
}