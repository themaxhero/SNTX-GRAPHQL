defmodule SntxGraph.PostTypes do
  use Absinthe.Schema.Notation

  import AbsintheErrorPayload.Payload

  import_types SntxGraph.UserTypes, only: [:user_public_account]

  object(:post_create_payload) do
    field :title, non_null(:string)
    field :body, non_null(:string)
  end

  object(:post_update_params) do
    field :title, :string
    field :body, :string
  end

  object(:post_delete_payload) do
    field :id, :uuid4
  end

  object(:post_update_payload) do
    field :id, :uuid4
    field :params, :post_update_params
  end

  object(:post) do
    field :id, :uuid4
    field :title, non_null(:string)
    field :body, non_null(:string)
    field :author, non_null(:user_public_account)
  end
end
