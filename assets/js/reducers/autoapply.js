import { UPDATE_AUTOAPPLY } from "../actionTypes.js";

export default (state = false, action) => {
  switch (action.type) {
    case UPDATE_AUTOAPPLY:
      return action.payload;
    default:
      return state;
  }
}