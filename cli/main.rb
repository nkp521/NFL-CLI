require 'rest-client'
require 'json'
require_relative 'menu_handler'
require_relative 'display_helper'

class APIClient
  def initialize(base_url = 'http://localhost:9292')
    @base_url = base_url
  end

  def show_teams
    response = RestClient.get("#{@base_url}/teams")
    JSON.parse(response.body)
  rescue RestClient::Exception => e
    { error: "Failed to fetch Owners: #{e.message}" }
  end

  def create_team(data)
    response = RestClient.post("#{@base_url}/teams", data.to_json, content_type: :json)
    JSON.parse(response.body)
  rescue RestClient::Exception => e
    { error: "Failed to create Team: #{e.message}" }
  end

  def get_team(id)
    response = RestClient.get("#{@base_url}/teams/#{id}")
    JSON.parse(response.body)
  rescue RestClient::Exception => e
    { error: "Failed to fetch team: #{e.message}" }
  end

  def update_team(id, data)
    response = RestClient.patch("#{@base_url}/teams/#{id}", data.to_json, content_type: :json)
    JSON.parse(response.body)
  rescue RestClient::Exception => e
    { error: "Failed to move Team: #{e.message}" }
  end

  def delete_team(id)
    response = RestClient.delete("#{@base_url}/teams/#{id}")
    JSON.parse(response.body)
  rescue RestClient::Exception => e
    { error: "Failed to delete team: #{e.message}" }
  end

  def show_players
    response = RestClient.get("#{@base_url}/players")
    JSON.parse(response.body)
  rescue RestClient::Exception => e
    { error: "Failed to fetch Players: #{e.message}" }
  end

  def create_player(data)
    response = RestClient.post("#{@base_url}/players", data.to_json, content_type: :json)
    JSON.parse(response.body)
  rescue RestClient::Exception => e
    { error: "Failed to create Player: #{e.message}" }
  end

  def get_player(id)
    response = RestClient.get("#{@base_url}/players/#{id}")
    JSON.parse(response.body)
  rescue RestClient::Exception => e
    { error: "Failed to fetch player: #{e.message}" }
  end

  def update_player(id, data)
    response = RestClient.patch("#{@base_url}/players/#{id}", data.to_json, content_type: :json)
    JSON.parse(response.body)
  rescue RestClient::Exception => e
    { error: "Failed to update pet: #{e.message}" }
  end

  def delete_pet(id)
    response = RestClient.delete("#{@base_url}/players/#{id}")
    JSON.parse(response.body)
  rescue RestClient::Exception => e
    { error: "Failed to delete player: #{e.message}" }
  end

  def view_players_by_team_id(team_id)
    response = RestClient.get("#{@base_url}/teams/#{team_id}/players")
    JSON.parse(response.body)
  rescue RestClient::Exception => e
    { error: "Failed to fetch Team's Players: #{e.message}" }
  end

  def show_positions
    response = RestClient.get("#{@base_url}/positions")
    JSON.parse(response.body)
  rescue RestClient::Exception => e
    { error: "Failed to fetch Owners: #{e.message}" }
  end
end

class CLIInterface
  def initialize
    @api_client = APIClient.new
    @menu_handler = MenuHandler.new(self)
    @display = DisplayHelper.new(@api_client)
  end

  def run
    @menu_handler.show_welcome_message

    loop do
      result = @menu_handler.display_and_handle_menu
      break if result == :quit
    end
  end

  def view_all_teams
    puts "\n=== All Teams ==="
    response = @api_client.show_teams

    if response.is_a?(Array)
      if response.empty?
        puts "No teams found."
      else
        response.each do |team|
          @display.display_team(team)
          puts "-" * 75
        end
      end
    else
      puts "Error: #{response[:error]}"
    end
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
    puts "\n=== Create New Team ==="

    print "Name: "
    name = gets.chomp

    print "City: "
    city = gets.chomp

    data = { name: name, city: city }

    response = @api_client.create_team(data)

    if response[:error]
      puts "Error: #{response[:error]}"
    else
      puts "Congrats on creating your own NFL Team!!"
      @display.display_team(response)
    end
  end

  def create_player
    puts "\n=== Create New Player ==="

    print "\nName: "
    name = gets.chomp

    print "Number: "
    number = gets.chomp.to_i

    puts @display.show_positions_info

    print "\nPosition ID: "
    position_id = gets.chomp.to_i

    puts @display.show_teams_info

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
    @display.show_teams_info
    print "\nEnter the ID of the Team to move location: "
    id = gets.chomp.to_i

    team = @api_client.get_team(id)
    if team[:error]
      puts "Error: #{team[:error]}"
      return
    end

    puts "\nCurrent Team data:"
    @display.display_team(team)

    puts "\nEnter new city (press Enter to keep current city):"

    print "City (#{team['city']}): "
    city = gets.chomp
    city = team['city'] if city.empty?

    data = { city: city }

    response = @api_client.update_team(id, data)

    if response[:error]
      puts "Error: #{response[:error]}"
    else
      puts "Team location updated successfully!"
      @display.display_team(response)
    end
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
    @display.show_teams_info
    print "\nEnter the ID of the team to delete: "
    id = gets.chomp.to_i

    print "Are you sure you want to delete this team? It will delete all players associated with it! (y/n): "
    confirmation = gets.chomp.downcase

    if %w[y yes].include?(confirmation)
      response = @api_client.delete_team(id)

      if response[:error]
        puts "Error: #{response[:error]}"
      else
        puts "Team deleted successfully!"
      end
    else
      puts "Deletion cancelled."
    end
  end

  def delete_player
    view_all_teams
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
      response = @api_client.delete_pet(player_id)

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
    puts "\n=== All Players ==="
    response = @api_client.show_positions

    if response.is_a?(Array)
      if response.empty?
        puts "No positions found."
      else
        response.each do |position|
          @display.display_position(position)
          puts "-" * 50
        end
      end
    else
      puts "Error: #{response[:error]}"
    end
  end
end

cli = CLIInterface.new
cli.run
