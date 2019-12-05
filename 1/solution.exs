defmodule Solution do
  def read_input do
    {:ok, contents} = File.read("input")
    [h|t] = contents |> String.split("\n")
    IO.puts(calc([h|t]))
  end

  def calc([h|t]) do
    calc(0, [h|t])
  end

  def calc(acc, [string]) when string == "" do
    calc(acc, [])
  end

  def calc(acc, [h|t]) do
    calc(acc + fuel(String.to_integer(h)), t)
  end

  def calc(acc, []) do
    acc
  end

  def fuel(mass) do
    trunc(mass / 3) - 2
  end

end
