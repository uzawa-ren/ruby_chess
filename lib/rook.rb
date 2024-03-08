# frozen_string_literal: true

require 'colorize'

class Rook
  MOVE_DIRECTIONS = [
    [+1, 0], [0, +1], [-1, 0], [0, -1]
  ].freeze

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def to_s
    if color == 'white'
      ' ♜ '
    elsif color == 'black'
      ' ♜ '.black
    end
  end
end
