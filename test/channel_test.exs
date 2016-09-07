defmodule CSP.Channel.Test do
  use ExUnit.Case

  setup do
    channel = CSP.Channel.create
    {:ok, %{channel: channel}}
  end

  describe "create" do
    test "creates a new channel" do
      assert %CSP.Channel{} = CSP.Channel.create
    end
  end

  describe "write" do
    test "adds the value and writing process to the queue" do
      value = 1
      empty_queue = :queue.new
      expected_queue = :queue.in({value, self}, empty_queue)

      assert {:noreply, ^expected_queue} =
      CSP.Channel.handle_call({:write, value}, {self, :tag}, empty_queue)
    end
  end

  describe "read" do
    test ""
  end
end
