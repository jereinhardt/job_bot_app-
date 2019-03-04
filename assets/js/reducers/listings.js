import {
  ADD_LISTING,
  UPDATE_LISTING,
  UPDATE_LISTINGS
} from "../actionTypes.js";

export default (state = [], action) => {
  switch (action.type) {
    case ADD_LISTING:
      return [ ...state, action.payload ];
    case UPDATE_LISTINGS:
      return action.payload;
    case UPDATE_LISTING:
      const listing = state.find((l) => l.id == action.payload.id);
      const i = state.indexOf(listing);
      let newState = Object.assign([], state)
      newState[i] = action.payload;
      return newState;
    default:
      return state;
  }
}