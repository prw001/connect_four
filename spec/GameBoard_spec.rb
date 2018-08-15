require 'GameBoard.rb'

describe GameBoard do 

	let(:game_board) {GameBoard.new}

	describe "#initialize" do 
		context "when created" do 
			it "exists" do 
				expect(game_board).to exist
			end
		end

		context "when attributes are defined" do 
			it "has a container for columns" do 
				expect(game_board.columns).to eql([[], [], [], [], [], [], []])
			end

			it "has a record for whose turn it is" do 
				expect(game_board.player_turn).to eql(1)
			end

			it "has a record for total turns remaining" do 
				expect(game_board.turns_remaining). to eql(42)
			end
		end

		context "when given load data" do 
			data = [['r'], ['b', 'r'], ['b', 'r', 'b'], ['r'], [], [], ['b']]
			let(:game_board) {GameBoard.new(data)}
			it "loads the column container with data" do 
				expect(game_board.columns).to eql(data)
			end
		end
	end


	describe "#add_token" do 
		context "when a player plays in a column" do 
			it "adds the token to that column" do 
				game_board.add_token('b', 1)
				expect(game_board.columns[0]).to eql(['b'])
			end
			it "returns specified column" do 
				expect(game_board.add_token('b', 1)).to eql(1)
			end
		end

		context "when additional move are made to the first column" do 
			it "stacks moves in columns" do 
				game_board.add_token('b', 1)
				game_board.add_token('r', 1)
				expect(game_board.columns[0]).to eql(['b', 'r'])
			end
		end

		context "when players fill a column" do 
			it "allows for six tokens in a column" do 
				game_board.add_token('b', 1)
				game_board.add_token('b', 1)
				game_board.add_token('r', 1)
				game_board.add_token('b', 1)
				game_board.add_token('b', 1)
				game_board.add_token('r', 1)
				expect(game_board.columns[0]).to eql(['b', 'b', 'r', 'b', 'b', 'r'])
			end
		end

		context "player adds to a full column" do 
			it "does not add the token" do 
				game_board.add_token('b', 1)
				game_board.add_token('b', 1)
				game_board.add_token('r', 1)
				game_board.add_token('b', 1)
				game_board.add_token('b', 1)
				game_board.add_token('r', 1)
				game_board.add_token('r', 1)
				expect(game_board.columns[0]).to eql(['b', 'b', 'r', 'b', 'b', 'r'])
			end
			it "returns nil" do 
				game_board.add_token('b', 1)
				game_board.add_token('b', 1)
				game_board.add_token('r', 1)
				game_board.add_token('b', 1)
				game_board.add_token('b', 1)
				game_board.add_token('r', 1)
				expect(game_board.add_token('r', 1)).to eql(nil)
			end
		end
	end

	describe "#update_turns" do 
		context "when player 1's turn ends" do 
			it "switches to player 2's turn" do 
				game_board.player_turn = 1
				expect(game_board.update_turns).to eql(2)
			end
		end

		context "when player 2's turn ends" do 
			it "switches to player 1's turn" do 
				game_board.player_turn = 2
				expect(game_board.update_turns).to eql(1)
			end
		end

		context "when starting with 42 turns" do 
			it "decrements the number of remaining turns" do 
				game_board.turns_remaining = 42
				game_board.update_turns
				expect(game_board.turns_remaining).to eql(41)
			end
		end
	end

	describe "#has_winning_sequence" do 
		context "when given a sequence" do 
			context "when sequence contains a four-in-a-row" do 
				it "returns true" do 
					expect(game_board.has_winning_sequence('b', ['r', 'b', 'b', 'b', 'b', 'r', 'r'])).to eql(true)
				end
			end

			context "when sequence contains four-in-a-row and a gap" do 
				it "returns true" do 
					expect(game_board.has_winning_sequence('b', ['b', '.', 'b', 'b', 'b', 'b',])).to eql(true)
				end
			end

			context "when sequence has four, but not in a row" do 
				it "returns false" do 
					expect(game_board.has_winning_sequence('r', ['r', 'r', 'b', 'b', 'r', 'r', 'b'])).to eql(false)
				end
			end

			context "when sequence does not have four in a row" do 
				it "returns false" do 
					expect(game_board.has_winning_sequence('r', ['r', 'b', 'r', 'b'])).to eql(false)
				end
			end

			context "when sequence is less than four" do 
				it "returns false" do 
					expect(game_board.has_winning_sequence('r', ['r', 'b', 'r'])).to eql(false)
				end
			end

			context "when sequence has four, but broken by a gap" do 
				it "returns false" do 
					expect(game_board.has_winning_sequence('b', ['b', 'b', '.', 'b', 'b',])).to eql(false)
				end
			end
		end
	end

	describe "#collect_horizontal_sequence" do  
		it "returns the sequence for that row" do 
			game_board.add_token('r', 1)
			game_board.add_token('b', 2)
			game_board.add_token('r', 3)
			expect(game_board.collect_horizontal_sequence(3)).to eql(['r', 'b', 'r', '.', '.', '.', '.'])
		end

		it "returns the sequence for that row and retains gaps" do 
			game_board.add_token('r', 1)
			game_board.add_token('b', 3)
			game_board.add_token('r', 5)
			game_board.add_token('b', 7)
			expect(game_board.collect_horizontal_sequence(7)).to eql(['r', '.', 'b', '.', 'r', '.', 'b'])
		end

		it "does not collect from inferior rows" do 
			game_board.add_token('r', 1)
			game_board.add_token('b', 2)
			game_board.add_token('r', 2)
			expect(game_board.collect_horizontal_sequence(2)).to eql(['.', 'r', '.', '.', '.', '.', '.'])
		end

		it "does not collect from superior rows" do 
			game_board.add_token('r', 1)
			game_board.add_token('b', 2)
			game_board.add_token('r', 2)
			game_board.add_token('r', 3)
			expect(game_board.collect_horizontal_sequence(3)).to eql(['r', 'b', 'r', '.', '.', '.', '.'])
		end
	end

	describe "#collect_vertical_sequence" do 
		it "returns specified column" do 
			game_board.add_token('r', 1)
			game_board.add_token('b', 1)
			game_board.add_token('r', 1)
			game_board.add_token('b', 1)
			game_board.add_token('b', 1)
			expect(game_board.collect_vertical_sequence(1)).to eql(['r', 'b', 'r', 'b', 'b'])
		end
	end

	describe "#collect_neg_slope_diagonal" do 
		it "returns a sequence of diagonal tokens" do
			game_board.add_token('r', 1)
			game_board.add_token('b', 2)
			game_board.add_token('r', 1)
			expect(game_board.collect_neg_slope_diagonal(1)).to eql(['r', 'b'])
		end

		it "returns a sequence of diagonal tokens with gaps" do 
			game_board.add_token('r', 1)
			game_board.add_token('b', 1)
			game_board.add_token('r', 1)
			game_board.add_token('b', 3)
			expect(game_board.collect_neg_slope_diagonal(3)).to eql(['r', '.', 'b'])
		end
	end

	describe "#collect_pos_slope_diagonal" do 
		it "returns a sequence of diagonal tokens" do 
			game_board.add_token('r', 1)
			game_board.add_token('b', 2)
			game_board.add_token('r', 2)
			expect(game_board.collect_pos_slope_diagonal(2)).to eql(['r', 'r', '.', '.', '.', '.'])
		end

		it "returns a sequence of diagonal tokens with gaps" do 
			game_board.add_token('r', 1)
			game_board.add_token('b', 3)
			game_board.add_token('r', 3)
			game_board.add_token('b', 3)
			expect(game_board.collect_pos_slope_diagonal(3)).to eql(['r', '.', 'b', '.', '.', '.'])
		end
	end
end

