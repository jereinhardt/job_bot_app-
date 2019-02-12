import { ADD_LISTING } from "../actionTypes.js";

export default (state = [], action) => {
  switch (action.type) {
    case ADD_LISTING:
      return [ ...state, action.payload ];
    default:
      return state;
  }
}