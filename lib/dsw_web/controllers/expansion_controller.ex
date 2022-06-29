defmodule DswWeb.ExpansionController do
  use DswWeb, :controller
  import Dsw.Service.Expansion.Service

  def list_GET(conn, _params) do
    res_dto = get_expansions(conn.path_params["id"], conn.query_params)
    json(conn, res_dto)
  end

  def expansions_POST(conn, _params) do
    res_dto = expand_and_publish(conn.path_params["id"], conn.body_params)
    json(conn, res_dto)
  end

end
