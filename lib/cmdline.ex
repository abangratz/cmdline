defmodule Cmdline do
  @moduledoc ~S"""
  This is se help.

  If it no helps you, you are wrang.

  """

  @doc """
  Main function, parses arguments and switches

     iex> Cmdline.main(["--verbose", "moo"])
     ["moo"]

  """
  def main(args) do
    args |> parse_args |> process
  end

  def process(:empty) do
    IO.puts("No args")
  end

  def process({:help, _}) do
    IO.puts @moduledoc
    System.halt(0)
  end


  def process({options, args}) do
    IO.puts "processing"
    IO.inspect options
    IO.inspect args
  end

  @doc """
  Parses arguments

     iex> Cmdline.parse_args(["--verbose", "moo"])
     {[verbose: true], ["moo"]}
     iex> Cmdline.parse_args(["--verbose"])
     {[verbose: true], []}
     iex> Cmdline.parse_args(["--help"])
     {:help, []}
     iex> Cmdline.parse_args(["--help", "--verbose"])
     {:help, []}
     iex> Cmdline.parse_args(["--help", "moo"])
     {:help, ["moo"]}
     iex> Cmdline.parse_args([])
     :empty
     iex> Cmdline.parse_args(["moo"])
     {[], ["moo"]}

  """
  def parse_args(args) do
    options = OptionParser.parse(args, switches: [verbose: :boolean, help: :boolean])
    case options do
    {[], [], []} -> :empty
    {[], args, []} -> { [], args }
    {opts, args, []} -> { parse_opts(opts), args }
    _ -> {:help, []}
    end
  end

  def parse_opts(opts) do
    if Enum.any?(opts, fn(x) -> x == {:help, true} end) do
        :help
    else
      opts
    end
  end

end
