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
        <label htmlFor="terms" className={termsError}>
          What kind of job are you looking for?
        </label>
        <input
          type="text"
          name="terms"
          value={this.state.terms}
          placeholder="What kind of job are you looking for?"
          onChange={(e) => this.handleTermsChange(e)}
          className={termsError}
        />
        <span className={`input-error-message ${termsError}`}>
          {this.validator.errorMessageFor("terms")}
        </span>

        <label htmlFor="location">Where are you looking for a job? (optional)</label>
        <input
          type="text"
          name="location"
          value={this.state.location}
          placeholder="Where are you looking? (optional)"
          onChange={(e) => this.handleLocationChange(e)}
        />

        <input type="submit" value="continue" />
      </form>
    );
  }
}