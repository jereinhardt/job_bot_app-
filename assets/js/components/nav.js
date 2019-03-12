import React from "react";
import { Link } from "react-router-dom";

export default class Nav extends React.Component {
  constructor(props) {
    super(props);

    this.state = { expanded: false };
    this.toggleExpanded = this.toggleExpanded.bind(this)
  }

  toggleExpanded(event) {
    event.preventDefault();
    this.setState({ expanded: !this.state.expanded });
  }

  _menuItems() {
    if ( this.props.user.id ) {
      return(
        <div className="navbar-end">
          <div className="navbar-item">
            <a href="#" className="button is-primary">Create New Search</a>
          </div>
          <div className="navbar-item">
            <a href="/logout" className="button is-light">Logout</a>
          </div>
        </div>
      );
    } else {
      return(
        <div className="navbar-end">
          <div className="navbar-item">
            <Link to="/signup" className="button is-primary">Sign Up</Link>
          </div>
          <div className="navbar-item">
            <Link to="/login" className="button is-light">Log In</Link>
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
          <a href="/" className="navbar-item">
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