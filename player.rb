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

  def get_two_moves
    moves = []
    until moves.length == 2
      moves << move
    end
    moves
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

  def countdown
    [3,2,1].each do |idx|
      print "#{idx} "
      sleep(1)
    end
  end

end
