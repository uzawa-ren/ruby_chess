# frozen_string_literal: true

require 'colorize'

class Pawn
  MOVE_DIRECTIONS = [
    [-1, -1], [-1, 0], [-1, +1], [-2, 0]
  ].freeze

  attr_reader :color, :moved

  def initialize(color)
    @color = color
    @moved = false
  end

  def self.move_directions(color)
    if color == 'black'
      MOVE_DIRECTIONS.map { |direction| flip_path_direction(direction) }
    else
      MOVE_DIRECTIONS
    end
  end

  def self.flip_path_direction(direction)
    [direction[0].abs, direction[1]]
  end

  def self.moves_linearly?
    false
  end

  def to_s
    if color == 'white'
      ' ♙ '
    elsif color == 'black'
      ' ♟︎'.black
    end
  end

  def update_status
    @moved = true
  end

  def ==(other)
    self.class == other.class && color == other.color && moved == other.moved
  end
end
