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

    # TODO Change to app_uuid
    Logger.metadata(identity: user["uuid"], app: user["uuid"])

    Process.put(:user, user)

    Plug.Conn.assign(conn, :user, user)
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
