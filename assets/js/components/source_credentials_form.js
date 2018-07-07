import React from "react";

export default class SourceCredentialsForm extends React.Component {
  constructor(props) {
    super(props);
  }

  handleSubmit(event) {
    event.preventDefault();
    const attrs = Object.assign({credentials: this.state}, {selected: true});
    this.props.updateSource(this.props.source, attrs);
  }

  updateEmail(event) {
    event.persist();
    this.setState({email: event.target.value});
  }

  updatePassword(event) {
    event.persist();
    this.setState({password: event.target.value});
  }

  render() {
    const className = this.props.toggled ? "toggled" : ""
    return(
      <form className={className} onSubmit={(e) => this.handleSubmit(e)}>
        <label htmlFor="email">Email or Username</label>
        <input
          name="email"
          type="text"
          onChange={(e) => this.updateEmail(e)}
        />

        <label htmlFor="password">Password</label>
        <input
          name="password"
          type="password"
          onChange={(e) => this.updatePassword(e)}
        />

        <input type="submit" value="submit" />
      </form>
    );
  }
}