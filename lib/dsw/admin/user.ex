defmodule Dsw.Admin.User do
  def is_active?(u) do
    if u.active, do: "✅", else: "❌"
  end

  def index(_) do
    [
      id: nil,
      first_name: nil,
      last_name: nil,
      email: nil,
      active: %{name: "Active?", value: fn user -> is_active?(user) end},
      last_visited_at: nil
    ]
  end
end
