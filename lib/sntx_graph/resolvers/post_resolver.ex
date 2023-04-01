defmodule SntxGraph.PostResolver do
  alias Sntx.Repo
  alias Sntx.Posts.Post

  def create(%{input: input}, %{context: %{user: user}}) do
    args = Map.put(input, :author, user)

    case Post.create(args) do
      {:ok, post} ->
        {:ok, post}

      error ->
        error
    end
  end

  def create(_, _),
    do: {:error, :unauthorized}

  def edit(%{input: %{id: id, params: params}}, %{context: ctx}) do
    author_id = ctx.user.id

    case Post.get(id) do
      {:ok, %Post{author: %{id: ^author_id}} = post} ->
        Post.update(post, params)

      {:ok, _post} ->
        {:error, :unauthorized}

      error ->
        error
    end
  end

  def edit(_, _),
    do: {:error, :unauthorized}

  def delete(%{input: %{id: id}}, %{context: ctx}) do
    author_id = ctx.user.id

    case Post.get(id) do
      {:ok, %Post{author: %{id: ^author_id}} = post} ->
        Post.delete(post)

      {:ok, _post} ->
        {:error, :unauthorized}

      error ->
        error
    end
  end

  def delete(_, _),
    do: {:error, :unauthoried}

  def get(%{id: id}, _), do: Post.get(id)
  def get_all(_, _), do: {:ok, Repo.all(Post)}
end
