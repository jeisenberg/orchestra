defmodule Orchestra.Stream do
  alias Porcelain.Process, as: Proc
  alias Porcelain.Result

  @doc"""
  Runs docker-compose up
  passes all messages from the stdout of docker-compose up to the
  callback function
  """

  def up(recv_module, recv_function, opts \\ []) do
    %Proc{pid: pid} = Orchestra.Command.up(opts)
    |> Porcelain.spawn_shell(in: :receive, out: {:send, self()})
    receive do
      {^pid, :data, :out, data} -> apply(recv_module, recv_function, data)
    end
    receive do
      {^pid, :result, %Result{status: status}} -> IO.inspect status   #=> 0
    end
  end
  def up(opts \\ []) do
    %Proc{out: outstream, pid: pid} = Orchestra.Command.up(opts)
    |> Porcelain.spawn_shell(in: :receive, out: :stream)
    Enum.into(outstream, IO.stream(:stdio, :line))
    {:ok, pid}
  end

  @doc"""
  Runs docker-compose build
  passes all messages from the stdout of docker-compose up to the
  callback function
  """
  def build(recv_module, recv_function, opts \\ []) do
    %Proc{pid: pid} = Orchestra.Command.build(opts)
    |> Porcelain.spawn_shell(in: :receive, out: {:send, self()})
    receive do
      {^pid, :data, :out, data} -> apply(recv_module, recv_function, data)
    end
  end
  def build(opts \\ []) do
    %Proc{out: outstream, pid: pid} = Orchestra.Command.build(opts)
    |> Porcelain.spawn_shell(in: :receive, out: :stream)
    Enum.into(outstream, IO.stream(:stdio, :line))
    {:ok, pid}
  end

end
