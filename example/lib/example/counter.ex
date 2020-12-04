defmodule Example.Counter do
  use GenServer

  @vsn 1

  def start_link(count) do
    GenServer.start_link(__MODULE__, count, name: __MODULE__)
  end

  def init(count) do
    {:ok, count}
  end

  def handle_call(:increment, _from, count) do
    {:reply, count + 2, count + 2}
  end

  def code_change(_old_vsn, count, _extra) do
    {:ok, count}
  end
end
