defmodule Auth.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:auth_users) do
      add(:email, :string)
      add(:password_hash, :string)

      timestamps()
    end

    create(unique_index(:auth_users, [:email]))
  end
end
