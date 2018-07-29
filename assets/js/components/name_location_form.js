import React from "react";
import Validator from "../containers/validator.js";

export default class NameLocationForm extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      name: this.props.name,
      applicantLocation: this.props.applicantLocation
    }

    const validations = [
      {id: "name", validate: ["presence"]},
      {id: "applicantLocation", validate: ["presence"]}
    ];
    this.validator = new Validator(this, validations);
  }

  handleSubmit(event) {
    event.preventDefault();
    if ( !this.validator.hasInvalidFields() ) {
      this.props.updateData(this.state);
      this.props.moveForward();
    }
  }

  handleNameChange(event) {
    event.persist();
    this.setState({name: event.target.value});
  }

  handleLocationChange(event) {
    event.persist();
    this.setState({applicantLocation: event.target.value});
  }

  render() {
    const nameError = this.validator.errorClassFor("name");
    const locationError = this.validator.errorClassFor("applicantLocation");

    return(
      <form onSubmit={(e) => this.handleSubmit(e)}>
        <label 
          htmlFor="name"
          className={nameError}
        >
          Name
        </label>
        <input
          type="text"
          name="name"
          value={this.state.name}
          placeholder="Enter your full name"
          onChange={(e) => this.handleNameChange(e)}
          className={nameError}
        />
        <span
          className={`input-error-message ${nameError}`}
        >
          {this.validator.errorMessageFor("name")}
        </span>


        <label 
          htmlFor="applicantLocation"
          className={locationError}
        >
          Location
        </label>
        <input
          type="text"
          name="applicantLocation"
          value={this.state.applicantLocation}
          placeholder="Enter your Location"
          onChange={(e) => this.handleLocationChange(e)}
          className={locationError}
        />
        <span className={`input-error-message ${locationError}`}>
          {this.validator.errorMessageFor("applicantLocation")}
        </span>

        <input type="submit" value="Continue" />
      </form>
    )
  }
}