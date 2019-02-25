import { ADD_LISTING, UPDATE_LISTINGS } from "../actionTypes.js";

export default (state = [], action) => {
  switch (action.type) {
    case ADD_LISTING:
      return [ ...state, action.payload ];
    case UPDATE_LISTINGS:
      return action.payload;
    default:
      return state;
  }
}