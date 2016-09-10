defmodule Docs.BookingController do
  use Docs.Web, :controller

  alias Docs.Booking

  def index(conn, _params) do
    bookings = Repo.all(Booking)
    render(conn, "index.html", bookings: bookings)
  end

  def new(conn, _params) do
    changeset = Booking.changeset(%Booking{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"booking" => booking_params}) do
    changeset = Booking.changeset(%Booking{}, booking_params)

    case Repo.insert(changeset) do
      {:ok, _booking} ->
        conn
        |> put_flash(:info, "Booking created successfully.")
        |> redirect(to: booking_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    booking = Repo.get!(Booking, id)
    render(conn, "show.html", booking: booking)
  end

  def edit(conn, %{"id" => id}) do
    booking = Repo.get!(Booking, id)
    changeset = Booking.changeset(booking)
    render(conn, "edit.html", booking: booking, changeset: changeset)
  end

  def update(conn, %{"id" => id, "booking" => booking_params}) do
    booking = Repo.get!(Booking, id)
    changeset = Booking.changeset(booking, booking_params)

    case Repo.update(changeset) do
      {:ok, booking} ->
        conn
        |> put_flash(:info, "Booking updated successfully.")
        |> redirect(to: booking_path(conn, :show, booking))
      {:error, changeset} ->
        render(conn, "edit.html", booking: booking, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    booking = Repo.get!(Booking, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(booking)

    conn
    |> put_flash(:info, "Booking deleted successfully.")
    |> redirect(to: booking_path(conn, :index))
  end
end
