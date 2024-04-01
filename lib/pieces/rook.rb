# frozen_string_literal: true

require 'colorize'

class Rook
  MOVE_DIRECTIONS = [
    [+1, 0], [0, +1], [-1, 0], [0, -1]
  ].freeze

  attr_reader :color, :moved

  def initialize(color, moved = false)
    @color = color
    @moved = moved
  end

  def self.move_directions(_color)
    MOVE_DIRECTIONS
  end

  def self.moves_linearly?
    true
  end

  def to_s
    if color == 'white'
      ' ♜ '
    elsif color == 'black'
      ' ♜ '.black
    end
  end

  def update_status
    @moved = true
  end

  def ==(other)
    self.class == other.class && color == other.color
  end
end
