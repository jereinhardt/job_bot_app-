import React from "react";
import SourceCredentialsForm from "./source_credentials_form.js";
import { UPDATE_SOURCE, TOGGLE_SOURCE } from "../actionTypes.js";

export default class Source extends React.Component {
  constructor(props) {
    super(props);

    this.toggleSourceSelect = this.toggleSourceSelect.bind(this);
  }

  toggleSourceSelect() {
    this.props.toggleSource(this.props.source.name)
  }

  render() {
    const className = this.props.source.selected ? "source selected" : "source";
    
    return(
      <li className={className}>
        <button
          className="source__checkbox"
          onClick={this.toggleSourceSelect}
        >
        </button>
        <h4 className="source__title">
          {this.props.source.name}
        </h4>
      </li>
    );
  }
}