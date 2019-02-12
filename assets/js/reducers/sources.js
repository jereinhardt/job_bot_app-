import { UPDATE_SOURCE, TOGGLE_SOURCE } from "../actionTypes.js";

export default (state = {}, action) => {
  switch (action.type) {
    case UPDATE_SOURCE:
      return state.map((source) => {
        if ( source.name == action.payload.source.name ) {
          return Object.assign({}, source, action.payload.data);
        } else {
          return source;
        }
      });
    case TOGGLE_SOURCE:
      return state.map((source) => {
        if ( source.name == action.payload ) {
          return Object.assign({}, source, { selected: !source.selected });
        } else {
          return source;
        }
      });
    default:
      return state;
  }
}