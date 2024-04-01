# frozen_string_literal: true

require_relative '../lib/board/board'
require_relative '../lib/game/game'

# rubocop:disable Metrics/BlockLength, Layout/LineLength, Layout/FirstArrayElementIndentation

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

      context 'when castling is possible' do
        before do
          board.instance_variable_set(:@cells, [
            {
              a: Rook.new('black'), b: Knight.new('black'), c: Bishop.new('black'), d: Queen.new('black'),
              e: King.new('black'), f: Bishop.new('black'), g: Knight.new('black'), h: Rook.new('black')
            },
            { a: Pawn.new('black'), b: Pawn.new('black'), c: Pawn.new('black'), d: Pawn.new('black'),
              e: Pawn.new('black'), f: Pawn.new('black'), g: Pawn.new('black'), h: Pawn.new('black') },
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: Bishop.new('white'), d: '   ', e: Pawn.new('white'), f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: Knight.new('white'), d: '   ', e: '   ', f: Knight.new('white'), g: '   ', h: '   ' },
            { a: Pawn.new('white'), b: Pawn.new('white'), c: Pawn.new('white'), d: Pawn.new('white'),
              e: '   ', f: Pawn.new('white'), g: Pawn.new('white'), h: Pawn.new('white') },
            {
              a: Rook.new('white'), b: '   ', c: Bishop.new('white'), d: Queen.new('white'),
              e: King.new('white'), f: '   ', g: '   ', h: Rook.new('white')
            }
          ])
        end

        it 'returns array of possible moves for King including castling move' do
          moves = board.possible_moves([7, :e])
          castling_move = [7, :g]
          expect(moves).to include(castling_move)
        end
      end

      context 'when castling is not possible' do
        context 'when path is not empty' do
          before do
            board.instance_variable_set(:@cells, [
              {
                a: Rook.new('black'), b: Knight.new('black'), c: Bishop.new('black'), d: Queen.new('black'),
                e: King.new('black'), f: Bishop.new('black'), g: Knight.new('black'), h: Rook.new('black')
              },
              { a: Pawn.new('black'), b: Pawn.new('black'), c: Pawn.new('black'), d: Pawn.new('black'),
                e: Pawn.new('black'), f: Pawn.new('black'), g: Pawn.new('black'), h: Pawn.new('black') },
              { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
              { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
              { a: '   ', b: '   ', c: '   ', d: '   ', e: Pawn.new('white'), f: '   ', g: '   ', h: '   ' },
              { a: '   ', b: '   ', c: Knight.new('white'), d: '   ', e: '   ', f: Knight.new('white'), g: '   ', h: '   ' },
              { a: Pawn.new('white'), b: Pawn.new('white'), c: Pawn.new('white'), d: Pawn.new('white'),
                e: '   ', f: Pawn.new('white'), g: Pawn.new('white'), h: Pawn.new('white') },
              {
                a: Rook.new('white'), b: '   ', c: Bishop.new('white'), d: Queen.new('white'),
                e: King.new('white'), f: Bishop.new('white'), g: '   ', h: Rook.new('white')
              }
            ])
          end

          it 'returns array of possible moves for King without castling move' do
            moves = board.possible_moves([7, :e])
            castling_move = [7, :g]
            expect(moves).not_to include(castling_move)
          end
        end

        context 'when path is attacked by a pawn' do
          before do
            board.instance_variable_set(:@cells, [
              {
                a: Rook.new('black'), b: Knight.new('black'), c: Bishop.new('black'), d: Queen.new('black'),
                e: King.new('black'), f: Bishop.new('black'), g: Knight.new('black'), h: Rook.new('black')
              },
              { a: Pawn.new('black'), b: Pawn.new('black'), c: Pawn.new('black'), d: Pawn.new('black'),
                e: Pawn.new('black'), f: '   ', g: Pawn.new('black'), h: Pawn.new('black') },
              { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
              { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
              { a: '   ', b: '   ', c: Bishop.new('white'), d: '   ', e: Pawn.new('white'), f: '   ', g: '   ', h: '   ' },
              { a: '   ', b: '   ', c: Knight.new('white'), d: '   ', e: '   ', f: Knight.new('white'), g: '   ', h: '   ' },
              { a: Pawn.new('white'), b: Pawn.new('white'), c: Pawn.new('white'), d: Pawn.new('white'),
                e: Pawn.new('black'), f: Pawn.new('white'), g: Pawn.new('white'), h: Pawn.new('white') },
              {
                a: Rook.new('white'), b: '   ', c: Bishop.new('white'), d: Queen.new('white'),
                e: King.new('white'), f: '   ', g: '   ', h: Rook.new('white')
              }
            ])
          end

          it 'returns array of possible moves for King without castling move' do
            moves = board.possible_moves([7, :e])
            castling_move = [7, :g]
            expect(moves).not_to include(castling_move)
          end
        end
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
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' }
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
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' }
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
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' }
          ])
          board.cells[3][:d].update_status
        end

        it 'returns array of possible moves for Pawn without double step move' do
          moves = board.possible_moves([3, :d])
          double_step_move = [1, :d]
          expect(moves).not_to include(double_step_move)
        end
      end

      context 'when taking en-passant is possible' do
        before do
          board.instance_variable_set(:@cells, [
            {
              a: Rook.new('black'), b: Knight.new('black'), c: Bishop.new('black'), d: Queen.new('black'),
              e: King.new('black'), f: Bishop.new('black'), g: Knight.new('black'), h: Rook.new('black')
            },
            { a: Pawn.new('black'), b: Pawn.new('black'), c: '   ', d: Pawn.new('black'),
              e: Pawn.new('black'), f: Pawn.new('black'), g: Pawn.new('black'), h: Pawn.new('black') },
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: Knight.new('white'), h: '   ' },
            { a: '   ', b: '   ', c: Pawn.new('black'), d: Pawn.new('white'), e: '   ', f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
            { a: Pawn.new('white'), b: Pawn.new('white'), c: Pawn.new('white'), d: '   ',
              e: Pawn.new('white'), f: Pawn.new('white'), g: Pawn.new('white'), h: Pawn.new('white') },
            {
              a: Rook.new('white'), b: Knight.new('white'), c: Bishop.new('white'), d: Queen.new('white'),
              e: King.new('white'), f: Bishop.new('white'), g: '   ', h: Rook.new('white')
            }
          ])
          board.cells[4][:c].update_status
          board.cells[4][:d].just_made_double_step = true
          game.send(:switch_current_player)
        end

        it 'returns array of possible moves for Pawn with en-passant move' do
          moves = board.possible_moves([4, :c])
          available_moves = [[5, :c], [5, :d]]
          expect(moves).to eql(available_moves)
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
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: King.new('black'), g: '   ', h: '   ' }
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
          { a: Rook.new('white'), b: Queen.new('white'), c: King.new('white'), d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' }
        ])
        game.send(:switch_current_player)
        allow(board).to receive(:puts)
      end

      it 'returns true' do
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

      it 'returns false' do
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
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: King.new('black'), g: '   ', h: '   ' }
        ])
      end

      it 'returns false' do
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
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: King.new('black'), g: '   ', h: '   ' }
        ])
      end

      it 'returns false' do
        allow(board).to receive(:puts)

        mate = board.mate?
        expect(mate).to be(false)
      end
    end
  end

  describe '#stalemate?' do
    context 'when there is stalemate' do
      before do
        board.instance_variable_set(:@cells, [
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: King.new('white') },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: Rook.new('black'), h: King.new('black') },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' }
        ])
      end

      it 'returns true' do
        stalemate = board.stalemate?
        expect(stalemate).to be(true)
      end
    end

    context 'when there is no stalemate' do
      before do
        board.instance_variable_set(:@cells, [
          { a: King.new('black'), b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: Rook.new('white'), b: Queen.new('white'), c: King.new('white'), d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' }
        ])
        game.send(:switch_current_player)
        allow(board).to receive(:puts)
      end

      it 'returns true' do
        stalemate = board.stalemate?
        expect(stalemate).to be(false)
      end
    end
  end

  describe '#move_piece' do
    context 'when castling' do
      before do
        board.instance_variable_set(:@cells, [
            {
              a: Rook.new('black'), b: Knight.new('black'), c: Bishop.new('black'), d: Queen.new('black'),
              e: King.new('black'), f: Bishop.new('black'), g: Knight.new('black'), h: Rook.new('black')
            },
            { a: Pawn.new('black'), b: Pawn.new('black'), c: Pawn.new('black'), d: Pawn.new('black'),
              e: Pawn.new('black'), f: Pawn.new('black'), g: Pawn.new('black'), h: Pawn.new('black') },
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: Bishop.new('white'), d: '   ', e: Pawn.new('white'), f: '   ', g: '   ', h: '   ' },
            { a: '   ', b: '   ', c: Knight.new('white'), d: '   ', e: '   ', f: Knight.new('white'), g: '   ', h: '   ' },
            { a: Pawn.new('white'), b: Pawn.new('white'), c: Pawn.new('white'), d: Pawn.new('white'),
              e: '   ', f: Pawn.new('white'), g: Pawn.new('white'), h: Pawn.new('white') },
            {
              a: Rook.new('white'), b: '   ', c: Bishop.new('white'), d: Queen.new('white'),
              e: King.new('white'), f: '   ', g: '   ', h: Rook.new('white')
            }
          ])
      end

      it 'moves Rook piece along with King piece' do
        king_current_coord = [7, :e]
        king_destination_coord = [7, :g]
        board.move_piece(king_current_coord, king_destination_coord)
        moved_rook_coord = [7, :f]
        moved_rook_piece = board.piece_obj_from_coord(moved_rook_coord)
        expect(moved_rook_piece).to be_a(Rook)
      end
    end

    context 'when making double move' do
      it "sets the pawn's @just_made_double_step to true for 1 turn" do
        pawn_current_coord = [6, :c]
        pawn_destination_coord = [4, :c]
        board.move_piece(pawn_current_coord, pawn_destination_coord)
        moved_pawn_piece = board.piece_obj_from_coord(pawn_destination_coord)
        expect(moved_pawn_piece.just_made_double_step).to be(true)
      end

      it 'then sets @just_made_double_step to false' do
        board.move_piece([6, :c], [4, :c])
        game.send(:switch_current_player)
        board.move_piece([0, :b], [2, :a])
        game.send(:switch_current_player)
        board.move_piece([7, :g], [5, :h])
        pawn_piece = board.piece_obj_from_coord([4, :c])
        expect(pawn_piece.just_made_double_step).to be(false)
      end
    end

    context 'when promoting a pawn' do
      before do
        board.instance_variable_set(:@cells, [
          { a: '   ', b: '   ', c: '   ', d: '   ', e: Pawn.new('black'), f: Pawn.new('black'), g: '   ', h: '   ' },
          { a: Pawn.new('white'), b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
          { a: '   ', b: Pawn.new('white'), c: Pawn.new('white'), d: Pawn.new('white'),
            e: Pawn.new('white'), f: Pawn.new('white'), g: Pawn.new('white'), h: Pawn.new('white') },
          {
            a: Rook.new('white'), b: Knight.new('white'), c: Bishop.new('white'), d: Queen.new('white'),
            e: King.new('white'), f: Bishop.new('white'), g: Knight.new('white'), h: Rook.new('white')
          }
        ])
        allow(board).to receive(:puts)
        allow(game).to receive(:print)
        allow(game).to receive(:gets).and_return('q')
      end

      it 'changes the pawn to piece of chosen type' do
        current_pawn_coord = [1, :a]
        last_in_row_coord = [0, :a]
        board.move_piece(current_pawn_coord, last_in_row_coord)
        promoted_piece = board.cells[0][:a]
        expect(promoted_piece).to be_a(Queen)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength, Layout/LineLength, Layout/FirstArrayElementIndentation
