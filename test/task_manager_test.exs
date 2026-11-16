defmodule TaskManagerTest do
  use ExUnit.Case
  doctest TaskManager

  test "greets the world" do
    assert TaskManager.hello() == :world
  end

  # 各テストで使う初期データ（id 1, 2 のタスクが未完了で入っている）
  setup do
    tasks =
      %{}
      |> TaskManager.add(1, "LPIC")
      |> TaskManager.add(2, "Elixir")

    %{tasks: tasks}
  end

  describe "add/3" do
    test "空のMapにタスクを追加できる" do
      assert TaskManager.add(%{}, 1, "LPIC") == %{
               1 => %{id: 1, title: "LPIC", completed: false}
             }
    end

    test "既存のタスクを残したまま追加できる", %{tasks: tasks} do
      tasks = TaskManager.add(tasks, 3, "AWS")

      assert map_size(tasks) == 3
      assert tasks[3] == %{id: 3, title: "AWS", completed: false}
      assert tasks[1].title == "LPIC"
    end

    test "同じIDで追加すると上書きされる", %{tasks: tasks} do
      tasks = TaskManager.add(tasks, 1, "LPIC Level2")

      assert map_size(tasks) == 2
      assert tasks[1].title == "LPIC Level2"
    end
  end

  describe "complete/2" do
    test "指定したIDのタスクを完了にする", %{tasks: tasks} do
      assert {:ok, updated} = TaskManager.complete(tasks, 1)

      assert updated[1].completed == true
      # 他のタスクには影響しない
      assert updated[2].completed == false
    end

    test "元のMapは変更されない（イミュータブル）", %{tasks: tasks} do
      {:ok, _updated} = TaskManager.complete(tasks, 1)

      assert tasks[1].completed == false
    end

    test "存在しないIDは {:error, :not_found}", %{tasks: tasks} do
      assert TaskManager.complete(tasks, 999) == {:error, :not_found}
    end

    test "完了済みのタスクは {:error, :already_completed}", %{tasks: tasks} do
      {:ok, tasks} = TaskManager.complete(tasks, 1)

      assert TaskManager.complete(tasks, 1) == {:error, :already_completed}
    end
  end

  describe "list_completed/1" do
    test "完了済みが無ければ空のMap", %{tasks: tasks} do
      assert TaskManager.list_completed(tasks) == %{}
    end

    test "完了済みのタスクだけをMapで返す", %{tasks: tasks} do
      {:ok, tasks} = TaskManager.complete(tasks, 1)

      assert TaskManager.list_completed(tasks) == %{
               1 => %{id: 1, title: "LPIC", completed: true}
             }
    end

    test "空のMapなら空のMap" do
      assert TaskManager.list_completed(%{}) == %{}
    end

    test "複数の完了済みタスクだけ取得できる" do
      tasks =
        %{}
        |> TaskManager.add(1, "LPIC")
        |> TaskManager.add(2, "Elixir")
        |> TaskManager.add(3, "Kubernetes")

      {:ok, tasks} = TaskManager.complete(tasks, 1)
      {:ok, tasks} = TaskManager.complete(tasks, 3)

      completed = TaskManager.list_completed(tasks)

      assert map_size(completed) == 2
      assert Map.has_key?(completed, 1)
      assert Map.has_key?(completed, 3)
      refute Map.has_key?(completed, 2)
    end
  end
end
