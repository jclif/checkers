class Piece
  attr_accessor :color, :pos, :unicode, :basis

  def initialize(color, pos)
    @color = color
    @pos = pos
    @unicode = "\u2B24"
    @basis = color == :white ? [[1, -1], [1, 1]] : [[-1, -1], [-1, 1]]
  end

  def slide_moves(board)
    moves = []
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
      diag_piece_pos = [pos, base].transpose.map { |x| x.reduce(:+) }
      if board[diag_piece_pos] && board[diag_piece_pos].color != color
        new_base = base.collect { |n| n * 2 }
        summed_end = [pos, new_base].transpose.map { |x| x.reduce(:+) }
        summed_move = [pos, summed_end]
        if on_board?(summed_end) && board[summed_end].nil?
          moves << summed_move  
          summed_move_chain = get_summed_move_chain
          moves.concat(new_jump_moves)
        end
      end
    end

    moves
  end

  def get_summed_move_chains(board, summed_moved)
    new_board = board.duplicate
    new_board.perform_move(summed_move)
    new_jump_moves = new_board[summed_end].jump_moves(new_board)
    unless new_jump_moves == []
      debugger
      new_jump_moves.map! do |move|
        move.unshift(summed_move)
      end
    end

  def on_board?(pos)
    pos.all?{ |coord| coord.between?(0, 7) }
  end

  def to_s
    unicode
  end
end

