import React from "react";

export default class Step extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    let className;
    if (this.props.activeStep == this.props.step) {
      className = "step active";
    } else {
      className = "step"
    }

    return(
      <div className={className}>
        {this.props.children}
      </div>
    )
  }
}