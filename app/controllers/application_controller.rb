class ApplicationController < Sinatra::Base
  
  get "/" do
    { message: "Please visit '/teams' or '/players' for data" }.to_json
  end
end
