import { Socket } from "phoenix";
import store from "./store.js";
import { ADD_LISTING } from "./actionTypes.js";

export default class UserSocket {
  constructor(user) {
    let socket = new Socket("/socket", { params: { token: user.token } });
    socket.connect();

    this.user = user;
    this.socket = socket;
  }

  listenForListings() {
    let channel = this.socket.channel(`users:${this.user.id}`, {});
  
    channel.join().
      receive("error", resp => { 
        console.error("failed to connect to channel", resp);
      });

    channel.on("new_listing", payload => {
      store.dispatch({ type: ADD_LISTING, payload: payload.listing });
    });
  }
}