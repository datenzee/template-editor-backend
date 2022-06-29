defmodule Dsw.Service.TemplateEditor.Service do
  alias Dsw.Database.Repo
  alias Dsw.Model.TemplateEditor
  alias Dsw.Model.Expansion
  alias Dsw.Model.PersistentCommand
  alias Dsw.Model.PersistentWorkflow
  alias DswWeb.Dto.Page
  alias Dsw.Database.PersistentCommand.Notification
  require Logger

  def get_template_editors(query_params) do
    editor_page =
      TemplateEditor
      |> Repo.paginate(query_params)

    %Page{
      entries: editor_page.entries,
      page_number: editor_page.page_number,
      page_size: editor_page.page_size,
      total_entries: editor_page.total_entries,
      total_pages: editor_page.total_pages
    }
  end

  def create_template_editor(req_body) do
    created_by = Process.get(:user)["uuid"]
    app_uuid = Process.get(:app_uuid)

    editor =
      TemplateEditor.changeset(
        %TemplateEditor{created_by: created_by, app_uuid: app_uuid},
        req_body
      )

    Repo.insert!(editor)
  end

  def get_template_editor(id) do
    Repo.get!(Dsw.Model.TemplateEditor, id)
  end

  def update_template_editor(id, req_body) do
    editor = get_template_editor(id)

    updatedEditor =
      TemplateEditor.changeset(
        editor,
        req_body
      )

    Repo.update!(updatedEditor)
  end

  def delete_template_editor(id) do
    editor = get_template_editor(id)

    Repo.delete!(editor)
  end

end
