"""
 After 4 hours, I gave up and stole someone elses and spent some time trying to understand it..... 
  I'll try it again later 
   Thanks to: https://github.com/CraigCottingham/advent-of-code-2019/blob/master/lib/aoc/day_03.ex
"""
defmodule Solution do

  def part_1 do
    "input"
    |> load_paths_from_file()
    |> closest_intersection()
    |> manhattan_distance({0, 0})
  end

  def part_2 do
    "input"
    |> load_paths_from_file()
    |> shortest_path()
  end

  defp all_intersections([path1, path2]) do
    for s1 <- path_to_segments(path1), s2 <- path_to_segments(path2) do
      {s1, s2, intersect?(s1, s2)}
    end
    |> Enum.filter(fn {_, _, intersect} -> intersect end)
    |> Enum.map(fn {s1, s2, _} -> intersection(s1, s2) end)
    |> Enum.reject(fn p -> p == {0, 0} end)
  end

  def closest_intersection([path1, path2]) do
    all_intersections([path1, path2])
    |> Enum.min_by(fn p -> manhattan_distance({0, 0}, p) end)
  end

  def intersect?({p1, q1}, {p2, q2}) do
    o1 = orientation(p1, q1, p2)
    o2 = orientation(p1, q1, q2)
    o3 = orientation(p2, q2, p1)
    o4 = orientation(p2, q2, q1)

    if o1 != o2 && o3 != o4 do
      true
    else

      false
    end
  end

  def intersection({{p1x, _p1y}, {q1x, _q1y}}, {{_p2x, p2y}, {_q2x, q2y}})
      when p1x == q1x and p2y == q2y,
      do: {p1x, p2y}

  def intersection({{_p1x, p1y}, {_q1x, q1y}}, {{p2x, _p2y}, {q2x, _q2y}})
      when p2x == q2x and p1y == q1y,
      do: {p2x, p1y}

  def length_to_point(path, point, length_so_far \\ 0)

  def length_to_point([], _, length_so_far), do: length_so_far

  def length_to_point([{{px, py} = p, {qx, qy} = q} | tail], {rx, ry} = r, length_so_far) do
    cond do
      py == qy && py == ry && Enum.member?(px..qx, rx) ->
        length_so_far + manhattan_distance(p, r)

      px == qx && px == rx && Enum.member?(py..qy, ry) ->
        length_so_far + manhattan_distance(p, r)

      true ->
        length_to_point(tail, r, length_so_far + manhattan_distance(p, q))
    end
  end

  defp load_paths_from_file(filename) do
    filename
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(&String.trim/1)
    end)
  end

  def manhattan_distance({px, py}, {qx, qy}), do: abs(qx - px) + abs(qy - py)

  def orientation({px, py}, {qx, qy}, {rx, ry}) do
    case (qy - py) * (rx - qx) - (qx - px) * (ry - qy) do
      0 -> :colinear
      val when val > 0 -> :cw
      _ -> :ccw
    end
  end

  def path_to_segments(path, previous_point \\ {0, 0}, segments \\ [])

  def path_to_segments([], _, segments), do: Enum.reverse(segments)

  def path_to_segments([vector | tail], {previous_x, previous_y} = previous_point, segments) do
    next_point =
      case Regex.named_captures(~r/(?<direction>[DLRU])(?<distance>\d+)/, vector) do
        %{"direction" => "D", "distance" => distance} ->
          {previous_x, previous_y - String.to_integer(distance)}

        %{"direction" => "L", "distance" => distance} ->
          {previous_x - String.to_integer(distance), previous_y}

        %{"direction" => "R", "distance" => distance} ->
          {previous_x + String.to_integer(distance), previous_y}

        %{"direction" => "U", "distance" => distance} ->
          {previous_x, previous_y + String.to_integer(distance)}
      end

    path_to_segments(tail, next_point, [{previous_point, next_point} | segments])
  end

  def shortest_path([path1, path2]) do
    segment_list_1 = path_to_segments(path1)
    segment_list_2 = path_to_segments(path2)

    all_intersections([path1, path2])
    |> Enum.map(fn point ->
      length_to_point(segment_list_1, point) + length_to_point(segment_list_2, point)
    end)
    |> Enum.min()
  end
end
