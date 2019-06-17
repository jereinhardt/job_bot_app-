import { combineReducers } from "redux";
import { connectRouter } from "connected-react-router";
import activeStep from "./reducers/activeStep";
import applicantLocation from "./reducers/applicantLocation";
import listings from "./reducers/listings";
import listingsChannel from "./reducers/listingsChannel";
import location from "./reducers/location";
import name from "./reducers/name";
import sources from "./reducers/sources";
import terms from "./reducers/terms";
import user from "./reducers/user";

export default (history) => combineReducers({
  activeStep,
  applicantLocation,
  csrfToken: (state = "", _action) => state,
  location,
  listings,
  listingsChannel,
  name,
  router: connectRouter(history),
  sources,
  terms,
  user
});