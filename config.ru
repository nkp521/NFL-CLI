require_relative "config/environment"

use Rack::Cors do
  allow do
    origins "*"
    resource "*", headers: :any, methods: %i[get post delete put patch options head]
  end
end


use Rack::JSONBodyParser

use PlayersController
use TeamsController

run ApplicationController
