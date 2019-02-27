import $ from "jquery";
import { createBrowserHistory } from "history";
import { applyMiddleware, compose, createStore } from "redux";
import { routerMiddleware } from "connected-react-router";
import createRootReducer from "./reducer.js";

const sources = (() => {
  let sources;
  $.ajax({
    url: "/data/sources",
    type: "get",
    dataType: "json",
    async: false,
    success: (data) => sources = data
  });
  return JSON.parse(sources);
})()

const user = (() => {
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
})()

let submitted = false;
if ( user.id ) {
  submitted = true;
}

const initialState = {
  activeStep: 1,
  applicantLocation: "",
  listings: [],
  location: "",
  name: "",
  sources: sources,
  terms: "",
  resumePath: "",
  submitted: submitted,
  user: user
}

export const history = createBrowserHistory();
const middleware = applyMiddleware(routerMiddleware(history));

export const store = createStore(
  createRootReducer(history),
  initialState,
  compose(middleware)
);