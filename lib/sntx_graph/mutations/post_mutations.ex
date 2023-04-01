defmodule SntxGraph.PostMutations do
  use Absinthe.Schema.Notation

  alias SntxGraph.Middleware.Authorize
  alias SntxGraph.PostResolver
  import_types SntxGraph.PostTypes

  object :post_mutations do
    field :post_create, :post do
      middleware(Authorize)
      arg :input, non_null(:post_create_payload)

      resolve(&PostResolver.create/2)
    end

    field :post_edit, :post do
      middleware(Authorize)
      arg :input, non_null(:post_update_payload)

      resolve(&PostResolver.edit/2)
    end

    field :post_delete, :post do
      middleware(Authorize)
      arg :input, non_null(:post_delete_payload)

      resolve(&PostResolver.delete/2)
    end
  end
end
