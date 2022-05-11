defmodule DswWeb.Dto.UserDto do
  require Jason.Encoder

  # @derive Jason.Encoder
  @derive {Jason.Encoder, except: [:name]}
  defstruct [:name, :age]
end
