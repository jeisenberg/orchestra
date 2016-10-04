defmodule OrchestraTest do
  use ExUnit.Case

  test "runs docker compose up" do
    {resp, pid} = Orchestra.Stream.up([f: "test/docker/compose.yml"])
    assert resp == :ok
  end
end
