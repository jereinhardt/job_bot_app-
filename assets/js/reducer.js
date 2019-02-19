import { combineReducers } from "redux";
import activeStep from "./reducers/activeStep";
import applicantLocation from "./reducers/applicantLocation";
import listings from "./reducers/listings";
import location from "./reducers/location";
import name from "./reducers/name";
import resumePath from "./reducers/resumePath";
import sources from "./reducers/sources";
import submitted from "./reducers/submitted";
import terms from "./reducers/terms";
import user from "./reducers/user";

export default combineReducers({
  activeStep,
  applicantLocation,
  location,
  listings,
  name,
  resumePath,
  sources,
  submitted,
  terms,
  user
});