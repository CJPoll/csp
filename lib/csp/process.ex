defmodule CSP.Process do
  defmacro __using__(_arg) do
    quote do
      @behaviour CSP.Process

      require CSP.Process
      import CSP.Process

      def start(arg \\ []) do
        CSP.Process.start(__MODULE__, arg)
      end
    end
  end

  @typep ignored :: term
  @type state    :: term

  @callback init(term) :: {:ok, state}
  @callback run(state) :: ignored

  def start(module, arg) do
    spawn(fn ->
      {:ok, state} = apply(module, :init, [arg])
      apply(module, :run, [state])
    end)
  end

  def kill(process, reason \\ :normal) do
    Process.exit(process, reason)
  end
end
