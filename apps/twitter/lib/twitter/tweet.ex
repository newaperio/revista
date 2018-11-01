defmodule Twitter.Tweet do
  @moduledoc """
  Defines a Tweet retrieved from Twitter.
  """

  alias __MODULE__

  @type t :: %Tweet{}
  defstruct [
    :created_at,
    :id,
    :profile_image,
    :screen_name,
    :source,
    :text
  ]

  @doc """
  Given data Tweet returned by the Twitter web API, returns
  a valid `%Twitter.Tweet{}`.
  """
  def from_api(data) do
    %Tweet{
      created_at: data["created_at"],
      id: data["id"],
      profile_image: data["user"]["profile_image_url_https"],
      screen_name: data["user"]["screen_name"],
      source: data["source"],
      text: data["text"]
    }
  end
end
