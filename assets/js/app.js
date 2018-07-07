import React from "react";
import ReactDOM from "react-dom";
import $ from "jquery";
import NameLocationForm from "./components/name_location_form.js";
import SourcesForm from "./components/sources_form.js";
import Step from "./components/step.js"
import TermsLocationForm from "./components/terms_location_form.js";

export default class App extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      sources: this.getSources(),
      activeStep: 1,
      name: "",
      applicantLocation: "",
      terms: "",
      location: ""
    };

    this.totalSteps = 2;

    window.state = this.state;
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

  updateName(name) {
    this.setState({name: name});
  }

  updateApplicantLocation(location) {
    this.setState({applicantLocation: location});
  }

  moveForward() {
    if (this.state.activeStep < this.totalSteps) {
      this.setState({activeStep: this.state.activeStep + 1});
    }
  }

  moveBackward() {
    if (this.state.activeStep > 1) {
      this.setState({activeStep: this.state.activeStep - 1});
    }
  }

  render() {
    return(
      <div className="steps-conatiner">
        <Step activeStep={this.state.activeStep} step={1}>
          <NameLocationForm 
            moveForward={this.moveForward.bind(this)}
            name={this.state.name}
            applicantLocation={this.state.applicantLocation}
            updateName={this.updateName.bind(this)}
            updateApplicantLocation={this.updateApplicantLocation.bind(this)}       
          />
        </Step>
        <Step activeStep={this.state.activeStep} step={2}>
          <SourcesForm 
            sources={this.state.sources}
            updateSource={this.updateSource.bind(this)}
            moveForward={this.moveForward.bind(this)}
            moveBackward={this.moveBackward.bind(this)}
          />
        </Step>
        <Step activeStep={this.state.activeStep} step={3}>
          <TermsLocationForm
            terms={this.state.terms}
            location={this.state.location}
            updateData={this.updateData.bind(this)}
            moveForward={this.moveForward.bind(this)}
            moveBackward={this.moveBackward.bind(this)}
          />
        </Step>
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
