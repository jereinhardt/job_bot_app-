import React from "react";
import Source from "./source.js";

export default class SourcesForm extends React.Component {
  constructor(props) {    
    super(props);

    this.state = {
      errorClass: "",
      errorMessage: ""
    };
  }

  toggleSource(source) {
    if (source.selected) {
      this.props.updateSource(source, {selected: false});
    } else {
      this.props.updateSource(source, {selected: true});
    }
  }

  handleSubmit(event) {
    event.preventDefault();
    if ( this._hasOneSelectedSource() ) {
      this.setState({
        errorClass: "",
        errorMessage: ""        
      });
      this.props.moveForward();
    } else {
      this.setState({
        errorClass: "has-error",
        errorMessage: "Please select at least one job board"
      });
    }
  }

  _hasOneSelectedSource() {
    return this.props.sources.some((source) => source.selected);
  }

  render() {
    const sourceNodes = this.props.sources.map(function(source) {
      return(
        <Source
          key={source.name}
          source={source} 
          updateSource={this.props.updateSource} 
        />
      );
    }.bind(this));

    return(
      <div>
        <h2 class="">This is the Form</h2>
        <ul className="source__list">
          {sourceNodes}
        </ul>
        <span className={`input-error-message ${this.state.errorClass}`}>
          {this.state.errorMessage}
        </span>
        <button 
          onClick={(_e) => this.props.moveBackward()}
          className="button is-link"
        >
          Go Back
        </button>
        <button
          onClick={(e) => this.handleSubmit(e)}
          className="button is-link"
        >
          Continue
        </button>
      </div> 
    );
  }
}