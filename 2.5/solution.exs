defmodule Solution do
	def read_input do
		{:ok, contents} = File.read("input_ga")
		ins = contents |> String.trim |> String.split(",")	
		instructions = Enum.map(ins, &String.to_integer/1)
		gen_noun(instructions)
	end

	def gen_noun(instructions) do
		gen_noun(instructions, 0)
	end

	def gen_noun(instructions, noun) do
		gen_verb(instructions, noun)
		gen_noun(instructions, noun+1)
	end

	def gen_verb(instructions, noun) do
		gen_verb(instructions, noun, 0)
	end

	def gen_verb(_instructions, _noun, verb) when verb == 99 do
	end

	def gen_verb(instructions, noun, verb) do
		newinstructions = instructions \
		|> List.replace_at(2, verb)
		|> List.replace_at(1, noun)
		execute(0, newinstructions)
		gen_verb(instructions, noun, verb+1)
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
		{:ok, result} = Enum.fetch(input, 0)
		check_result(result, input)
	end

	def check_result(result, input) when result == 19690720 do
		{:ok, noun} = Enum.fetch(input, 1)
		{:ok, verb} = Enum.fetch(input, 2)
		IO.puts("Result: #{inspect 100*noun+verb}")
		System.halt()
	end

	def check_result(_, _) do
	end

end

