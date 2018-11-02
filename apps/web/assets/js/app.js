import { Socket } from "phoenix";
import React from "react";
import ReactDOM from "react-dom";
import TweetList from "./components/TweetList";
import "phoenix_html";
import "../css/app.scss";

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

document.addEventListener("DOMContentLoaded", () => {
  const node = document.getElementById("tweets");
  ReactDOM.render(<TweetList channel={channel} />, node);
});
