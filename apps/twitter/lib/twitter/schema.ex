defmodule Twitter.Schema do
  use Absinthe.Schema

  alias Twitter.Collector

  @desc "A Tweet retrieved from the Twitter web API"
  object :tweet do
    field(:created_at, :string)
    field(:id, :string)
    field(:profile_image, :string)
    field(:screen_name, :string)
    field(:source, :string)
    field(:text, :string)
  end

  query do
    @desc "Get recent `Tweets`"
    field :tweets, list_of(:tweet) do
      resolve(fn _, _, _ -> {:ok, Collector.list()} end)
    end
  end
end
