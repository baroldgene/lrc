require 'google_drive'

class GD
  def initialize
    @session = GoogleDrive::Session.from_config("config.json")
    @folder = @session.collection_by_title("LRC")
    if @folder.nil?
      @folder = @session.root_collection.create_subcollection("LRC")
    end
    @file = @folder.create_spreadsheet(Time.now.strftime('%Y%m%e-%R'))
    @ws = @file.worksheets[0]
    @ws[1,1] = 'player_count'
    @ws[1,2] = 'rounds_to_complete'
    @ws.save

    @line_number = 2
  end

  def write_line(player_count, turns)
    @ws[@line_number, 1] = player_count
    @ws[@line_number, 2] = turns
    @line_number += 1
  end

  def save()
    @ws.save
  end

  def method_missing(m, *args, &block)
    puts "Delegating #{m}"
    @session.send(m, *args, &block)
  end

end
