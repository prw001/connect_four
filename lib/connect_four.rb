require 'GameBoard.rb' #Remove relative directory signifier ('./') for running rspec tests, include it to play game
$welcome_prompt = %s{|||||||||~ Welcome to Connect 4! ~|||||||||
Please select one of the following options:

Option (1): New Game
Option (2): Load Game
Option (3): Exit

}
$how_to_play = %s{p1 = red || p2 = blue}
$invalid_option = "Not a valid option.  Please type one of the possible options or 'quit', and then press Enter:\n"
$load_prompt = "Type the name of the save file (no extensions):]\n"
$turn_prompt = "Choose a column for your next token, Player "
$column_IDs = ['1', '2', '3', '4', '5', '6', '7']

def load_save(filename = nil)
	#needs test written
end

def save_game(filename = nil)
	#needs test written
end

def valid_choice(response, color, game)
	if $column_IDs.include? response
		if game.add_token(color, response)
			return response
		else
			return nil
		end
	elsif response == 'quit'
		return response
	else
		return nil
	end
end

def turn(game)
	if game.player_turn == 1
		token_color = 'r'
	else
		token_color = 'b'
	end

	puts $turn_prompt + game.player_turn.to_s + ":\n"
	response = gets.chomp

	while !(valid_choice(response, token_color, game))
		puts $invalid_option
		response = gets.chomp
	end
	return response
end

def valid_option(option = nil)
	case option
	when '1', '2', '3', 'quit'
		return option
	else
		return nil
	end
end

def winning_move?(column, color)

end

def play(game)
	while game.turns_remaining > 0
		move = turn(game)
		if winning_move?()
			#puts winner
			break
		else
			game.update_turns
		end
	end
end

def menu
	puts $welcome_prompt
	option = gets.chomp.downcase
	game = nil

	while !(valid_option(option))
		puts $invalid_option
		option = gets.chomp.downcase
	end

	case option
	when '1'
		game = GameBoard.new 
		play(game)
	when '2'
		puts $load_prompt
		filename = gets.chomp
		data = load_save(filename)
		game = GameBoard.new(data)
		play(game)
	else
		puts "Goodbye!"
	end
end

#menu()