defmodule Dsw.Kaffy.Core.Config do
  def create_resources(_conn) do
    [
      dsw: [
        name: "Dsw",
        resources: [
          persistentCommand: [
            schema: Dsw.Model.PersistentCommand,
            admin: Dsw.Admin.PersistentCommand
          ],
          persistentWorkflow: [
            schema: Dsw.Model.PersistentWorkflow,
            admin: Dsw.Admin.PersistentWorkflow
          ],
          templateEditor: [schema: Dsw.Model.TemplateEditor, admin: Dsw.Admin.TemplateEditor],
          user: [schema: Dsw.Model.User, admin: Dsw.Admin.User]
        ]
      ]
    ]
  end
end
