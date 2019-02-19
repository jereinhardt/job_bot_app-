import $ from "jquery";
import { createStore } from "redux";
import reducer from "./reducer.js";

const getSources = () => {
  let sources;
  $.ajax({
    url: "/data/sources",
    type: "get",
    dataType: "json",
    async: false,
    success: (data) => sources = data
  });
  return JSON.parse(sources);
}

const getUser = () => {
  let user;
  $.ajax({
    url: "/data/users",
    type: "get",
    dataType: "json",
    async: false,
    success: (res) => {
      if ( res.data.user == null ) {
        user = {};        
      } else {
        user = res.data.user;        
      }
    }
  })
  return user;
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
  submitted: false,
  user: getUser()
}

export const store = createStore(reducer, initialState);