import $ from "jquery";
import { createBrowserHistory } from "history";
import { applyMiddleware, compose, createStore } from "redux";
import { routerMiddleware } from "connected-react-router";
import { sourcesPath, userDataPath, userListingsPath } from "./routes.js";
import createRootReducer from "./reducer.js";

const sources = (() => {
  let sources;
  $.ajax({
    url: sourcesPath,
    type: "get",
    dataType: "json",
    async: false,
    success: (data) => sources = data
  });
  return JSON.parse(sources);
})()

const user = (() => {
  let user = {};
  $.ajax({
    url: userDataPath,
    type: "get",
    dataType: "json",
    async: false,
    success: (res) => {
      user = res.data.user;        
    }
  });
  return user;
})()

const listings = (() => {
  let listings = [];
  $.ajax({
    url: userListingsPath,
    type: "get",
    dataType: "json",
    async: false,
    success: (res) => {
      listings = res.data.listings
    }
  });
  return listings;
})()

const name = user.name || "";

let submitted = false;
if ( listings.length > 0 ) {
  submitted = true;
}


const initialState = {
  activeStep: 1,
  applicantLocation: "",
  listings: listings,
  location: "",
  name: name,
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