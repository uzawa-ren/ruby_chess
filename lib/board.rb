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
        a: Rook.new,
        b: Knight.new,
        c: Bishop.new,
        d: Queen.new,
        e: King.new,
        f: Bishop.new,
        g: Knight.new,
        h: Rook.new
      },
      { a: Pawn.new, b: Pawn.new, c: Pawn.new, d: Pawn.new,
        e: Pawn.new, f: Pawn.new, g: Pawn.new, h: Pawn.new },
      {},
      {},
      {},
      {},
      { a: Pawn.new, b: Pawn.new, c: Pawn.new, d: Pawn.new,
        e: Pawn.new, f: Pawn.new, g: Pawn.new, h: Pawn.new },
      {
        a: Rook.new,
        b: Knight.new,
        c: Bishop.new,
        d: Queen.new,
        e: King.new,
        f: Bishop.new,
        g: Knight.new,
        h: Rook.new
      }
    ]
  end

  def show(possible_moves = nil)
    index = 0
    cells.each do |line|
      line.each do |cell|
        if possible_moves&.include?
          highlight_cell(index, cell)
        else
          print_cell(index, cell)
        end
      end
    end
  end

  private

  def highlight_cell(index, cell)
    if index.odd?
      print cell.on_green
    else
      print cell.on_red
    end
  end

  def print_cell(index, cell)
    if index.odd?
      print cell.on_yellow
    else
      print cell.on_gray
    end
  end
end

Board.new.show
