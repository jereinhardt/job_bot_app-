import { UPDATE_NAME } from "../actionTypes.js";

export default (state = "", action) => {
  switch (action.type) {
    case UPDATE_NAME:
      return action.payload;
    default:
      return state;
  }
}