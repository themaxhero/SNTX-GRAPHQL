defmodule Sntx.Repo.Migrations.AddPostsTable do
  use Ecto.Migration

  def change do
    create table("posts", primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :title, :string, size: 40
      add :body, :string, size: 1024
      add :author_id, references(:user_accounts, type: :binary_id)

      timestamps()
    end
  end
end
