import React from "react";
import $ from "jquery";
import { history } from "../store.js";
import { resultsPath } from "../routes.js";

export default class ConfirmationPage extends React.Component {
  handleBack() {
    const steps = this.props.data.user.id ? 2 : 1;
    this.props.moveBackward(steps);
  }

  handleSubmit() {
    const data = this.props.data;
    const sources = data.sources.filter(source => source.selected).
      map(({ name, crawler, applier }) => {
        return { name, crawler, applier }
      });
    const params = {
      sources: sources,
      name: data.name,
      applicant_location: data.applicantLocation,
      terms: data.terms,
      location: data.location,
      resume_path: data.resumePath,
      user_id: data.user.id,
      _csrf_token: this.props.csrfToken
    };
    $.post("/data/job_searches", params, () => {
      this.props.clearListings();
      this.props.resetSteps();
      history.push(resultsPath);
    });
  }

  render() {
    const data = this.props.data
    const location = data.location == "" ? "Anywhere" : data.location;

    return(
      <section className="data-summary">
        <h3 className="title">Does this look right?</h3>

        <div className="field">
          <label className="label">Your Name</label>
          <p className="data-summary--info">{data.name}</p>
        </div>

        <div className="field">
          <label className="label">Your Location</label>
          <p className="data-summary--info">{data.applicantLocation}</p>
        </div>

        <div className="field">
          <label className="label">What You're Looking For</label>
          <p className="data-summary--info">{data.terms}</p>
        </div>

        <div className="field">
          <label className="label">Where You're Looking</label>
          <p className="data-summary--info">{location}</p>
        </div>

        <div className="columns">
          <div className="column is-one-quarter">
            <button
              onClick={() => this.handleBack()}
              className="button is-fullwidth"
            >
              Go Back
            </button>
          </div>
          <div className="column is-one-quarter">
            <button
              onClick={() => this.handleSubmit()}
              className="button is-fullwidth is-link"
            >
              Confirm
            </button>
          </div>
        </div>
      </section>
    );
  }
}