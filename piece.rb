require './tree_node.rb'

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

  def naive_jump_moves(board)
    moves = []
    basis.each do |base|
      diag_piece_pos = [pos, base].transpose.map { |x| x.reduce(:+) }
      if board[diag_piece_pos] && board[diag_piece_pos].color != color
        new_base = base.collect { |n| n * 2 }
        summed_end = [pos, new_base].transpose.map { |x| x.reduce(:+) }
        summed_move = [pos, summed_end]
        moves.concat(summed_move) if board[summed_end].nil? && on_board?(summed_end)
      end
    end

    moves
  end

  def jump_moves(board)
    # using TreeNode, create a tree with the value being a hash of its board and move
    # once the tree is created, traverse the tree and find any node that doesn't have any children
    # trace the path from this node until it finds nil, and append this path to moves.
    parent = build_tree(board)
    
    traverse_tree(parent)
  end

  def build_tree(board)
    debugger
    
    node_hash = {board: board, pos: self.pos}
    parent = TreeNode.new(node_hash)
    considered_nodes = [parent]

    until considered_nodes == []
      current = considered_nodes.shift
      curr_board = current.value[:board]
      curr_pos = current.value[:pos]
      curr_piece = curr_board[curr_pos]
      next_moves = curr_piece.naive_jump_moves(curr_board)

      next_moves.each do |move|
        next_board = curr_board.perform_move(move)
        node_hash = {board: next_board, pos: move[1]}
        next_node = TreeNode.new(node_hash, current)
        considered_nodes << next_node
      end
    end

    return parent
  end

  def traverse_tree(parent)
    leaves = TreeNode.dfs(parent) { |x| x.children.nil? }

    return moves
  end

  def on_board?(pos)
    pos.all?{ |coord| coord.between?(0, 7) }
  end

  def to_s
    unicode
  end
end

