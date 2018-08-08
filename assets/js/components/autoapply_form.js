import React from "react";

export default class AutoapplyForm extends React.Component {
  constructor(props) {
    super(props);

    this.state = {autoapply: this.props.autoapply};
  }

  handleSubmit(event) {
    event.preventDefault();
    const steps = this.state.autoapply ? 1 : 3;
    this.props.updateData(this.state);
    this.props.moveForward(steps);
  }

  handleChange(event) {
    event.persist();
    this.setState({autoapply: event.target.value})
  }

  render() {
    return(
      <form onSubmit={(e) => this.handleSubmit(e)}>
        <div className="step__title">
          Are you ready to apply?
        </div>
        <p className="step__description">
          If you would like, I can automatically send applications to some jobs
          as I find them.  Would you like me to apply to jobs on your behalf?
        </p>
        <div className="field">
          <label className="checkbox">
            <input 
              type="checkbox"
              value={this.state.autoapply}
              onChange={(e) => this.handleChange(e)}
            />
            Yes, I would like to automatically apply to available jobs.
          </label>
        </div>

        <div className="step__actions">
          <button
            className="step__action step__action--backward"
            onClick={(e) => this.props.moveBackward}
          >
            Go Back
          </button>
          <input
            type="submit"
            value="Continue"
            className="step__action step__action--forward"
          />
        </div>
      </form>
    );
  }
}