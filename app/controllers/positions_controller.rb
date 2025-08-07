class PositionsController < ApplicationController
  set :default_content_type, "application/json"

  get '/positions' do
    positions = Position.all
    positions.to_json(methods: :player_count)
  end
end
