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
        <label htmlFor="resumePath" className={errorClass}>
          Please upload your most recent recume
        </label>
        <input
          name="resumePath"
          type="file"
          onChange={(e) => this.handleChange(e)}
          className={errorClass}
        />
        <span className={`input-error-message ${errorClass}`}>
          {this.validator.errorMessageFor("resumePath")}
        </span>

        <input type="submit" value="Continue" />
      </form>
    )
  }
}