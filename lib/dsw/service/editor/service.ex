defmodule Dsw.Service.Editor.Service do
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
    # TODO Change to app_uuid
    app_uuid = Process.get(:user)["uuid"]

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

  def expand_and_publish(id, req_body) do
    editor = get_template_editor(id)

    created_by = Process.get(:user)["uuid"]
    # TODO Change to app_uuid
    app_uuid = Process.get(:user)["uuid"]

    expansion = create_expansion(req_body["rdf"], created_by, app_uuid)
    expand_command = create_expand_command(expansion, created_by, app_uuid)
    deploy_command = create_deploy_command(expansion, created_by, app_uuid)
    workflow = create_workflow(expand_command, deploy_command, created_by, app_uuid)
    Notification.notify(expand_command)
    workflow
  end

  defp create_expansion(rdf, created_by, app_uuid) do
    expansion =
      Expansion.changeset(
        %Expansion{content: rdf, created_by: created_by, app_uuid: app_uuid},
        %{}
      )

    Repo.insert!(expansion)
  end

  defp create_expand_command(expansion, created_by, app_uuid) do
    expand_command =
      PersistentCommand.changeset(
        %PersistentCommand{
          component: "web_app_expander",
          function: "expand",
          body: "#{expansion.id}",
          created_by: created_by,
          app_uuid: app_uuid
        },
        %{}
      )

    Repo.insert!(expand_command) |> Repo.preload(:persistent_workflow)
  end

  defp create_deploy_command(expansion, created_by, app_uuid) do
    deploy_command =
      PersistentCommand.changeset(
        %PersistentCommand{
          component: "web_app_expander",
          function: "expand",
          body: "#{expansion.id}",
          created_by: created_by,
          app_uuid: app_uuid
        },
        %{}
      )

    Repo.insert!(deploy_command) |> Repo.preload(:persistent_workflow)
  end

  defp create_workflow(expand_command, deploy_command, created_by, app_uuid) do
    workflow =
      PersistentWorkflow.changeset(
        %PersistentWorkflow{
          name: "Expand Web App",
          command_ids: [expand_command.id, deploy_command.id],
          commands: [expand_command, deploy_command],
          created_by: created_by,
          app_uuid: app_uuid
        },
        %{}
      )

    Repo.insert!(workflow) |> Repo.preload(:commands)
  end
end
