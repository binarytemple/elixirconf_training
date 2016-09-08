defmodule Docs.DocumentController do
  use Docs.Web, :controller

  alias Docs.Document

  plug :scrub_params, "document" when action in [:create, :update]

  def index(conn, %{"search" => %{"q" => search_string}}) do
    documents = Repo.all(
      from d in Document,
        where: ilike(d.title,   ^"%#{search_string}%")
               or ilike(d.author, ^"%#{search_string}%")
               or ilike(d.body,   ^"%#{search_string}%"),
        order_by: [asc: d.title]
    )

    conn
    |> put_flash(:info, "Showing #{length(documents)} document(s) for \"#{search_string}\"")
    |> render("index.html", documents: documents)
  end
  def index(conn, _params) do
    documents = Repo.all(from d in Document, where: d.is_deleted == false)
    render(conn, "index.html", documents: documents)
  end

  def new(conn, _params) do
    changeset = Document.changeset(%Document{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"document" => document_params}) do
    changeset = Document.changeset(%Document{}, document_params)

    case Repo.insert(changeset) do
      {:ok, _document} ->
        conn
        |> put_flash(:info, "Document created successfully.")
        |> redirect(to: document_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    document = Repo.get!(Document, id)
    render(conn, "show.html", document: document)
  end

  def edit(conn, %{"id" => id}) do
    document = Repo.get!(Document, id)
    changeset = Document.changeset(document)
    render(conn, "edit.html", document: document, changeset: changeset)
  end

  def update(conn, %{"id" => id, "document" => document_params}) do
    document = Repo.get!(Document, id)
    changeset = Document.changeset(document, document_params)

    case Repo.update(changeset) do
      {:ok, document} ->
        conn
        |> put_flash(:info, "Document updated successfully.")
        |> redirect(to: document_path(conn, :show, document))
      {:error, changeset} ->
        render(conn, "edit.html", document: document, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    case Repo.update(Document.changeset(Docs.Repo.get(Document,id),%{is_deleted: true} ) )
      do
      {:ok, document} ->
        conn
        |> put_flash(:info, "Document deleted successfully.")
        |> redirect(to: document_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:info, "Document failed deletion.")
        |> redirect(to: document_path(conn, :index))
    end
  end
end
