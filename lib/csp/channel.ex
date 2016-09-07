defmodule CSP.Channel do
  use GenServer
  defstruct [:pid]

  defmodule State do
    defstruct readers: :queue.new, writers: :queue.new
  end

  def create do
    {:ok, pid} = GenServer.start(__MODULE__, [])
    %__MODULE__{pid: pid}
  end

  def write(%__MODULE__{pid: channel}, value) do
    GenServer.call(channel, {:write, value}, :infinity)
  end

  def read(%__MODULE__{pid: channel}) do
    GenServer.call(channel, :read, :infinity)
  end

  def init(_arg) do
    {:ok, %State{} |> IO.inspect}
  end

  def handle_call({:write, value}, from,
  %State{readers: {[], []}, writers: writers} = state) do
    writers = :queue.in({value, from}, writers)
    state = %{state | writers: writers} |> IO.inspect
    {:noreply, state}
  end

  def handle_call({:write, value}, _from,
  %State{readers: readers} = state) do
    {{:value, reader}, readers} = :queue.out(readers)
    GenServer.reply(reader, value)
    state = %{state | readers: readers} |> IO.inspect
    {:reply, :ok, state}
  end

  def handle_call(:read, from, %State{readers: readers, writers: {[], []}} = state) do
    readers = :queue.in(from, readers)
    state = %{state | readers: readers} |> IO.inspect
    {:noreply, state}
  end

  def handle_call(:read, _from, %State{writers: writers} = state) do
    {{:value, {value, from}}, writers} = :queue.out(writers)
    GenServer.reply(from, :ok)
    state = %{state | writers: writers} |> IO.inspect
    {:reply, value, state}
  end
end
