defmodule Dsw.Integration.ExpanderClient do
  use Tesla
  require Logger
  alias Dsw.Model.Exception.InternalServerErrorException

  def expand(client, template_editor_id, content, root_component, expander_type, data_url) do
    request_body = %{
      template_editor_id: template_editor_id,
      content: content,
      root_component: root_component,
      expander_type: expander_type,
      template_id: data_url
    }

    case post(client, "/expand", request_body) do
      {:ok, response} ->
        if response.status == 200 do
          Logger.info(response)
          response.body["url"]
        else
          Logger.info(response)
          raise InternalServerErrorException, "Can't get response from expander server"
#          "http://localhost:222/sss"
        end
    end
  end

  def client() do
    middleware = [
      {Tesla.Middleware.BaseUrl, "http://expander_server:5000"},
#      {Tesla.Middleware.BaseUrl, "https://mockserver.ds-wizard.org/"},
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware)
  end
end
