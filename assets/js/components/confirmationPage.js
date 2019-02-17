import React from "react";
import $ from "jquery";

export default class ConfirmationPage extends React.Component {
  handleBack(e) {
    const steps = this.props.data.autoapply ? 1 : 3;
    this.props.moveBackward(steps)
  }

  handleSubmit() {
    const data = this.props.data;
    const sources = data.sources.filter(source => source.selected).
      map(({ name, crawler, applier, credentials }) => {
        return { name, crawler, applier, credentials }
      });
    const params = {
      sources: sources,
      name: data.name,
      applicant_location: data.applicantLocation,
      terms: data.terms,
      location: data.location,
      resume_path: data.resumePath,
      user_id: $("#app").data("js-user-id")
    };
    $.post("/api/job_searches", params, () => {
      this.props.toggleSubmitted();
    });
  }

  render() {
    const data = this.props.data

    const sourceNodes = data.sources.
      filter(source => source.selected).
      map(source => <li key={source.name}>{source.name}</li>)
    const location = data.location == "" ? "Anywhere" : data.location;

    return(
      <section className="data-summary">
        <h3 className="data-summary--heading">Does this look right?</h3>
        <section className="data-summary--section name-location">
          <h5>Your Name</h5>
          <p className="data-summary--info">{data.name}</p>
          <h5>Your Location</h5>
          <p className="data-summary--info">{data.applicantLocation}</p>
        </section>

        <section className="data-summary--section search-info">
          <h5>What You're Looking For</h5>
          <p className="data-summary--info">{data.terms}</p>
          <h5>Where You're Looking</h5>
          <p className="data-summary--info">{location}</p>
        </section>

        <section className="data-summary--section sources">
          <h5>Sources</h5>
          <ul className="data-summary--sources-list">
            {sourceNodes}
          </ul>
        </section>

        <div className="field">
          <div className="control">
            <button
              onClick={() => this.handleBack()}
              className="button is-link"
            >
              Go Back
            </button>
            <button
              onClick={() => this.handleSubmit()}
              className="button is-link"
            >
              Confirm
            </button>
          </div>
        </div>
      </section>
    );
  }
}