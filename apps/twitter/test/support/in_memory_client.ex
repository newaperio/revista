defmodule Twitter.InMemoryClient do
  @moduledoc false

  alias Twitter.Tweet

  @behaviour Twitter.Client

  @doc false
  @impl true
  def get_recent_tweets(_count \\ 0) do
    body = [
      %{
        "created_at" => "Wed Oct 24 20:04:44 +0000 2018",
        "id" => "1055188361982500865",
        "source" => ~s(<a href="http://twitter.com" rel="nofollow">Twitter Web Client</a>),
        "text" =>
          "Glad to be aboard, @newaperio! Let's build cool stuff. https://t.co/Mqu31L4NWY",
        "user" => %{
          "profile_image" =>
            "https://pbs.twimg.com/profile_images/1021886062803599360/UEvD1KcW_normal.jpg",
          "screen_name" => "ngscheurich"
        }
      }
    ]

    tweets = Enum.map(body, fn x -> Tweet.from_api(x) end)
    {:ok, tweets}
  end
end
