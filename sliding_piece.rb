require_relative 'piece'

class SlidingPiece < Piece
  def initialize(pos, color, board)
    super(pos,color,board)
  end


  def trace_path(dir)
    next_pos = add_coord(pos,dir)
    row, col = next_pos
    path = []
    until out_of_bounds?(next_pos)
      if @board[next_pos].is_a?(Piece)
        path << next_pos if @board[next_pos].color != self.color
        break
      end
      path << next_pos
      next_pos = add_coord(next_pos,dir)
    end
    path
  end

  def moves
    all_paths = []
    @permitted_directions.each do |dir|
      all_paths += trace_path(dir)
    end
    all_paths
  end
end

class Bishop < SlidingPiece
  def initialize(pos, color, board)
    super(pos,color,board)
    @permitted_directions = [[-1,-1],[-1,1],[1,1],[1,-1]]
  end

  def move_dirs
    [:diagonal]
  end

  def to_s
    "B"
  end
end

class Rook < SlidingPiece
  def initialize(pos, color, board)
    super(pos,color,board)
    @permitted_directions = [[-1,0],[0,1],[1,0],[0,-1]]
  end

  def move_dirs
    [:straight]
  end

  def to_s
    "R"
  end

end

class Queen < SlidingPiece
  def initialize(pos, color, board)
    super(pos,color,board)
    @permitted_directions = [[-1,0],[0,1],[1,0],[0,-1],[-1,-1],[-1,1],[1,1],[1,-1]]
  end

  def move_dirs
    [:straight, :diagonal]
  end

  def to_s
    "Q"
  end
end
