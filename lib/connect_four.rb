require './GameBoard.rb' #Remove relative directory signifier ('./') for running rspec tests, include it to play game
require './GameTools.rb' #Remove relative directory signifier ('./') for running rspec tests, include it to play game

$welcome_prompt = "|||||||||~ Welcome to Connect 4! ~|||||||||".blue

$options = %s{Please select one of the following options:

Option (1): New Game
Option (2): Load Game
Option (3): Exit

}
$how_to_play = "HOW TO PLAY:\n".green + 
			   "Players take alternating turns adding one token of their color\n" +
			   "to one of the available columns. The first player to get four in a row -\n" + 
			   "horizontally, vertically, or diagonally".blue + " wins!\n" + 
			   "Player 1 is " + "RED\n".red + "Player 2 is " + "BLUE\n\n".blue + 
			   "Type the number of the column you want to put your token in and press ENTER.\n" +
			   "Type 'quit' at any time to quit, or 'save' to save your current game.\n"
$invalid_option = "Not a valid option.  Please type one of the possible options or 'quit', and then press Enter:\n"
$load_prompt = "Type the name of the save file (no extensions):\n"
$save_prompt = "Type a name for your save file (no special characters):\n"
$turn_prompt = "Choose a column for your next token, Player "
$column_IDs = ['1', '2', '3', '4', '5', '6', '7']

def valid_choice(response, color, game)
	if $column_IDs.include? response
		if game.add_token(color, response)
			return response
		else
			return nil
		end
	elsif response == 'quit' || response == 'save'
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

	puts $turn_prompt + game.player_turn.to_s + ", or use commands 'quit' or 'save':\n"
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

def winning_move?(game, move)
	move = move.to_i
	(game.player_turn == 1) ? color = 'r' : color = 'b'

	sequences = []
	sequences += [game.collect_horizontal_sequence(move),
				  game.collect_vertical_sequence(move),
				  game.collect_neg_slope_diagonal(move),
				  game.collect_pos_slope_diagonal(move)]

	sequences.each do |sequence| 
		if game.has_winning_sequence(color, sequence)
			return true
		end
	end
	return false
end

def play(game)
	include GameTools
	puts $how_to_play
	sleep 1
	puts "The starting board:\n"
	game.display
	while game.turns_remaining > 0
		move = turn(game)
		if move != 'quit' && move != 'save'
			if winning_move?(game, move)
				puts "Player " + game.player_turn.to_s + " Wins!'\n\n" + "Final Board:\n"
				game.display
				break
			else
				game.update_turns
				if game.turns_remaining  == 0
					puts "Draw!"
					game.display
					break
				end
			end
		elsif move == 'save'
			puts $save_prompt
			filename = gets.chomp
			save_game(game, filename)
		else
			break
		end
		puts "Current Board: "
		game.display
	end
end

def menu
	include GameTools
	wants_to_play = true
	game = nil

	puts $welcome_prompt
	
	while wants_to_play
		puts $options
		option = gets.chomp.downcase

		while !(valid_option(option))
			puts $invalid_option
			option = gets.chomp.downcase
		end

		case option
		when '1'
			game = GameBoard.new 
			play(game)
		when '2'
			data = load_game
			unless !data
				game = GameBoard.new(data[0], data[1], data[2])
				play(game)
			else
				puts "\nFailed to load game, try again or a different filename.\n".red
			end
		else
			wants_to_play = false
			puts "Goodbye!"
		end
	end
end

menu() #uncomment 'menu()' to run game
