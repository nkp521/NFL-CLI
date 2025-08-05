class PlayersController < ApplicationController
  set :default_content_type, "application/json"

  # GET /players
  get "/players" do
    players = Player.all
    players.to_json(include: :team)
  end

  # GET /players/:id
  get "/players/:id" do
    player = Player.find(params[:id])
    player.to_json(include: :team)
  rescue ActiveRecord::RecordNotFound
    status 404
    { error: "Player not found" }.to_json
  end

  # GET /teams/:team_id/players
  get "/teams/:team_id/players" do
    team = Team.find(params[:team_id])
    team.players.to_json(include: :team)
  rescue ActiveRecord::RecordNotFound
    status 404
    { error: "Owner not found" }.to_json
  end
end
