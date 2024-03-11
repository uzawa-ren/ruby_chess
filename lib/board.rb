# frozen_string_literal: true

require 'colorize'
require_relative 'bishop'
require_relative 'king'
require_relative 'knight'
require_relative 'pawn'
require_relative 'queen'
require_relative 'rook'
require_relative 'displayable'

class Board # rubocop:disable Metrics/ClassLength
  include Displayable
  attr_reader :cells

  def initialize # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    @cells = [
      {
        a: Rook.new('black'), b: Knight.new('black'), c: Bishop.new('black'), d: Queen.new('black'),
        e: King.new('black'), f: Bishop.new('black'), g: Knight.new('black'), h: Rook.new('black')
      },
      { a: '   ', b: '   ', c: '   ', d: '   ', e: Pawn.new('white'), f: '   ', g: '   ', h: '   ' },
      { a: '   ', b: Pawn.new('white'), c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
      { a: '   ', b: '   ', c: '   ', d: Pawn.new('black'), e: '   ', f: '   ', g: '   ', h: '   ' },
      { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
      { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
      { a: '   ', b: Pawn.new('white'), c: Pawn.new('white'), d: Pawn.new('white'),
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
    return if empty_cell?(piece)

    directions = piece.class.move_directions
    find_all_moves(coord, directions, piece)
  end

  private

  def piece_obj_from_coord(coord)
    cells[coord[0]][coord[1]]
  end

  def find_all_moves(coord, directions, piece)
    result_array = []
    directions.each do |direction|
      result_array << if piece.class.moves_linearly?
                        find_line_of_next_moves(coord, direction, piece.color)
                      else
                        find_next_coord(coord, direction)
                      end
    end
    result_array.flatten(1)
  end

  def find_line_of_next_moves(coord, direction, piece_color)
    result_array = []
    next_coord = find_next_coord(coord, direction, piece_color)
    while next_coord
      result_array << next_coord
      next_coord = find_next_coord(next_coord, direction, piece_color)
    end
    result_array
  end

  def find_next_coord(coord, direction, piece_color)
    next_row = coord[0].to_i + direction[0]
    next_letter = find_next_letter(coord, direction)
    next_coord = [next_row, next_letter]
    next_coord unless invalid?(next_coord, coord, piece_color)
  end

  def invalid?(coord, prev_coord, team_color)
    off?(coord) || occupied_by_same_team?(coord, team_color) ||
      crashed_into_opponent_piece?(coord, prev_coord, team_color)
  end

  def off?(coord)
    return false if coord.nil?

    !coord[0]&.between?(0, 7) || !coord[1]&.between?(:a, :h)
  end

  def occupied_by_same_team?(coord, piece_color)
    cell = cells[coord[0]][coord[1]]
    return false if empty_cell?(cell)

    cell.color == piece_color
  end

  def crashed_into_opponent_piece?(coord, prev_coord, team_color)
    curr_cell = cells[coord[0]][coord[1]]
    prev_cell = cells[prev_coord[0]][prev_coord[1]]
    return false if empty_cell?(prev_cell)

    prev_cell.color != team_color && empty_cell?(curr_cell)
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

  def empty_cell?(cell)
    cell.is_a?(String)
  end
end

Board.new.show(Board.new.possible_moves([0, :d]))
