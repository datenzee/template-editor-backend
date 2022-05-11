defmodule Dsw.Admin.PersistentWorkflow do
  def index(_) do
    [
      id: nil,
      state: nil,
      name: nil,
      command_ids: nil,
      created_by: nil,
      app_uuid: nil,
      inserted_at: nil
    ]
  end
end
