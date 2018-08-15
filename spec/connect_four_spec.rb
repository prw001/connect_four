require 'connect_four.rb'
require 'GameBoard.rb'

describe "#valid_option" do 
	context "when given 1" do 
		it "returns 1" do 
			expect(valid_option('1')).to eq('1')
		end
	end

	context "when given 2" do 
		it "returns 2" do 
			expect(valid_option('2')).to eq('2')
		end
	end

	context "when given 3" do
		it "returns 3" do 
			expect(valid_option('3')).to eq('3')
		end
	end

	context "when given 'quit'" do 
		it "returns quit" do 
			expect(valid_option('quit')).to eq('quit')
		end
	end

	context "when given an invalid number" do 
		it "returns nil" do 
			expect(valid_option('4')).to eql(nil)
		end
	end

	context "when given a word" do 
		it "returns nil" do 
			expect(valid_option('three')).to eql(nil)
		end
	end
end

describe "#valid_choice" do 
	let(:game_board) {GameBoard.new}
	context "when given a valid number" do 
		it "returns that number" do 
			expect(valid_choice('1', 'r', game_board)).to eql('1')
		end
	end

	context "when given an invalid number" do 
		it "returns nil" do 
			expect(valid_choice('10', 'b', game_board)).to eql(nil)
		end
	end

	context "when given the word 'quit'" do 
		it "returns 'quit'" do 
			expect(valid_choice('quit', 'r', game_board)).to eql('quit')
		end
	end

	context "when given an invalid word" do 
		it "returns nil" do 
			expect(valid_choice('one', 'r', game_board)).to eql(nil)
		end
	end
end

describe "#winning_move?" do 
	let(:game_board) {GameBoard.new}
	context "when a move is made that wins the game" do 
		it "returns true" do 
			expect(winning_move?()).to eql(true)
		end
	end

	context "when a move is made that does not win the game" do 
		it "returns false" do 
			expect(winning_move?()).to eql(false)
		end
	end
end