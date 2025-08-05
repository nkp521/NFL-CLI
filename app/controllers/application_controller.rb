# frozen_string_literal: true

class ApplicationController < Sinatra::Base
  # Add your routes here
  get "/" do
    { message: "Please visit '/teams' or '/players' for data" }.to_json
  end
end
