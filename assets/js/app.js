import React from "react";
import ReactDOM from "react-dom";
import $ from "jquery";
import NameLocationForm from "./components/name_location_form.js";
import SourcesForm from "./components/sources_form.js";
import StepsController from "./containers/steps_controller.js";
import TermsLocationForm from "./components/terms_location_form.js";
import AutoapplyForm from "./components/autoapply_form.js";
import EmailForm from "./components/email_form.js";
import ResumeForm from "./components/resume_form.js";
import ConfirmationPage from "./components/confirmation_page.js";

export default class App extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      sources: this.getSources(),
      activeStep: 1,
      name: "",
      applicantLocation: "",
      terms: "",
      location: "",
      autoapply: false,
      email: {username: "", password: ""},
      resumePath: ""
    };

    this.updateSource = this.updateSource.bind(this);
    this.updateData = this.updateData.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);

    window.state = this.state;
  }

  handleSubmit() {
    const sources = this.state.sources.
      filter(source => source.selected).
      map(({ name, scraper, applier, credentials }) => ({ name, scraper, applier, credentials }));
    const data = {
      sources: sources,
      name: this.state.name,
      applicant_location: this.state.applicantLocation,
      terms: this.state.terms,
      location: this.state.location,
      autoapply: this.state.autoapply,
      email: this.state.email,
      resume_path: this.state.resumePath
    };

    // submit data to api endpoint
  }

  updateSource(source, attrs) {
    let sources = this.state.sources;
    const i = this.state.sources.find((s) => s.name == source.name);
    sources[i] = Object.assign(source, attrs);
    this.setState({sources: sources});
  }

  updateData(attrs) {
    const newState = Object.assign(this.state, attrs);
    this.setState(newState);
  }

  render() {
    return(
      <div className="main-app">
        <StepsController>
          <NameLocationForm 
            name={this.state.name}
            applicantLocation={this.state.applicantLocation}
            updateData={this.updateData}       
          />
          <SourcesForm 
            sources={this.state.sources}
            updateSource={this.updateSource}
          />
          <TermsLocationForm
            terms={this.state.terms}
            location={this.state.location}
            updateData={this.updateData}
          />
          <AutoapplyForm
            autoapply={this.state.autoapply}
            updateData={this.updateData}
          />
          <EmailForm
            email={this.state.email}
            updateData={this.updateData}
          />
          <ResumeForm
            resumePath={this.state.resumePath}
            updateData={this.updateData}
          />
          <ConfirmationPage
            data={this.state}
            handleSubmit={this.handleSubmit}
          />
        </StepsController>
      </div>
    );
  }

  getSources() {
    let sources
    $.ajax({
      url: "/api/sources",
      type: "get",
      dataType: "json",
      async: false,
      success: (data) => sources = data
    });
    return JSON.parse(sources);
  }
}

ReactDOM.render(<App />, document.getElementById("app"));
