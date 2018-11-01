defmodule Twitter.Client do
  @moduledoc """
  This module defines an explicit contract to which all modules
  that act as consumers of the Twitter web API should adhere to.
  """

  alias Twitter.Tweet

  @callback get_recent_tweets(count :: integer()) :: {:ok, list(Tweet.t())} | {:error, term}
end
