class PlayersController < ApplicationController
  set :default_content_type, "application/json"

  get "/players" do
    players = Player.all
    players.to_json(include: :team)
  end
end
