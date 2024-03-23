# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/game'
require 'yaml'

describe Game do
  subject(:game) { described_class.new }

  describe '#coord_input' do
    context 'when user inputs value for coordinate to move' do
      context 'when user inputs correct value' do
        before do
          valid_input = 'c2'
          allow(game).to receive(:gets).and_return(valid_input)
          allow(game).to receive(:print)
        end

        it 'completes loop and does not display error message' do
          error_message = "\e[0;31;49mInput error!\e[0m"
          prompt = "Select the piece you want to move. You can also type 'save' or 'quit: "
          empty_next_moves = ['default value']

          expect(game).not_to receive(:puts).with(error_message)
          game.coord_input(prompt, empty_next_moves)
        end
      end

      context 'when user inputs an incorrect value once, then a valid input' do
        before do
          off_board_input = 'w9'
          valid_input = 'g1'
          allow(game).to receive(:gets).and_return(off_board_input, valid_input)
          allow(game).to receive(:print)
        end

        it 'completes loop and displays error message once' do
          error_message = "\e[0;31;49mInput error!\e[0m"
          prompt = "Select the piece you want to move. You can also type 'save' or 'quit: "
          empty_next_moves = ['default value']

          expect(game).to receive(:puts).with(error_message).once
          game.coord_input(prompt, empty_next_moves)
        end
      end
    end

    context 'when user inputs value for destination coordinate' do
      context 'when user inputs correct value' do
        before do
          valid_input = 'c2'
          allow(game).to receive(:gets).and_return(valid_input)
          allow(game).to receive(:print)
        end

        it 'completes loop and does not display error message' do
          error_message = "\e[0;31;49mInput error!\e[0m"
          prompt = "Now select the cell you want to move to or type 'r' to reselect piece: "
          next_moves = [[5, :d], [6, :c], [1, :a]]

          expect(game).not_to receive(:puts).with(error_message)
          game.coord_input(prompt, next_moves)
        end
      end

      context 'when user inputs an incorrect value once, then a valid input' do
        before do
          not_next_move_input = '4b'
          valid_input = 'g1'
          allow(game).to receive(:gets).and_return(not_next_move_input, valid_input)
          allow(game).to receive(:print)
        end

        it 'completes loop and displays error message once' do
          error_message = "\e[0;31;49mInput error!\e[0m"
          prompt = "Now select the cell you want to move to or type 'r' to reselect piece: "
          next_moves = [[5, :d], [6, :c], [7, :g]]

          expect(game).to receive(:puts).with(error_message).once
          game.coord_input(prompt, next_moves)
        end
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

  describe '#save_game' do
    let(:cells) { game.board.instance_variable_get(:@cells) }
    let(:current_player) { game.instance_variable_get(:@current_player) }

    before do
      game.board.instance_variable_set(:@cells, [
        { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
        { a: '   ', b: King.new('white'), c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
        { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
        { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
        { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
        { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' },
        { a: '   ', b: '   ', c: '   ', d: '   ', e: King.new('black'), f: '   ', g: '   ', h: '   ' },
        { a: '   ', b: '   ', c: '   ', d: '   ', e: '   ', f: '   ', g: '   ', h: '   ' }
      ])
      allow(game).to receive(:puts)
    end

    it 'creates a file' do
      game.save_game
      save_file = Dir['saves/*_game.yaml'].sort.last

      expect(save_file).not_to be_empty # so it exists
      File.delete(save_file)
    end

    it 'writes the same @cells and @current_player inside saved file' do
      game.save_game

      save_file = Dir['saves/*_game.yaml'].sort.last
      saved_data = YAML.safe_load(
        File.read(save_file),
        permitted_classes: [Bishop, King, Knight, Pawn, Queen, Rook, Symbol]
      )
      data = {cells:, current_player:} # rubocop:disable Lint/Syntax
      expect(saved_data).to eq(data)
      File.delete(save_file)
    end
  end

  describe '#load_game' do
    let(:cells) { game.board.instance_variable_get(:@cells) }
    let(:current_player) { game.instance_variable_get(:@current_player) }

    before do
      allow(game).to receive(:puts)
      allow(game).to receive(:print)
      game.save_game
      game.board.instance_variable_set(:@current_player, 'black')
      allow(game).to receive(:gets).and_return '1'
    end

    it 'loads game with saved values' do
      game.load_game
      expect(current_player).to eql('white')
    end
  end
end

# rubocop:enable Metrics/BlockLength
