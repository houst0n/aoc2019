defmodule Solution do
  def part1() do
    do_loop1(0, 172851)
  end

  defp do_loop1(count, x) when x == 675869 do
    IO.puts("#{inspect count}")
  end

  defp do_loop1(count, x) do
    xa = Integer.to_string(x) |> String.graphemes |> Enum.map(&String.to_integer/1) 
    count = validate_double(count, xa, xa)
    do_loop1(count, x+1)
  end

  defp validate_double(count, [x,x,_,_,_,_], y), do: validate_dec(count, y)
  defp validate_double(count, [_,x,x,_,_,_], y), do: validate_dec(count, y)
  defp validate_double(count, [_,_,x,x,_,_], y), do: validate_dec(count, y)
  defp validate_double(count, [_,_,_,x,x,_], y), do: validate_dec(count, y)
  defp validate_double(count, [_,_,_,_,x,x], y), do: validate_dec(count, y)
  defp validate_double(count, _x, _y), do: count

  defp validate_dec(count, [a, b, c, d, e, f]) when a <= b and b <= c and c <= d and d <= e and e <= f do
    count + 1
  end

  defp validate_dec(count, _x) do
    count
  end

  def part2() do
    172581..675869
    |> Enum.filter(&validate_p2/1)
    |> Enum.count()
  end

  def validate_p2(x), do: validate_p2(Integer.digits(x), %{all_increase: true, has_double: false})
  def validate_p2([], r), do: r.all_increase && r.has_double

  def validate_p2([h, h | _] = l, r) do
    case count_pairs(l) do
      {2, rest} -> validate_p2(rest, %{r | has_double: true})
      {_, rest} -> validate_p2(rest, r)
    end
  end

  def validate_p2([a, b | _] = l, r) when a > b, do: validate_p2(tl(l), %{r | all_increase: false})
  def validate_p2([_ | tl], r), do: validate_p2(tl, r)

  def count_pairs([h | _t] = l), do: count_pairs(l, h, 0)
  def count_pairs([], value, acc), do: {acc, [value]}
  def count_pairs([h | t], value, acc) when h == value, do: count_pairs(t, value, acc + 1)
  def count_pairs(l, value, acc), do: {acc, [value | l]}
end
