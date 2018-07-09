import React from "react";

export default class AutoapplyForm extends React.Component {
  constructor(props) {
    super(props);

    this.state = {autoapply: this.props.autoapply};
  }

  handleSubmit(event) {
    event.preventDefault();
    this.props.updateData(this.state);
    this.props.moveForward();
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
        <label>
          <input 
            type="checkbox"
            value={this.state.autoapply}
            onChange={(e) => this.handleChange(e)}
          />
          Yes.
        </label>

        <input type="submit" value="continue" />
      </form>
    );
  }
}