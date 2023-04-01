defmodule Sntx.Posts.Post do
  use Sntx.Schema

  import Ecto.Changeset
  import SntxWeb.Gettext

  alias __MODULE__, as: Post
  alias Sntx.Repo
  alias Sntx.User.Account

  @cast_params ~w[title body]a
  @required_params ~w[title body]a

  schema "posts" do
    field :title, :string
    field :body, :string
    belongs_to :author, Account

    timestamps()
  end

  @doc false
  def create_changeset(attrs) do
    %Post{}
    |> cast(attrs, @cast_params)
    |> put_assoc(:author, attrs[:author])
    |> validate_required(@required_params)
  end

  def update_changeset(%Post{} = post \\ %Post{}, attrs) do
    post
    |> cast(attrs, @cast_params)
    |> validate_required(@required_params)
  end

  def get(id) do
    Post
    |> Repo.get(id)
    |> Repo.preload(:author)
    |> case do
      nil -> {:error, dgettext("global", "Post not found")}
      post -> {:ok, post}
    end
  end

  def create(attrs) do
    attrs
    |> create_changeset()
    |> Repo.insert()
  end

  def update(post, attrs) do
    post
    |> update_changeset(attrs)
    |> Repo.update()
  end

  def delete(post), do: Repo.delete(post)
end
