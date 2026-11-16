defmodule TaskManager do
  @moduledoc """
  Documentation for `TaskManager`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> TaskManager.hello()
      :world

  """
  def hello do
    :world
  end

  # タスクは%{id: 1, title: "LPIC", completed: false}の形式
  # 新しいタスクを追加したListを返す
  def add(tasks, id, title) do
    task = %{
      id: id,
      title: title,
      completed: false
    }

    Map.put(tasks, id, task)
  end

  # 指定したIDのタスクを完了状態にする
  def complete(tasks, id) do
    case Map.fetch(tasks, id) do
      {:ok, task} ->
        updated_task = %{task | completed: true}
        updated_tasks = Map.put(tasks, id, updated_task)
        {:ok, updated_tasks}

      # 存在しないIDはエラー
      :error ->
        {:error, :not_found}
    end
  end

  # 完了済みのタスクだけ返す
  def list_completed(tasks) do
    Map.filter(tasks, fn {_id, task} -> task.completed end)
  end
end
