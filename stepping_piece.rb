require_relative 'piece'
class SteppingPiece < Piece
  def initialize(pos, color, board)
    super(pos,color,board)
  end

  def moves
    all_moves = []
    @permitted_directions.each do |dir|
      next_move = add_coord(dir, pos)
      next if out_of_bounds?(next_move)
      if @board[next_move].is_a?(Piece)
        all_moves << next_move if board[next_move].color != self.color
        next
      end
      all_moves << next_move
    end
    all_moves
  end
end

class Knight < SteppingPiece
  def initialize(pos, color, board)
    super(pos,color,board)
    @permitted_directions = [[-2,-1],[2,-1],[1,2],[2,1],[-2,1],[1,-2],[-1,2],[-1,-2]]
  end
end

class King < SteppingPiece
  def initialize(pos, color, board)
    super(pos,color,board)
    @permitted_directions = [[-1,0],[0,1],[1,0],[0,-1],[-1,-1],[-1,1],[1,1],[1,-1]]
  end
end
