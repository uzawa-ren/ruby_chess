# frozen_string_literal: true

require_relative '../lib/board'

# rubocop:disable Metrics/BlockLength, Layout/LineLength

describe Board do
  subject(:board) { described_class.new }

  describe '#possible_moves' do
    context 'when passed coordinate with Bishop piece' do
      before do
        board.instance_variable_set(:@cells, [
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: Pawn.new('white'), c: '   ', d: '   ', e: '   ', f: Rook.new('black'), g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: Bishop.new('white'), e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: Knight.new('black'), f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' }
        ])
      end

      it 'returns array of possible moves for Bishop' do
        moves = board.possible_moves([3, :d])
        available_moves = [[4, :c], [5, :b], [6, :a], [4, :e], [2, :c], [2, :e], [1, :f]]
        expect(moves).to eql(available_moves)
      end
    end

    context 'when passed coordinate with King piece' do
      before do
        board.instance_variable_set(:@cells, [
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: Rook.new('black'), e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: Pawn.new('white'), d: King.new('white'), e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: Knight.new('white'), e: Knight.new('black'), f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' }
        ])
      end

      it 'returns array of possible moves for King' do
        moves = board.possible_moves([3, :d])
        available_moves = [[4, :c], [4, :e], [3, :e], [2, :e], [2, :d], [2, :c]]
        expect(moves).to include(*available_moves)
      end
    end

    context 'when passed coordinate with Knight piece' do
      before do
        board.instance_variable_set(:@cells, [
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: Rook.new('black'), g: '   ', h: '   ' },
          { a: '   ', b: Pawn.new('white'), c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: Knight.new('white'), e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: Pawn.new('white'), g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: Knight.new('black'), f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' }
        ])
      end

      it 'returns array of possible moves for Knight' do
        moves = board.possible_moves([3, :d])
        available_moves = [[5, :c], [5, :e], nil, [2, :f], [1, :e], [1, :c], nil, [4, :b]]
        expect(moves).to include(*available_moves)
      end
    end

    context 'when passed coordinate with Pawn piece' do
      context 'when there are no pieces to take' do
        before do
          board.instance_variable_set(:@cells, [
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: '   ', d: Pawn.new('white'), e: '   ', f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          ])
          board.cells[3][:d].update_status
        end

        it 'returns array of possible moves for Pawn without dianogal moves' do
          moves = board.possible_moves([3, :d])
          available_move = [[2, :d]]
          expect(moves).to include(*available_move)
        end
      end

      context 'when there are 2 pieces to take' do
        before do
          board.instance_variable_set(:@cells, [
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: Pawn.new('black'), d: '   ', e: Knight.new('black'), f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: '   ', d: Pawn.new('white'), e: '   ', f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          ])
        end

        it 'returns array of possible moves for Pawn with both dianogal moves' do
          moves = board.possible_moves([3, :d])
          available_moves = [[2, :c], [2, :d], [2, :e], [1, :d]]
          expect(moves).to include(*available_moves)
        end
      end

      context 'when a Pawn has moved from its starting position' do
        before do
          board.instance_variable_set(:@cells, [
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: Pawn.new('black'), d: '   ', e: Knight.new('black'), f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: '   ', d: Pawn.new('white'), e: '   ', f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          ])
          board.cells[3][:d].update_status
        end

        it 'returns array of possible moves for Pawn without double step move' do
          moves = board.possible_moves([3, :d])
          double_step_move = [1, :d]
          expect(moves).not_to include(double_step_move)
        end
      end
    end

    context 'when passed coordinate with Queen piece' do
      before do
        board.instance_variable_set(:@cells, [
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: Rook.new('black'), e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: Pawn.new('white'), c: '   ', d: Queen.new('white'), e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: Knight.new('black'), f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' }
        ])
      end

      it 'returns array of possible moves for Queen' do
        moves = board.possible_moves([3, :d])
        available_moves = [[4, :c], [5, :b], [6, :a], [4, :d], [5, :d], [6, :d], [7, :d], [4, :e], [3, :e], [3, :f], [3, :g], [3, :h], [2, :e], [1, :f], [0, :g], [2, :d], [1, :d], [2, :c], [1, :b], [0, :a], [3, :c]]
        expect(moves).to eql(available_moves)
      end
    end

    context 'when passed coordinate with Rook piece' do
      before do
        board.instance_variable_set(:@cells, [
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: Rook.new('black'), e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: Pawn.new('white'), c: '   ', d: Rook.new('white'), e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: Knight.new('black'), f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' }
        ])
      end

      it 'returns array of possible moves for Rook' do
        moves = board.possible_moves([3, :d])
        available_moves = [[4, :d], [5, :d], [6, :d], [7, :d], [3, :e], [3, :f], [3, :g], [3, :h], [2, :d], [1, :d], [3, :c]]
        expect(moves).to eql(available_moves)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength, Layout/LineLength
