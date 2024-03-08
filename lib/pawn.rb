# frozen_string_literal: true

require 'colorize'

class Pawn
  MOVE_DIRECTIONS = {
    move: [+1, 0],
    attack: [[+1, -1], [+1, +1]],
    en_passant: [+2, 0]
  }.freeze

  attr_reader :color, :first_move

  def initialize(color)
    @color = color
    @first_move = true
  end

  def to_s
    if color == 'white'
      ' ♙ '
    elsif color == 'black'
      ' ♟︎'.black
    end
  end

  def update_status
    @first_move = false
  end
end
