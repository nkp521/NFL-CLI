class ApplicationController < Sinatra::Base
  get "/" do
    { message: "Please visit '/teams' '/players' or '/positions' for data" }.to_json
  end
end
