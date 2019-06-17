import { Socket } from "phoenix";

export const joinUserListingsChannel = (user, callback) => {
  const socket = new Socket("/socket", { params: { token: user.token } })
  socket.connect();
  const channel = socket.channel(`users:${user.id}`, {});
  callback(channel);
}