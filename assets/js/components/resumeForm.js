import React from "react";
import Validator from "../containers/validator.js";
import { post } from "axios";

export default class ResumeForm extends React.Component {
  constructor(props) {
    super(props);

    this.state = {resumePath: this.props.resumePath};
    window.t = this;

    this.validator = new Validator(
      this,
      [{id: "resumePath", validate: ["presence"]}]
    );

    this.handleChange = this.handleChange.bind(this);
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
      this.props.updateResumePath(this.state.resumePath);
      this.props.moveForward();
    }
  }

  render() {
    const errorClass = this.validator.errorClassFor("resumePath");
    let filename = "";
    if ( this.state.resumePath != "" ) {
      filename = this.state.resumePath.split("/").pop();
    }

    return(
      <form onSubmit={(e) => this.handleSubmit(e)}>
        <div className="step__title">Next, I'll need your resume</div>
        <p className="step__description">
          Please upload a current resume that I can show off to employers.
        </p>
        <div className="field">
          <div className="file">
            <label htmlFor="resumePath" className={`file-label ${errorClass}`}>
              <input
                name="resumePath"
                type="file"
                onChange={(e) => this.handleChange(e)}
                className={`file-input ${errorClass}`}
                ref={(ref) => this.upload = ref}
              />
              <span 
                className="file-cta"
                onClick={(_e) => this.upload.click()}
              >
                <span className="file-icon">
                  <span className="fas fa-upload"></span>
                </span>
                <span className="file-label">Upload Your Resume</span>
              </span>
              <span className="file-filename">{filename}</span>
              <p className={`input-error-message is-danger ${errorClass}`}>
                {this.validator.errorMessageFor("resumePath")}
              </p>
            </label>
          </div>
        </div>

        <div className="step__actions">
          <span
            className="step__action step__action--backward"
            onClick={() => this.props.moveBackward()}
          >
            Go Back
          </span>
          <input
            type="submit"
            value="Continue"
            className="step__action step__action--forward"
          />
        </div>
    </form>
    )
  }
}