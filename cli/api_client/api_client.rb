require 'rest-client'
require 'json'

class APIClient
  def initialize(base_url = 'http://localhost:9292')
    @base_url = base_url
  end

  def show_teams
    response = RestClient.get("#{@base_url}/teams")
    JSON.parse(response.body)
  rescue RestClient::Exception => e
    { error: "Failed to fetch Teams: #{e.message}" }
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
    { error: "Failed to update player: #{e.message}" }
  end

  def delete_player(id)
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
    { error: "Failed to fetch Positions: #{e.message}" }
  end
end
