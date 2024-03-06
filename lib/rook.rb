# frozen_string_literal: true

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
      '♜'
    elsif color == 'black'
      '♜'.to_black
    end
  end
end
