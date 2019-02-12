import { combineReducers } from "redux";
import activeStep from "./reducers/activeStep";
import applicantLocation from "./reducers/applicantLocation";
import autoapply from "./reducers/autoapply";
import email from "./reducers/email";
import listings from "./reducers/listings";
import location from "./reducers/location";
import name from "./reducers/name";
import resumePath from "./reducers/resumePath";
import sources from "./reducers/sources";
import submitted from "./reducers/submitted";
import terms from "./reducers/terms";

export default combineReducers({
  activeStep,
  applicantLocation,
  autoapply,
  email,
  location,
  listings,
  name,
  resumePath,
  sources,
  submitted,
  terms
});