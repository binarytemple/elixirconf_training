defmodule Docs.BookingTest do
  use Docs.ModelCase

  alias Docs.Booking

  @valid_attrs %{body: "some content", end: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, start: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Booking.changeset(%Booking{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Booking.changeset(%Booking{}, @invalid_attrs)
    refute changeset.valid?
  end
end
