import React from "react";
import Step from "./step.js";

export default class StepsController extends React.Component {
  constructor(props) {
    super(props);

    this.totalSteps = this.props.children.length;
    this.state = {activeStep: 1};
  }

  moveForward(steps = 1) {
    this.setState({activeStep: this.state.activeStep + steps});
  }

  moveBackward(steps = 1) {
    this.setState({activeStep: this.state.activeStep - steps});
  }

  moveBackwardOnClick(event, steps = 1) {
    event.preventDefault();
    this.moveBackward(steps);
  }

  _stepMethodsForChild(child, i) {
    const forward = this.moveForward.bind(this);
    const backward = this.moveBackward.bind(this);
    const backwardOnClick = this.moveBackwardOnClick.bind(this);

    if (i == 1) {
      return {moveForward: forward}
    } else if (i == this.totalSteps) {
      return {moveBackward: backward, moveBackwardOnClick: backwardOnClick}
    } else {
      return(
        {
          moveForward: forward,
          moveBackward: backward,
          moveBackwardOnClick: backwardOnClick
        }
      );
    }
  }

  render() {
    const { children } = this.props;
    const updatedChildren = children.map((child) => {
      const i = children.indexOf(child) + 1;
      const methods = this._stepMethodsForChild(child, i);
      return React.cloneElement(child, methods);
    });

    let i = 0;
    const stepNodes = updatedChildren.map((child) => {
      i += 1;
      return(
        <Step activeStep={this.state.activeStep} step={i} key={i}>
          {child}
        </Step>
      );
    });

    return(<div>{stepNodes}</div>);
  }
}