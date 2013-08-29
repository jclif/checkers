require 'colorize'

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
        background = (i + j).even? ? :red : :grey
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
    # moves piece from move[0] to move[1] and deletes if jump,
    # then calls perform move against with move minus the first coord 
    # i.e. perform_move(move[1..-1] 
    if (move[0].first - move[1].first).abs == 2 # it jumped!
      debugger
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

end
