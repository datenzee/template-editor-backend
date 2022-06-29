defmodule DswWeb.TemplateEditorController do
  use DswWeb, :controller
  import Dsw.Service.TemplateEditor.Service

  def list_GET(conn, _params) do
    res_dto = get_template_editors(conn.query_params)
    json(conn, res_dto)
  end

  def list_POST(conn, _params) do
    res_dto = create_template_editor(conn.body_params)
    json(conn, res_dto)
  end

  def detail_GET(conn, _params) do
    res_dto = get_template_editor(conn.path_params["id"])
    json(conn, res_dto)
  end

  def detail_PUT(conn, _params) do
    res_dto = update_template_editor(conn.path_params["id"], conn.body_params)
    json(conn, res_dto)
  end

  def detail_DELETE(conn, _params) do
    delete_template_editor(conn.path_params["id"])
    send_resp(conn, :no_content, [])
  end

end
