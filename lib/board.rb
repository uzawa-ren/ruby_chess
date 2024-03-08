# frozen_string_literal: true

require 'colorize'
require_relative 'bishop'
require_relative 'king'
require_relative 'knight'
require_relative 'pawn'
require_relative 'queen'
require_relative 'rook'

class Board
  attr_reader :cells

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

  def show(possible_moves = nil)
    cell_index = 0
    row_index = 0
    cells.each do |row|
      row.each_value do |cell|
        print_cell(cell_index, row_index, cell, possible_moves)
        cell_index += 1
      end
      puts ''
      row_index += 1
    end
  end

  private

  def print_cell(cell_index, row_index, cell, possible_moves)
    if possible_moves&.include?
      highlight_cell(cell_index, row_index, cell)
    else
      not_highlight_cell(cell_index, row_index, cell)
    end
  end

  def highlight_cell(cell_index, row_index, cell)
    if even_row?(row_index)
      highlight_cell_in_even_row(cell_index, cell)
    else
      highlight_cell_in_odd_row(cell_index, cell)
    end
  end

  def even_row?(row_index)
    row_index.even?
  end

  def highlight_cell_in_even_row(cell_index, cell)
    if even_cell?(cell_index)
      print cell.to_s.on_blue
    else
      print cell.to_s.on_red
    end
  end

  def highlight_cell_in_odd_row(cell_index, cell)
    if even_cell?(cell_index)
      print cell.to_s.on_red
    else
      print cell.to_s.on_blue
    end
  end

  def even_cell?(cell_index)
    cell_index.even?
  end

  def not_highlight_cell(row_index, cell_index, cell)
    if even_row?(row_index)
      print_cell_in_even_row(cell_index, cell)
    else
      print_cell_in_odd_row(cell_index, cell)
    end
  end

  def print_cell_in_even_row(cell_index, cell)
    if even_cell?(cell_index)
      print cell.to_s.on_yellow
    else
      print cell.to_s.on_gray
    end
  end

  def print_cell_in_odd_row(cell_index, cell)
    if even_cell?(cell_index)
      print cell.to_s.on_gray
    else
      print cell.to_s.on_yellow
    end
  end
end

Board.new.show
