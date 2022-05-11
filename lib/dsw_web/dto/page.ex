defmodule DswWeb.Dto.Page do
  require Jason.Encoder

  @derive Jason.Encoder
  defstruct [:entries, :page_number, :page_size, :total_entries, :total_pages]
end
