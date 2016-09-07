defmodule CSP.Process.Test do
  use ExUnit.Case

  defmodule Test1 do
    use CSP.Process

    def init(_arg) do
      {:ok, {}}
    end

    def run({}) do
      run({})
    end
  end

  test "can create a process" do
    process = CSP.Process.start(Test1, %{})
    assert Process.alive?(process)
  end
end
