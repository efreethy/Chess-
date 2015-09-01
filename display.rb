require_relative 'cursorable'
require_relative 'player'

class Display
  include Cursorable

  attr_accessor :selected

  def initialize(board)
    @board = board
    @cursor = [0, 0]
    @selected = false

  end

  def build_grid
    @board.rows.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    row.map.with_index do |piece, j|
      color_options = colors_for(i, j)
      piece.to_s.colorize(color_options)
    end
  end

  def colors_for(i, j)
    if [i, j] == @cursor
      bg = :light_red
    elsif (i + j).odd?
      bg = :light_blue
    else
      bg = :blue
    end
    { background: bg, color: :white }
  end

  def render
    system("clear")
    # puts "#{@game.current_player.color}, please make a move: "
    puts "Arrow keys, WASD, or vim to move, space or enter to confirm."

    build_grid.each_with_index { |row, i| puts  "#{i+1}#{row.join}" }
    puts " A B C D E F G H".downcase
  end
end
