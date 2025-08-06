class PlayersController < ApplicationController
  set :default_content_type, "application/json"

  get "/players" do
    players = Player.all
    players.to_json(include: [:team, :position])
  end

  get "/players/:id" do
    player = Player.find(params[:id])
    player.to_json(include: [:team, :position])
  rescue ActiveRecord::RecordNotFound
    status 404
    { error: "Player not found" }.to_json
  end

  get "/teams/:team_id/players" do
    team = Team.find(params[:team_id])
    team.players.to_json(include: [:team, :position])
  rescue ActiveRecord::RecordNotFound
    status 404
    { error: "Team not found" }.to_json
  end

  post "/players" do
    player = Player.new(params)
    if player.save
      status 201
      player.to_json(include: [:team, :position])
    else
      status 422
      { errors: player.errors.full_messages }.to_json
    end
  end

  patch "/players/:id" do
    player = Player.find(params[:id])
    if player.update(params)
      player.to_json(include: [:team, :position])
    else
      status 422
      { errors: player.errors.full_messages }.to_json
    end
  rescue ActiveRecord::RecordNotFound
    status 404
    { error: "Player not found" }.to_json
  end

  delete "/players/:id" do
    player = Player.find(params[:id])
    player.destroy
    { message: "Player successfully removed" }.to_json
  rescue ActiveRecord::RecordNotFound
    status 404
    { error: "Player not found" }.to_json
  end
end
