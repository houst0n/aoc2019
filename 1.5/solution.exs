defmodule Solution do
  def read_input do
    {:ok, contents} = File.read("input")
    [h|t] = contents |> String.split("\n")
    IO.puts(calc([h|t]))
  end

  def calc([h|t]), do: calc(0, [h|t])
  def calc(acc, [string]) when string == "", do: calc(acc, [])
  def calc(acc, [h|t]), do: calc(acc + fuel(String.to_integer(h)), t)
  def calc(acc, []), do: acc

  def fuelcalc(x), do: negcheck(trunc(x / 3) - 2)

  def negcheck(x) when x < 0, do: 0
  def negcheck(x), do: x

  def fuel(mass), do: fof(fuelcalc(mass))

  def fof(mass), do: fof(mass, mass)
  def fof(acc, mass) when mass <= 0, do: acc
  def fof(acc, mass), do: fof(acc + fuelcalc(mass), fuelcalc(mass))
end
