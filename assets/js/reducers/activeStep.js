import { MOVE_FORWARD, MOVE_BACKWARD, RESET_STEPS } from "../actionTypes.js";

export default (state = 1, action) => {
  const i = action.payload || 1;

  switch (action.type) {
    case MOVE_BACKWARD:
      return state - i;
    case MOVE_FORWARD:
      return state + i;
    case RESET_STEPS:
      return 1;
    default:
      return state;
  }
}