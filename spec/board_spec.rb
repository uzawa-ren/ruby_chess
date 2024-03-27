# frozen_string_literal: true

require_relative '../lib/board'
require_relative '../lib/game'

# rubocop:disable Metrics/BlockLength, Layout/LineLength

describe Board do
  let(:game) { Game.new }
  subject(:board) { described_class.new(game) }

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
        available_moves = [[5, :c], [5, :e], [2, :f], [1, :e], [1, :c], [4, :b]]
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

  describe '#check?' do
    context 'when there is a check' do
      before do
        board.instance_variable_set(:@cells, [
          { a: Knight.new('white'), b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: King.new('white'), f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: Knight.new('black'), e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: King.new('black'), g: '   ', h: '   ' },
        ])
      end

      it 'returns true' do
        allow(board).to receive(:puts)

        check = board.check?
        expect(check).to be(true)
      end

      it 'displays the correct message' do
        correct_message = 'Black knight gives check to white king!'.magenta

        expect(board).to receive(:puts).with(correct_message)
        board.check?
      end
    end

    context 'when there is no check' do
      it 'returns false' do
        allow(board).to receive(:puts)

        check = board.check?
        expect(check).to be(false)
      end

      it 'does not display any messages' do
        expect(board).not_to receive(:puts)
        board.check?
      end
    end
  end

  describe '#mate?' do
    context 'when there is a mate' do
      before do
        board.instance_variable_set(:@cells, [
          { a: King.new('black'), b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: Rook.new('white'), b: Queen.new('white'), c: King.new('white'), d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
        ])
        game.instance_variable_set(:@board, board)
        game.send(:switch_current_player)
        allow(game).to receive(:puts)
        allow(game).to receive(:print)
        allow(board).to receive(:puts)
        allow(board).to receive(:print)
        allow(game).to receive(:gets).and_return('a8', 'a7')
      end

      it 'returns true' do
        game.send(:turns)

        mate = board.mate?
        expect(mate).to be(true)
      end
    end

    context 'when king moves away to a square where he is not in check' do
      before do
        board.instance_variable_set(:@cells, [
          { a: Knight.new('white'), b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: King.new('white'), f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: Knight.new('black'), e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: King.new('black'), g: '   ', h: '   ' }
        ])
      end

      xit 'returns false' do
        allow(board).to receive(:puts)

        mate = board.mate?
        expect(mate).to be(false)
      end
    end

    context 'when check is removed by taking checker piece' do
      before do
        board.instance_variable_set(:@cells, [
          { a: Knight.new('white'), b: '   ', c: '   ', d: Pawn.new('white'), e: Pawn.new('white'), f: Pawn.new('white'), g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: Pawn.new('white'), e: King.new('white'), f: Pawn.new('white'), g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: Rook.new('white'), e: Pawn.new('white'), f: Pawn.new('white'), g: '   ', h: '   ' },
          { a: '   ', b: Rook.new('white'), c: '   ', d: Knight.new('black'), e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: King.new('black'), g: '   ', h: '   ' },
        ])
        board.show
      end

      xit 'returns false' do
        allow(board).to receive(:puts)

        mate = board.mate?
        expect(mate).to be(false)
      end
    end

    context 'when check is removed by placing another piece in front of moving linearly checker (e.g. Rook)' do
      before do
        board.instance_variable_set(:@cells, [
          { a: Knight.new('white'), b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: King.new('white'), g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: Pawn.new('white'), f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: Rook.new('black'), e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: King.new('black'), g: '   ', h: '   ' },
        ])
      end

      xit 'returns false' do
        allow(board).to receive(:puts)

        mate = board.mate?
        expect(mate).to be(false)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength, Layout/LineLength
