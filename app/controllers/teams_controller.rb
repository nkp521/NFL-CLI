class TeamsController < ApplicationController
  set :default_content_type, "application/json"

  # GET /players
  get "/players" do
    teams = Team.all
    teams.to_json(include: :players)
  end

  # GET /players/:id
  get "/teams/:id" do
    teams = Team.find(params[:id])
    teams.to_json(include: :players)
  rescue ActiveRecord::RecordNotFound
    status 404
    { error: "Player not found" }.to_json
  end
end
