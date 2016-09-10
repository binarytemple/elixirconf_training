defmodule Docs.MessageControllerTest do
  use Docs.ConnCase

  alias Docs.Message
  alias Docs.Document

  @valid_attrs %{body: "some content", username: "some content"}
  @invalid_attrs %{}

  setup do
    document = Repo.insert! %Document{author: "author", body: "some body", title: "some title"}
    {:ok, conn: build_conn, document_id: document.id }

  end

  test "lists all entries on index", %{conn: conn, document_id: document_id} do
    conn = get conn, document_message_path(conn, :index, document_id)
    assert html_response(conn, 200) =~ "Listing messages"
  end

  test "renders form for new resources", %{conn: conn, document_id: document_id} do
    conn = get conn, document_message_path(conn, :new, document_id)
    assert html_response(conn, 200) =~ "New message"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, document_id: document_id} do
    conn = post conn, document_message_path(conn, :create, document_id), message: @valid_attrs
    assert redirected_to(conn) == document_message_path(conn, :index, document_id)
    assert Repo.get_by(Message, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, document_id: document_id} do
    conn = post conn, document_message_path(conn, :create, document_id), message: @invalid_attrs
    assert html_response(conn, 200) =~ "New message"
  end

  test "shows chosen resource", %{conn: conn, document_id: document_id} do
    message = Repo.insert! %Message{document_id: document_id}
    conn = get conn, document_message_path(conn, :show, document_id, message.id)
    assert html_response(conn, 200) =~ "Show message"
  end

  test "renders page not found when id is nonexistent", %{conn: conn, document_id: document_id} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, document_message_path(conn, :show, document_id, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, document_id: document_id} do
    message = Repo.insert! %Message{}
    conn = get conn, document_message_path(conn, :edit, document_id, message)
    assert html_response(conn, 200) =~ "Edit message"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, document_id: document_id} do
    message = Repo.insert! %Message{}
    conn = put conn, document_message_path(conn, :update, document_id, message), message: @valid_attrs
    assert redirected_to(conn) == document_message_path(conn, :show, document_id, message)
    assert Repo.get_by(Message, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn,document_id: document_id} do
    message = Repo.insert! %Message{}
    conn = put conn, document_message_path(conn, :update, document_id, message), message: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit message"
  end

  test "deletes chosen resource", %{conn: conn,document_id: document_id} do
    message = Repo.insert! %Message{document_id: document_id}
    conn = delete conn, document_message_path(conn, :delete, document_id, message)
    assert redirected_to(conn) == document_message_path(conn, :index, document_id )
    refute Repo.get(Message, message.id)
  end
end
