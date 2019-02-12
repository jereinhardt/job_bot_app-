import { UPDATE_TERMS } from "../actionTypes.js";

export default (state = "", action) => {
  switch (action.type) {
    case UPDATE_TERMS:
      return action.payload;
    default:
      return state;
  }
}