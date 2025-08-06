class PositionsController < ApplicationController
  set :default_content_type, "application/json"

  get '/positions' do
    positions = Position.all
    positions.to_json(include: :players)
  end
end
