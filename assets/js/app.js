import React from "react";
import ReactDOM from "react-dom";
import $ from "jquery";
import Form from "./components/form.js";

export default class App extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      sources: this.getSources()
    };
  }

  updateSource(source, attrs) {
    let sources = this.state.sources;
    const i = this.state.sources.find((s) => s.name == source.name);
    sources[i] = Object.assign(source, attrs);
    this.setState({sources: sources});
  }

  render() {
    return(
      <Form 
        sources={this.state.sources}
        updateSource={this.updateSource.bind(this)}
      />
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
