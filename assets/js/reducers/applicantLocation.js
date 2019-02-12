import { UPDATE_APPLICANT_LOCATION } from "../actionTypes.js";

export default (state = "", action) => {
  switch (action.type) {
    case UPDATE_APPLICANT_LOCATION:
      return action.payload;
    default:
      return state;
  }
}