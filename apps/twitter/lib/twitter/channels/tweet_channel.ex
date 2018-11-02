defmodule Twitter.TweetChannel do
  use Phoenix.Channel

  def join("tweets", _message, socket) do
    {:ok, socket}
  end
end
