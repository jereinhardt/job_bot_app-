import React from "react";
import ReactDOM from "react-dom";
import $ from "jquery";
import NameLocationForm from "./components/name_location_form.js";
import SourcesForm from "./components/sources_form.js";
import StepsController from "./containers/steps_controller.js";
import TermsLocationForm from "./components/terms_location_form.js";
import AutoapplyForm from "./components/autoapply_form.js";
import EmailForm from "./components/email_form.js";

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
      email: {username: "", password: ""}
    };

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

  render() {
    return(
      <div className="main-app">
        <StepsController>
          <NameLocationForm 
            name={this.state.name}
            applicantLocation={this.state.applicantLocation}
            updateData={this.updateData.bind(this)}       
          />
          <SourcesForm 
            sources={this.state.sources}
            updateSource={this.updateSource.bind(this)}
          />
          <TermsLocationForm
            terms={this.state.terms}
            location={this.state.location}
            updateData={this.updateData.bind(this)}
          />
          <AutoapplyForm
            autoapply={this.state.autoapply}
            updateData={this.updateData.bind(this)}
          />
          <EmailForm
            email={this.state.email}
            updateData={this.updateData.bind(this)}
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
