import { Socket } from "phoenix";
import "phoenix_html";
import "../css/app.css";

const SOCKET_URL = "ws://localhost:4002/socket";

const socket = new Socket(SOCKET_URL, {
  params: { token: window.userToken }
});

socket.connect();

const channel = socket.channel("tweets", {});
channel
  .join()
  .receive("ok", resp => console.log("Joined Tweets channel", resp))
  .receive("error", resp => console.log("Unable to join Tweets channel", resp));

channel.on("tweets_refreshed", payload => {
  console.log(payload);
});
