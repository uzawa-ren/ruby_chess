# frozen_string_literal: true

require 'colorize'
require_relative 'pieces/bishop'
require_relative 'pieces/king'
require_relative 'pieces/knight'
require_relative 'pieces/pawn'
require_relative 'pieces/queen'
require_relative 'pieces/rook'
require_relative 'display'
require_relative 'moves_finding'
require_relative 'moving'

class Board
  include Display
  include MovesFinding
  include Moving
  attr_reader :coord_to_move, :destination_coord
  attr_accessor :cells

  def initialize # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    @cells = [
      {
        a: Rook.new('black'), b: Knight.new('black'), c: Bishop.new('black'), d: Queen.new('black'),
        e: King.new('black'), f: Bishop.new('black'), g: Knight.new('black'), h: Rook.new('black')
      },
      { a: Pawn.new('black'), b: Pawn.new('black'), c: Pawn.new('black'), d: Pawn.new('black'),
        e: Pawn.new('black'), f: Pawn.new('black'), g: Pawn.new('black'), h: Pawn.new('black') },
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
    puts '    a  b  c  d  e  f  g  h'.gray
    cell_index = 0
    row_index = 0
    cells.each do |row|
      print " #{(row_index - 8).abs} ".gray
      print_row(cell_index, row_index, row, possible_moves)
      puts ''
      row_index += 1
    end
  end

  def empty_cell?(cell)
    cell.is_a?(String)
  end

  def piece_obj_from_coord(coord)
    cells[coord[0]][coord[1]]
  end

  def occupied_coord?(coord)
    piece = piece_obj_from_coord(coord)
    !empty_cell?(piece)
  end

  def update_coord_to_move(coord)
    @coord_to_move = coord
  end

  def update_destination_coord(coord)
    @destination_coord = coord
  end

  private

  def invalid?(coord, prev_coord, team_color, direction)
    return true if off?(coord)

    cell = piece_obj_from_coord(coord)
    prev_cell = piece_obj_from_coord(prev_coord)

    occupied_by_same_team?(cell, team_color) ||
      crashed_into_opponent_piece?(cell, prev_cell, team_color) ||
      (invalid_pawn_move?(coord, prev_coord, team_color, direction) if prev_cell.instance_of?(Pawn))
  end

  def off?(coord)
    return false if coord.nil?

    !coord[0]&.between?(0, 7) || !coord[1]&.between?(:a, :h)
  end
end
