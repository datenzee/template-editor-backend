defmodule Dsw.Admin.PersistentCommand do
  def index(_) do
    [
      id: nil,
      state: nil,
      component: nil,
      function: nil,
      attempts: nil,
      body: nil,
      last_error_message: nil,
      max_attempts: nil,
      created_by: nil,
      inserted_at: nil
    ]
  end
end
