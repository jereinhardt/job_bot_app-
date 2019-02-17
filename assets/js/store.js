import $ from "jquery";
import { createStore } from "redux";
import reducer from "./reducer.js";

const getSources = () => {
  let sources;
  $.ajax({
    url: "/api/sources",
    type: "get",
    dataType: "json",
    async: false,
    success: (data) => sources = data
  });
  return JSON.parse(sources);
}

const initialState = {
  activeStep: 1,
  applicantLocation: "",
  listings: [],
  location: "",
  name: "",
  sources: getSources(),
  terms: "",
  resumePath: "",
  submitted: false
}

export const store = createStore(reducer, initialState);