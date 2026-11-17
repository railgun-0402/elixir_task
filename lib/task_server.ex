defmodule TaskServer do
  use GenServer

  # Client API
  def start_link do
    # __MODULE__は現在のモジュールを表し、プロセスを初期化
    GenServer.start_link(__MODULE__, %{}) # 空のMapを作成する
  end

  # Server Callback
  @impl true
  def init(initial_state) do
    {:ok, initial_state}
  end

  # Client add
  def add(pid, id, title) do
    GenServer.call(pid, {:add, id, title})
  end

  # Client complete
  def complete(pid, id) do
    GenServer.call(pid, {:complete, id})
  end

  # Client list_completed
  def list_completed(pid) do
    GenServer.call(pid, :list_completed)
  end

  # Server add
  @impl true
  def handle_call({:add, id, title}, _from, state) do
      # ① TaskManager.add(state, id, title) を呼ぶ
      new_state = TaskManager.add(state, id, title)
    # ③ クライアントに :ok を返す
    {:reply, :ok, new_state}
  end


  # Server complete
  @impl true
  def handle_call({:complete, id}, _from, state) do
    case TaskManager.complete(state, id) do
      {:ok, new_state} ->
        {:reply, :ok, new_state}

      {:error, reason} ->
        {:reply, {:error, reason}, state}
    end
  end

  @impl true
  def handle_call(:list_completed, _from, state) do
    {:reply, TaskManager.list_completed(state), state}
  end
end
