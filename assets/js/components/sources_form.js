import React from "react";
import Source from "./source.js";

export default class SourcesForm extends React.Component {
  constructor(props) {    
    super(props);
  }

  toggleSource(source) {
    if (source.selected) {
      this.props.updateSource(source, {selected: false});
    } else {
      this.props.updateSource(source, {selected: true});
    }
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
    const moveForward = (event) => {
      event.preventDefault();
      this.props.moveForward();
    }

    return(
      <div>
        <h2>This is the Form</h2>
        <ul>
          {sourceNodes}
        </ul>
        <button onClick={(e) => moveForward(e)}>Continue</button>
      </div> 
    );
  }
}