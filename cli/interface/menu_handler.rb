require 'tty-prompt'
require 'tty-spinner'

class MenuHandler
  def initialize(cli_interface)
    @cli_interface = cli_interface
    @prompt = TTY::Prompt.new
  end

  def display_and_handle_menu
    football_frames = ["🏈", "🏉", "🏈", "🏉"]
    spinner = TTY::Spinner.new(":spinner NFL CLI MANAGER :spinner", format: :custom, frames: football_frames,
                                                                    interval: 175)
    spinner.auto_spin
    sleep(1.5)
    spinner.stop

    choice = @prompt.select("\nWhat would you like to do?\n", cycle: true, per_page: 12) do |t|
      t.choice "View all teams", :view_teams
      t.choice "View players by team", :view_players_by_team
      t.choice "Find Player by Name", :view_players_by_name
      t.choice "Create a new team", :create_team
      t.choice "Create a new player", :create_player
      t.choice "Move team location", :move_team_location
      t.choice "Trade a player", :trade_player
      t.choice "Delete a team", :delete_team
      t.choice "Delete a player", :delete_player
      t.choice "Position information", :position_info
      t.choice "Exit", :quit
    end

    handle_choice(choice)
  end

  def handle_choice(choice)
    case choice
    when :view_teams
      @cli_interface.view_all_teams
    when :view_players_by_name
      @cli_interface.view_all_players_by_name
    when :view_players_by_team
      @cli_interface.view_players_by_team_id
    when :create_team
      @cli_interface.create_team
    when :create_player
      @cli_interface.create_player
    when :move_team_location
      @cli_interface.move_team_location
    when :trade_player
      @cli_interface.trade_player
    when :delete_team
      @cli_interface.delete_team
    when :delete_player
      @cli_interface.delete_player
    when :position_info
      @cli_interface.position_info
    when :quit
      puts "\nSee You Next Time on NFL CLI Manager!\n"
      return :quit
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
