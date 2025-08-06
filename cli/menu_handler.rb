class MenuHandler
  def initialize(cli_interface)
    @cli_interface = cli_interface
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
    puts "0. Position Information"
    puts "q. Quit"
  end

  def handle_choice(choice)
    case choice
    when '1'
      @cli_interface.view_all_teams
    when '2'
      @cli_interface.view_all_players
    when '3'
      @cli_interface.view_players_by_team_id
    when '4'
      @cli_interface.create_team
    when '5'
      @cli_interface.create_player
    when '6'
      @cli_interface.move_team_location
    when '7'
      @cli_interface.trade_player
    when '8'
      @cli_interface.delete_team
    when '9'
      @cli_interface.delete_player
    when '0'
      @cli_interface.position_info
    when 'q', 'quit', 'exit'
      puts "Goodbye!"
      return :quit
    else
      puts "Invalid choice. Please try again."
      return :continue
    end
    :continue
  end

  def show_welcome_message
    puts "Welcome to the NFL Manager CLI!"
    puts "This is a full CRUD App to build and manage new and existing teams and players!"
    puts "Make sure your API server is running on http://localhost:9292"
    puts
  end
end
