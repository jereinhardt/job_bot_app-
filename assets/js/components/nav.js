import React from "react";
import { Link } from "react-router-dom";
import { loginPath, logoutPath, mainAppPath, signupPath } from "../routes.js";

export default class Nav extends React.Component {
  constructor(props) {
    super(props);

    this.state = { expanded: false };
    this.toggleExpanded = this.toggleExpanded.bind(this)
    this.createNewSearch = this.createNewSearch.bind(this)
  }

  toggleExpanded(event) {
    event.preventDefault();
    this.setState({ expanded: !this.state.expanded });
  }

  createNewSearch(event) {
    event.preventDefault();
    this.props.createNewSearch();
  }

  _menuItems() {
    if ( this.props.user.id ) {
      return(
        <div className="navbar-end">
          <div className="navbar-item">
            <Link to={mainAppPath} className="button is-primary">
              Create New Search
            </Link>
          </div>
          <div className="navbar-item">
            <a href={logoutPath} className="button is-light">Logout</a>
          </div>
        </div>
      );
    } else {
      return(
        <div className="navbar-end">
          <div className="navbar-item">
            <Link to={signupPath} className="button is-primary">Sign Up</Link>
          </div>
          <div className="navbar-item">
            <Link to={loginPath} className="button is-light">Log In</Link>
          </div>
        </div>
      );
    }
  }

  render() {
    const mobileMenuClass = this.state.expanded ? " expanded" : "";

    return(
      <nav className="navbar" role="navigation">
        <div className="navbar-brand">
          <a href={mainAppPath} className="navbar-item">
            <span className="navbar-logo">
              JOB BOT
            </span>
          </a>

          <a
            role="button"
            className="navbar-burger burger"
            aria-label="menu"
            aria-expanded={this.state.expanded}
            onClick={this.toggleExpanded}
          >
            <span aria-hidden="true"></span>
            <span aria-hidden="true"></span>
            <span aria-hidden="true"></span>
          </a>
        </div>

        <div className={`navbar-menu${mobileMenuClass}`}>
          {this._menuItems()}
        </div>
      </nav>
    );
  }
}