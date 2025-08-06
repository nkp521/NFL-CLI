#!/usr/bin/env ruby
require 'rest-client'
require 'json'

# TODO: Build your CLI application here!
#
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
end

class CLIInterface
  def initialize
    @api_client = APIClient.new
  end

  def display_menu
    puts "\n=== NFL Manager CLI ==="
    puts "1. View all teams"
    puts "2. View all players"
    puts "3. View players by team ID"
    puts "4. Create a new team"
    puts "5. Create a new player"
    puts "6. Move Team Location"
    puts "7. Trade a Player"
    puts "8. Delete a team"
    puts "9. Delete a player"
    puts "q. Quit"
  end

  def run
    puts "Welcome to the NFL Manager CLI!"
    puts "This is a full CRUD App to build and manage new and existing teams and players!"
    puts "Make sure your API server is running on http://localhost:9292"
    puts

    loop do
      display_menu
      puts "Enter Your Command:"
      choice = gets.chomp.downcase

      case choice
      when '1'
        view_all_teams
      when '2'
        view_all_players
      when '3'
        view_players_by_team_id
      when '4'
        create_team
      when '5'
        create_player
      when '6'
        move_team_location
      when '7'
        trade_player
      when '8'
        delete_team
      when '9'
        delete_player
      when 'q', 'quit', 'exit'
        puts "Goodbye!"
        break
      else
        puts "Invalid choice. Please try again."
      end
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
          display_team(team)
          puts "-" * 75
        end
      end
    else
      puts "Error: #{response[:error]}"
    end
  end

  def view_all_players
    puts "\n=== All Players ==="
    response = @api_client.show_players

    if response.is_a?(Array)
      if response.empty?
        puts "No players found."
      else
        response.each do |player|
          display_player(player)
          puts "-" * 50
        end
      end
    else
      puts "Error: #{response[:error]}"
    end
  end

  def view_players_by_team_id
    view_all_teams
    print "\nEnter the team ID to view their players: "
    team_id = gets.chomp.to_i

    response = @api_client.view_players_by_team_id(team_id)

    if response.is_a?(Array)
      if response.empty?
        puts "This team has no players."
      else
        puts "\n=== Players for this team ==="
        response.each do |player|
          display_team_player(player)
          puts "-" * 50
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
      display_team(response)
    end
  end

  def create_player
    puts "\n=== Create New Player ==="

    show_teams_info

    print "Name: "
    name = gets.chomp

    print "Number: "
    number = gets.chomp.to_i

    print "Position: "
    position = gets.chomp

    print "Team ID: "
    team_id = gets.chomp.to_i

    data = { name: name, number: number, position: position, team_id: team_id }

    response = @api_client.create_player(data)

    if response[:error]
      puts "Error: #{response[:error]}"
    else
      puts "Congrats, Your Player is in the NFL!"
      display_player(response)
    end
  end

  def move_team_location
    show_teams_info
    print "\nEnter the ID of the Team to move location: "
    id = gets.chomp.to_i

    team = @api_client.get_team(id)
    if team[:error]
      puts "Error: #{team[:error]}"
      return
    end

    puts "\nCurrent Team data:"
    display_team(team)

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
      display_team(response)
    end
  end

  def trade_player
    print "\nCheck Players by Team ID (option 3) in the Main Menu to find Players to trade "
    print "\nEnter the ID of the Player to update: "
    id = gets.chomp.to_i

    # Get current player data
    current_player = @api_client.get_player(id)
    if current_player[:error]
      puts "Error: #{current_player[:error]}"
      return
    end

    puts "\nCurrent Player data:"
    display_player(current_player)

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
      display_player(response)
    end
  end

  def delete_team
    show_teams_info
    print "\nEnter the ID of the team to delete: "
    id = gets.chomp.to_i

    print "Are you sure you want to delete this team? It will delete all players associated with it! (y/n): "
    confirmation = gets.chomp.downcase

    if confirmation == 'y' || confirmation == 'yes'
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
    # First, show all teams so user can select one
    view_all_teams
    print "\nEnter the ID of the Team to view players: "
    team_id = gets.chomp.to_i

    # Show players from the selected team
    response = @api_client.view_players_by_team_id(team_id)
    
    if response.is_a?(Array)
      if response.empty?
        puts "This team has no players to delete."
        return
      else
        puts "\n=== Players on this team ==="
        response.each do |player|
          display_team_player(player)
          puts "-" * 50
        end
      end
    else
      puts "Error: #{response[:error]}"
      return
    end

    # Ask user to select a player to delete
    print "\nEnter the ID of the Player to delete: "
    player_id = gets.chomp.to_i

    print "Are you sure you want to delete this player? (y/n): "
    confirmation = gets.chomp.downcase

    if confirmation == 'y' || confirmation == 'yes'
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
    puts "Position: #{player['position']}"
    puts "Team: #{player['team']['name']}"
  end

  def display_team_player(player)
    puts "ID: #{player['id']}  Name: #{player['name']}  Number: #{player['number']}  Position: #{player['position']}"
  end

  def show_teams_info
    teams_response = @api_client.show_teams
    if teams_response.is_a?(Array) && !teams_response.empty?
      puts "Available Teams:"
      teams_response.each { |team| puts "#{team['id']}. #{team['name']}" }
    else
      puts "No Teams avilable."
      nil
    end
  end
end

# Start the CLI application
cli = CLIInterface.new
cli.run
