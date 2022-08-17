defmodule DswWeb.Dto.Error do
  defimpl Plug.Exception, for: Dsw.Model.Exception.ForbiddenException do
    def status(_exception), do: 403
    def actions(_exception), do: []
  end
  defimpl Plug.Exception, for: Dsw.Model.Exception.InternalServerErrorException do
    def status(_exception), do: 500
    def actions(_exception), do: []
  end
end
