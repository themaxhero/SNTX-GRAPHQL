defmodule SntxGraph.PostQueries do
  use Absinthe.Schema.Notation

  alias SntxGraph.Middleware.Authorize
  alias SntxGraph.PostResolver

  object :post_queries do
    field :post, :post do
      arg :id, :uuid4

      resolve(&PostResolver.get/2)
    end

    field :all_posts, list_of(:post) do
      resolve(&PostResolver.get_all/2)
    end
  end
end
