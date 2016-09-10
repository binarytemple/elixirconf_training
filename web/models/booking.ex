defmodule Docs.Booking do
  use Docs.Web, :model

  schema "bookings" do
    field :title, :string
    field :body, :string
    field :start, Ecto.DateTime
    field :end, Ecto.DateTime

    field :date_start, :string, virtual: true
    field :date_end, :string, virtual: true

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body, :start, :end])
    |> validate_required([:title, :body, :start, :end])
  end
end
