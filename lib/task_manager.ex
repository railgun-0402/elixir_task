defmodule TaskManager do
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
    with {:ok, task} <- Map.fetch(tasks, id),
        :ok <- ensure_not_completed(task) do
      updated_task = %{task | completed: true}
      {:ok, Map.put(tasks, id, updated_task)}
    else
      :error ->
        {:error, :not_found}

      {:error, reason} ->
        {:error, reason}
    end
  end

  # 完了済みのタスクだけ返す
  def list_completed(tasks) do
    Map.filter(tasks, fn {_id, task} -> task.completed end)
  end

  defp ensure_not_completed(%{completed: false}), do: :ok

  defp ensure_not_completed(%{completed: true}) do
    {:error, :already_completed}
  end

end
