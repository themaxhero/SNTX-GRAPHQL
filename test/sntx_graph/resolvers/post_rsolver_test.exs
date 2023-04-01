defmodule SntxGraph.Resolvers.PostResolverTest do
  use SntxWeb.ConnCase
  alias SntxGraph.PostResolver, as: Resolver

  alias Sntx.User.Account
  alias Sntx.Posts.Post

  setup do
    {:ok, creator} =
      Account.create(%{
        first_name: "Cleber",
        last_name: "Silva",
        password: "xpto1234",
        email: "cleber.silva@gmail.com"
      })

    {:ok, other} =
      Account.create(%{
        first_name: "Johnson",
        last_name: "Smith",
        password: "xpto1234",
        email: "smith@gmail.com"
      })

    {:ok, existing_post} =
      Post.create(%{
        title: "Pre-existing Post Title",
        body: "Pre-existing Post Body",
        author: creator
      })

    [
      creator: creator,
      other: other,
      existing_post: existing_post
    ]
  end

  describe "create/2" do
    test "can create a post", %{creator: user} do
      input = %{
        title: "Post Title",
        body: "Post Body"
      }

      assert {:ok, post} =
               Resolver.create(
                 %{input: input},
                 %{context: %{user: user}}
               )

      assert post.author_id == user.id
      assert post.title == input.title
      assert post.body == input.body
    end
  end

  describe "edit/2" do
    test "the author of the post can edit", %{existing_post: post, creator: user} do
      params = %{
        title: "Post updated title",
        body: "Post updated body"
      }

      assert {:ok, post} = Resolver.edit(%{input: %{id: post.id, params: params}}, %{context: %{user: user}})
      assert post.author_id == user.id
      assert post.title == params.title
      assert post.body == params.body
    end

    test "other users can't edit the post", %{existing_post: post, other: user} do
      params = %{
        title: "Post updated title",
        body: "Post updated body"
      }

      assert {:error, :unauthorized} =
               Resolver.edit(%{input: %{id: post.id, params: params}}, %{context: %{user: user}})
    end
  end

  describe "delete/2" do
    test "author of the post can delete the post", %{existing_post: post, creator: user} do
      assert {:ok, %Post{}} = Resolver.delete(%{input: %{id: post.id}}, %{context: %{user: user}})
    end

    test "other users can't delete the post", %{existing_post: post, other: user} do
      assert {:error, :unauthorized} = Resolver.delete(%{input: %{id: post.id}}, %{context: %{user: user}})
    end
  end

  describe "get/2" do
    test "can get post", %{existing_post: post} do
      assert {:ok, %Post{}} = Resolver.get(%{id: post.id}, %{})
    end
  end

  describe "get_all/2" do
    test "can get all posts" do
      assert {:ok, [%Post{}]} = Resolver.get_all(%{}, %{})
    end
  end
end
