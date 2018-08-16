require "./colorize.rb" #Remove relative directory signifier ('./') for running rspec tests, include it to play game
require "JSON"

class GameBoard
	attr_reader :columns
	attr_accessor :player_turn
	attr_accessor :turns_remaining
	def initialize(data = nil, player_turn = 1, turns_remaining = 42)
		unless data
			@columns = [[], [], [], [], [], [], []]
		else
			@columns = data
		end
		@player_turn = player_turn
		@turns_remaining = turns_remaining
	end

	def exist?
		self
	end

	def add_token(color, column)
		column = column.to_i - 1
		unless @columns[column].length == 6
			@columns[column] << color
			column + 1
		end
	end

	def get_save_data
		data = JSON.generate [@columns, @player_turn, @turns_remaining]
	end

	def update_turns
		@turns_remaining -= 1
		if @player_turn == 1
			@player_turn = 2
		else
			@player_turn = 1
		end
	end

	def has_winning_sequence(color, sequence)
		has_winner = false
		unless sequence.length < 4
			i = 0
			(sequence.length - 3).times do 
				if sequence.slice(i, 4).all? {|token| token == color}
					has_winner = true
					break
				end
				i += 1
			end
		end
		return has_winner
	end

	def get_slot_value(column, row)
		if @columns[column][row]
			return @columns[column][row]
		else
			return '.' #placeholder
		end
	end

	def display
		row = 5
		column = 0
		top = "┏━━━━━━━━━━━━━━━┓\n".yellow
		bottom = "┗━━━━━━━━━━━━━━━┛\n".yellow + "+ 1 2 3 4 5 6 7 +\n".green
		rows = ""
		while row >= 0
			rows << "┃ ".yellow
			while column < 7
				color = get_slot_value(column, row)
				if color == "r"
					rows << "◉ ".red
				elsif color == 'b'
					rows << "◉ ".blue
				else
					rows << "◯ ".yellow
				end
				column += 1
			end
			rows << "┃\n".yellow
			row -= 1
			column = 0
		end
		board = top + rows + bottom
		puts board
	end

	def collect_horizontal_sequence(column)
		row = (@columns[column-1]).length - 1
		sequence = []
		column_index = 0
		while column_index < 7
			sequence << get_slot_value(column_index, row)
			column_index += 1
		end
		return sequence
	end

	def collect_vertical_sequence(column)
		return @columns[column - 1]
	end

	def collect_neg_slope_diagonal(column)
		#Because upper left portion of sequence is added in reverse,
		#reverse array before adding lower right portion
		column -= 1
		row = @columns[column].length - 1
		sequence = []
		delta = 0

		while (column - delta) >= 0 && (row + delta) < 6
			sequence << get_slot_value((column - delta), (row + delta))
			delta += 1
		end

		sequence.reverse!
		delta = 1

		while (column + delta < 7) && (row - delta) >= 0
			sequence << get_slot_value((column + delta), (row - delta))
			delta += 1
		end

		return sequence
	end

	def collect_pos_slope_diagonal(column)
		#Because lower left portion of sequence is added in reverse,
		#reverse array before adding upper right portion
		column -= 1
		row = @columns[column].length - 1
		sequence = []
		delta = 0

		while (column - delta) >= 0 && (row - delta) >= 0
			sequence << get_slot_value((column - delta), (row - delta))
			delta += 1
		end

		sequence.reverse!
		delta = 1

		while (column + delta) < 7 && (row + delta) < 6
			sequence << get_slot_value((column + delta), (row + delta))
			delta += 1
		end

		return sequence
	end
end