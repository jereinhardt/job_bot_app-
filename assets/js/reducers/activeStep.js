import { MOVE_FORWARD, MOVE_BACKWARD } from "../actionTypes.js";

export default (state = 1, action) => {
  const i = action.payload || 1;

  switch (action.type) {
    case MOVE_BACKWARD:
      return state - i;
    case MOVE_FORWARD:
      return state + i;
    default:
      return state;
  }
}