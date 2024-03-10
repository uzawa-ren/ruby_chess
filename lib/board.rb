# frozen_string_literal: true

require 'colorize'
require_relative 'bishop'
require_relative 'king'
require_relative 'knight'
require_relative 'pawn'
require_relative 'queen'
require_relative 'rook'
require_relative 'displayable'

class Board
  include Displayable
  attr_reader :cells

  def initialize # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    @cells = [
      {
        a: Rook.new('black'), b: Knight.new('black'), c: Bishop.new('black'), d: Queen.new('black'),
        e: King.new('black'), f: Bishop.new('black'), g: Knight.new('black'), h: Rook.new('black')
      },
      { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
      { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
      { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
      { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
      { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
      { a: Pawn.new('white'), b: Pawn.new('white'), c: Pawn.new('white'), d: Pawn.new('white'),
        e: Pawn.new('white'), f: Pawn.new('white'), g: Pawn.new('white'), h: Pawn.new('white') },
      {
        a: Rook.new('white'), b: Knight.new('white'), c: Bishop.new('white'), d: Queen.new('white'),
        e: King.new('white'), f: Bishop.new('white'), g: Knight.new('white'), h: Rook.new('white')
      }
    ]
  end

  def show(possible_moves = [])
    cell_index = 0
    row_index = 0
    cells.each do |row|
      print_row(cell_index, row_index, row, possible_moves)
      puts ''
      row_index += 1
    end
  end

  def possible_moves(coord)
    piece = piece_obj_from_coord(coord)
    return if piece.is_a?(String)

    directions = piece.class.move_directions
    find_all_moves(coord, directions, piece.class)
  end

  private

  def piece_obj_from_coord(coord)
    cells[coord[0]][coord[1]]
  end

  def find_all_moves(coord, directions, piece_class)
    result_array = []
    directions.each do |direction|
      if piece_class.moves_linearly?
        find_line_of_next_moves(coord, direction, result_array)
      else
        result_array << find_next_coord(coord, direction)
      end
    end
    result_array
  end

  def find_line_of_next_moves(coord, direction, result_array)
    next_coord = find_next_coord(coord, direction)
    until invalid?(next_coord)
      result_array << next_coord
      next_coord = find_next_coord(next_coord, direction)
    end
  end

  def find_next_coord(next_coord, direction)
    next_row = next_coord[0].to_i + direction[0]
    next_letter = find_next_letter(next_coord, direction)
    next_coord = [next_row, next_letter]
    next_coord unless invalid?(next_coord)
  end

  def invalid?(coord)
    off?(coord) || occupied?(coord)
  end

  def off?(coord)
    coord.nil? || !coord[0]&.between?(0, 7) || !coord[1]&.between?(:a, :h)
  end

  def occupied?(coord)
    !cells[coord[0]][coord[1]].is_a?(String)
  end

  def find_next_letter(coord, direction)
    num_to_letter_dict = %i[a b c d e f g h]
    current_letter_index = num_to_letter_dict.index(coord[1])
    next_letter_index = current_letter_index + direction[1]
    num_to_letter(next_letter_index)
  end

  def find_coord(cell_index, row_index)
    [row_index, num_to_letter(cell_index)]
  end

  def num_to_letter(num)
    return if num.negative?

    num_to_letter_dict = %i[a b c d e f g h]
    num_to_letter_dict[num]
  end
end

Board.new.show(Board.new.possible_moves([7, :g]))
