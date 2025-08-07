require_relative 'api_client/api_client'
require_relative 'interface/menu_handler'
require_relative 'interface/display_helper'
require_relative 'operations/team_operations'
require_relative 'operations/player_operations'
require_relative 'operations/position_operations'


class CLIInterface
  def initialize
    @api_client = APIClient.new
    @display = DisplayHelper.new(@api_client)
    
    @team_ops = TeamOperations.new(@api_client, @display)
    @player_ops = PlayerOperations.new(@api_client, @display)
    @position_ops = PositionOperations.new(@api_client, @display)
    
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
    @player_ops.search_by_name
  end

  def view_players_by_team_id
    @player_ops.view_by_team
  end

  def create_team
    @team_ops.create
  end

  def create_player
    @player_ops.create
  end

  def move_team_location
    @team_ops.update_location
  end

  def trade_player
    @player_ops.trade
  end

  def delete_team
    @team_ops.delete
  end

  def delete_player
    @player_ops.delete
  end

  def position_info
    @position_ops.view_all
  end
end

cli = CLIInterface.new
cli.run
