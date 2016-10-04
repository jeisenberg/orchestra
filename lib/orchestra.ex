defmodule Orchestra do

  @doc"""
  checks if docker exists in shell and raises error if not
  """

  def check_for_docker() do
  end

  @doc"""
  builds a command string out of an executable, options passed in as flags
  """
  def build_command(command, exec, opts) do
    parsed_opts = parse_opts(opts)
    Enum.join([command, parsed_opts, exec], " ")
  end

  defp parse_opts([]), do: ""
  defp parse_opts(opts) do
    opts
    |> Enum.reduce([], fn
       {:f, _}, acc -> ["-f " <> Keyword.get(opts, :f)|acc]
       _, acc -> acc
    end)
    |> Enum.join(" ")
  end


end
