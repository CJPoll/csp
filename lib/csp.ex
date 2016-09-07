defmodule CSP.Writer do
  use CSP.Process

  def init(channel) do
    {:ok, channel}
  end

  def run(channel) do
    CSP.Channel.write(channel, "Hello world!")

    IO.inspect("write complete")
  end
end

defmodule CSP.Reader do
  use CSP.Process

  def init(channel) do
    {:ok, channel}
  end

  def run(channel) do
    message = CSP.Channel.read(channel)

    IO.inspect("Read: #{inspect message}")
  end
end
