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

  def get_owner(id)
    response = RestClient.get("#{@base_url}/owners/#{id}")
    JSON.parse(response.body)
  rescue RestClient::Exception => e
    { error: "Failed to fetch owner: #{e.message}" }
  end

  #   def create_owner(data)
  #     response = RestClient.post("#{@base_url}/owners", data.to_json, content_type: :json)
  #     JSON.parse(response.body)
  #   rescue RestClient::Exception => e
  #     { error: "Failed to create owner: #{e.message}" }
  #   end

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

  #   def get_pet(id)
  #     response = RestClient.get("#{@base_url}/pets/#{id}")
  #     JSON.parse(response.body)
  #   rescue RestClient::Exception => e
  #     { error: "Failed to fetch pet: #{e.message}" }
  #   end

  #   def create_pet(data)
  #     response = RestClient.post("#{@base_url}/pets", data.to_json, content_type: :json)
  #     JSON.parse(response.body)
  #   rescue RestClient::Exception => e
  #     { error: "Failed to create pet: #{e.message}" }
  #   end

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

  #   def get_owner_pets(owner_id)
  #     response = RestClient.get("#{@base_url}/owners/#{owner_id}/pets")
  #     JSON.parse(response.body)
  #   rescue RestClient::Exception => e
  #     { error: "Failed to fetch owner's pets: #{e.message}" }
  #   end
end

class CLIInterface
  def initialize
    @api_client = APIClient.new
  end

  def display_menu
    puts "\n=== NFL Manager CLI ==="
    puts "0. View all teams"
    puts "1. View all players"
    puts "2. View team by player"
    puts "3. View players by team"
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
      when '0'
        view_all_teams
      when '1'
        view_all_players
      when '2'
        view_team_by_player
      when '3'
        view_players_by_team
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
          puts "-" * 50
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

  def view_team_by_player
    puts "9"
  end

  def view_players_by_team
    puts "8"
  end

  def create_team
    puts "2"
  end

  def create_player
    puts "3"
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
end

# Start the CLI application
cli = CLIInterface.new
cli.run
