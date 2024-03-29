module Saving
  require 'yaml'

  def save_game
    Dir.mkdir('saves') unless Dir.exist?('saves')
    time = Time.now.strftime('%d-%b-%Y_%H-%M-%S')
    filename = "saves/#{time}_game.yaml"
    File.open(filename, 'w') do |file|
      file.puts YAML.dump('cells': board.cells,
                          'current_player': current_player,
                          'checks': checks,
                          'winners': winners)
    end
    puts "Successfully saved. Type 'quit' or continue playing.".magenta
  end

  def load_game
    if file_list.empty?
      puts "It seems you don't have any saves yet! Starting a new game.".magenta
      return
    end

    save_name = find_save
    load_save(save_name)
    File.delete(save_name) if File.exist?(save_name)
  end

  private

  def find_save
    return if file_list.empty?

    show_save_list
    text = 'Here is your saves. Choose one to load (number): '
    file_number = user_input(text, /\d+/)
    file_list[file_number.to_i - 1]
  end

  def show_save_list
    file_list.each_with_index do |name, index|
      puts "    #{index + 1}. #{name}"
    end
  end

  def file_list
    Dir['saves/*_game.yaml'].sort
  end

  def load_save(save_name)
    save = YAML.safe_load(
      File.read(save_name),
      permitted_classes: [Bishop, King, Knight, Pawn, Queen, Rook, Symbol]
    )
    board.cells = save[:cells]
    @current_player = save[:current_player]
    @checks = save[:checks]
    @winners = save[:winners]
  end
end
