import React from "react";
import SourceCredentialsForm from "./source_credentials_form.js";
import { UPDATE_SOURCE, TOGGLE_SOURCE } from "../actionTypes.js";

export default class Source extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      formToggled: false
    };

    this.toggleSourceForm = this.toggleSourceForm.bind(this);
    this.toggleSourceFormClose = this.toggleSourceFormClose.bind(this);
  }

  toggleSourceSelect() {
    this.props.toggleSource(this.props.source.name)
  }

  toggleSourceForm(event) {
    event.preventDefault();
    if ( this.state.formToggled ) {
      this.setState({formToggled: false});
    } else {
      if ( this.props.source.selected ) { 
        this.toggleSourceSelect();
      } else {
        this.setState({formToggled: true});
      }
    }
  }

  toggleSourceFormClose(event) {
    event.preventDefault();
    this.setState({formToggled: false});
  }

  render() {
    const source = this.props.source
    const className = source.selected ? "source selected" : "source";

    if (source.credentials == null) {
      return this._renderSourceWithoutCredentials(className);
    } else {
      return this._renderSourceWithCredentials(className);
    }
  }

  _renderSourceWithoutCredentials(className) {
    return(
      <li className={className}>
        <button
          className="source__checkbox"
          onClick={() => this.toggleSourceSelect()}
        >
        </button>
        <h4 className="source__title">
          {this.props.source.name}
        </h4>
      </li>
    );
  }

  _renderSourceWithCredentials(className) {
    const updateSource = (data) => {
      this.setState({formToggled: false});
      const source = this.props.source;
      this.props.updateSource({ source, data });
    }

    const toggleClass = this.state.formToggled ? "form-toggled" : "";
    const buttonClass = this.state.formToggled ? "" : "hidden";

    return(
      <li className={`${className} ${toggleClass}`}>
        <button
          className="source__checkbox"
          onClick={this.toggleSourceForm}
        >
        </button>
        <h4 className="source__title">
          {this.props.source.name}
          <button
            className={`source__form--close-toggle ${buttonClass}`}
            onClick={this.toggleSourceFormClose}
          >
          </button>
        </h4>

        <SourceCredentialsForm
          toggled={this.state.formToggled}
          source={this.props.source}
          updateSource={updateSource}
        />
      </li>
    )
  }
}