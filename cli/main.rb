require_relative 'api_client/api_client'
require_relative 'interface/menu_handler'
require_relative 'interface/display_helper'
require_relative 'operations/team_operations'


class CLIInterface
  def initialize
    @api_client = APIClient.new
    @display = DisplayHelper.new(@api_client)
    
    @team_ops = TeamOperations.new(@api_client, @display)
    
    @menu_handler = MenuHandler.new(self)
  end

  def run
    @menu_handler.show_welcome_message

    loop do
      result = @menu_handler.display_and_handle_menu
      break if result == :quit
    end
  end

  def view_all_teams
    @team_ops.view_all
  end

  def view_all_players_by_name
    puts "\n=== Enter a name to find players ==="
    print "Player name: "
    player_name = gets.chomp.downcase

    response = @api_client.show_players

    if response.is_a?(Array)
      matching_players = response.select do |player|
        player['name'].downcase.include?(player_name)
      end

      if matching_players.empty?
        puts "No players found matching '#{player_name}'."
      else
        puts "\n=== Players matching '#{player_name}' ==="
        matching_players.each do |player|
          @display.display_player(player)
          puts "-" * 80
        end
      end
    else
      puts "Error: #{response[:error]}"
    end
  end

  def view_players_by_team_id
    @display.show_teams_info
    print "\nEnter the team ID to view their players: "
    team_id = gets.chomp.to_i

    response = @api_client.view_players_by_team_id(team_id)

    if response.is_a?(Array)
      if response.empty?
        puts "This team has no players"
      else
        puts "\n=== Players for this team ==="
        response.each do |player|
          @display.display_team_player(player)
          puts "-" * 80
        end
      end
    else
      puts "Error: #{response[:error]}"
    end
  end

  def create_team
    @team_ops.create
  end

  def create_player
    puts "\n=== Create New Player ==="

    print "\nName: "
    name = gets.chomp

    print "Number: "
    number = gets.chomp.to_i

    @display.show_positions_info

    print "\nPosition ID: "
    position_id = gets.chomp.to_i

    @display.show_teams_info

    print "Team ID: "
    team_id = gets.chomp.to_i

    data = { name: name, number: number, position_id: position_id, team_id: team_id }

    response = @api_client.create_player(data)

    if response[:error]
      puts "Error: #{response[:error]}"
    else
      puts "Congrats, Your Player is in the NFL!"
      @display.display_player(response)
    end
  end

  def move_team_location
    @team_ops.update_location
  end

  def trade_player
    print "\nCheck Players by Team ID (option 3) in the Main Menu to find Players to trade "
    print "\nEnter the ID of the Player to update: "
    id = gets.chomp.to_i

    current_player = @api_client.get_player(id)
    if current_player[:error]
      puts "Error: #{current_player[:error]}"
      return
    end

    puts "\nCurrent Player data:"
    @display.display_player(current_player)

    puts "\nEnter new values (press Enter to keep current value):"

    print "Team ID (#{current_player['team_id']}): "
    team_id = gets.chomp
    team_id = current_player['team_id'] if team_id.empty?

    data = { team_id: team_id }

    response = @api_client.update_player(id, data)

    if response[:error]
      puts "Error: #{response[:error]}"
    else
      puts "Player was traded!"
      @display.display_player(response)
    end
  end

  def delete_team
    @team_ops.delete
  end

  def delete_player
    @display.show_teams_info
    print "\nEnter the ID of the Team to view players: "
    team_id = gets.chomp.to_i

    response = @api_client.view_players_by_team_id(team_id)

    if response.is_a?(Array)
      if response.empty?
        puts "This team has no players to delete."
        return
      else
        puts "\n=== Players on this team ==="
        response.each do |player|
          @display.display_team_player(player)
          puts "-" * 50
        end
      end
    else
      puts "Error: #{response[:error]}"
      return
    end

    print "\nEnter the ID of the Player to delete: "
    player_id = gets.chomp.to_i

    print "Are you sure you want to delete this player? (y/n): "
    confirmation = gets.chomp.downcase

    if %w[y yes].include?(confirmation)
      response = @api_client.delete_player(player_id)

      if response[:error]
        puts "Error: #{response[:error]}"
      else
        puts "Player removed successfully!"
      end
    else
      puts "Player Removal Cancelled."
    end
  end

  def position_info
    puts "\n=== Position Information ==="
    @display.show_positions_info
  end
end

cli = CLIInterface.new
cli.run
