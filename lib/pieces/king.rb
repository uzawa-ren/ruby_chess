# frozen_string_literal: true

require 'colorize'

class King
  MOVE_DIRECTIONS = [
    [+1, -1], [+1, 0], [+1, +1], [0, +1], [-1, +1], [-1, 0], [-1, -1], [0, -1],
    [0, +2], [0, -2]
  ].freeze

  attr_reader :color, :moved

  def initialize(color)
    @color = color
    @moved = false
  end

  def self.move_directions(_color)
    MOVE_DIRECTIONS
  end

  def self.moves_linearly?
    false
  end

  def to_s
    if color == 'white'
      ' ♚ '
    elsif color == 'black'
      ' ♚ '.black
    end
  end

  def update_status
    @moved = true
  end

  def ==(other)
    self.class == other.class && color == other.color
  end
end
