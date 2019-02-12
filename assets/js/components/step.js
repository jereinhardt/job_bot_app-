import React from "react"

export default class Step extends React.Component {
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