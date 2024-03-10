# frozen_string_literal: true

require 'colorize'

class Knight
  MOVE_DIRECTIONS = [
    [+2, -1], [+2, +1], [+1, +2], [-1, +2], [-2, +1], [-2, -1], [-1, -2], [+1, -2]
  ].freeze

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def self.move_directions
    MOVE_DIRECTIONS
  end

  def self.moves_linearly?
    false
  end

  def to_s
    if color == 'white'
      ' ♞ '
    elsif color == 'black'
      ' ♞ '.black
    end
  end
end
