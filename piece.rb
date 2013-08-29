class Piece
  attr_accessor :color, :pos, :unicode, :basis

  def initialize(color, pos)
    @color = color
    @pos = pos
    @unicode = "\u2B24"
    @basis = color == :white ? [[1, -1], [1, 1]] : [[-1, -1], [-1, 1]]
  end

  def slide_moves(board)
    moves =[]
    basis.each do |base|
      summed_end = [pos, base].transpose.map { |x| x.reduce(:+) }
      summed_move = [pos, summed_end]
      moves << summed_move if board[summed_end].nil? && on_board?(summed_end)
    end

    moves
  end

  def jump_moves(board)
    moves = []
    basis.each do |base| 
      if board[base] && board[base].color != color
        coord = base.collect { |n| n * 2 }
        moves << coords if on_board?(dir)
      end
    end

    moves
  end

  def on_board?(pos)
    pos.all?{ |coord| coord.between?(0, 7) }
  end

  def to_s
    unicode
  end
end

