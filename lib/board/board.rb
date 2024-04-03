# frozen_string_literal: true

require 'colorize'
require_relative '../pieces/bishop'
require_relative '../pieces/king'
require_relative '../pieces/knight'
require_relative '../pieces/pawn'
require_relative '../pieces/queen'
require_relative '../pieces/rook'
require_relative 'board_filling'
require_relative 'display'
require_relative 'moves_finding'
require_relative 'pawn_moves_finding'
require_relative 'moving'
require_relative 'winning'
require_relative 'castling'

class Board
  include BoardFilling
  include Display
  include MovesFinding
  include PawnMovesFinding
  include Moving
  include Winning
  include Castling
  attr_reader :coord_to_move, :destination_coord, :game, :queue
  attr_accessor :cells

  def initialize(game)
    fill_board
    @game = game
    @queue = []
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

  def empty_cell_by_coord?(coord)
    empty_cell?(piece_obj_from_coord(coord))
  end

  def update_coord_to_move(coord)
    @coord_to_move = coord
  end

  def update_destination_coord(coord)
    @destination_coord = coord
  end

  def valid_piece?(coord)
    not_off?(coord) && current_player_color?(coord) && occupied_coord?(coord)
  end

  def next_move?(input, next_moves)
    next_moves.include?(input)
  end

  private

  def not_off?(input)
    !off?(input)
  end

  def current_player_color?(input)
    piece = piece_obj_from_coord(input)
    return true if empty_cell?(piece)

    piece.color == game.current_player
  end

  def occupied_coord?(coord)
    piece = piece_obj_from_coord(coord)
    !empty_cell?(piece)
  end

  def off?(coord)
    return false if coord.nil?

    !coord[0]&.between?(0, 7) || !coord[1]&.between?(:a, :h)
  end

  def king_position(team_color)
    cells.each_with_index do |row, index|
      cell_with_king = row.find { |_letter, cell| cell.is_a?(King) && cell.color == team_color }
      next unless cell_with_king

      finded_coord_letter = cell_with_king[0]
      finded_coord_number = index
      finded_coord = [finded_coord_number, finded_coord_letter]
      return finded_coord
    end
  end
end
