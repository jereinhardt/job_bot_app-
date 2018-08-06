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
        <div>
          Would you like us to automatically apply as they are found on your behalf?
        </div>
        <div className="field">
          <label className="checkbox">
            <input 
              type="checkbox"
              value={this.state.autoapply}
              onChange={(e) => this.handleChange(e)}
            />
            Yes.
          </label>
        </div>

        <div className="field">
          <div className="control">
            <button
              className="button is-link"
              onClick={(e) => this.props.moveBackward}
            >
              Go Back
            </button>
            <input type="submit" value="continue" className="button is-link"/>
          </div>
        </div>
      </form>
    );
  }
}