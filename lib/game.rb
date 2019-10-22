class Game
  attr_reader :pot
  def initialize(player_list, options = {})
    @player_list = player_list
    @current_index = 0
    @left_index = player_list.count - 1
    @right_index = 1
    @pot = 0
    @silent = true if options[:silent]
  end

  def roll
    @player = @player_list[@current_index]
    output = []
    [@player.dollars, 3].min.times do
      case roll_dice()
      when "L"
        @player_list[@left_index].dollars += 1
        @player.dollars -= 1
        output << "L"
      when "R"
        @player_list[@right_index].dollars += 1
        @player.dollars -= 1
        output << "R"
      when "C"
        @pot += 1
        @player.dollars -= 1
        output << "C"
      else
        output << "*"
      end
    end
    puts "#{@player.name} rolled: #{output.join(" ")}" unless @silent
    rotate()
  end

  def print_scorecard
    @player_list.each_with_index do |p, ind|
      color = ind == @current_index ? :yellow : :white
      pre = ind == @current_index ? "> " : "  "
      puts "#{pre}#{name_string(p.name)}: ".colorize(color) +  ("*" * p.dollars).colorize(:green)
    end
    puts "\n\nCurrent_pot: " + "#{"*" * @pot}".colorize(:green)
  end

  def game_over?
    @player_list.select{|p| p.dollars > 0}.count <= 1
  end

  def winner
    return "No one....YET!" unless game_over?
    @player_list.select{|p| p.dollars > 0}.first
  end

  ###################  PRIVATE METHODS #################
  private

  def name_string(name)
    longest_name = @player_list.map{|i| i.name.length}.max
    name + (" " * (longest_name - name.length))
  end

  def rotate
    @current_index = rotate_right(@current_index)
    @left_index = rotate_right(@left_index)
    @right_index = rotate_right(@right_index)
  end

  def rotate_right(current_index)
    current_index += 1
    current_index = 0 if current_index >= @player_list.count
    current_index
  end

  def roll_dice()
    %w[L R C * * * ].sample
  end
end
