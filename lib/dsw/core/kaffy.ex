defmodule Dsw.Kaffy.Core.Config do
  def create_resources(_conn) do
    [
      dsw: [
        name: "Dsw",
        resources: [
          expansion: [
            schema: Dsw.Model.Expansion,
            admin: Dsw.Admin.Expansion
          ],
          persistent_command: [
            schema: Dsw.Model.PersistentCommand,
            admin: Dsw.Admin.PersistentCommand
          ],
          persistent_workflow: [
            schema: Dsw.Model.PersistentWorkflow,
            admin: Dsw.Admin.PersistentWorkflow
          ],
          template_editor: [schema: Dsw.Model.TemplateEditor, admin: Dsw.Admin.TemplateEditor],
          user: [schema: Dsw.Model.User, admin: Dsw.Admin.User]
        ]
      ]
    ]
  end
end
