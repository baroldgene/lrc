require 'faker'
require 'colorize'


Dir["./lib/*.rb"].each {|file| require file }

player_list = []

if ARGV.count >= 3
  ARGV.each do |name|
    player_list << Player.new(name, 3)
  end
else
  puts "How many players?"
  player_count = gets
  player_count = player_count.to_i

  throw ArgumentError if player_count < 3


  puts "Proceeding with #{player_count} RANDOM players\n\n\n"

  player_count.times do
    player_list << Player.new(Faker::Name.name, 3)
  end

end

@game = Game.new(player_list)
@game.print_scorecard

loop do
  @game.roll
  sleep 0.2
  lines = player_list.count + 4
  lines.times do
    print "\e[A\e[2K"
  end
  @game.print_scorecard
  break if @game.game_over?
end

puts "\n"
puts "#{@game.winner.name}".colorize(:yellow) + " wins $#{@game.pot + @game.winner.dollars}!!"


