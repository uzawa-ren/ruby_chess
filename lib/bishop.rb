# frozen_string_literal: true

require 'colorize'

class Bishop
  MOVE_DIRECTIONS = [
    [+1, -1], [+1, +1], [-1, -1], [-1, +1]
  ].freeze

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def to_s
    if color == 'white'
      ' ♝ '
    elsif color == 'black'
      ' ♝ '.black
    end
  end
end
