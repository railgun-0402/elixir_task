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
  def add(tasks, title) do
    task = %{
      id: length(tasks) + 1,
      title: title,
      completed: false
    }

    tasks ++ [task]
  end

  # 指定したIDのタスクを完了状態にする
  def complete(tasks, id) do
    Enum.map(tasks, fn task ->
      if task.id == id do
        %{task | completed: true}
      else
        task
      end
    end)
  end

  # 完了済みのタスクだけ返す
  def list_completed(tasks) do
    completed_tasks =
      tasks
      |> Enum.filter(fn task -> task.completed end)
    completed_tasks
  end
end
