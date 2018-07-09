import React from "react";
import { post } from "axios";

export default class ResumeForm extends React.Component {
  constructor(props) {
    super(props);

    this.state = {resumePath: this.props.resumePath};
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
      const path = JSON.parse(res.data).path;
      this.setState({resumePath: path});
    })
  }

  handleSubmit(event) {
    event.preventDefault();
    this.props.updateData(this.state);
    this.props.moveForward();
  }

  render() {
    return(
      <form onSubmit={(e) => this.handleSubmit(e)}>
        <label htmlFor="resume">Please upload your most recent recume</label>
        <input name="resume" type="file" onChange={(e) => this.handleChange(e)} />

        <input type="submit" value="Continue" />
      </form>
    )
  }
}