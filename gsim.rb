require 'faker'
require 'colorize'
require 'tty-prompt'

Dir["./lib/*.rb"].each {|file| require file }


min_players = 3

if ARGV[0].nil? and ARGV[1].nil?

  prompt = TTY::Prompt.new

  sim_count = prompt.ask('How many simulations do you want to run?') do |q|
    q.validate /^\d*$/
  end


  max_players = prompt.ask('What is the upper bound on players?') do |q|
    q.validate /^\d*$/
  end
else
  sim_count = ARGV[0]
  max_players = ARGV[1]
end

min_players = min_players.to_i
max_players = max_players.to_i
sim_count = sim_count.to_i

g = GD.new

puts "Running #{sim_count} simulations for every player count from #{min_players} to #{max_players}"

(3..max_players).each do |player_count|
  puts "Running simulation with #{player_count} players"
  sim_count.times do
    round_count = 0
    player_list = []
    player_count.times do
      player_list << Player.new(Faker::Name.name, 3)
    end
    @game = Game.new(player_list, silent: true)
    while(not @game.game_over?) do
      @game.roll
      round_count += 1
    end
    g.write_line(player_count, round_count)
  end
end
g.save

