import React from "react";
import Source from "../containers/source.js";

export default class SourcesForm extends React.Component {
  constructor(props) {    
    super(props);

    this.state = {
      errorClass: "",
      errorMessage: ""
    };
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
        />
      );
    }.bind(this));

    return(
      <div>
        <div className="step__title">Where would you like to look?</div>
        <p className="step__description">
          Please select at least one job board where you would like to look for
          jobs.
        </p>

        <ul className="source__list">
          {sourceNodes}
        </ul>
        <span className={`input-error-message ${this.state.errorClass}`}>
          {this.state.errorMessage}
        </span>
        <div className="step__actions">
          <button 
            onClick={(_e) => this.props.moveBackward()}
            className="step__action step__action--backward"
          >
            Go Back
          </button>
          <button
            onClick={(e) => this.handleSubmit(e)}
            className="step__action step__action--forward"
          >
            Continue
          </button>
        </div>
      </div> 
    );
  }
}