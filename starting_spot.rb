require 'faker'
require 'colorize'
require 'tty-prompt'

Dir["./lib/*.rb"].each {|file| require file }


min_players = 3

if ARGV[0].nil?

  prompt = TTY::Prompt.new

  player_count = prompt.ask('How many players?') do |q|
    q.validate /^\d*$/
  end
else
  player_count = ARGV[0]
end

player_count = player_count.to_i
positions = {}

run_count = 5000

run_count.times do
    round_count = 0
    player_list = []
    player_count.times do
      player_list << Player.new(Faker::Name.name, 3)
    end
    @game = Game.new(player_list, silent: true)
    while(not @game.game_over?) do
      @game.roll
    end
    winner_index = player_list.index(@game.winner)
    positions[winner_index + 1] ||= 0
    positions[winner_index + 1] += 1
end
puts positions


positions.sort_by{|k,v| v}.reverse.to_h.each do |k, v|
  puts "Position #{k} won #{v * 100.0 / run_count}% of the time."
end




