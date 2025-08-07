class DisplayHelper
  def initialize(api_client)
    @api_client = api_client
  end

  def display_team(team)
    puts "ID: #{team['id']}"
    puts "Name: #{team['name']}"
    puts "City: #{team['city']}"
    puts "Player Count: #{team['players'].count}"
  end

  def display_player(player)
    puts "ID: #{player['id']}"
    puts "Name: #{player['name']}"
    puts "Number: #{player['number']}"
    puts "Position: #{player['position']['name']}"
    puts "Team: #{player['team']['name']}"
  end

  def display_team_player(player)
    puts "ID: #{player['id']}  Name: #{player['name']}  Number: #{player['number']}  Position: #{player['position']['name']}"
  end

  def show_teams_info
    teams_response = @api_client.show_teams
    if teams_response.is_a?(Array) && !teams_response.empty?
      puts "Available Teams:"
      teams_response.each { |team| puts "#{team['id']}. #{team['name']} || Player Count: #{team['players'].count}" }
    else
      puts "No Teams available."
    end
  end

  def show_positions_info
    positions_response = @api_client.show_positions
    if positions_response.is_a?(Array)
      if positions_response.empty?
        puts "No positions found."
      else
        puts "Available Positions:"
        positions_response.each do |position|
          display_position(position)
          puts "-" * 50
        end
      end
    else
      puts "Error loading positions"
    end
  end

  def display_position(position)
    puts "ID: #{position['id']}"
    puts "Name: #{position['name']}"
    puts "Description: #{position['description']}"
    puts "Position Player Count: #{position['player_count']}"
  end
end
