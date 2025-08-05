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

  # POST /players
  post "/players" do
    player = Player.new(params)
    if player.save
      status 201
      player.to_json(include: :team)
    else
      status 422
      { errors: player.errors.full_messages }.to_json
    end
  end

  # PATCH /players/:id
  patch "/players/:id" do
    player = Player.find(params[:id])
    if player.update(params)
      player.to_json(include: :team)
    else
      status 422
      { errors: player.errors.full_messages }.to_json
    end
  rescue ActiveRecord::RecordNotFound
    status 404
    { error: "player not found" }.to_json
  end
end
