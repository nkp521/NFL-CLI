#!/usr/bin/env ruby

# TODO: Build your CLI application here!
#
# Requirements:
# - Be object-oriented (at least two classes)
# - Make HTTP requests to your Sinatra API
# - Parse and display JSON responses
# - Accept user input and use it to send requests
# - Use a loop or menu interface
# - Include current value prompts for updates

class CLIInterface
  def initialize
    @api_client = APIClient.new
  end

  def display_menu
    puts "\n=== Pet Tracker CLI ==="
    puts "1. View all owners"
    puts "2. View all pets"
    puts "3. Create a new owner"
    puts "4. Create a new pet"
    puts "5. Update an owner"
    puts "6. Update a pet"
    puts "7. Delete an owner"
    puts "8. Delete a pet"
    puts "9. View pets by owner"
    puts "q. Quit"
    print "\nEnter your choice: "
  end

  def run
    puts "Welcome to the NFL Team-Builder CLI!"
    puts "This is a full CRUD App to build and manage new and existing teams!"
    puts "Make sure your API server is running on http://localhost:9292"
    puts

    loop do
      display_menu
      choice = gets.chomp.downcase

      case choice
      when '0'
        view_all_teams
      when '1'
        view_all_players
      when '2'
        create_team
      when '3'
        create_player
      when '4'
        update_team
      when '5'
        update_player
      when '6'
        delete_team
      when '7'
        delete_player
      when '8'
        view_players_by_team
      when '9'
        view_team_by_player
      when 'q', 'quit', 'exit'
        puts "Goodbye!"
        break
      else
        puts "Invalid choice. Please try again."
      end
    end
  end
end
