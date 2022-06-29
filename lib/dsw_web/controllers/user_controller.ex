defmodule DswWeb.UserController do
  use DswWeb, :controller
  require Dsw.Database.Repo
  require Dsw.Model.User
  require DswWeb.Dto.UserDto
  require Logger
  require Jason
  require Jason.Encoder

  def get_users(conn, _params) do
    users = Dsw.Database.Repo.all(Dsw.Model.User)
    json(conn, users)
  end
end
