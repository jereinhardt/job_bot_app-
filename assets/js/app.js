import React from "react";
import ReactDOM from "react-dom";
import $ from "jquery";
import Form from "./components/form.js";
import Step from "./components/step.js"

export default class App extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      sources: this.getSources(),
      activeStep: 1
    };

    this.totalSteps = 1;

    window.state = this.state;
  }

  updateSource(source, attrs) {
    let sources = this.state.sources;
    const i = this.state.sources.find((s) => s.name == source.name);
    sources[i] = Object.assign(source, attrs);
    this.setState({sources: sources});
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
      <Step activeStep={this.state.activeStep} step={1}>
        <Form 
          sources={this.state.sources}
          updateSource={this.updateSource.bind(this)}
          moveForward={this.moveForward.bind(this)}
          moveBackward={this.moveBackward.bind(this)}
        />
      </Step>
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
