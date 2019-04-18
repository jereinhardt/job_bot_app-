import { Socket } from "phoenix";
import { store } from "./store.js";
import { ADD_LISTING, UPDATE_LISTINGS } from "./actionTypes.js";

export default class UserSocket {
  constructor(user) {
    let socket = new Socket("/socket", { params: { token: user.token } });
    socket.connect();

    this.user = user;
    this.socket = socket;
    this.channel = this.socket.channel(`users:${this.user.id}`, {});
  }

  joinChannel(callback = undefined) {
    this.channel.join().
      receive("ok", (res) => {
        store.dispatch({ type: UPDATE_LISTINGS, payload: res.listings });
        if ( callback ) {
          callback(res);
        }
        this.listenForListings();
      }).
      receive("error", (res) => {
        console.error("failed to connect to channel", res);
      });
  }

  listenForListings() {
    this.channel.on("new_listing", payload => {
      store.dispatch({ type: ADD_LISTING, payload: payload.listing });
    });
  }
}