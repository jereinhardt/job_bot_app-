import { TOGGLE_SUBMITTED } from "../actionTypes.js";

export default (state = false, action) => {
  switch (action.type) {
    case TOGGLE_SUBMITTED:
      return !state;
    default:
      return state;
  }
}