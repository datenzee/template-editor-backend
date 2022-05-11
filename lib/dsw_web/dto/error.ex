defmodule DswWeb.Dto.Error do
  defimpl Plug.Exception, for: Dsw.Model.Exception.ForbiddenException do
    def status(_exception), do: 403
    def actions(_exception), do: []
  end
end
