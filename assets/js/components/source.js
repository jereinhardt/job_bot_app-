import React from "react";
import SourceCredentialsForm from "./source_credentials_form.js";

export default class Source extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      toggled: false
    };

    this.toggleSourceForm = this.toggleSourceForm.bind(this);
    this.toggleSourceFormClose = this.toggleSourceFormClose.bind(this);
    this.deselectSource = this.deselectSource.bind(this);
  }

  toggleSource(event, source) {
    event.preventDefault();
    if (source.selected) {
      this.props.updateSource(source, {selected: false});
    } else {
      this.props.updateSource(source, {selected: true});
    }
  }

  toggleSourceForm(event) {
    event.preventDefault();
    if ( !this.state.toggled ) {
      if ( this.props.source.selected ) { 
        this.deselectSource() 
      } else {
        this.setState({toggled: true});
      }
    }
  }

  toggleSourceFormClose(event) {
    event.preventDefault();
    this.setState({toggled: false});
  }

  deselectSource() {
    this.props.updateSource(this.props.source, {selected: false});
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
          onClick={(e) => this.toggleSource(e, this.props.source)}
        >
        </button>
        <h4 className="source__title">
          {this.props.source.name}
        </h4>
      </li>
    );
  }

  _renderSourceWithCredentials(className) {
    const updateSource = (source, attrs) => {
      this.setState({toggled: false});
      this.props.updateSource(source, attrs);
    }

    const toggleClass = this.state.toggled ? "form-toggled" : "";
    const buttonClass = this.state.toggled ? "" : "hidden";

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
          toggled={this.state.toggled}
          source={this.props.source}
          updateSource={updateSource}
        />
      </li>
    )
  }
}