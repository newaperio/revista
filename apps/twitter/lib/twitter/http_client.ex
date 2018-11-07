defmodule Twitter.HTTPClient do
  @moduledoc """
  Provides functions for interfacing with Twitter’s web API.
  """

  alias Twitter.Tweet

  @behaviour Twitter.Client
  @base_url "https://api.twitter.com/1.1"

  @doc """
  `GET`s the authenticated user’s most recent `count` tweets.

  Returns `{:ok, tweets}` if successful, otherwise `{:error,
  reason}`.

  * `limit` - an optional integer describing how many tracks
    to request

  ## Examples
      iex> get_recent_tweets(2)
      {:ok, [%{}Tweet, %Tweet{}]}

      iex> get_recent_tweets(2)
      {:error, "Endpoint was unresponsive"}
  """
  @impl true
  def get_recent_tweets(count \\ 5) do
    url =
      url("/statuses/user_timeline.json",
        screen_name: config()[:screen_name],
        count: count
      )

    headers = [{"Authorization", "Bearer #{config()[:bearer_token]}"}]

    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        tweets =
          body
          |> Jason.decode!()
          |> Enum.map(fn x -> Tweet.from_api(x) end)

        {:ok, tweets}

      {:ok, %HTTPoison.Response{status_code: code, body: body}} ->
        body =
          body
          |> Jason.decode!()
          |> Map.put("status_code", code)

        {:error, body}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @doc false
  def config, do: Application.get_env(:twitter, Twitter.HTTPClient)

  defp url(endpoint, params) do
    params =
      params
      |> Enum.map(fn pair ->
        {key, value} = pair
        "#{key}=#{value}"
      end)
      |> Enum.join("&")

    @base_url <> endpoint <> "?#{params}"
  end
end
