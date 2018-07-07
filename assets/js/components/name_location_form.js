import React from "react";

export default class NameLocationForm extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      name: this.props.name,
      applicantLocation: this.props.applicantLocation
    }
  }

  handleSubmit(event) {
    event.preventDefault();
    this.props.updateData(this.state);
    this.props.moveForward();
  }

  handleNameChange(event) {
    event.persist();
    this.setState({name: event.target.value});
  }

  handleLocationChange(event) {
    event.persist();
    this.setState({applicantLocation: event.target.value});
  }

  render() {
    return(
      <form onSubmit={(e) => this.handleSubmit(e)}>
        <label htmlFor="name">Name</label>
        <input
          type="text"
          name="name"
          value={this.state.name}
          placeholder="Enter your full name"
          onChange={(e) => this.handleNameChange(e)}
        />

        <label htmlFor="applicantLocation">Location</label>
        <input
          type="text"
          name="applicantLocation"
          value={this.state.applicantLocation}
          placeholder="Enter your Location"
          onChange={(e) => this.handleLocationChange(e)}
        />

        <input type="submit" value="Continue" />
      </form>
    )
  }
}