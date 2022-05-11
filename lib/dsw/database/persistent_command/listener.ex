defmodule Dsw.Database.PersistentCommand.Listener do
  use GenServer
  alias Dsw.Model.PersistentCommand
  alias Dsw.Model.PersistentWorkflow
  alias Dsw.Database.Repo
  require Logger

  @event_name "persistent_command_changed_channel"

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  def start_link(opts \\ []),
    do: GenServer.start_link(__MODULE__, opts)

  def init(opts) do
    with {:ok, _pid, _ref} <- Repo.listen(@event_name) do
      {:ok, opts}
    else
      error -> {:stop, error}
    end
  end

  def handle_info({:notification, _pid, _ref, @event_name, payload}, _state) do
    Logger.info(payload)
    [workflow_id, command_id, command_state] = String.split(payload, ";")
    {workflow_id, _} = Integer.parse(workflow_id)
    {command_id, _} = Integer.parse(command_id)

    if workflow_id != -1 do
      if command_state == "Done" do
        Logger.info(
          "Command '#{command_id}' move to state '#{:Done}'. We should run next command"
        )

        workflow = Repo.get!(PersistentWorkflow, workflow_id)
        Logger.info(workflow)
        index = Enum.find_index(workflow.command_ids, fn x -> x == command_id end)

        if index + 1 < Enum.count(workflow.command_ids) do
          command = Repo.get!(PersistentCommand, Enum.at(workflow.command_ids, index + 1))
          Repo.update!(PersistentCommand.changeset(command, %{state: :New}))
        end
      else
        Logger.info(
          "Command '#{command_id}' move to state #{command_state}. There is nothing to do"
        )
      end
    else
      Logger.debug("The command '#{command_id}' has no successors. There is nothing to do")
    end

    if payload != nil do
      {:noreply, :event_handled}
    else
      {:stop, "error", []}
    end
  end

  def handle_info(_, _state), do: {:noreply, :event_received}
end
