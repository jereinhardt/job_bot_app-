import React from "react";

export default class EmailForm extends React.Component {
  constructor(props) {
    super(props);

    this.state = this.props.email;
  }

  handleUsernameChange(event) {
    event.persist();
    this.setState(username: event.target.value);
  }

  handlePasswordChange(event) {
    event.persist();
    this.setState(password: event.target.value);
  }

  handleSubmit(event) {
    event.preventDefault();
    this.props.updateData({email: this.state});
    this.props.moveForward();
  }

  render() {
    return(
      <form onSubmit={(e) => this.handleSubmit(e)}>
        <label htmlFor="username">Email</label>
        <input
          type="text"
          name="username"
          placeholder="enter your email"
          value={this.state.username}
          onChange={(e) => this.handleUsernameChange(e)}
        />

        <label htmlFor="emailPassword">Password</label>
        <input
          type="password"
          name="emailPassword"
          value={this.state.password}
          onChange={(e) => this.handlePasswordChange(e)}
        />

        <input type="submit" value="continue" />
      </form>
    );
  }  
}