import React from "react";

export default class Listing extends React.Component {
  constructor(props) {
    super(props);

    this.state = { expanded: false };

    this.apply = this.apply.bind(this);
    this.toggleApplied = this.toggleApplied.bind(this);
    this.toggleDescription = this.toggleDescription.bind(this);
  }

  toggleDescription(event) {
    event.preventDefault();
    this.setState({expanded: !this.state.expanded});
  }

  toggleApplied(event) {
    event.preventDefault();
    const token = $("#app").data("js-csrf-token");
    const params = {
      user_listing: {toggle_applied_to_at: true},
      _csrf_token: token
    };
    $.ajax({
      url: `/data/user_listings/${this.props.id}`,
      data: params,
      type: "PATCH",
      dataType: "json",
      async: false,
      success: (res) => this.props.updateListing(res.data.user_listing)
    });
  }

  apply(event) {
    if ( this.props.applied_to_at ) {
      event.preventDefault();
    }
  }

  render() {
    let descriptionClassName,
      descriptionToggleOnClassName,
      descriptionToggleOffClassName;
    if ( this.state.expanded ) {
      descriptionClassName = " expanded";
      descriptionToggleOnClassName = "hidden";
      descriptionToggleOffClassName = "";
    } else {
      descriptionClassName = "";
      descriptionToggleOnClassName = "";
      descriptionToggleOffClassName = "hidden"
    }

    let applyHref;
    if ( this.props.application_url ) {
      applyHref = this.props.application_url
    } else if ( this.props.email ) {
      applyHref = `mailto:${this.props.email}`;
    } else {
      applyHref = this.props.listing_url;
    }

    let applyClassName;
    if ( this.props.applied_to_at ) {
      applyClassName = " button is-success"
    } else {
      applyClassName = " button is-link"
    }

    return(
      <li className="listing card">
        <div className="card-content">
          <div className="listing--title">
            <span className="listing--job-title has-text-weight-semibold">
              {this.props.title}
            </span>
            <span className="listing--company-name">
              {this.props.company_name}
            </span>
          </div>

          <div 
            className={`listing--description${ descriptionClassName }`}
          >
            <p dangerouslySetInnerHTML={{ __html: this.props.description }}></p>
            <a 
              className="listing--description-toggle has-text-centered"
              onClick={this.toggleDescription}
            >
              <span className={descriptionToggleOnClassName}>
                Show More
              </span>
              <span className={descriptionToggleOffClassName}>
                See Less
              </span>
            </a>
          </div>
          <div className="listing--actions has-text-right">
            <a 
              className="listing--action button"
              target="_blank"
              href={this.props.listing_url}
            >
              View Listing
            </a>
            <a
              className="listing--action button"
              href="#"
              onClick={this.toggleApplied}
            >
              {this.props.applied_to_at ? "Unmark as Applied" : "Mark as Applied"}
            </a>
            <a
              className={`listing--action${applyClassName}`}
              target="_blank"
              href={applyHref}
              onClick={this.apply}
            >
              {this.props.applied_to_at ? "Applied!" : "Apply"}
            </a>
          </div>
        </div>
      </li>
    );
  }
}