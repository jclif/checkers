require 'colorize'
require 'yaml/store'

class Board
  attr_accessor :grid

  def initialize
    @grid = set_up
  end

  def [](pos)
    grid[pos[0]][pos[1]]
  end

  def []=(pos,value)
    grid[pos[0]][pos[1]] = value
  end

  def set_up
    grid = Array.new(8) do |row|
      Array.new(8) do |col|
        if row.between?(3,4)
          nil
        else
          color = row.between?(0,2) ? :white : :black
          Piece.new(color, [row,col]) if (row + col).odd?
        end
      end
    end
  end
  
  def render
    puts "   a b c d e f g h "
    grid.each_with_index do |row, i|
      print " #{8 - i} "
      row.each_with_index do |piece, j|
        background = (i + j).odd? ? :red : :grey
        if piece
          print "#{piece} ".colorize(color: piece.color, background: background)
        else
          print "  ".colorize( :background => background )
        end
      end
      print "\n"
    end
  end

  def perform_move(move) # [[5, 0], [3, 2], [1, 0]]
    if (move[0].first - move[1].first).abs == 2 # it jumped!
      # this looks crazy, but im just setting the coord between
      # them to nil -.-
      mid = [(move[0].first + move[1].first) / 2, (move[0][1] + move[1][1]) / 2]
      self[mid] = nil
    end
    self[move[1]] = self[move[0]]
    self[move[1]].pos = move[1]
    self[move[0]] = nil
    perform_move(move[1..-1]) if move.length > 2 # consecutive moves
  end

  def valid?(move, current_player) # [[x, y], [x, y],...]
    # iterate over board, grabbing each pieces sliding and jumping moves
    # the jumping moves will be tricky, because the  peice that jumped
    # will have to have the jumping moves at that position grabbed, and 
    # etc
    legal_moves = []

    grid.each do |row|
      row.each do |square|
        if square && square.color == current_player
          legal_moves.concat(square.slide_moves(self))
        end
      end
    end
   
    attack_moves = []

    #get attack_moves
    grid.each do |row|
      row.each do |square|
        if square && square.color == current_player
          attack_moves.concat(square.jump_moves(self))
        end
      end
    end

    attack_moves == [] ? legal_moves.include?(move) : attack_moves.include?(move)
  end

  def duplicate
    yamlized_board = self.to_yaml
    YAML::load(yamlized_board)
  end
end
