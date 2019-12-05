defmodule Solution do
	def read_input do
		{:ok, contents} = File.read("input_ga")
		ins = contents |> String.trim |> String.split(",")	
		instructions = Enum.map(ins, &String.to_integer/1)
		execute(0, instructions)
	end

	def execute(ptr, instructions) do
		{:ok, instruction} = Enum.fetch(instructions, ptr)
		execute(ptr, instruction, Enum.slice(instructions, ptr+1, 3), instructions)
	end

	def execute(ptr, instruction, arguments, input) when instruction == 1 do
		{:ok, a1} = Enum.fetch(arguments, 0)
		{:ok, v1} = Enum.fetch(input, a1)
		{:ok, a2} = Enum.fetch(arguments, 1)
		{:ok, v2} = Enum.fetch(input, a2)
		{:ok, index} = Enum.fetch(arguments, 2)
		execute(ptr + 4, List.replace_at(input, index, v1 + v2))
	end

	def execute(ptr, instruction, arguments, input) when instruction == 2 do
		{:ok, a1} = Enum.fetch(arguments, 0)
		{:ok, v1} = Enum.fetch(input, a1)
		{:ok, a2} = Enum.fetch(arguments, 1)
		{:ok, v2} = Enum.fetch(input, a2)
		{:ok, index} = Enum.fetch(arguments, 2)
		execute(ptr + 4, List.replace_at(input, index, v1 * v2))
	end

	def execute(_ptr, instruction, _arguments, input) when instruction == 99 do
		IO.puts("#{inspect Enum.fetch(input, 0)}\n")
	end
end

