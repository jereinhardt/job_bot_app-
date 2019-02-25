import $ from "jquery";
import React from "react";
import { Link } from "react-router-dom";
import { history } from "../store.js";
import UserSocket from "../userSocket.js";

export default class LoginForm extends React.Component {
  constructor(props) {
    super(props);

    this.state = {email: "", password: ""};
  }

  handleSubmit(event) {
    event.preventDefault();
    const url = "/session";
    const token = $("#app").data("js-csrf-token");
    const params = {
      session: {email: this.state.email, password: this.state.password},
      _csrf_token: token
    };
    $.post(url, params, (res) => {
      this.props.updateUser(res.data.user);
      new UserSocket(res.data.user).listenForListings();
      history.push("/");
    }).fail((res) => {
      this.setState({error: res.responseJSON.data.message});
    })
  }

  handleEmailChange(event) {
    event.persist();
    this.setState({email: event.target.value});
  }

  handlePasswordChange(event) {
    event.persist();
    this.setState({password: event.target.value});
  }

  render() {
    return(
      <div className="modal is-active">
        <div className="modal-background"></div>
        <div className="modal-content">
          <h2 className="step__title">Welcome Back</h2>
          <h4 className="step__description">
            Log in and get back to the job search
          </h4>
          <p>
            New to JobBot? <Link to="/">Sign up for a free account</Link>.
          </p>
          <form className="login-form" onSubmit={(e) => this.handleSubmit(e)}>

            <div className="field">
              <label name="email" className="label">Email</label>
              <div className="control">
                <input
                  className="input"
                  name="email"
                  onChange={(e) => this.handleEmailChange(e)}
                  placeholder="job@bot.com"
                  type="email"
                  value={this.state.email}
                />
              </div>
            </div>

            <div className="field">
              <label name="password" className="label">Password</label>
              <div className="control">
                <input
                  className="input"
                  name="password"
                  onChange={(e) => this.handlePasswordChange(e)}
                  type="password"
                  value={this.state.password}
                />

              </div>
            </div>            

            <input
              type="submit"
              value="Log In"
              className="step__action step__action--forward"
            />
          </form>
        </div>
      </div>
    );
  }
}