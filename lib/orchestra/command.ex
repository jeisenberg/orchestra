defmodule Orchestra.Command do

  @compose_exec "docker-compose"
  @machine_exec "docker-machine"

  @doc"""
  Runs docker-compose build
  Takes a keyword list as opts that get passed in as args
  example:
  build([f: "dev.yml"]) will run docker-compose -f dev.yml build
  """
  def build(opts \\ []) do
    Orchestra.build_command(@compose_exec, "build", opts)
  end

  @doc"""
  Runs docker-compose up
  Takes a keyword list as opts that get passed in as args
  example:
  build([f: "dev.yml"]) will run docker-compose -f dev.yml up
  """
  def up(opts \\ []) do
    Orchestra.build_command(@compose_exec, "up", opts)
  end
end
