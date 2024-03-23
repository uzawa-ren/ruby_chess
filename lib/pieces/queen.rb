# frozen_string_literal: true

require 'colorize'

class Queen
  MOVE_DIRECTIONS = [
    [+1, -1], [+1, 0], [+1, +1], [0, +1], [-1, +1], [-1, 0], [-1, -1], [0, -1]
  ].freeze

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def self.move_directions(_color)
    MOVE_DIRECTIONS
  end

  def self.moves_linearly?
    true
  end

  def to_s
    if color == 'white'
      ' ♛ '
    elsif color == 'black'
      ' ♛ '.black
    end
  end

  def ==(other)
    self.class == other.class && color == other.color
  end
end
