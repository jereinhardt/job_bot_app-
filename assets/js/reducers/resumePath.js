import { UPDATE_RESUME_PATH } from "../actionTypes.js";

export default (state = "", action) => {
  switch (action.type) {
    case UPDATE_RESUME_PATH:
      return action.payload;
    default:
      return state;
  }
}