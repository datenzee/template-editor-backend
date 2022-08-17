defmodule Dsw.Service.Expansion.Service do
  alias Dsw.Database.Repo
  alias Dsw.Model.TemplateEditor
  alias Dsw.Model.Expansion
  alias Dsw.Model.PersistentCommand
  alias Dsw.Model.PersistentWorkflow
  alias DswWeb.Dto.Page
  alias Dsw.Database.PersistentCommand.Notification
  alias Dsw.Integration.ExpanderClient
  import Ecto.Query
  import Dsw.Service.TemplateEditor.Service
  require Logger

  def get_expansions(template_editor_id, query_params) do
    page =
      Expansion
      |> where([e], e.template_editor_id == ^template_editor_id)
      |> Repo.paginate(query_params)

    %Page{
      entries: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_entries: page.total_entries,
      total_pages: page.total_pages
    }
  end

  def expand(id, req_body) do
    editor = get_template_editor(id)

    created_by = Process.get(:user)["uuid"]
    app_uuid = Process.get(:app_uuid)

    url =
      ExpanderClient.client()
      |> ExpanderClient.expand(editor.id, req_body["rdf"], "vue")

    create_expansion(editor, req_body["rdf"], url, created_by, app_uuid)

    update_template_editor(editor.id, %{url: url})

    %{url: url}

    #    ---------------------------------------------
    #    We will not use commands for now
    #    ---------------------------------------------
    #    expand_command = create_expand_command(expansion, created_by, app_uuid)
    #    deploy_command = create_deploy_command(expansion, created_by, app_uuid)
    #    workflow = create_workflow(expand_command, deploy_command, created_by, app_uuid)
    #    Notification.notify(expand_command)
    #    workflow
    #    ---------------------------------------------
  end

  defp create_expansion(editor, rdf, url, created_by, app_uuid) do
    expansion =
      Expansion.changeset(
        %Expansion{
          content: rdf,
          path: url,
          state: :Done,
          created_by: created_by,
          app_uuid: app_uuid,
          template_editor_id: editor.id
        },
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

    Repo.insert!(expand_command)
    |> Repo.preload(:persistent_workflow)
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

    Repo.insert!(deploy_command)
    |> Repo.preload(:persistent_workflow)
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

    Repo.insert!(workflow)
    |> Repo.preload(:commands)
  end
end
