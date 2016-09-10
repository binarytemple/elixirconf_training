defmodule Docs.Repo.Migrations.CreateBooking do
  use Ecto.Migration

  def change do
    create table(:bookings) do
      add :title, :string
      add :body, :string
      add :start, :datetime
      add :end, :datetime
      timestamps()
    end

  end
end
