import { ADD_LISTINGS_CHANNEL } from "../actionTypes.js";

export default (state = null, action) => {
  switch (action.type) {
    case ADD_LISTINGS_CHANNEL:
      if ( state == null ) {
        return action.payload;  
      } else {
        return state;
      }
     default:
       return state;
  }
}