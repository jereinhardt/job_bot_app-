import React from "react";
import Validator from "../utils/validator.js";

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
      const steps = this.props.user.id ? 2 : 1;
      this.props.updateTerms(this.state.terms);
      this.props.updateLocation(this.state.location);
      this.props.moveForward(steps);
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
        <div className="step__title">
          What kind of job are you looking for?
        </div>
        <div className="field">
          <label htmlFor="terms" className={`label ${termsError}`}>
            What search terms would you like me to use?
          </label>
          <div className="control">
            <input
              type="text"
              name="terms"
              value={this.state.terms}
              placeholder="e.g. 'Hospitality Management'"
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
            placeholder="Enter a city, state, or country."
            onChange={(e) => this.handleLocationChange(e)}
            className="input"
          />
        </div>

        <div className="step__actions">
          <span
            className="step__action step__action--backward"
            onClick={(e) => this.props.moveBackward()}
          >
            Go Back
          </span>
          <input
            type="submit"
            value="continue"
            className="step__action step__action--forward"
          />
        </div>
      </form>
    );
  }
}