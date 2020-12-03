defmodule Device.Led do
  use GenServer
  require Logger
  alias Circuits.GPIO

  @led_pin Application.get_env(:device, :led_pin)

  def start_link(state \\ %{led: nil}) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    Logger.debug("Starting pin #{@led_pin} as output")
    {:ok, led} = GPIO.open(@led_pin, :output)
    {:ok, %{state | led: led}}
  end

  def handle_cast(:turn_on, state) do
    Logger.debug("Turning LED at #{@led_pin} ON")
    GPIO.write(state.led, 1)
    {:noreply, state}
  end

  def handle_cast(:turn_off, state) do
    Logger.debug("Turning LED at #{@led_pin} OFF")
    GPIO.write(state.led, 0)
    {:noreply, state}
  end

  def code_change(_old_vsn, state, _extra) do
    Logger.debug("Code changed!")
    {:ok, state}
  end
end
