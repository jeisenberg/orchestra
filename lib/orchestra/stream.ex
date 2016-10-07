defmodule Orchestra.Stream do
  alias Porcelain.Process, as: Proc
  alias Porcelain.Result

  @doc"""
  Runs docker-compose up
  passes all messages from the stdout of docker-compose up to the
  callback function
  """

  def up(recv_module, recv_function, opts \\ []) do
    cmd = Orchestra.Command.up(opts)
    {out, status} = System.cmd(System.get_env("SHELL"), ["-c", cmd], [stderr_to_stdout: true, into: IO.stream(:stdio, :line)])
    apply(recv_module, recv_function, out)
  end
  def up(opts \\ []) do
    cmd = Orchestra.Command.up(opts)
    {out, status} = System.cmd(System.get_env("SHELL"), ["-c", cmd], [stderr_to_stdout: true, into: IO.stream(:stdio, :line)])
    for line <- out do
      IO.inspect line
    end
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
