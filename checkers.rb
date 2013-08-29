require './board.rb'
require './player.rb'
require './piece.rb'
require './move_parser.rb'

require 'debugger';

class CheckersGame
  include MoveParser

  attr_accessor :board, :current_player

  def initialize
    @players = {:white => User.new(:white), :black => User.new(:black)}
    @board = Board.new
    @current_player = :black
  end

  def play
    until won? || drawn?
      board.render
      board.perform_move(input)
      switch_turns
      puts "end of turn"
    end
    
    puts "You Lose!"
  end

  def won?
    # enemy has no legal moves
    false
  end

  def drawn?
    false
  end

  def input
    input = ""
    until board.valid?(convert(input), current_player)
      puts "enter a valid move"
      input = gets.chomp
    end
    
    input
  end
  
  def switch_turns
    current_player = current_player == :white ? :black : :white
  end
end

if __FILE__ == $0
  c = CheckersGame.new
  c.turn([[5, 6], [4, 5]])
  c.board.render
  c.switch_turns
  c.turn([[2, 5], [3, 4]])
  c.board.render
  c.switch_turns
  c.turn([[4, 5], [3, 6]])
  c.board.render
  c.switch_turns
  c.turn([[1, 6], [2, 5]])
  c.board.render
  c.switch_turns
  c.turn([[6, 5], [5, 6]])
  c.board.render
  c.switch_turns
  c.turn([[5, 0], [4, 1]])
  c.board.render
  c.switch_turns
  # 2 move chain
  c.turn([[2, 5], [4, 7], [6, 5]])
  c.board.render
  c.switch_turns

end
