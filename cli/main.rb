#!/usr/bin/env ruby

require 'rest-client'
require 'json'

# TODO: Build your CLI application here!
#
class APIClient
  def initialize(base_url = 'http://localhost:9292')
    @base_url = base_url
  end

  def get_teams
    response = RestClient.get("#{@base_url}/teams")
    JSON.parse(response.body)
  rescue RestClient::Exception => e
    { error: "Failed to fetch owners: #{e.message}" }
  end

  def create_team(data)
    response = RestClient.post("#{@base_url}/teams", data.to_json, content_type: :json)
    JSON.parse(response.body)
  rescue RestClient::Exception => e
    { error: "Failed to create team: #{e.message}" }
  end

  #   def update_owner(id, data)
  #     response = RestClient.patch("#{@base_url}/owners/#{id}", data.to_json, content_type: :json)
  #     JSON.parse(response.body)
  #   rescue RestClient::Exception => e
  #     { error: "Failed to update owner: #{e.message}" }
  #   end

  #   def delete_owner(id)
  #     response = RestClient.delete("#{@base_url}/owners/#{id}")
  #     JSON.parse(response.body)
  #   rescue RestClient::Exception => e
  #     { error: "Failed to delete owner: #{e.message}" }
  #   end

  def get_players
    response = RestClient.get("#{@base_url}/players")
    JSON.parse(response.body)
  rescue RestClient::Exception => e
    { error: "Failed to fetch pets: #{e.message}" }
  end

  def create_player(data)
    response = RestClient.post("#{@base_url}/players", data.to_json, content_type: :json)
    JSON.parse(response.body)
  rescue RestClient::Exception => e
    { error: "Failed to create player: #{e.message}" }
  end

  #   def update_pet(id, data)
  #     response = RestClient.patch("#{@base_url}/pets/#{id}", data.to_json, content_type: :json)
  #     JSON.parse(response.body)
  #   rescue RestClient::Exception => e
  #     { error: "Failed to update pet: #{e.message}" }
  #   end

  #   def delete_pet(id)
  #     response = RestClient.delete("#{@base_url}/pets/#{id}")
  #     JSON.parse(response.body)
  #   rescue RestClient::Exception => e
  #     { error: "Failed to delete pet: #{e.message}" }
  #   end

  def view_players_by_team_id(team_id)
    response = RestClient.get("#{@base_url}/teams/#{team_id}/players")
    JSON.parse(response.body)
  rescue RestClient::Exception => e
    { error: "Failed to fetch owner's pets: #{e.message}" }
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
    puts "6. Update a team"
    puts "7. Update a player"
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
        update_team
      when '7'
        update_player
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
    response = @api_client.get_teams

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
    response = @api_client.get_players

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

    teams_response = @api_client.get_teams
    if teams_response.is_a?(Array) && !teams_response.empty?
      puts "Available Teams:"
      teams_response.each { |team| puts "#{team['id']}. #{team['name']}" }
    else
      puts "No Teams wish to sign you."
      return
    end

    print "Name: "
    name = gets.chomp

    print "Number: "
    number = gets.chomp

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

  def update_team
    puts "4"
  end

  def update_player
    puts "5"
  end

  def delete_team
    puts "6"
  end

  def delete_player
    puts "7"
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
end

# Start the CLI application
cli = CLIInterface.new
cli.run
