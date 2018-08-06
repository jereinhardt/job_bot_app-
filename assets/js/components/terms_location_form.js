import React from "react";
import Validator from "../containers/validator.js";

export default class TermsLocationForm extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      terms: this.props.terms,
      location: this.props.location
    }

    const validations = [{id: "terms", validate: ["presence"]}];
    this.validator = new Validator(this, validations);
  }

  handleSubmit(event) {
    event.preventDefault();
    if ( !this.validator.hasInvalidFields() ) {
      this.props.updateData(this.state);
      this.props.moveForward();
    }
  }

  handleTermsChange(event) {
    event.persist();
    this.setState({terms: event.target.value});
  }

  handleLocationChange(event) {
    event.persist();
    this.setState({location: event.target.value});
  }

  render() {
    const termsError = this.validator.errorClassFor("terms");

    return(
      <form onSubmit={(e) => this.handleSubmit(e)}>
        <div className="field">
          <label htmlFor="terms" className={`label ${termsError}`}>
            What kind of job are you looking for?
          </label>
          <div className="control">
            <input
              type="text"
              name="terms"
              value={this.state.terms}
              placeholder="What kind of job are you looking for?"
              onChange={(e) => this.handleTermsChange(e)}
              className={`input ${termsError}`}
            />
            <p className={`input-error-message is-danger ${termsError}`}>
              {this.validator.errorMessageFor("terms")}
            </p>
          </div>
        </div>

        <div className="field">
          <label 
            htmlFor="location"
            className="label"
          >
            Where are you looking for a job? (optional)
          </label>
          <input
            type="text"
            name="location"
            value={this.state.location}
            placeholder="Where are you looking? (optional)"
            onChange={(e) => this.handleLocationChange(e)}
            className="input"
          />
        </div>

        <div className="field">
          <div className="control">
            <button
              className="button is-link"
              onClick={(e) => this.props.moveBackward}
            >
              Go Back
            </button>
            <input type="submit" value="continue" className="button is-link"/>
          </div>
        </div>
      </form>
    );
  }
}