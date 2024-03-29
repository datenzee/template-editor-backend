defmodule Dsw.Database.Repo do
  use Ecto.Repo,
    otp_app: :dsw,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 20
  alias Postgrex.Notifications

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :supervisor
    }
  end

  def init(_, opts), do: {:ok, opts}

  def listen(event_name) do
    with {:ok, pid} <- Notifications.start_link(__MODULE__.config()),
         {:ok, ref} <- Notifications.listen(pid, event_name) do
      {:ok, pid, ref}
    end
  end
end
