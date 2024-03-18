# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/game'

describe Game do
  subject(:game) { described_class.new }

  describe '#user_input' do
    context 'when user inputs correct value' do
      before do
        valid_input = 'c2'
        allow(game).to receive(:gets).and_return(valid_input)
      end

      it 'completes loop and does not display error message' do
        error_message = "\e[0;31;49mInput error!\e[0m"
        expect(game).not_to receive(:puts).with(error_message)
        game.user_input
      end
    end

    context 'when user inputs an incorrect value once, then a valid input' do
      before do
        off_board_input = 'w9'
        valid_input = 'g1'
        allow(game).to receive(:gets).and_return(off_board_input, valid_input)
      end

      it 'completes loop and displays error message once' do
        error_message = "\e[0;31;49mInput error!\e[0m"
        expect(game).to receive(:puts).with(error_message).once
        game.user_input
      end
    end
  end

  describe '#verify_input' do
    context 'when given input is correct' do
      it 'returns that input' do
        input = [6, :h]
        empty_next_moves = ['default value']
        verified_input = game.verify_input(input, empty_next_moves)
        expect(verified_input).to eql(input)
      end
    end

    context 'when given input is off' do
      it 'returns nil' do
        invalid_input = [15, :q]
        empty_next_moves = ['default value']
        verified_input = game.verify_input(invalid_input, empty_next_moves)
        expect(verified_input).to be_nil
      end
    end

    context 'when given input is different color' do
      it 'returns nil' do
        invalid_input = [1, :c]
        empty_next_moves = ['default value']
        verified_input = game.verify_input(invalid_input, empty_next_moves)
        expect(verified_input).to be_nil
      end
    end

    context 'when given input is not occupied' do
      it 'returns nil' do
        invalid_input = [5, :c]
        empty_next_moves = ['default value']
        verified_input = game.verify_input(invalid_input, empty_next_moves)
        expect(verified_input).to be_nil
      end
    end

    context 'when the given input is not the next move of a previously given piece' do
      it 'returns nil' do
        invalid_input = [6, :c]
        next_moves = [[5, :a], [4, :a]]
        verified_input = game.verify_input(invalid_input, next_moves)
        expect(verified_input).to be_nil
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
