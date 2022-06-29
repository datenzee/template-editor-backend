defmodule DswWeb.Plug.Jwt do
  require Plug.Conn
  require Logger
  alias Dsw.Integration.DswClient
  alias Dsw.Model.Exception.ForbiddenException

  def init(opts), do: opts

  def call(conn, _opts) do
    token = extract_token(conn)
    Plug.Conn.assign(conn, :token, token)

    user =
      DswClient.client(token)
      |> DswClient.get_users_current()

    # TODO Get app_uuid dynamically
    app_uuid = "00000000-0000-0000-0000-000000000000"

    Logger.metadata(identity: user["uuid"], app: app_uuid)

    Process.put(:user, user)
    Process.put(:app_uuid, app_uuid)

    conn
  end

  defp extract_token(conn) do
    header = Plug.Conn.get_req_header(conn, "authorization")

    if header == [] do
      raise ForbiddenException, "No token"
    else
      header
      |> List.first()
      |> String.replace("Bearer", "")
      |> String.replace(" ", "")
    end
  end
end
