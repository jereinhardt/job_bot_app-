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
        <div className="field">
          <label
            htmlFor="name"
            className={`label ${nameError}`}
          >
            Name
          </label>
          <div className="control">
            <input
              type="text"
              name="name"
              value={this.state.name}
              placeholder="Enter your full name"
              onChange={(e) => this.handleNameChange(e)}
              className={`input ${nameError}`}
            />
            <p className={`input-error-message is-danger ${nameError}`}>
              {this.validator.errorMessageFor("name")}
            </p>
          </div>
        </div>

        <div className="field">
          <label 
            htmlFor="applicantLocation"
            className={`label ${locationError}`}
          >
            Location
          </label>
          <div className="control">
            <input
              type="text"
              name="applicantLocation"
              value={this.state.applicantLocation}
              placeholder="Enter your Location"
              onChange={(e) => this.handleLocationChange(e)}
              className={`input ${locationError}`}
            />
            <p className={`input-error-message is-danger ${locationError}`}>
              {this.validator.errorMessageFor("applicantLocation")}
            </p>
          </div>
        </div>

        <div className="field">
          <div className="control">
            <input type="submit" value="Continue" className="button is-link"/>
          </div>
        </div>
      </form>
    )
  }
}