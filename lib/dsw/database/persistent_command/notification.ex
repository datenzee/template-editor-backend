defmodule Dsw.Database.PersistentCommand.Notification do
  require Ecto.Adapters.SQL
  require Dsw.Database.Repo

  def notify(command) do
    sql = "NOTIFY persistent_command_channel__#{command.component}, '#{command.id}'"
    Ecto.Adapters.SQL.query!(Dsw.Database.Repo, sql, [])
  end
end
