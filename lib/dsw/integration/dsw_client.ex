defmodule Dsw.Integration.DswClient do
  use Tesla
  require Logger
  alias Dsw.Model.Exception.ForbiddenException

  def get_users_current(client) do
    case get(client, "/users/current") do
      {:ok, response} ->
        if response.status == 200 do
          response.body
        else
          raise ForbiddenException, "Invalid token"
        end
    end
  end

  def client(token) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.datenzee.ds-wizard.org"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"authorization", "Bearer " <> token}]}
    ]

    Tesla.client(middleware)
  end
end
