class TeamsController < ApplicationController
  set :default_content_type, "application/json"

  get "/teams" do
    teams = Team.all
    teams.to_json(include: :players)
  end

  get "/teams/:id" do
    teams = Team.find(params[:id])
    teams.to_json(include: :players)
  rescue ActiveRecord::RecordNotFound
    status 404
    { error: "Team not found" }.to_json
  end

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

  delete "/teams/:id" do
    team = Team.find(params[:id])
    team.destroy
    { message: "Team successfully dissolved" }.to_json
  rescue ActiveRecord::RecordNotFound
    status 404
    { error: "Team not found" }.to_json
  end
end
