import React from "react";

export default class Listing extends React.Component {
  render() {    
    return(
      <li className="listing">
        <div className="listing--title">{this.props.title}</div>
      </li>
    )
  }
}