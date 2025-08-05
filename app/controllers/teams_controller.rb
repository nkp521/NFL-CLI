class TeamsController < ApplicationController
  set :default_content_type, "application/json"

  get "/teams" do
    teams = Team.all
    teams.to_json(include: :players)
  end
end
