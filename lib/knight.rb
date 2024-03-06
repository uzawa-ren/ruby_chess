# frozen_string_literal: true

class Knight
  MOVE_DIRECTIONS = [
    [+2, -1], [+2, +1], [+1, +2], [-1, +2], [-2, +1], [-2, -1], [-1, -2], [+1, -2]
  ].freeze

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def to_s
    if color == 'white'
      '♞'
    elsif color == 'black'
      '♞'.to_black
    end
  end
end
