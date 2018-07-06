import React from "react";

export default class Form extends React.Component {
  constructor(props) {    
    super(props);

    this.state = {
      sources: props.sources
    };
  }

  toggleSource(source) {
    if (source.selected) {
      this.props.updateSource(source, {selected: false});
    } else {
      this.props.updateSource(source, {selected: true});
    }
  }

  sourceOptionNodes() {
    return this.props.sources.map(function(source) {
      const className = source.selected ? "source selected" : "source"
      const text = source.selected ? "source selected" : "source"
      return (
        <li 
          key={source.name}
          onClick={() => this.toggleSource(source)}
          className={className}
        >
          {source.name} {text}
        </li>
      );
    }.bind(this));
  }

  render() {
    return(
      <form action="/apply" method="POST">
        <h2>This is the Form</h2>
        <ul>
          {this.sourceOptionNodes()}
        </ul>
      </form> 
    );
  }
}