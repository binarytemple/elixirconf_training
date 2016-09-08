defmodule Docs.Repo.Migrations.AddDeletedFlagToDocuments do
  use Ecto.Migration

  def change do

    # ALTER TABLE public.documents ADD deleted BOOL DEFAULT FALSE  NULL;
    # CREATE INDEX documents_deleted_index ON public.documents (deleted)

    alter table(:documents) do
      add :is_deleted, :boolean , [default: false]
    end

    create index(:documents, [:is_deleted])

  end
end
