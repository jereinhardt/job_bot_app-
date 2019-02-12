import { UPDATE_EMAIL } from "../actionTypes.js";

export default (state = {}, action) => {
  switch (action.type) {
    case UPDATE_EMAIL:
      return action.payload;
    default:
      return state;
  }
}