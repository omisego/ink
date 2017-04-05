defmodule InkTest do
  use ExUnit.Case, async: false

  import ExUnit.CaptureIO

  setup do
    {:ok, %{timestamp: {{2017, 2, 1}, {4, 3, 2, 5123}}}}
  end

  test "it can be configured" do
    Logger.configure_backend(Ink, [test: :moep])
  end

  test "it logs a message", %{timestamp: timestamp} do
    msg = capture_io(fn ->
      Ink.log_message("test", :info, timestamp, [], %{level: :info})
    end)

    assert Poison.decode!(msg) == %{
      "timestamp" => "2017-02-01T04:03:02.005",
      "message" => "test"}
  end

  test "it includes metadata", %{timestamp: timestamp} do
    msg = capture_io(fn ->
      Ink.log_message("test", :info, timestamp, [moep: "hi"], %{level: :info})
    end)

    assert Poison.decode!(msg) == %{
      "timestamp" => "2017-02-01T04:03:02.005",
      "message" => "test",
      "moep" => "hi"}
  end

  test "respects log level", %{timestamp: timestamp} do
    msg = capture_io(fn ->
      Ink.log_message("test", :info, timestamp, [moep: "hi"], %{level: :warn})
    end)

    assert msg == ""
  end
end