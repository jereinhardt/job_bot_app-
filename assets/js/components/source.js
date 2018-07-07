import React from "react";
import SourceCredentialsForm from "./source_credentials_form.js";

export default class Source extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      toggled: false
    };
  }

  toggleSource(source) {
    if (source.selected) {
      this.props.updateSource(source, {selected: false});
    } else {
      this.props.updateSource(source, {selected: true});
    }
  }

  toggleSourceForm() {
    this.setState({toggled: true});
  }

  render() {
    const source = this.props.source
    const className = source.selected ? "source selected" : "source";

    const text = source.selected ? "selected" : "";

    if (source.credentials == null) {
      return this._renderSourceWithoutCredentials(className, text);
    } else {
      return this._renderSourceWithCredentials(className, text);
    }
  }

  _renderSourceWithoutCredentials(className, text) {
    return(
      <li
        onClick={() => this.toggleSource(this.props.source)}
        className={className}
      >
        {this.props.source.name} {text}
      </li>
    );
  }

  _renderSourceWithCredentials(className, text) {
    const updateSource = (source, attrs) => {
      this.setState({toggled: false});
      this.props.updateSource(source, attrs);
    }

    return(
      <li onClick={this.toggleSourceForm.bind(this)} className={className}>
        {this.props.source.name } {text}

        <SourceCredentialsForm
          toggled={this.state.toggled}
          source={this.props.source}
          updateSource={updateSource}
        />
      </li>
    )
  }
}