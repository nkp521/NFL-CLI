class TeamsController < ApplicationController
  set :default_content_type, "application/json"

  # GET /teams
  get "/teams" do
    teams = Team.all
    teams.to_json(include: :players)
  end

  # GET /teams/:id
  get "/teams/:id" do
    teams = Team.find(params[:id])
    teams.to_json(include: :players)
  rescue ActiveRecord::RecordNotFound
    status 404
    { error: "Team not found" }.to_json
  end

  # POST /teams
  post "/teams" do
    team = Team.new(params)
    if team.save
      status 201
      team.to_json(include: :players)
    else
      status 422
      { errors: team.errors.full_messages }.to_json
    end
  end

  # PATCH /teams/:id
  patch "/teams/:id" do
    team = Team.find(params[:id])
    if team.update(params)
      team.to_json(include: :players)
    else
      status 422
      { errors: team.errors.full_messages }.to_json
    end
  rescue ActiveRecord::RecordNotFound
    status 404
    { error: "Teams aren't open for relocation" }.to_json
  end
end
