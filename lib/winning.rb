module Winning
  def mate?
    return false unless check?

    checker_team_color = game.checks.find { |_key, value| value == true }[0].to_s
    game.current_player == checker_team_color
  end

  def stalemate?

  end

  # private

  def check?
    mutual_check? || gave_check?('white') || gave_check?('black')
  end

  def mutual_check?
    gave_check?('white') && gave_check?('black')
  end

  def gave_check?(team_color)
    checker_player_pieces = all_pieces(team_color)
    checker_coord = find_checker_coord(checker_player_pieces, team_color)
    unless checker_coord
      game.checks[team_color] = false
      return false
    end

    notify_of_check(checker_coord, team_color) unless notified?(team_color)
    game.winners << team_color
    game.checks[team_color] = true
  end

  def all_pieces(team_color)
    result_array = []
    cells.each_with_index do |row, row_index|
      row.each do |letter, cell|
        next if empty_cell?(cell)

        result_array << [row_index, letter] if cell.color == team_color
      end
    end
    result_array
  end

  def find_checker_coord(checker_player_pieces, team_color)
    checker_player_pieces.find { |piece| king_in_next_moves?(piece, team_color) }
  end

  def king_in_next_moves?(piece, team_color)
    other_team_color = game.other_player(team_color)
    possible_moves(piece).any? do |next_coord|
      next_coord == king_position(other_team_color)
    end
  end

  def notify_of_check(checker_coord, team_color)
    checker = string_of_checker(checker_coord)
    receiver = string_of_receiver(team_color)
    puts "#{checker} gives check to #{receiver}!".magenta
  end

  def string_of_checker(checker_coord)
    checker_piece = piece_obj_from_coord(checker_coord)
    "#{checker_piece.color} #{checker_piece.class}".capitalize
  end

  def string_of_receiver(team_color)
    other_team_color = game.other_player(team_color)
    receiver_piece = piece_obj_from_coord(king_position(other_team_color))
    "#{receiver_piece.color} #{receiver_piece.class}".downcase
  end

  def notified?(team_color)
    !!game.checks[team_color]
  end
end
