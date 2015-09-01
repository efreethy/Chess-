require_relative 'display'
require_relative 'board'

class HumanPlayer
  attr_reader :color

  def initialize(board, color)
    @display = Display.new(board)
    @board = board
    @color = color
  end

  def move
    start = nil
    until start
      @display.render
      start = @display.get_input
    end
    start
  end

  def play_turn
    puts "Please make a move, use enter to select and place."
    start, end_pos = get_two_moves
    @board.move_piece(start, end_pos)
    rescue EmptySpaceError
      print "There are no pieces at that start space. Try again in ".colorize(:red)
      countdown
      retry
    rescue EndPositionError
      print "That endpoint is invalid (Puts you in check, or is out-of-bounds). \nTry again in ".colorize(:red)
      countdown
      retry
    rescue WrongPlayerError
      print "You can only move your own pieces, fucker. \nTry again in ".colorize(:red)
      countdown
      retry
  end

  private

  def get_two_moves
    moves = []
    until moves.length == 2
      moves << move
    end
    moves
  end

  def countdown
    [3,2,1].each do |idx|
      print "#{idx} "
      sleep(1)
    end
  end

end


class ComputerPlayer
  attr_reader :color

  def initialize(board, color)
    @display = Display.new(board)
    @board = board
    @color = color
  end

  def play_turn
    move = self.move
    @board.move_piece(move[0], move[1])
  end

  def move
    opponents_king = get_opponents_king
    pieces = @board.grab_pieces(color)
    movable_pieces = pieces.reject { |piece| piece.valid_moves.empty? }
    move = select_best_move(movable_pieces, opponents_king)
    # best_piece = select_best_piece(movable_pieces, opponents_king)
  end

  def select_best_move(movable_pieces, opponents_king)
    valid_moves_hash = {}
    movable_pieces.each do |piece|
      piece.valid_moves.each {|move| valid_moves_hash[move] = piece}
    end
    smallest_distance = nil
    best_move = nil
    valid_moves_hash.each do |move, piece|
      distance = get_distance(opponents_king, move)
      smallest_distance ||= distance
      best_move ||= move
      if distance < smallest_distance
        smallest_distance = distance
        best_move = move
      end
    end
    p valid_moves_hash
    [valid_moves_hash[best_move].pos, best_move]
  end


  def select_best_piece(movable_pieces, opponents_king)
    # best_piece = nil
    # smallest_distance = nil
    # king_pos = opponents_king.pos
    #
    # movable_pieces.each do |piece|
    #   distance = get_distance(opponents_king,piece)
    #   smallest_distance ||= distance
    #   best_piece ||= piece
    #   if distance < smallest_distance
    #
    #     smallest_distance = distance
    #     best_piece = piece
    #   end
    # end
  end
  private

  def get_distance(pos1,pos2)
    # pos1, pos2 = piece1.pos, piece2.pos
    (pos1[0]-pos2[0]).abs + (pos1[1]-pos2[1]).abs
  end

  def get_opponents_king
    opponent_color = get_opponent_color
    @board.find_king(opponent_color)
  end

  def get_opponent_color
    player_color = @board.current_player_color
    color = (player_color == :white) ? :black : :white
  end

end
