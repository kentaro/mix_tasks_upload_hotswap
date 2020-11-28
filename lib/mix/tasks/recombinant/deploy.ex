defmodule Mix.Tasks.Recombinant.Deploy do
  use Mix.Task

  @requirements ["app.config"]
  @shortdoc "Deploy modules to remote nodes."
  def run(_) do
    Recombinant.deploy
  end
end
