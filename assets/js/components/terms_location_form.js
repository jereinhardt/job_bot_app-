import React from "react";

export default class TermsLocationForm extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      terms: this.props.terms,
      location: this.props.location
    }
  }

  handleSubmit(event) {
    event.preventDefault();
    this.props.updateData(this.state)
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
    return(
      <form onSubmit={(e) => this.handleSubmit(e)}>
        <label htmlFor="terms">What kind of job are you looking for?</label>
        <input
          type="text"
          name="terms"
          value={this.state.terms}
          placeholder="What kind of job are you looking for?"
          onChange={(e) => this.handleTermsChange(e)}
        />

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