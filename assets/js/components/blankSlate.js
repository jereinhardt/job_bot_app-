import React from "react";

export default class BlankSlate extends React.Component {
  constructor(props) {
    super(props);

    this.createNewSearch = this.createNewSearch.bind(this);
  }

  createNewSearch(event) {
    event.preventDefault();
    this.props.createNewSearch();
  }

  render() {
    return(
      <section className="hero is-large">
        <div className="hero-body has-text-centered">
          <div className="container">
            <p className="title">I'm hard at work</p>
            <p>
              Looks like I don't have any job listings for you yet. 
              Try checking in later, or 
              <a
                href="#"
                onClick={this.createNewSearch}
              > create a new search</a>.
            </p>
          </div>
        </div>
      </section>
    );
  }
}