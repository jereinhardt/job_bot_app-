import React from "react";
import Validator from "../containers/validator.js";
import { post } from "axios";

export default class ResumeForm extends React.Component {
  constructor(props) {
    super(props);

    this.state = {resumePath: this.props.resumePath};

    this.validator = new Validator(
      this,
      [{id: "resumePath", validate: ["presence"]}]
    );
  }

  handleChange(event) {
    const file = event.target.files[0];
    const url = "/uploads";
    const token = $("#app").data("js-csrf-token");
    let formData = new FormData();
    formData.append("file", file);
    formData.append("_csrf_token", token);
    const config = {
      headers: { "content-type": "multipart/form-data" }
    }

    post(url, formData, config).then((res) => {
      const path = res.data.path;
      this.setState({resumePath: path});
    })
  }

  handleSubmit(event) {
    event.preventDefault();
    if ( !this.validator.hasInvalidFields() ) {
      this.props.updateData(this.state);
      this.props.moveForward();
    }
  }

  render() {
    const errorClass = this.validator.errorClassFor("resumePath");

    return(
      <form onSubmit={(e) => this.handleSubmit(e)}>
        <p>Please upload your most recent resume</p>
        <div className="field">
          <div className="file">
            <label htmlFor="resumePath" className={`file-label ${errorClass}`}>
              <input
                name="resumePath"
                type="file"
                onChange={(e) => this.handleChange(e)}
                className={`file-input ${errorClass}`}
              />
              <span className="file-cta">
                <span className="file-icon">
                  <i className="fas fa-upload"></i>
                </span>
                <span className="file-label">Upload Your Resume</span>
              </span>
              <p className={`input-error-message is-danger ${errorClass}`}>
                {this.validator.errorMessageFor("resumePath")}
              </p>
            </label>
          </div>
        </div>

        <div className="field">
          <div className="control">
            <input type="submit" value="Continue" className="button is-link"/>
          </div>
        </div>  
    </form>
    )
  }
}